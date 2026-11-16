<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container">
    <div class="auth-card card p-4">
        <h3 class="text-center mb-1 fw-bold">Create Account</h3>
        <p class="text-center text-muted mb-4">Join Island Escape Adventures today</p>

        <asp:ValidationSummary ID="valSummary" runat="server"
            CssClass="alert alert-danger validation-summary-errors"
            HeaderText="Please fix the following:" />

        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

        <div class="mb-3">
            <label class="form-label">Full Name *</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. Jean-Paul Laborde" MaxLength="100" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                ErrorMessage="Full name is required." Display="None" ForeColor="" />
        </div>

        <div class="mb-3">
            <label class="form-label">Email Address *</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" MaxLength="150" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Email is required." Display="None" ForeColor="" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                ErrorMessage="Please enter a valid email address." Display="None" ForeColor="" />
        </div>

        <div class="mb-3">
            <label class="form-label">Phone Number</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="+230 5900 0000" MaxLength="20" />
        </div>

        <div class="mb-3">
            <label class="form-label">Address</label>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Street, City, Mauritius" MaxLength="250" />
        </div>

        <div class="mb-3">
            <label class="form-label">Password *</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Minimum 6 characters" MaxLength="100" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                ErrorMessage="Password is required." Display="None" ForeColor="" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword"
                ValidationExpression=".{6,}"
                ErrorMessage="Password must be at least 6 characters." Display="None" ForeColor="" />
        </div>

        <div class="mb-4">
            <label class="form-label">Confirm Password *</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat your password" MaxLength="100" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmPassword"
                ErrorMessage="Please confirm your password." Display="None" ForeColor="" />
            <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword"
                ErrorMessage="Passwords do not match." Display="None" ForeColor="" />
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="Create Account"
            CssClass="btn btn-primary w-100" OnClick="btnRegister_Click" />

        <p class="text-center mt-3 small">
            Already have an account? <a href="~/Login.aspx" runat="server">Login here</a>
        </p>
    </div>
</div>
</asp:Content>
