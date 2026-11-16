using System;
using System.Collections.Generic;
using System.Data.SqlClient;

public partial class Contact : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Pre-fill if logged in
        if (!IsPostBack && Helpers.IsLoggedIn())
        {
            string sql = "SELECT FullName, Email FROM Users WHERE UserID = @ID";
            var parms = new List<SqlParameter> { DBHelper.ParamInt("@ID", Helpers.GetUserID()) };
            var dt = DBHelper.ExecuteQuery(sql, parms);
            if (dt.Rows.Count > 0)
            {
                txtName.Text  = dt.Rows[0]["FullName"].ToString();
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
            }
        }
    }

    protected void btnSend_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string sql = @"INSERT INTO ContactQueries (Name, Email, Subject, Message, DateSubmitted, IsResolved)
                       VALUES (@Name, @Email, @Subject, @Message, GETDATE(), 0)";

        var parameters = new List<SqlParameter>
        {
            DBHelper.ParamString("@Name",    txtName.Text.Trim(), 100),
            DBHelper.ParamString("@Email",   txtEmail.Text.Trim().ToLower(), 150),
            DBHelper.ParamString("@Subject", ddlSubject.SelectedValue, 200),
            DBHelper.ParamString("@Message", txtMessage.Text.Trim(), 2000)
        };

        DBHelper.ExecuteNonQuery(sql, parameters);

        pnlForm.Visible = false;
        pnlSuccess.Visible = true;
    }
}
