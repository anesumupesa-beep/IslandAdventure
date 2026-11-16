<%@ Page Title="Customer Queries" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ManageQueries.aspx.cs" Inherits="Admin_ManageQueries" %>

<asp:Content ID="cTitle" ContentPlaceHolderID="PageTitle" runat="server">Customer Queries</asp:Content>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Filter -->
    <div class="mb-3 no-print">
        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger me-2"
            CommandArgument="0" OnClick="FilterBtn_Click">Unresolved</asp:LinkButton>
        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-success me-2"
            CommandArgument="1" OnClick="FilterBtn_Click">Resolved</asp:LinkButton>
        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-secondary"
            CommandArgument="-1" OnClick="FilterBtn_Click">All</asp:LinkButton>
    </div>

    <div class="card border-0 shadow-sm p-3">
        <asp:GridView ID="gvQueries" runat="server"
            CssClass="table table-hover align-middle"
            AutoGenerateColumns="false"
            GridLines="None"
            OnRowCommand="gvQueries_RowCommand"
            AllowPaging="true" PageSize="10"
            OnPageIndexChanging="gvQueries_PageIndexChanging">
            <Columns>
                <asp:BoundField DataField="QueryID"  HeaderText="ID" />
                <asp:BoundField DataField="Name"     HeaderText="Name" />
                <asp:BoundField DataField="Email"    HeaderText="Email" />
                <asp:BoundField DataField="Subject"  HeaderText="Subject" />
                <asp:BoundField DataField="Message"  HeaderText="Message" ItemStyle-CssClass="text-truncate" ItemStyle-Width="250px" />
                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate><%# Convert.ToDateTime(Eval("DateSubmitted")).ToString("dd MMM yyyy") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='badge <%# Convert.ToBoolean(Eval("IsResolved")) ? "bg-success" : "bg-danger" %>'>
                            <%# Convert.ToBoolean(Eval("IsResolved")) ? "Resolved" : "Open" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton runat="server"
                            CommandName='<%# Convert.ToBoolean(Eval("IsResolved")) ? "Reopen" : "Resolve" %>'
                            CommandArgument='<%# Eval("QueryID") %>'
                            CssClass='<%# Convert.ToBoolean(Eval("IsResolved")) ? "btn btn-sm btn-outline-secondary" : "btn btn-sm btn-outline-success" %>'
                            CausesValidation="false">
                            <%# Convert.ToBoolean(Eval("IsResolved")) ? "Reopen" : "Mark Resolved" %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
        </asp:GridView>
    </div>

</asp:Content>
