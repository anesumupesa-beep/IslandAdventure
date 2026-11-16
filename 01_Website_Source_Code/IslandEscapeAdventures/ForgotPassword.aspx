<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="ForgotPassword" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container">
    <div class="auth-card card p-4">
        <h3 class="text-center mb-1 fw-bold">Reset Password</h3>
        <p class="text-center text-muted mb-4">Enter your email and a temporary password will be generated.</p>

        <!-- Step 1: Enter email -->
        <asp:Panel ID="pnlForm" runat="server">
            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
            </div>

            <asp:Button ID="btnReset" runat="server" Text="Reset My Password"
                CssClass="btn btn-warning w-100" OnClick="btnReset_Click" />
        </asp:Panel>

        <!-- Step 2: Show new password -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="alert alert-success text-center">
                <h4 class="fw-bold h5">Password Reset Successful!</h4>
                <p class="mb-2">Your temporary password is:</p>
                <div class="bg-light border rounded p-2 mb-3">
                    <code class="fs-5 fw-bold text-danger">
                        <asp:Label ID="lblNewPassword" runat="server" />
                    </code>
                </div>
                <p class="small text-muted">Please log in and change your password immediately.</p>
            </div>
            <a href="~/Login.aspx" runat="server" class="btn btn-primary w-100">Go to Login</a>
        </asp:Panel>

        <p class="text-center mt-3 small">
            <a href="~/Login.aspx" runat="server">Back to Login</a>
        </p>
    </div>
</div>
</asp:Content>
