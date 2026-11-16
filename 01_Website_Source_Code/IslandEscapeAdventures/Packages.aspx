<%@ Page Title="All Packages" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Packages.aspx.cs" Inherits="Packages" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5">

    <h2 class="section-title">All Packages</h2>

    <!-- Category filter -->
    <div class="filter-pills mb-4">
        <asp:LinkButton ID="lbtnAll" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="" OnClick="FilterBtn_Click">All</asp:LinkButton>
        <asp:LinkButton ID="lbtnHotels" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="Hotels" OnClick="FilterBtn_Click">HOT Hotels</asp:LinkButton>
        <asp:LinkButton ID="lbtnDining" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="Dining" OnClick="FilterBtn_Click">DIN Dining</asp:LinkButton>
        <asp:LinkButton ID="lbtnTransfer" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="Airport Transfer" OnClick="FilterBtn_Click">TRN Transfers</asp:LinkButton>
        <asp:LinkButton ID="lbtnExcursions" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="Excursions" OnClick="FilterBtn_Click">EXP Excursions</asp:LinkButton>
        <asp:LinkButton ID="lbtnSea" runat="server" CssClass="btn btn-outline-primary btn-sm"
            CommandArgument="Sea Activities" OnClick="FilterBtn_Click">SEA Sea Activities</asp:LinkButton>
    </div>

    <!-- Package grid -->
    <asp:Repeater ID="rptPackages" runat="server">
        <HeaderTemplate><div class="row g-4"></HeaderTemplate>
        <ItemTemplate>
            <div class="col-sm-6 col-lg-4">
                <div class="card package-card">
                    <img src='<%# Eval("ImageURL") %>'
                         onerror="this.src='images/packages/default-package.jpg'"
                         alt='<%# Eval("Name") %>' class="card-img-top" />
                    <div class="card-body d-flex flex-column">
                        <span class="badge bg-primary category-badge mb-2"><%# Eval("Category") %></span>
                        <h3 class="card-title h5"><%# Eval("Name") %></h3>
                        <p class="card-text text-muted small flex-grow-1">
                            <%# Eval("Description").ToString().Length > 110
                                ? Eval("Description").ToString().Substring(0, 110) + "..."
                                : Eval("Description") %>
                        </p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="price-tag">Rs <%# string.Format("{0:N2}", Eval("Price")) %></span>
                            <a href='<%# "PackageDetail.aspx?id=" + Eval("PackageID") %>' class="btn btn-outline-primary btn-sm">
                                View Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>

    <!-- Empty state -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5">
        <div class="display-6 fw-bold text-primary">0</div>
        <h3 class="mt-3 h5">No packages found in this category.</h3>
        <asp:LinkButton runat="server" CssClass="btn btn-primary mt-3"
            CommandArgument="" OnClick="FilterBtn_Click">View All Packages</asp:LinkButton>
    </asp:Panel>

</div>
</asp:Content>
