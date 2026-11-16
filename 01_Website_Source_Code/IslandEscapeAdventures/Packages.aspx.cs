using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public partial class Packages : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Support category filter from query string (e.g., from home page category links)
            string cat = Request.QueryString["cat"];
            LoadPackages(cat ?? "");
        }
    }

    protected void FilterBtn_Click(object sender, EventArgs e)
    {
        System.Web.UI.WebControls.LinkButton btn = (System.Web.UI.WebControls.LinkButton)sender;
        LoadPackages(btn.CommandArgument);
    }

    private void LoadPackages(string category)
    {
        string sql;
        List<SqlParameter> parameters = new List<SqlParameter>();

        if (string.IsNullOrEmpty(category))
        {
            sql = "SELECT PackageID, Name, Description, Price, Category, ImageURL FROM Packages WHERE IsAvailable = 1 ORDER BY Category, Name";
        }
        else
        {
            sql = "SELECT PackageID, Name, Description, Price, Category, ImageURL FROM Packages WHERE IsAvailable = 1 AND Category = @Cat ORDER BY Name";
            parameters.Add(DBHelper.ParamString("@Cat", category, 50));
        }

        DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
        rptPackages.DataSource = dt;
        rptPackages.DataBind();

        pnlEmpty.Visible = (dt.Rows.Count == 0);
    }
}
