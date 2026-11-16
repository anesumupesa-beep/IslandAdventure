using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_ManagePackages : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadPackages();
    }

    private void LoadPackages()
    {
        string sql = "SELECT PackageID, Name, Category, Price, IsAvailable FROM Packages ORDER BY Category, Name";
        gvPackages.DataSource = DBHelper.ExecuteQuery(sql);
        gvPackages.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int packageId = Convert.ToInt32(hdnPackageID.Value);
        decimal price = 0;
        decimal.TryParse(txtPrice.Text, out price);

        if (packageId == 0)
        {
            // INSERT
            string sql = @"INSERT INTO Packages (Name, Description, Price, Category, ImageURL, IsAvailable)
                           VALUES (@Name, @Desc, @Price, @Cat, @Img, @Avail)";
            DBHelper.ExecuteNonQuery(sql, BuildParams(packageId, price));
            Admin_AdminMaster.SetFlash("Package added successfully.");
        }
        else
        {
            // UPDATE
            string sql = @"UPDATE Packages SET Name=@Name, Description=@Desc, Price=@Price,
                           Category=@Cat, ImageURL=@Img, IsAvailable=@Avail
                           WHERE PackageID=@ID";
            var parms = BuildParams(packageId, price);
            parms.Add(DBHelper.ParamInt("@ID", packageId));
            DBHelper.ExecuteNonQuery(sql, parms);
            Admin_AdminMaster.SetFlash("Package updated successfully.");
        }

        ClearForm();
        LoadPackages();
    }

    private List<SqlParameter> BuildParams(int id, decimal price)
    {
        return new List<SqlParameter>
        {
            DBHelper.ParamString("@Name",  txtName.Text.Trim(), 150),
            DBHelper.ParamString("@Desc",  txtDescription.Text.Trim(), 1000),
            DBHelper.ParamDecimal("@Price", price),
            DBHelper.ParamString("@Cat",   ddlCategory.SelectedValue, 50),
            DBHelper.ParamString("@Img",   txtImageURL.Text.Trim(), 300),
            DBHelper.ParamBit("@Avail",    chkAvailable.Checked)
        };
    }

    protected void gvPackages_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int packageId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DeletePkg")
        {
            DBHelper.ExecuteNonQuery("UPDATE Packages SET IsAvailable = 0 WHERE PackageID = @ID",
                new List<SqlParameter> { DBHelper.ParamInt("@ID", packageId) });
            Admin_AdminMaster.SetFlash("Package removed from the public catalogue.", "alert-warning");
        }
        else if (e.CommandName == "EditPkg")
        {
            string sql = "SELECT * FROM Packages WHERE PackageID = @ID";
            DataTable dt = DBHelper.ExecuteQuery(sql, new List<SqlParameter> { DBHelper.ParamInt("@ID", packageId) });
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                hdnPackageID.Value       = packageId.ToString();
                txtName.Text             = row["Name"].ToString();
                txtDescription.Text      = row["Description"].ToString();
                txtPrice.Text            = row["Price"].ToString();
                ddlCategory.SelectedValue = row["Category"].ToString();
                txtImageURL.Text         = row["ImageURL"].ToString();
                chkAvailable.Checked     = Convert.ToBoolean(row["IsAvailable"]);
                lblFormTitle.Text        = "Edit Package";
            }
        }

        LoadPackages();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
    }

    private void ClearForm()
    {
        hdnPackageID.Value  = "0";
        txtName.Text        = "";
        txtDescription.Text = "";
        txtPrice.Text       = "";
        txtImageURL.Text    = "";
        chkAvailable.Checked = true;
        lblFormTitle.Text   = "Add New Package";
    }

    protected void gvPackages_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        gvPackages.PageIndex = e.NewPageIndex;
        LoadPackages();
    }
}
