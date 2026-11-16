using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.Security;

public class IslandEscapeMembershipProvider : MembershipProvider
{
    public override string ApplicationName { get; set; }
    public override bool EnablePasswordReset { get { return true; } }
    public override bool EnablePasswordRetrieval { get { return false; } }
    public override bool RequiresQuestionAndAnswer { get { return false; } }
    public override bool RequiresUniqueEmail { get { return true; } }
    public override int MaxInvalidPasswordAttempts { get { return 5; } }
    public override int PasswordAttemptWindow { get { return 10; } }
    public override MembershipPasswordFormat PasswordFormat { get { return MembershipPasswordFormat.Hashed; } }
    public override int MinRequiredPasswordLength { get { return 6; } }
    public override int MinRequiredNonAlphanumericCharacters { get { return 0; } }
    public override string PasswordStrengthRegularExpression { get { return string.Empty; } }

    public override bool ValidateUser(string username, string password)
    {
        string email = NormalizeEmail(username);
        string sql = "SELECT PasswordHash, IsActive FROM Users WHERE Email = @Email";
        DataTable dt = DBHelper.ExecuteQuery(sql, new List<SqlParameter> { DBHelper.ParamString("@Email", email, 150) });

        if (dt.Rows.Count == 0)
            return false;

        DataRow row = dt.Rows[0];
        return Convert.ToBoolean(row["IsActive"]) && Helpers.VerifyPassword(password, row["PasswordHash"].ToString());
    }

    public override MembershipUser CreateUser(
        string username,
        string password,
        string email,
        string passwordQuestion,
        string passwordAnswer,
        bool isApproved,
        object providerUserKey,
        out MembershipCreateStatus status)
    {
        string normalizedEmail = NormalizeEmail(!string.IsNullOrWhiteSpace(email) ? email : username);

        if (string.IsNullOrWhiteSpace(normalizedEmail))
        {
            status = MembershipCreateStatus.InvalidEmail;
            return null;
        }

        if (password == null || password.Length < MinRequiredPasswordLength)
        {
            status = MembershipCreateStatus.InvalidPassword;
            return null;
        }

        int exists = Convert.ToInt32(DBHelper.ExecuteScalar(
            "SELECT COUNT(*) FROM Users WHERE Email = @Email",
            new List<SqlParameter> { DBHelper.ParamString("@Email", normalizedEmail, 150) }));

        if (exists > 0)
        {
            status = MembershipCreateStatus.DuplicateEmail;
            return null;
        }

        string displayName = string.IsNullOrWhiteSpace(username) ? normalizedEmail : username.Trim();
        string sql = @"INSERT INTO Users (FullName, Email, PasswordHash, Role, IsActive)
                       OUTPUT INSERTED.UserID
                       VALUES (@FullName, @Email, @PasswordHash, 'Customer', @IsActive)";

        int userId = Convert.ToInt32(DBHelper.ExecuteScalar(sql, new List<SqlParameter>
        {
            DBHelper.ParamString("@FullName", displayName, 100),
            DBHelper.ParamString("@Email", normalizedEmail, 150),
            DBHelper.ParamString("@PasswordHash", Helpers.HashPassword(password), 256),
            DBHelper.ParamBit("@IsActive", isApproved)
        }));

        status = MembershipCreateStatus.Success;
        return BuildMembershipUser(userId, displayName, normalizedEmail, isApproved, DateTime.Now);
    }

    public MembershipCreateStatus CreateIslandEscapeUser(string fullName, string email, string password, string phone, string address)
    {
        string normalizedEmail = NormalizeEmail(email);

        if (string.IsNullOrWhiteSpace(normalizedEmail))
            return MembershipCreateStatus.InvalidEmail;

        if (password == null || password.Length < MinRequiredPasswordLength)
            return MembershipCreateStatus.InvalidPassword;

        int exists = Convert.ToInt32(DBHelper.ExecuteScalar(
            "SELECT COUNT(*) FROM Users WHERE Email = @Email",
            new List<SqlParameter> { DBHelper.ParamString("@Email", normalizedEmail, 150) }));

        if (exists > 0)
            return MembershipCreateStatus.DuplicateEmail;

        string sql = @"INSERT INTO Users (FullName, Email, PasswordHash, Phone, Address, Role, IsActive)
                       VALUES (@FullName, @Email, @PasswordHash, @Phone, @Address, 'Customer', 1)";

        DBHelper.ExecuteNonQuery(sql, new List<SqlParameter>
        {
            DBHelper.ParamString("@FullName", fullName, 100),
            DBHelper.ParamString("@Email", normalizedEmail, 150),
            DBHelper.ParamString("@PasswordHash", Helpers.HashPassword(password), 256),
            DBHelper.ParamString("@Phone", phone, 20),
            DBHelper.ParamString("@Address", address, 250)
        });

        return MembershipCreateStatus.Success;
    }

    public override bool ChangePassword(string username, string oldPassword, string newPassword)
    {
        if (!ValidateUser(username, oldPassword) || string.IsNullOrEmpty(newPassword) || newPassword.Length < MinRequiredPasswordLength)
            return false;

        return SetPassword(username, newPassword);
    }

    public bool ChangePasswordByUserId(int userId, string newPassword)
    {
        if (userId <= 0 || string.IsNullOrEmpty(newPassword) || newPassword.Length < MinRequiredPasswordLength)
            return false;

        string sql = "UPDATE Users SET PasswordHash = @Hash WHERE UserID = @ID AND IsActive = 1";
        int rows = DBHelper.ExecuteNonQuery(sql, new List<SqlParameter>
        {
            DBHelper.ParamString("@Hash", Helpers.HashPassword(newPassword), 256),
            DBHelper.ParamInt("@ID", userId)
        });
        return rows > 0;
    }

    public override string ResetPassword(string username, string answer)
    {
        string temporaryPassword = GenerateTemporaryPassword();
        if (!SetPassword(username, temporaryPassword))
            throw new MembershipPasswordException("No active account was found for the supplied email address.");

        return temporaryPassword;
    }

    public override MembershipUser GetUser(string username, bool userIsOnline)
    {
        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT UserID, FullName, Email, IsActive, DateRegistered FROM Users WHERE Email = @Email",
            new List<SqlParameter> { DBHelper.ParamString("@Email", NormalizeEmail(username), 150) });

        if (dt.Rows.Count == 0)
            return null;

        DataRow row = dt.Rows[0];
        return BuildMembershipUser(
            Convert.ToInt32(row["UserID"]),
            row["FullName"].ToString(),
            row["Email"].ToString(),
            Convert.ToBoolean(row["IsActive"]),
            Convert.ToDateTime(row["DateRegistered"]));
    }

    public override MembershipUser GetUser(object providerUserKey, bool userIsOnline)
    {
        int userId;
        if (!int.TryParse(providerUserKey.ToString(), out userId))
            return null;

        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT UserID, FullName, Email, IsActive, DateRegistered FROM Users WHERE UserID = @ID",
            new List<SqlParameter> { DBHelper.ParamInt("@ID", userId) });

        if (dt.Rows.Count == 0)
            return null;

        DataRow row = dt.Rows[0];
        return BuildMembershipUser(
            Convert.ToInt32(row["UserID"]),
            row["FullName"].ToString(),
            row["Email"].ToString(),
            Convert.ToBoolean(row["IsActive"]),
            Convert.ToDateTime(row["DateRegistered"]));
    }

    public override string GetUserNameByEmail(string email)
    {
        object result = DBHelper.ExecuteScalar(
            "SELECT Email FROM Users WHERE Email = @Email",
            new List<SqlParameter> { DBHelper.ParamString("@Email", NormalizeEmail(email), 150) });

        return result == null ? null : result.ToString();
    }

    private bool SetPassword(string username, string newPassword)
    {
        string sql = "UPDATE Users SET PasswordHash = @Hash WHERE Email = @Email AND IsActive = 1";
        int rows = DBHelper.ExecuteNonQuery(sql, new List<SqlParameter>
        {
            DBHelper.ParamString("@Hash", Helpers.HashPassword(newPassword), 256),
            DBHelper.ParamString("@Email", NormalizeEmail(username), 150)
        });
        return rows > 0;
    }

    private static string NormalizeEmail(string email)
    {
        return (email ?? string.Empty).Trim().ToLower();
    }

    private static string GenerateTemporaryPassword()
    {
        string[] firstWords = { "Lagoon", "Coral", "Palm", "Island", "Ocean", "Sunset", "Reef", "Tamarin" };
        string[] secondWords = { "Escape", "Voyage", "Harbor", "Breeze", "Trail", "Cruise", "Resort", "Holiday" };
        char[] symbols = { '!', '#', '$', '?' };

        return firstWords[RandomIndex(firstWords.Length)] +
               secondWords[RandomIndex(secondWords.Length)] +
               RandomNumber(100, 999).ToString() +
               symbols[RandomIndex(symbols.Length)];
    }

    private static int RandomIndex(int maxExclusive)
    {
        byte[] bytes = new byte[4];
        using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            rng.GetBytes(bytes);

        int value = Math.Abs(BitConverter.ToInt32(bytes, 0));
        return value % maxExclusive;
    }

    private static int RandomNumber(int minInclusive, int maxInclusive)
    {
        return minInclusive + RandomIndex(maxInclusive - minInclusive + 1);
    }

    private MembershipUser BuildMembershipUser(int userId, string fullName, string email, bool isApproved, DateTime created)
    {
        return new MembershipUser(
            Name,
            email,
            userId,
            email,
            string.Empty,
            fullName,
            isApproved,
            false,
            created,
            DateTime.Now,
            DateTime.Now,
            DateTime.MinValue,
            DateTime.MinValue);
    }

    public override bool DeleteUser(string username, bool deleteAllRelatedData) { throw new NotSupportedException(); }
    public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords) { throw new NotSupportedException(); }
    public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords) { throw new NotSupportedException(); }
    public override MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords) { throw new NotSupportedException(); }
    public override int GetNumberOfUsersOnline() { return 0; }
    public override string GetPassword(string username, string answer) { throw new NotSupportedException(); }
    public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer) { return false; }
    public override bool UnlockUser(string userName) { return false; }
    public override void UpdateUser(MembershipUser user) { throw new NotSupportedException(); }
}
