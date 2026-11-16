using System;

public partial class Admin_AdminMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Enforce admin-only access
        if (!Helpers.IsAdmin())
        {
            Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
        }

        lblAdminName.Text = Helpers.GetUserName();

        // Flash messages
        string msg = Session["FlashMsg"] as string;
        string css = Session["FlashCss"] as string;
        if (!string.IsNullOrEmpty(msg))
        {
            pnlFlash.Visible = true;
            lblFlash.Text = msg;
            lblFlash.CssClass = "alert d-block " + (css ?? "alert-success");
            Session.Remove("FlashMsg");
            Session.Remove("FlashCss");
        }
    }

    protected void lbtnAdminLogout_Click(object sender, EventArgs e)
    {
        Helpers.ClearSession();
        Response.Redirect("~/Login.aspx");
    }

    public static void SetFlash(string message, string cssClass = "alert-success")
    {
        System.Web.HttpContext.Current.Session["FlashMsg"] = message;
        System.Web.HttpContext.Current.Session["FlashCss"] = cssClass;
    }
}
