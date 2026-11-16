<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NavMenu.ascx.cs" Inherits="Controls_NavMenu" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand fw-bold" href="~/Default.aspx" runat="server">
            Island Escape Adventures
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navMain">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="~/Default.aspx" runat="server">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="~/Packages.aspx" runat="server">Packages</a></li>
                <li class="nav-item"><a class="nav-link" href="~/Contact.aspx" runat="server">Contact</a></li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item me-2">
                    <a class="nav-link position-relative" href="~/Cart.aspx" runat="server">
                        Cart
                        <asp:Label ID="lblCartCount" runat="server" CssClass="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                            Text="0" Visible="false" />
                    </a>
                </li>

                <asp:PlaceHolder ID="pnlLoggedOut" runat="server">
                    <li class="nav-item"><a class="nav-link" href="~/Login.aspx" runat="server">Login</a></li>
                    <li class="nav-item"><a class="btn btn-warning btn-sm ms-2" href="~/Register.aspx" runat="server">Register</a></li>
                </asp:PlaceHolder>

                <asp:PlaceHolder ID="pnlLoggedIn" runat="server" Visible="false">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <asp:Label ID="lblUserName" runat="server" />
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="~/Profile.aspx" runat="server">My Profile</a></li>
                            <li><a class="dropdown-item" href="~/PurchaseHistory.aspx" runat="server">Purchase History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <asp:LinkButton ID="lbtnLogout" runat="server" CssClass="dropdown-item" OnClick="lbtnLogout_Click">
                                    Logout
                                </asp:LinkButton>
                            </li>
                        </ul>
                    </li>
                </asp:PlaceHolder>
            </ul>
        </div>
    </div>
</nav>
