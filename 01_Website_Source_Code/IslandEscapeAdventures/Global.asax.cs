using System;
using System.Security.Principal;
using System.Web;
using System.Web.Security;

public partial class Global : HttpApplication
{
    protected void Application_Start(object sender, EventArgs e)
    {
        // Application startup
    }

    protected void Session_End(object sender, EventArgs e)
    {
        // Session expired - cart and login state cleared automatically.
    }

    protected void Application_PostAuthenticateRequest(object sender, EventArgs e)
    {
        HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
        if (authCookie == null || string.IsNullOrEmpty(authCookie.Value))
            return;

        FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
        if (ticket == null || ticket.Expired)
            return;

        string[] roles = ticket.UserData.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        HttpContext.Current.User = new GenericPrincipal(new FormsIdentity(ticket), roles);
    }

    protected void Application_Error(object sender, EventArgs e)
    {
        Exception ex = Server.GetLastError();
        if (ex != null)
        {
            Application["LastError"] = ex.Message;
        }
    }
}
