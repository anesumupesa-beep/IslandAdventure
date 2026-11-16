<%@ Page Title="Package Details" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PackageDetail.aspx.cs" Inherits="PackageDetail" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5">

    <!-- Not found -->
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="text-center py-5">
        <div class="fs-1">Package unavailable</div>
        <h4 class="mt-3">Package not found.</h4>
        <a href="~/Packages.aspx" runat="server" class="btn btn-primary mt-3">Back to Packages</a>
    </asp:Panel>

    <!-- Package detail using FormView -->
    <asp:FormView ID="fvPackage" runat="server" DefaultMode="ReadOnly" CssClass="w-100">
        <ItemTemplate>
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="~/Default.aspx" runat="server">Home</a></li>
                    <li class="breadcrumb-item"><a href="~/Packages.aspx" runat="server">Packages</a></li>
                    <li class="breadcrumb-item active"><%# Eval("Name") %></li>
                </ol>
            </nav>

            <div class="row g-4">
                <div class="col-md-6">
                    <img src='<%# Eval("ImageURL") %>'
                         onerror="this.src='images/packages/default-package.jpg'"
                         alt='<%# Eval("Name") %>'
                         class="img-fluid rounded shadow" style="width:100%; height:380px; object-fit:cover;" />
                </div>
                <div class="col-md-6">
                    <span class="badge bg-primary mb-2"><%# Eval("Category") %></span>
                    <h2 class="fw-bold"><%# Eval("Name") %></h2>
                    <p class="text-muted mt-3"><%# Eval("Description") %></p>
                    <hr />
                    <div class="price-tag mb-4">Rs <%# string.Format("{0:N2}", Eval("Price")) %></div>

                    <!-- Quantity selector -->
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <label class="form-label mb-0 fw-bold">Quantity:</label>
                        <asp:TextBox ID="txtQty" runat="server" CssClass="form-control cart-qty-input"
                            Text="1" TextMode="Number" />
                    </div>

                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart"
                        CssClass="btn btn-primary btn-lg me-2"
                        OnClick="btnAddToCart_Click"
                        CommandArgument='<%# Eval("PackageID") %>' />

                    <a href="~/Packages.aspx" runat="server" class="btn btn-outline-secondary btn-lg">Back</a>

                    <asp:Label ID="lblCartMsg" runat="server" CssClass="alert alert-success d-block mt-3" Visible="false" />
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>

</div>
</asp:Content>
