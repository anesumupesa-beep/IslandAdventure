using System;

public partial class Admin_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadStats();
    }

    private void LoadStats()
    {
        lblPackages.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Packages").ToString();
        lblUsers.Text    = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'Customer'").ToString();
        lblOrders.Text   = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Orders").ToString();
        lblQueries.Text  = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM ContactQueries WHERE IsResolved = 0").ToString();

        string sql = @"SELECT TOP 10 o.OrderID, u.FullName AS Customer, o.OrderDate, o.TotalAmount, o.PaymentStatus
                       FROM Orders o INNER JOIN Users u ON o.UserID = u.UserID
                       ORDER BY o.OrderDate DESC";
        gvRecentOrders.DataSource = DBHelper.ExecuteQuery(sql);
        gvRecentOrders.DataBind();
    }
}
