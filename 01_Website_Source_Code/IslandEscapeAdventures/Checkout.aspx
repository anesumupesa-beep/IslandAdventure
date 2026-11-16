<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5">
    <h2 class="section-title">Checkout</h2>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5">
        <h5>Your cart is empty.</h5>
        <a href="~/Packages.aspx" runat="server" class="btn btn-primary mt-3">Browse Packages</a>
    </asp:Panel>

    <asp:Panel ID="pnlCheckout" runat="server">
        <div class="row g-4">

            <!-- Order Summary -->
            <div class="col-md-5 order-md-2">
                <div class="card border-0 shadow-sm p-3">
                    <h5 class="fw-bold mb-3">Order Summary</h5>
                    <asp:Repeater ID="rptSummary" runat="server">
                        <ItemTemplate>
                            <div class="d-flex justify-content-between mb-2 small">
                                <span><%# Eval("Name") %> x <%# Eval("Quantity") %></span>
                                <span>Rs <%# string.Format("{0:N2}", Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))) %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <hr />
                    <div class="d-flex justify-content-between fw-bold">
                        <span>Total</span>
                        <span class="text-primary">Rs <asp:Label ID="lblTotal" runat="server" /></span>
                    </div>
                </div>
            </div>

            <!-- Payment Form -->
            <div class="col-md-7 order-md-1">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3">Payment Details <small class="text-muted fw-normal">(Simulated)</small></h5>

                    <asp:ValidationSummary runat="server" CssClass="alert alert-danger" HeaderText="Please fix:" ForeColor="" />

                    <div class="mb-3">
                        <label class="form-label">Cardholder Name *</label>
                        <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="Name as on card" MaxLength="100" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCardName"
                            ErrorMessage="Cardholder name is required." Display="None" ForeColor="" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Card Number *</label>
                        <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="1234 5678 9012 3456" MaxLength="19" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCardNumber"
                            ErrorMessage="Card number is required." Display="None" ForeColor="" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCardNumber"
                            ValidationExpression="\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}"
                            ErrorMessage="Please enter a valid 16-digit card number." Display="None" ForeColor="" />
                    </div>

                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label">Expiry Date *</label>
                            <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="MM/YY" MaxLength="5" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtExpiry"
                                ErrorMessage="Expiry date is required." Display="None" ForeColor="" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtExpiry"
                                ValidationExpression="(0[1-9]|1[0-2])\/\d{2}"
                                ErrorMessage="Use MM/YY format." Display="None" ForeColor="" />
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label">CVV *</label>
                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="4" TextMode="Password" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCVV"
                                ErrorMessage="CVV is required." Display="None" ForeColor="" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCVV"
                                ValidationExpression="\d{3,4}"
                                ErrorMessage="CVV must be 3 or 4 digits." Display="None" ForeColor="" />
                        </div>
                    </div>

                    <asp:Button ID="btnPay" runat="server" Text="🔒 Pay Now"
                        CssClass="btn btn-success btn-lg w-100 mt-2"
                        OnClick="btnPay_Click" />

                    <p class="text-muted small text-center mt-2">This is a simulated payment - no real charges will be made.</p>
                </div>
            </div>

        </div>
    </asp:Panel>
</div>
</asp:Content>
