using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class PurchaseHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Helpers.RequireLogin(this);

        if (Request.QueryString["new"] == "1")
            pnlSuccess.Visible = true;

        if (!IsPostBack)
            LoadOrders();
    }

    private void LoadOrders()
    {
        int userId = Helpers.GetUserID();
        DateTime threeMonthsAgo = DateTime.Now.AddMonths(-3);

        // Orders summary
        string orderSql = @"
            SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.PaymentStatus, o.CardLastFour,
                   COUNT(oi.OrderItemID) AS ItemCount
            FROM Orders o
            LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
            WHERE o.UserID = @UserID AND o.OrderDate >= @From
            GROUP BY o.OrderID, o.OrderDate, o.TotalAmount, o.PaymentStatus, o.CardLastFour
            ORDER BY o.OrderDate DESC";

        var orderParams = new List<SqlParameter>
        {
            DBHelper.ParamInt("@UserID", userId),
            new System.Data.SqlClient.SqlParameter("@From", threeMonthsAgo)
        };

        DataTable orders = DBHelper.ExecuteQuery(orderSql, orderParams);

        if (orders.Rows.Count == 0)
        {
            pnlEmpty.Visible = true;
            pnlOrders.Visible = false;
            return;
        }

        pnlEmpty.Visible = false;
        pnlOrders.Visible = true;

        gvOrders.DataSource = orders;
        gvOrders.DataBind();

        // Order items breakdown
        string itemSql = @"
            SELECT oi.OrderID, p.Name AS Package, p.Category, oi.UnitPrice, oi.Quantity
            FROM OrderItems oi
            INNER JOIN Orders o ON oi.OrderID = o.OrderID
            INNER JOIN Packages p ON oi.PackageID = p.PackageID
            WHERE o.UserID = @UserID AND o.OrderDate >= @From
            ORDER BY oi.OrderID DESC";

        var itemParams = new List<SqlParameter>
        {
            DBHelper.ParamInt("@UserID", userId),
            new System.Data.SqlClient.SqlParameter("@From", threeMonthsAgo)
        };

        DataTable items = DBHelper.ExecuteQuery(itemSql, itemParams);
        gvItems.DataSource = items;
        gvItems.DataBind();
    }

    protected void gvOrders_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        gvOrders.PageIndex = e.NewPageIndex;
        LoadOrders();
    }

    protected void btnDownloadPdf_Click(object sender, EventArgs e)
    {
        int userId = Helpers.GetUserID();
        DateTime threeMonthsAgo = DateTime.Now.AddMonths(-3);

        var orderParameters = new List<SqlParameter>
        {
            DBHelper.ParamInt("@UserID", userId),
            new SqlParameter("@From", threeMonthsAgo)
        };

        DataTable orders = DBHelper.ExecuteQuery(@"
            SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.PaymentStatus, o.CardLastFour,
                   COUNT(oi.OrderItemID) AS ItemCount
            FROM Orders o
            LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
            WHERE o.UserID = @UserID AND o.OrderDate >= @From
            GROUP BY o.OrderID, o.OrderDate, o.TotalAmount, o.PaymentStatus, o.CardLastFour
            ORDER BY o.OrderDate DESC", orderParameters);

        var itemParameters = new List<SqlParameter>
        {
            DBHelper.ParamInt("@UserID", userId),
            new SqlParameter("@From", threeMonthsAgo)
        };

        DataTable items = DBHelper.ExecuteQuery(@"
            SELECT oi.OrderID, p.Name AS Package, p.Category, oi.UnitPrice, oi.Quantity
            FROM OrderItems oi
            INNER JOIN Orders o ON oi.OrderID = o.OrderID
            INNER JOIN Packages p ON oi.PackageID = p.PackageID
            WHERE o.UserID = @UserID AND o.OrderDate >= @From
            ORDER BY oi.OrderID DESC", itemParameters);

        DataTableLike pdfOrders = new DataTableLike();
        foreach (DataRow row in orders.Rows)
        {
            var pdfRow = new Dictionary<string, string>();
            pdfRow["OrderID"] = row["OrderID"].ToString();
            pdfRow["OrderDate"] = Convert.ToDateTime(row["OrderDate"]).ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
            pdfRow["ItemCount"] = row["ItemCount"].ToString();
            pdfRow["TotalAmount"] = Convert.ToDecimal(row["TotalAmount"]).ToString("N2", CultureInfo.InvariantCulture);
            pdfRow["PaymentStatus"] = row["PaymentStatus"].ToString();
            pdfOrders.Rows.Add(pdfRow);
        }

        DataTableLike pdfItems = new DataTableLike();
        foreach (DataRow row in items.Rows)
        {
            var pdfRow = new Dictionary<string, string>();
            pdfRow["OrderID"] = row["OrderID"].ToString();
            pdfRow["Package"] = row["Package"].ToString();
            pdfRow["Category"] = row["Category"].ToString();
            pdfRow["Quantity"] = row["Quantity"].ToString();
            decimal subtotal = Convert.ToDecimal(row["UnitPrice"]) * Convert.ToInt32(row["Quantity"]);
            pdfRow["Subtotal"] = subtotal.ToString("N2", CultureInfo.InvariantCulture);
            pdfItems.Rows.Add(pdfRow);
        }

        byte[] pdf = PdfHelper.BuildPurchaseHistoryPdf(Helpers.GetUserName(), pdfOrders, pdfItems);
        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.AddHeader("Content-Disposition", "attachment; filename=IslandEscapePurchaseHistory.pdf");
        Response.BinaryWrite(pdf);
        Response.End();
    }
}
