<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container">
    <div class="auth-card card p-4">
        <h3 class="text-center mb-1 fw-bold">Welcome Back</h3>
        <p class="text-center text-muted mb-4">Login to your Island Escape account</p>

        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Email is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Your password" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                ErrorMessage="Password is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                <label class="form-check-label small">Remember me</label>
            </div>
            <a href="~/ForgotPassword.aspx" runat="server" class="small">Forgot password?</a>
        </div>

        <asp:Button ID="btnLogin" runat="server" Text="Login"
            CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />

        <p class="text-center mt-3 small">
            Don't have an account? <a href="~/Register.aspx" runat="server">Register here</a>
        </p>
    </div>
</div>
</asp:Content>
