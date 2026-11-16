using System;

public partial class Site : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Show flash message if one was set in Session
        string msg = Session["FlashMsg"] as string;
        string css = Session["FlashCss"] as string;

        if (!string.IsNullOrEmpty(msg))
        {
            pnlFlash.Visible = true;
            lblFlash.Text = msg;
            lblFlash.CssClass = "alert d-block " + (css ?? "alert-info");
            Session.Remove("FlashMsg");
            Session.Remove("FlashCss");
        }
    }

    // Helper so any page can set a flash message
    public static void SetFlash(string message, string cssClass = "alert-success")
    {
        System.Web.HttpContext.Current.Session["FlashMsg"] = message;
        System.Web.HttpContext.Current.Session["FlashCss"] = cssClass;
    }
}
