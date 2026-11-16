<%@ Page Title="Purchase History" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PurchaseHistory.aspx.cs" Inherits="PurchaseHistory" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5">

    <!-- Success banner (after checkout) -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success mb-4">
        <strong>Payment successful!</strong> Your booking is confirmed. Thank you for choosing Island Escape Adventures.
    </asp:Panel>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="section-title mb-0">Purchase History</h2>
        <div class="d-flex gap-2 no-print">
            <asp:LinkButton ID="btnDownloadPdf" runat="server" CssClass="btn btn-primary" OnClick="btnDownloadPdf_Click">Download PDF</asp:LinkButton>
            <button id="btnPrint" type="button" class="btn btn-outline-secondary">Print</button>
        </div>
    </div>

    <p class="text-muted small no-print">Showing purchases from the last 3 months.</p>

    <!-- No orders -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5">
        <div class="category-symbol">0</div>
        <h5 class="mt-3">No purchases in the last 3 months.</h5>
        <a href="~/Packages.aspx" runat="server" class="btn btn-primary mt-3">Browse Packages</a>
    </asp:Panel>

    <!-- Orders GridView -->
    <asp:Panel ID="pnlOrders" runat="server">
        <asp:GridView ID="gvOrders" runat="server"
            CssClass="table table-striped table-bordered align-middle"
            AutoGenerateColumns="false"
            GridLines="None"
            AllowPaging="true" PageSize="10"
            OnPageIndexChanging="gvOrders_PageIndexChanging">
            <Columns>
                <asp:BoundField DataField="OrderID"     HeaderText="Order #" />
                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate><%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy HH:mm") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Items">
                    <ItemTemplate><%# Eval("ItemCount") %> item(s)</ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total">
                    <ItemTemplate>Rs <%# string.Format("{0:N2}", Eval("TotalAmount")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PaymentStatus" HeaderText="Status" />
                <asp:TemplateField HeaderText="Card">
                    <ItemTemplate>**** <%# Eval("CardLastFour") %></ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
            <PagerStyle CssClass="no-print" />
        </asp:GridView>

        <!-- Order Items breakdown -->
        <h5 class="fw-bold mt-4">Order Details</h5>
        <asp:GridView ID="gvItems" runat="server"
            CssClass="table table-hover align-middle"
            AutoGenerateColumns="false"
            GridLines="None">
            <Columns>
                <asp:BoundField DataField="OrderID"   HeaderText="Order #" />
                <asp:BoundField DataField="Package"   HeaderText="Package" />
                <asp:BoundField DataField="Category"  HeaderText="Category" />
                <asp:TemplateField HeaderText="Unit Price">
                    <ItemTemplate>Rs <%# string.Format("{0:N2}", Eval("UnitPrice")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Quantity"  HeaderText="Qty" />
                <asp:TemplateField HeaderText="Subtotal">
                    <ItemTemplate>Rs <%# string.Format("{0:N2}", Convert.ToDecimal(Eval("UnitPrice")) * Convert.ToInt32(Eval("Quantity"))) %></ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
        </asp:GridView>
    </asp:Panel>

</div>
</asp:Content>
