using System;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadFeaturedPackages();
    }

    private void LoadFeaturedPackages()
    {
        // Show 6 available packages for the home page
        string sql = "SELECT TOP 6 PackageID, Name, Description, Price, Category, ImageURL FROM Packages WHERE IsAvailable = 1 ORDER BY PackageID";
        rptFeatured.DataSource = DBHelper.ExecuteQuery(sql);
        rptFeatured.DataBind();
    }
}
