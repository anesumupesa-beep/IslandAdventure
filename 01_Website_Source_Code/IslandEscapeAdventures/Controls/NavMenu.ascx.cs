using System;

public partial class Controls_NavMenu : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Helpers.IsLoggedIn())
        {
            pnlLoggedIn.Visible = true;
            pnlLoggedOut.Visible = false;
            lblUserName.Text = Helpers.GetUserName();
        }
        else
        {
            pnlLoggedIn.Visible = false;
            pnlLoggedOut.Visible = true;
        }

        // Show cart badge if items in cart
        int count = Helpers.GetCartCount();
        if (count > 0)
        {
            lblCartCount.Visible = true;
            lblCartCount.Text = count.ToString();
        }
    }

    protected void lbtnLogout_Click(object sender, EventArgs e)
    {
        Helpers.ClearSession();
        Response.Redirect("~/Default.aspx");
    }
}
