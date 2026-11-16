<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="UserProfile" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5" style="max-width:680px;">
    <h2 class="section-title">My Profile</h2>

    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success d-block" Visible="false" />
    <asp:Label ID="lblError"   runat="server" CssClass="alert alert-danger d-block"  Visible="false" />

    <!-- FormView for profile display/edit -->
    <asp:FormView ID="fvProfile" runat="server" DefaultMode="ReadOnly"
        OnModeChanging="fvProfile_ModeChanging"
        OnItemUpdating="fvProfile_ItemUpdating"
        CssClass="card p-4 shadow-sm border-0">
        <ItemTemplate>
            <div class="mb-3">
                <label class="form-label text-muted small">Full Name</label>
                <div class="fw-bold"><%# Eval("FullName") %></div>
            </div>
            <div class="mb-3">
                <label class="form-label text-muted small">Email</label>
                <div><%# Eval("Email") %></div>
            </div>
            <div class="mb-3">
                <label class="form-label text-muted small">Phone</label>
                <div><%# Eval("Phone") ?? "Not provided" %></div>
            </div>
            <div class="mb-3">
                <label class="form-label text-muted small">Address</label>
                <div><%# Eval("Address") ?? "Not provided" %></div>
            </div>
            <div class="mb-3">
                <label class="form-label text-muted small">Member Since</label>
                <div><%# Convert.ToDateTime(Eval("DateRegistered")).ToString("dd MMM yyyy") %></div>
            </div>
            <asp:LinkButton runat="server" CommandName="Edit" CssClass="btn btn-primary">Edit Profile</asp:LinkButton>
            <a href="~/PurchaseHistory.aspx" runat="server" class="btn btn-outline-secondary ms-2">Purchase History</a>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:ValidationSummary runat="server" CssClass="alert alert-danger" HeaderText="Please fix:" ForeColor="" />

            <div class="mb-3">
                <label class="form-label">Full Name *</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                    Text='<%# Bind("FullName") %>' MaxLength="100" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required." Display="None" ForeColor="" />
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light"
                    Text='<%# Eval("Email") %>' ReadOnly="true" />
                <small class="text-muted">Email cannot be changed.</small>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"
                    Text='<%# Bind("Phone") %>' MaxLength="20" />
            </div>
            <div class="mb-3">
                <label class="form-label">Address</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"
                    Text='<%# Bind("Address") %>' MaxLength="250" />
            </div>
            <div class="mb-3">
                <label class="form-label">New Password <small class="text-muted">(leave blank to keep current)</small></label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPassword"
                    ValidationExpression="(^$|.{6,})"
                    ErrorMessage="Password must be at least 6 characters." Display="None" ForeColor="" />
            </div>

            <asp:LinkButton runat="server" CommandName="Update" CssClass="btn btn-success">Save Changes</asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Cancel" CssClass="btn btn-outline-secondary ms-2" CausesValidation="false">Cancel</asp:LinkButton>
        </EditItemTemplate>

    </asp:FormView>
</div>
</asp:Content>
