using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class PackageDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadPackage();
    }

    private void LoadPackage()
    {
        int packageId;
        if (!int.TryParse(Request.QueryString["id"], out packageId))
        {
            pnlNotFound.Visible = true;
            fvPackage.Visible = false;
            return;
        }

        string sql = "SELECT PackageID, Name, Description, Price, Category, ImageURL FROM Packages WHERE PackageID = @ID AND IsAvailable = 1";
        var parameters = new List<SqlParameter> { DBHelper.ParamInt("@ID", packageId) };
        DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

        if (dt.Rows.Count == 0)
        {
            pnlNotFound.Visible = true;
            fvPackage.Visible = false;
            return;
        }

        fvPackage.DataSource = dt;
        fvPackage.DataBind();
    }

    protected void btnAddToCart_Click(object sender, EventArgs e)
    {
        if (!Helpers.IsLoggedIn())
        {
            Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        int packageId;
        if (!int.TryParse(Request.QueryString["id"], out packageId)) return;

        // Get qty from FormView
        TextBox txtQty = (TextBox)fvPackage.FindControl("txtQty");
        int qty = 1;
        if (txtQty != null) int.TryParse(txtQty.Text, out qty);
        if (qty < 1) qty = 1;

        Helpers.AddToCart(packageId, qty);

        Label lblCartMsg = (Label)fvPackage.FindControl("lblCartMsg");
        if (lblCartMsg != null)
        {
            lblCartMsg.Text = "Added to cart. <a href='Cart.aspx'>View Cart</a>";
            lblCartMsg.Visible = true;
        }
    }
}
