<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="Admin_ManageUsers" %>

<asp:Content ID="cTitle" ContentPlaceHolderID="PageTitle" runat="server">Manage Users</asp:Content>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card border-0 shadow-sm p-3">
        <h6 class="fw-bold mb-3">All Customers</h6>

        <asp:GridView ID="gvUsers" runat="server"
            CssClass="table table-hover align-middle"
            AutoGenerateColumns="false"
            GridLines="None"
            OnRowCommand="gvUsers_RowCommand"
            AllowPaging="true" PageSize="10"
            OnPageIndexChanging="gvUsers_PageIndexChanging">
            <Columns>
                <asp:BoundField DataField="UserID"        HeaderText="ID" />
                <asp:BoundField DataField="FullName"      HeaderText="Name" />
                <asp:BoundField DataField="Email"         HeaderText="Email" />
                <asp:BoundField DataField="Phone"         HeaderText="Phone" />
                <asp:TemplateField HeaderText="Registered">
                    <ItemTemplate><%# Convert.ToDateTime(Eval("DateRegistered")).ToString("dd MMM yyyy") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-success" : "bg-danger" %>'>
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton runat="server"
                            CommandName='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                            CommandArgument='<%# Eval("UserID") %>'
                            CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-sm btn-outline-danger" : "btn btn-sm btn-outline-success" %>'
                            CausesValidation="false"
                            OnClientClick='<%# Convert.ToBoolean(Eval("IsActive")) ? "return confirm(\"Deactivate this account?\")" : "return confirm(\"Activate this account?\")" %>'>
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
        </asp:GridView>
    </div>
</asp:Content>
