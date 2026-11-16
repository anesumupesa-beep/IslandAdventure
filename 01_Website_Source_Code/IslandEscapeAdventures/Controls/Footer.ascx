<%@ Control Language="C#" AutoEventWireup="true" %>

<footer class="site-footer bg-dark text-white mt-5 py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="fw-bold h5">Island Escape Adventures</div>
                <p class="footer-muted small">Your gateway to unforgettable Mauritius experiences. Hotels, dining, excursions and more - all in one place.</p>
            </div>
            <div class="col-md-4 mb-3">
                <div class="fw-bold h6">Quick Links</div>
                <ul class="list-unstyled small">
                    <li><a href="~/Default.aspx" runat="server" class="footer-link text-decoration-none">Home</a></li>
                    <li><a href="~/Packages.aspx" runat="server" class="footer-link text-decoration-none">Packages</a></li>
                    <li><a href="~/Contact.aspx" runat="server" class="footer-link text-decoration-none">Contact Us</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-3">
                <div class="fw-bold h6">Contact</div>
                <p class="footer-muted small">
                    Port Louis, Mauritius<br />
                    +230 5900 1234<br />
                    info@islandescape.mu
                </p>
            </div>
        </div>
        <hr class="border-secondary" />
        <p class="text-center footer-muted small mb-0">
            &copy; <%= DateTime.Now.Year %> Island Escape Adventures. All rights reserved.
        </p>
    </div>
</footer>
