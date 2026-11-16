using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Helpers.IsLoggedIn())
            Response.Redirect("~/Default.aspx");
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string email    = txtEmail.Text.Trim().ToLower();
        string password = txtPassword.Text;

        string sql = "SELECT UserID, FullName, Role, IsActive FROM Users WHERE Email = @Email";
        var parameters = new List<SqlParameter> { DBHelper.ParamString("@Email", email, 150) };
        DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

        if (dt.Rows.Count == 0)
        {
            lblError.Text = "Invalid email or password.";
            lblError.Visible = true;
            return;
        }

        DataRow row = dt.Rows[0];

        if (Convert.ToBoolean(row["IsActive"]) == false)
        {
            lblError.Text = "Your account has been deactivated. Please contact support.";
            lblError.Visible = true;
            return;
        }

        if (!Membership.ValidateUser(email, password))
        {
            lblError.Text = "Invalid email or password.";
            lblError.Visible = true;
            return;
        }

        // Set session
        Session["UserID"]   = Convert.ToInt32(row["UserID"]);
        Session["UserName"] = row["FullName"].ToString();
        Session["Role"]     = row["Role"].ToString();

        string[] roles = Roles.GetRolesForUser(email);
        string roleData = roles.Length > 0 ? string.Join(",", roles) : row["Role"].ToString();

        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
            1,
            email,
            DateTime.Now,
            DateTime.Now.AddMinutes(30),
            chkRemember.Checked,
            roleData,
            FormsAuthentication.FormsCookiePath);

        string encryptedTicket = FormsAuthentication.Encrypt(ticket);
        HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
        if (chkRemember.Checked)
            authCookie.Expires = DateTime.Now.AddDays(7);
        Response.Cookies.Add(authCookie);

        // Redirect: admin goes to admin portal, others to home or returnUrl
        string role      = row["Role"].ToString();
        string returnUrl = Request.QueryString["returnUrl"];

        if (role == "Admin")
        {
            Response.Redirect("~/Admin/Default.aspx");
        }
        else if (!string.IsNullOrEmpty(returnUrl))
        {
            Response.Redirect(returnUrl);
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}
