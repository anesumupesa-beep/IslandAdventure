using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Redirect if already logged in
        if (Helpers.IsLoggedIn())
            Response.Redirect("~/Default.aspx");
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string email = txtEmail.Text.Trim().ToLower();

        IslandEscapeMembershipProvider provider = Membership.Provider as IslandEscapeMembershipProvider;
        if (provider == null)
        {
            lblError.Text = "Membership provider is not configured correctly.";
            lblError.Visible = true;
            return;
        }

        MembershipCreateStatus status = provider.CreateIslandEscapeUser(
            txtFullName.Text.Trim(),
            email,
            txtPassword.Text,
            txtPhone.Text.Trim(),
            txtAddress.Text.Trim());

        if (status != MembershipCreateStatus.Success)
        {
            lblError.Text = GetCreateUserError(status);
            lblError.Visible = true;
            return;
        }

        // Auto-login after registration
        LoginUser(email);
    }

    private void LoginUser(string email)
    {
        string sql = "SELECT UserID, FullName, Role FROM Users WHERE Email = @Email AND IsActive = 1";
        var parameters = new List<SqlParameter> { DBHelper.ParamString("@Email", email, 150) };
        DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

        if (dt.Rows.Count > 0)
        {
            Session["UserID"]   = Convert.ToInt32(dt.Rows[0]["UserID"]);
            Session["UserName"] = dt.Rows[0]["FullName"].ToString();
            Session["Role"]     = dt.Rows[0]["Role"].ToString();

            string[] roles = Roles.GetRolesForUser(email);
            string roleData = roles.Length > 0 ? string.Join(",", roles) : dt.Rows[0]["Role"].ToString();

            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                1,
                email,
                DateTime.Now,
                DateTime.Now.AddMinutes(30),
                false,
                roleData,
                FormsAuthentication.FormsCookiePath);

            string encryptedTicket = FormsAuthentication.Encrypt(ticket);
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
            Response.Cookies.Add(authCookie);
        }

        Session["FlashMsg"] = "Welcome to Island Escape Adventures! Your account has been created.";
        Session["FlashCss"] = "alert-success";
        Response.Redirect("~/Default.aspx");
    }

    private string GetCreateUserError(MembershipCreateStatus status)
    {
        switch (status)
        {
            case MembershipCreateStatus.DuplicateEmail:
            case MembershipCreateStatus.DuplicateUserName:
                return "An account with this email already exists.";
            case MembershipCreateStatus.InvalidPassword:
                return "Password must be at least 6 characters.";
            case MembershipCreateStatus.InvalidEmail:
                return "Please enter a valid email address.";
            default:
                return "Account creation failed. Please check your details and try again.";
        }
    }
}
