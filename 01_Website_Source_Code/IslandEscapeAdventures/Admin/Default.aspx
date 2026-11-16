<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>

<asp:Content ID="cTitle" ContentPlaceHolderID="PageTitle" runat="server">Dashboard</asp:Content>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row g-4 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card p-3 text-center">
                <div class="stat-icon">PKG</div>
                <h3 class="fw-bold mt-2"><asp:Label ID="lblPackages" runat="server" /></h3>
                <div class="text-muted small">Total Packages</div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card p-3 text-center">
                <div class="stat-icon">USR</div>
                <h3 class="fw-bold mt-2"><asp:Label ID="lblUsers" runat="server" /></h3>
                <div class="text-muted small">Registered Customers</div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card p-3 text-center">
                <div class="stat-icon">ORD</div>
                <h3 class="fw-bold mt-2"><asp:Label ID="lblOrders" runat="server" /></h3>
                <div class="text-muted small">Total Orders</div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card p-3 text-center">
                <div class="stat-icon">QRY</div>
                <h3 class="fw-bold mt-2"><asp:Label ID="lblQueries" runat="server" /></h3>
                <div class="text-muted small">Unresolved Queries</div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm p-3">
        <h6 class="fw-bold mb-3">Recent Orders</h6>
        <asp:GridView ID="gvRecentOrders" runat="server"
            CssClass="table table-hover table-sm align-middle mb-0"
            AutoGenerateColumns="false" GridLines="None">
            <Columns>
                <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                <asp:BoundField DataField="Customer" HeaderText="Customer" />
                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate><%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total">
                    <ItemTemplate>Rs <%# string.Format("{0:N2}", Eval("TotalAmount")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PaymentStatus" HeaderText="Status" />
            </Columns>
            <HeaderStyle CssClass="table-light" />
        </asp:GridView>
    </div>

</asp:Content>
