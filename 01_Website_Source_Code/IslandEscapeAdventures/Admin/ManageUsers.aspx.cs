using System;
using System.Collections.Generic;
using System.Data.SqlClient;

public partial class Admin_ManageUsers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadUsers();
    }

    private void LoadUsers()
    {
        string sql = "SELECT UserID, FullName, Email, Phone, DateRegistered, IsActive FROM Users WHERE Role = 'Customer' ORDER BY DateRegistered DESC";
        gvUsers.DataSource = DBHelper.ExecuteQuery(sql);
        gvUsers.DataBind();
    }

    protected void gvUsers_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int userId = Convert.ToInt32(e.CommandArgument);
        bool setActive = (e.CommandName == "Activate");

        string sql = "UPDATE Users SET IsActive = @Active WHERE UserID = @ID";
        var parms = new List<SqlParameter>
        {
            DBHelper.ParamBit("@Active", setActive),
            DBHelper.ParamInt("@ID", userId)
        };
        DBHelper.ExecuteNonQuery(sql, parms);

        Admin_AdminMaster.SetFlash("Account " + (setActive ? "activated." : "deactivated."),
            setActive ? "alert-success" : "alert-warning");

        LoadUsers();
    }

    protected void gvUsers_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        gvUsers.PageIndex = e.NewPageIndex;
        LoadUsers();
    }
}
