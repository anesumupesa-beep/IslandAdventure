using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public partial class Checkout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Helpers.RequireLogin(this);

        if (!IsPostBack)
            LoadSummary();
    }

    private void LoadSummary()
    {
        var cart = Helpers.GetCart();

        if (cart.Count == 0)
        {
            pnlEmpty.Visible = true;
            pnlCheckout.Visible = false;
            return;
        }

        decimal total;
        DataTable dt = BuildCartTable(cart, out total);
        rptSummary.DataSource = dt;
        rptSummary.DataBind();
        lblTotal.Text = total.ToString("N2");
    }

    private DataTable BuildCartTable(Dictionary<int, int> cart, out decimal total)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Name",     typeof(string));
        dt.Columns.Add("Price",    typeof(decimal));
        dt.Columns.Add("Quantity", typeof(int));

        total = 0;
        foreach (var item in cart)
        {
            string sql = "SELECT Name, Price FROM Packages WHERE PackageID = @ID";
            var parms = new List<SqlParameter> { DBHelper.ParamInt("@ID", item.Key) };
            DataTable pkg = DBHelper.ExecuteQuery(sql, parms);
            if (pkg.Rows.Count > 0)
            {
                decimal price = Convert.ToDecimal(pkg.Rows[0]["Price"]);
                dt.Rows.Add(pkg.Rows[0]["Name"], price, item.Value);
                total += price * item.Value;
            }
        }
        return dt;
    }

    protected void btnPay_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        var cart = Helpers.GetCart();
        if (cart.Count == 0) return;

        decimal total;
        DataTable cartTable = BuildCartTable(cart, out total);

        // Get last 4 digits of card
        string cardNumber = txtCardNumber.Text.Replace(" ", "").Replace("-", "");
        string lastFour   = cardNumber.Length >= 4 ? cardNumber.Substring(cardNumber.Length - 4) : "0000";

        // Insert Order
        string orderSql = @"INSERT INTO Orders (UserID, OrderDate, TotalAmount, PaymentStatus, CardLastFour)
                            OUTPUT INSERTED.OrderID
                            VALUES (@UserID, GETDATE(), @Total, 'Paid', @LastFour)";
        var orderParams = new List<SqlParameter>
        {
            DBHelper.ParamInt("@UserID",    Helpers.GetUserID()),
            DBHelper.ParamDecimal("@Total", total),
            DBHelper.ParamString("@LastFour", lastFour, 4)
        };
        int orderId = Convert.ToInt32(DBHelper.ExecuteScalar(orderSql, orderParams));

        // Insert OrderItems
        foreach (var item in cart)
        {
            string itemSql = "INSERT INTO OrderItems (OrderID, PackageID, Quantity, UnitPrice) VALUES (@OrderID, @PackageID, @Qty, @Price)";
            string priceSql = "SELECT Price FROM Packages WHERE PackageID = @ID";
            decimal price = Convert.ToDecimal(DBHelper.ExecuteScalar(priceSql,
                new List<SqlParameter> { DBHelper.ParamInt("@ID", item.Key) }));

            var itemParams = new List<SqlParameter>
            {
                DBHelper.ParamInt("@OrderID",    orderId),
                DBHelper.ParamInt("@PackageID",  item.Key),
                DBHelper.ParamInt("@Qty",        item.Value),
                DBHelper.ParamDecimal("@Price",  price)
            };
            DBHelper.ExecuteNonQuery(itemSql, itemParams);
        }

        // Clear cart
        Helpers.ClearCart();

        // Redirect to confirmation
        Response.Redirect("~/PurchaseHistory.aspx?new=1");
    }
}
