using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI.WebControls;

public partial class UserProfile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Helpers.RequireLogin(this);
        if (!IsPostBack)
            LoadProfile();
    }

    private void LoadProfile()
    {
        string sql = "SELECT UserID, FullName, Email, Phone, Address, DateRegistered FROM Users WHERE UserID = @ID";
        var parameters = new List<SqlParameter> { DBHelper.ParamInt("@ID", Helpers.GetUserID()) };
        DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

        fvProfile.DataSource = dt;
        fvProfile.DataBind();
    }

    protected void fvProfile_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        fvProfile.ChangeMode(e.NewMode);
        LoadProfile();
    }

    protected void fvProfile_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        if (!Page.IsValid) return;

        TextBox txtFullName    = (TextBox)fvProfile.FindControl("txtFullName");
        TextBox txtPhone       = (TextBox)fvProfile.FindControl("txtPhone");
        TextBox txtAddress     = (TextBox)fvProfile.FindControl("txtAddress");
        TextBox txtNewPassword = (TextBox)fvProfile.FindControl("txtNewPassword");

        // Base update
        string sql = "UPDATE Users SET FullName = @FullName, Phone = @Phone, Address = @Address WHERE UserID = @ID";
        var parameters = new List<SqlParameter>
        {
            DBHelper.ParamString("@FullName", txtFullName.Text.Trim(), 100),
            DBHelper.ParamString("@Phone",    txtPhone.Text.Trim(), 20),
            DBHelper.ParamString("@Address",  txtAddress.Text.Trim(), 250),
            DBHelper.ParamInt("@ID",          Helpers.GetUserID())
        };
        DBHelper.ExecuteNonQuery(sql, parameters);

        // Update password only if provided
        if (!string.IsNullOrWhiteSpace(txtNewPassword.Text))
        {
            IslandEscapeMembershipProvider provider = Membership.Provider as IslandEscapeMembershipProvider;
            if (provider == null || !provider.ChangePasswordByUserId(Helpers.GetUserID(), txtNewPassword.Text))
            {
                lblSuccess.Text = "Profile details were saved, but the password could not be updated.";
                lblSuccess.CssClass = "alert alert-warning d-block";
                lblSuccess.Visible = true;
                fvProfile.ChangeMode(FormViewMode.ReadOnly);
                LoadProfile();
                return;
            }
        }

        // Update session name
        Session["UserName"] = txtFullName.Text.Trim();

        fvProfile.ChangeMode(FormViewMode.ReadOnly);
        LoadProfile();

        lblSuccess.Text = "Profile updated successfully.";
        lblSuccess.Visible = true;
    }
}
