using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Cart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadCart();
    }

    private void LoadCart()
    {
        var cart = Helpers.GetCart();

        if (cart.Count == 0)
        {
            pnlEmpty.Visible = true;
            pnlCart.Visible = false;
            return;
        }

        pnlEmpty.Visible = false;
        pnlCart.Visible = true;

        // Build an in-memory DataTable from session cart + DB prices
        DataTable dt = new DataTable();
        dt.Columns.Add("PackageID", typeof(int));
        dt.Columns.Add("Name",      typeof(string));
        dt.Columns.Add("Category",  typeof(string));
        dt.Columns.Add("Price",     typeof(decimal));
        dt.Columns.Add("Quantity",  typeof(int));

        decimal total = 0;

        foreach (var item in cart)
        {
            int packageId = item.Key;
            int qty = item.Value;

            string sql = "SELECT Name, Category, Price FROM Packages WHERE PackageID = @ID";
            var parms = new List<SqlParameter> { DBHelper.ParamInt("@ID", packageId) };
            DataTable pkg = DBHelper.ExecuteQuery(sql, parms);

            if (pkg.Rows.Count > 0)
            {
                decimal price = Convert.ToDecimal(pkg.Rows[0]["Price"]);
                dt.Rows.Add(packageId, pkg.Rows[0]["Name"], pkg.Rows[0]["Category"], price, qty);
                total += price * qty;
            }
        }

        gvCart.DataSource = dt;
        gvCart.DataBind();
        lblTotal.Text = total.ToString("N2");
    }

    protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            int packageId = Convert.ToInt32(e.CommandArgument);
            Helpers.RemoveFromCart(packageId);
        }
        else if (e.CommandName == "UpdateQty")
        {
            // CommandArgument = "packageId,txtQtyControlId"
            string[] parts = e.CommandArgument.ToString().Split(',');
            int packageId = Convert.ToInt32(parts[0]);

            // Find the row and get the textbox
            GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
            TextBox txtQty = (TextBox)row.FindControl("txtQty");
            int qty = 1;
            if (txtQty != null) int.TryParse(txtQty.Text, out qty);

            Helpers.UpdateCartQty(packageId, qty);
        }

        LoadCart();
    }
}
