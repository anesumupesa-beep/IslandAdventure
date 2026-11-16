<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">

    <section class="hero-section text-center">
        <div class="container">
            <h1>Discover Mauritius Like Never Before</h1>
            <p class="lead mt-3 mb-4">Hotels, dining, excursions, transfers and sea adventures - all in one place.</p>
            <a href="~/Packages.aspx" runat="server" class="btn btn-warning btn-lg px-5">Explore Packages</a>
        </div>
    </section>

    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="section-title text-center">Browse by Category</h2>
            <div class="row g-3 justify-content-center">
                <div class="col-6 col-md-2 text-center">
                    <a href="~/Packages.aspx?cat=Hotels" runat="server" class="text-decoration-none">
                        <div class="card p-3 h-100 border-0 shadow-sm">
                            <div class="category-symbol">HOT</div>
                            <div class="fw-bold mt-1 small">Hotels</div>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-2 text-center">
                    <a href="~/Packages.aspx?cat=Dining" runat="server" class="text-decoration-none">
                        <div class="card p-3 h-100 border-0 shadow-sm">
                            <div class="category-symbol">DIN</div>
                            <div class="fw-bold mt-1 small">Dining</div>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-2 text-center">
                    <a href="~/Packages.aspx?cat=Airport+Transfer" runat="server" class="text-decoration-none">
                        <div class="card p-3 h-100 border-0 shadow-sm">
                            <div class="category-symbol">TRN</div>
                            <div class="fw-bold mt-1 small">Transfers</div>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-2 text-center">
                    <a href="~/Packages.aspx?cat=Excursions" runat="server" class="text-decoration-none">
                        <div class="card p-3 h-100 border-0 shadow-sm">
                            <div class="category-symbol">EXP</div>
                            <div class="fw-bold mt-1 small">Excursions</div>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-2 text-center">
                    <a href="~/Packages.aspx?cat=Sea+Activities" runat="server" class="text-decoration-none">
                        <div class="card p-3 h-100 border-0 shadow-sm">
                            <div class="category-symbol">SEA</div>
                            <div class="fw-bold mt-1 small">Sea Activities</div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <h2 class="section-title text-center">Featured Packages</h2>
            <asp:Repeater ID="rptFeatured" runat="server">
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
                                    <%# Eval("Description").ToString().Length > 100
                                        ? Eval("Description").ToString().Substring(0, 100) + "..."
                                        : Eval("Description") %>
                                </p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="price-tag"><%# "Rs " + string.Format("{0:N2}", Eval("Price")) %></span>
                                    <a href='<%# "PackageDetail.aspx?id=" + Eval("PackageID") %>' class="btn btn-outline-primary btn-sm">View Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>

            <div class="text-center mt-4">
                <a href="~/Packages.aspx" runat="server" class="btn btn-primary px-4">View All Packages</a>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="section-title text-center">Why Choose Us?</h2>
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm p-4 h-100">
                        <div class="category-symbol mb-3">01</div>
                        <h3 class="fw-bold h5">Curated Experiences</h3>
                        <p class="text-muted small">Every package is handpicked to ensure an unforgettable Mauritius experience.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm p-4 h-100">
                        <div class="category-symbol mb-3">02</div>
                        <h3 class="fw-bold h5">Secure Booking</h3>
                        <p class="text-muted small">Your personal and payment information is always protected.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm p-4 h-100">
                        <div class="category-symbol mb-3">03</div>
                        <h3 class="fw-bold h5">24/7 Support</h3>
                        <p class="text-muted small">Our team is always available to help you plan your perfect holiday.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
