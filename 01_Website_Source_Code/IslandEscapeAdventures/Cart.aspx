<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Cart" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5">
    <h2 class="section-title">Shopping Cart</h2>

    <!-- Empty cart -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5">
        <div class="fs-1">Cart</div>
        <h5 class="mt-3">Your cart is empty.</h5>
        <a href="~/Packages.aspx" runat="server" class="btn btn-primary mt-3">Browse Packages</a>
    </asp:Panel>

    <!-- Cart contents -->
    <asp:Panel ID="pnlCart" runat="server">
        <asp:GridView ID="gvCart" runat="server"
            CssClass="table table-hover align-middle"
            AutoGenerateColumns="false"
            GridLines="None"
            OnRowCommand="gvCart_RowCommand">
            <Columns>
                <asp:BoundField DataField="Name"      HeaderText="Package"  />
                <asp:BoundField DataField="Category"  HeaderText="Category" />
                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        Rs <%# string.Format("{0:N2}", Eval("Price")) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Qty">
                    <ItemTemplate>
                        <asp:TextBox ID="txtQty" runat="server"
                            Text='<%# Eval("Quantity") %>'
                            CssClass="form-control cart-qty-input"
                            TextMode="Number" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Subtotal">
                    <ItemTemplate>
                        Rs <%# string.Format("{0:N2}", Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="UpdateQty"
                            CommandArgument='<%# Eval("PackageID") + "," + "txtQty" %>'
                            CssClass="btn btn-sm btn-outline-secondary me-1"
                            CausesValidation="false">Update</asp:LinkButton>
                        <asp:LinkButton runat="server" CommandName="Remove"
                            CommandArgument='<%# Eval("PackageID") %>'
                            CssClass="btn btn-sm btn-outline-danger"
                            CausesValidation="false"
                            OnClientClick="return confirm('Remove this item?')">Remove</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
        </asp:GridView>

        <!-- Total -->
        <div class="d-flex justify-content-end mt-3">
            <div class="card p-3 shadow-sm border-0" style="min-width:260px;">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Total:</span>
                    <span class="price-tag">Rs <asp:Label ID="lblTotal" runat="server" /></span>
                </div>
                <a href="~/Checkout.aspx" runat="server" class="btn btn-success w-100">Proceed to Checkout</a>
                <a href="~/Packages.aspx" runat="server" class="btn btn-outline-secondary w-100 mt-2">Continue Shopping</a>
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>
