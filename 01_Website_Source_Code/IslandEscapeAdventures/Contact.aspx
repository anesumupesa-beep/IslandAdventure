<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="container py-5" style="max-width:760px;">
    <h2 class="section-title">Contact Us</h2>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
        Thank you! Your message has been sent. We'll get back to you within 24 hours.
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server">
        <div class="row g-4">
            <!-- Contact Info -->
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 h-100">
                    <h3 class="fw-bold h6">Get In Touch</h3>
                    <p class="text-muted small mt-2">
                        Location: Port Louis, Mauritius<br /><br />
                        Phone: +230 5900 1234<br /><br />
                        info@islandescape.mu<br /><br />
                        Mon-Sat: 8:00 AM - 6:00 PM
                    </p>
                </div>
            </div>

            <!-- Form -->
            <div class="col-md-8">
                <div class="card border-0 shadow-sm p-4">
                    <asp:ValidationSummary runat="server" CssClass="alert alert-danger" HeaderText="Please fix:" ForeColor="" />

                    <div class="mb-3">
                        <label class="form-label">Name *</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Your full name" MaxLength="100" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName"
                            ErrorMessage="Name is required." Display="None" ForeColor="" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email *</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" MaxLength="150" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required." Display="None" ForeColor="" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            ErrorMessage="Enter a valid email." Display="None" ForeColor="" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Subject *</label>
                        <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Select a subject --" />
                            <asp:ListItem Value="General Enquiry">General Enquiry</asp:ListItem>
                            <asp:ListItem Value="Booking Assistance">Booking Assistance</asp:ListItem>
                            <asp:ListItem Value="Payment Issue">Payment Issue</asp:ListItem>
                            <asp:ListItem Value="Feedback">Feedback</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlSubject"
                            InitialValue="" ErrorMessage="Please select a subject." Display="None" ForeColor="" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Message *</label>
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="5" placeholder="How can we help you?" MaxLength="2000" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage"
                            ErrorMessage="Message is required." Display="None" ForeColor="" />
                    </div>

                    <asp:Button ID="btnSend" runat="server" Text="Send Message"
                        CssClass="btn btn-primary" OnClick="btnSend_Click" />
                </div>
            </div>
        </div>
    </asp:Panel>
</div>
</asp:Content>
