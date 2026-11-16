using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

public class IslandEscapeRoleProvider : RoleProvider
{
    public override string ApplicationName { get; set; }

    public override string[] GetRolesForUser(string username)
    {
        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT Role FROM Users WHERE Email = @Email AND IsActive = 1",
            new List<SqlParameter> { DBHelper.ParamString("@Email", NormalizeEmail(username), 150) });

        if (dt.Rows.Count == 0)
            return new string[0];

        return new string[] { dt.Rows[0]["Role"].ToString() };
    }

    public override bool IsUserInRole(string username, string roleName)
    {
        foreach (string role in GetRolesForUser(username))
        {
            if (string.Equals(role, roleName, StringComparison.OrdinalIgnoreCase))
                return true;
        }

        return false;
    }

    public override string[] GetAllRoles()
    {
        DataTable dt = DBHelper.ExecuteQuery("SELECT DISTINCT Role FROM Users ORDER BY Role");
        List<string> roles = new List<string>();

        foreach (DataRow row in dt.Rows)
            roles.Add(row["Role"].ToString());

        return roles.ToArray();
    }

    public override bool RoleExists(string roleName)
    {
        object result = DBHelper.ExecuteScalar(
            "SELECT COUNT(*) FROM Users WHERE Role = @Role",
            new List<SqlParameter> { DBHelper.ParamString("@Role", roleName, 20) });

        return Convert.ToInt32(result) > 0;
    }

    public override string[] GetUsersInRole(string roleName)
    {
        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT Email FROM Users WHERE Role = @Role AND IsActive = 1 ORDER BY Email",
            new List<SqlParameter> { DBHelper.ParamString("@Role", roleName, 20) });

        List<string> users = new List<string>();
        foreach (DataRow row in dt.Rows)
            users.Add(row["Email"].ToString());

        return users.ToArray();
    }

    public override string[] FindUsersInRole(string roleName, string usernameToMatch)
    {
        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT Email FROM Users WHERE Role = @Role AND Email LIKE @Email AND IsActive = 1 ORDER BY Email",
            new List<SqlParameter>
            {
                DBHelper.ParamString("@Role", roleName, 20),
                DBHelper.ParamString("@Email", "%" + NormalizeEmail(usernameToMatch) + "%", 150)
            });

        List<string> users = new List<string>();
        foreach (DataRow row in dt.Rows)
            users.Add(row["Email"].ToString());

        return users.ToArray();
    }

    private static string NormalizeEmail(string email)
    {
        return (email ?? string.Empty).Trim().ToLower();
    }

    public override void AddUsersToRoles(string[] usernames, string[] roleNames) { throw new NotSupportedException(); }
    public override void CreateRole(string roleName) { throw new NotSupportedException(); }
    public override bool DeleteRole(string roleName, bool throwOnPopulatedRole) { throw new NotSupportedException(); }
    public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames) { throw new NotSupportedException(); }
}
