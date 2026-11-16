using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;

/// <summary>
/// Utility methods used across the application.
/// </summary>
public static class Helpers
{
    // -------------------------------------------------------
    // Password hashing (SHA256)
    // -------------------------------------------------------

    /// <summary>Returns the SHA256 hex hash of a plain-text password.</summary>
    public static string HashPassword(string plainText)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }

    /// <summary>Verifies a plain-text password against a stored hash.</summary>
    public static bool VerifyPassword(string plainText, string storedHash)
    {
        return HashPassword(plainText) == storedHash;
    }

    // -------------------------------------------------------
    // Session helpers
    // -------------------------------------------------------

    public static void SetSession(string key, object value)
    {
        HttpContext.Current.Session[key] = value;
    }

    public static object GetSession(string key)
    {
        return HttpContext.Current.Session[key];
    }

    public static void ClearSession()
    {
        HttpContext.Current.Session.Clear();
        HttpContext.Current.Session.Abandon();
        FormsAuthentication.SignOut();
    }

    /// <summary>Returns true if a user is currently logged in.</summary>
    public static bool IsLoggedIn()
    {
        return HttpContext.Current.Session["UserID"] != null ||
               (HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated);
    }

    /// <summary>Returns true if the logged-in user is an Admin.</summary>
    public static bool IsAdmin()
    {
        object role = HttpContext.Current.Session["Role"];
        bool sessionAdmin = role != null && role.ToString() == "Admin";
        bool principalAdmin = HttpContext.Current.User != null && HttpContext.Current.User.IsInRole("Admin");
        return IsLoggedIn() && (sessionAdmin || principalAdmin);
    }

    public static int GetUserID()
    {
        return IsLoggedIn() ? (int)HttpContext.Current.Session["UserID"] : 0;
    }

    public static string GetUserName()
    {
        object userName = HttpContext.Current.Session["UserName"];
        return IsLoggedIn() && userName != null ? userName.ToString() : string.Empty;
    }

    public static string GetRole()
    {
        object role = HttpContext.Current.Session["Role"];
        return IsLoggedIn() && role != null ? role.ToString() : string.Empty;
    }

    // -------------------------------------------------------
    // Cart helpers (stored in Session as Dictionary<int,int>)
    // Key = PackageID, Value = Quantity
    // -------------------------------------------------------

    private const string CartKey = "Cart";

    public static System.Collections.Generic.Dictionary<int, int> GetCart()
    {
        if (HttpContext.Current.Session[CartKey] == null)
            HttpContext.Current.Session[CartKey] = new System.Collections.Generic.Dictionary<int, int>();

        return (System.Collections.Generic.Dictionary<int, int>)HttpContext.Current.Session[CartKey];
    }

    public static void AddToCart(int packageId, int qty = 1)
    {
        var cart = GetCart();
        if (cart.ContainsKey(packageId))
            cart[packageId] += qty;
        else
            cart[packageId] = qty;
    }

    public static void RemoveFromCart(int packageId)
    {
        var cart = GetCart();
        if (cart.ContainsKey(packageId))
            cart.Remove(packageId);
    }

    public static void UpdateCartQty(int packageId, int qty)
    {
        var cart = GetCart();
        if (qty <= 0)
            RemoveFromCart(packageId);
        else
            cart[packageId] = qty;
    }

    public static int GetCartCount()
    {
        int total = 0;
        foreach (var qty in GetCart().Values)
            total += qty;
        return total;
    }

    public static void ClearCart()
    {
        HttpContext.Current.Session[CartKey] = null;
    }

    // -------------------------------------------------------
    // Formatting helpers
    // -------------------------------------------------------

    /// <summary>Formats a decimal as Mauritian Rupees. E.g. Rs 1,200.00</summary>
    public static string FormatPrice(decimal amount)
    {
        return "Rs " + amount.ToString("N2");
    }

    /// <summary>Redirects to login page, preserving the return URL.</summary>
    public static void RequireLogin(Page page)
    {
        if (!IsLoggedIn())
        {
            HttpContext.Current.Response.Redirect("~/Login.aspx?returnUrl=" +
                HttpUtility.UrlEncode(HttpContext.Current.Request.Url.PathAndQuery));
        }
    }
}
