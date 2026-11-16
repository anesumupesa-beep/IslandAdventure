using System;
using System.Collections.Generic;
using System.Data.SqlClient;

public partial class Admin_ManageQueries : System.Web.UI.Page
{
    // -1 = all, 0 = unresolved, 1 = resolved
    private int _filter = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (ViewState["Filter"] != null)
            _filter = (int)ViewState["Filter"];

        if (!IsPostBack)
            LoadQueries();
    }

    private void LoadQueries()
    {
        string sql = "SELECT QueryID, Name, Email, Subject, Message, DateSubmitted, IsResolved FROM ContactQueries";

        if (_filter >= 0)
            sql += " WHERE IsResolved = " + _filter;

        sql += " ORDER BY DateSubmitted DESC";

        gvQueries.DataSource = DBHelper.ExecuteQuery(sql);
        gvQueries.DataBind();
    }

    protected void FilterBtn_Click(object sender, EventArgs e)
    {
        System.Web.UI.WebControls.LinkButton btn = (System.Web.UI.WebControls.LinkButton)sender;
        _filter = Convert.ToInt32(btn.CommandArgument);
        ViewState["Filter"] = _filter;
        gvQueries.PageIndex = 0;
        LoadQueries();
    }

    protected void gvQueries_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int queryId = Convert.ToInt32(e.CommandArgument);
        bool resolve = (e.CommandName == "Resolve");

        string sql = "UPDATE ContactQueries SET IsResolved = @Val WHERE QueryID = @ID";
        var parms = new List<SqlParameter>
        {
            DBHelper.ParamBit("@Val", resolve),
            DBHelper.ParamInt("@ID", queryId)
        };
        DBHelper.ExecuteNonQuery(sql, parms);
        LoadQueries();
    }

    protected void gvQueries_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        gvQueries.PageIndex = e.NewPageIndex;
        LoadQueries();
    }
}
