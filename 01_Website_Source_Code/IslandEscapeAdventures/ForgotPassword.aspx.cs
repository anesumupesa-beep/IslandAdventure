using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

public partial class ForgotPassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e) { }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string email = txtEmail.Text.Trim().ToLower();

        // Check if user exists
        string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND IsActive = 1";
        var checkParams = new List<SqlParameter> { DBHelper.ParamString("@Email", email, 150) };
        int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, checkParams));

        if (count == 0)
        {
            lblError.Text = "No active account found with that email address.";
            lblError.Visible = true;
            return;
        }

        string newPassword;
        try
        {
            newPassword = Membership.Provider.ResetPassword(email, null);
        }
        catch (MembershipPasswordException)
        {
            lblError.Text = "Password reset failed. Please contact support.";
            lblError.Visible = true;
            return;
        }

        // Show success panel
        pnlForm.Visible = false;
        pnlSuccess.Visible = true;
        lblNewPassword.Text = newPassword;
    }
}
