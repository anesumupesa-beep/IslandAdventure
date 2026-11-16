<%@ Page Title="Manage Packages" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ManagePackages.aspx.cs" Inherits="Admin_ManagePackages" %>

<asp:Content ID="cTitle" ContentPlaceHolderID="PageTitle" runat="server">Manage Packages</asp:Content>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Add / Edit Form -->
    <div class="card border-0 shadow-sm p-4 mb-4">
        <h6 class="fw-bold mb-3"><asp:Label ID="lblFormTitle" runat="server" Text="Add New Package" /></h6>

        <asp:HiddenField ID="hdnPackageID" runat="server" Value="0" />

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Package Name *</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="150" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName"
                    ErrorMessage="Name is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
            </div>
            <div class="col-md-3">
                <label class="form-label">Category *</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                    <asp:ListItem Value="Hotels">Hotels</asp:ListItem>
                    <asp:ListItem Value="Dining">Dining</asp:ListItem>
                    <asp:ListItem Value="Airport Transfer">Airport Transfer</asp:ListItem>
                    <asp:ListItem Value="Excursions">Excursions</asp:ListItem>
                    <asp:ListItem Value="Sea Activities">Sea Activities</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label class="form-label">Price (Rs) *</label>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrice"
                    ErrorMessage="Price is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
            </div>
            <div class="col-12">
                <label class="form-label">Description *</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="1000" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescription"
                    ErrorMessage="Description is required." CssClass="text-danger small" Display="Dynamic" ForeColor="" />
            </div>
            <div class="col-md-8">
                <label class="form-label">Image Filename</label>
                <asp:TextBox ID="txtImageURL" runat="server" CssClass="form-control" placeholder="e.g. hotel-lemorne.jpg" MaxLength="300" />
                <small class="text-muted">Place image in /images/packages/ or enter an existing relative path.</small>
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <div class="form-check ms-2">
                    <asp:CheckBox ID="chkAvailable" runat="server" CssClass="form-check-input" Checked="true" />
                    <label class="form-check-label">Available</label>
                </div>
            </div>
        </div>

        <div class="mt-3">
            <asp:Button ID="btnSave" runat="server" Text="Save Package" CssClass="btn btn-success" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary ms-2"
                OnClick="btnCancel_Click" CausesValidation="false" />
        </div>
    </div>

    <!-- Packages GridView -->
    <div class="card border-0 shadow-sm p-3">
        <h6 class="fw-bold mb-3">All Packages</h6>
        <asp:GridView ID="gvPackages" runat="server"
            CssClass="table table-hover align-middle"
            AutoGenerateColumns="false"
            GridLines="None"
            OnRowCommand="gvPackages_RowCommand"
            AllowPaging="true" PageSize="8"
            OnPageIndexChanging="gvPackages_PageIndexChanging">
            <Columns>
                <asp:BoundField DataField="PackageID"  HeaderText="ID" />
                <asp:BoundField DataField="Name"       HeaderText="Name" />
                <asp:BoundField DataField="Category"   HeaderText="Category" />
                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>Rs <%# string.Format("{0:N2}", Eval("Price")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Available">
                    <ItemTemplate>
                        <span class='badge <%# Convert.ToBoolean(Eval("IsAvailable")) ? "bg-success" : "bg-secondary" %>'>
                            <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Yes" : "No" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="EditPkg"
                            CommandArgument='<%# Eval("PackageID") %>'
                            CssClass="btn btn-sm btn-outline-primary me-1" CausesValidation="false">Edit</asp:LinkButton>
                        <asp:LinkButton runat="server" CommandName="DeletePkg"
                            CommandArgument='<%# Eval("PackageID") %>'
                            CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                            OnClientClick="return confirm('Remove this package from the public catalogue?')">Remove</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-dark" />
        </asp:GridView>
    </div>

</asp:Content>
