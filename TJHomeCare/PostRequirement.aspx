<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PostRequirement.aspx.cs" Inherits="TJHomeCare.PostRequirement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    
    Post Your Requirement
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style>
    /* ===== PROFESSIONAL UNIFIED STYLING ===== */
    .req-wrapper {
        max-width: 900px;
        margin: 30px auto;
        padding: 0 16px 40px;
        box-sizing: border-box;
    }

    .req-card {
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        padding: 35px;
        border: 1px solid #eaeaea;
    }

    .page-title {
        font-size: 26px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 6px;
    }

    .page-subtitle {
        color: #7f8c8d;
        font-size: 14px;
        margin-bottom: 25px;
    }

    .section-title {
        font-size: 18px;
        font-weight: 700;
        color: #34495e;
        margin: 30px 0 15px;
        padding-bottom: 8px;
        border-bottom: 2px solid #f1f5f9;
    }

    /* ===== GRID SYSTEM ===== */
    .form-row {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 20px;
    }

    .form-group {
        margin-bottom: 16px;
        min-width: 0;
    }

    .form-group.full {
        grid-column: 1 / -1;
    }

    .form-label {
        display: block;
        font-weight: 600;
        font-size: 13px;
        color: #2c3e50;
        margin-bottom: 8px;
    }

    .required {
        color: #dc3545;
    }

    /* ===== CONTROLS ===== */
    .form-control {
        display: block;
        width: 100%;
        height: 46px;
        padding: 8px 14px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        font-size: 14px;
        color: #1e293b;
        background: #fff;
        box-sizing: border-box;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-control:focus {
        border-color: #198754;
        box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.12);
    }

    /* ===== DUTY TIME / VERTICAL RADIO LIST ===== */
    .duty-options {
        padding: 12px 16px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        background: #f8fafc;
    }

    .duty-options table {
        width: 100%;
        border-collapse: collapse;
    }

    .duty-options tr {
        display: block;
        margin-bottom: 8px;
    }

    .duty-options tr:last-child {
        margin-bottom: 0;
    }

    .duty-options td {
        display: block;
        width: 100%;
        padding: 4px 0;
    }

    .duty-options label {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        color: #334155;
        font-size: 14px;
        cursor: pointer;
    }

    .duty-options input[type="radio"] {
        accent-color: #198754;
        margin: 0;
        width: 16px;
        height: 16px;
    }

    /* ===== VALIDATION ===== */
    .validation {
        display: block;
        color: #dc3545;
        font-size: 12px;
        margin-top: 5px;
    }

    /* ===== BUTTON ===== */
    .btn-submit {
        background: #198754;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 12px 28px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        width: 100%;
        transition: background 0.2s;
    }

    .btn-submit:hover {
        background: #157347;
    }

    .requirement-note {
        margin: 14px 0 0;
        text-align: center;
        color: #64748b;
        font-size: 12px;
    }

    /* ===== RESPONSIVE DESIGN ===== */
    @media (max-width: 768px) {
        .req-wrapper {
            margin: 10px auto;
            padding: 0 10px 25px;
        }

        .req-card {
            padding: 20px;
            border-radius: 12px;
        }

        .page-title {
            font-size: 22px;
        }

        .form-row {
            grid-template-columns: 1fr;
            gap: 12px;
        }

        .form-group.full {
            grid-column: auto;
        }

        .form-control {
            font-size: 16px;
        }
    }
</style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<section class="req-wrapper">
    <div class="req-card">
                      
        <h1 class="page-title">TJ HOME CARE – Post Your Requirement</h1>
        <div class="page-subtitle">Tell us what you need. Share your details to help us understand your home care requirements.</div>

        <!-- SERVICE & LOCATION DETAILS -->
        <div class="section-title">Service & Location Details</div>
        <div class="form-row">

            <!-- SERVICE REQUIREMENT -->
            <div class="form-group">
                <label class="form-label">Service Requirement <span class="required">*</span></label>
                <asp:DropDownList ID="ddlService" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">Select Service</asp:ListItem>
                    <asp:ListItem>Baby Caretaker</asp:ListItem>
                        <asp:ListItem>Cook</asp:ListItem>
                        <asp:ListItem>Driver</asp:ListItem>
                        <asp:ListItem>Patient Caretaker</asp:ListItem>
                        <asp:ListItem>Elder Caretaker</asp:ListItem>
                        <asp:ListItem>Home Nurse</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvService" runat="server" ControlToValidate="ddlService" InitialValue="" ErrorMessage="Please select a service." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- CITY -->
            <div class="form-group">
                <label class="form-label">City <span class="required">*</span></label>
                <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">Select City</asp:ListItem>
                    <asp:ListItem Value="Bangalore">Bangalore</asp:ListItem>
                    <asp:ListItem Value="Hyderabad">Hyderabad</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="ddlCity" InitialValue="" ErrorMessage="Please select a city." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- AREA / LOCALITY -->
            <div class="form-group full">
                <label class="form-label">Area / Locality <span class="required">*</span></label>
                <asp:TextBox ID="txtArea" runat="server" CssClass="form-control" placeholder="Enter your area or locality" MaxLength="100" />
                <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="txtArea" ErrorMessage="Please enter your area." CssClass="validation" Display="Dynamic" />
            </div>

        </div>

        <!-- DUTY & PREFERENCES -->
        <div class="section-title">Duty & Preferences</div>
        <div class="form-row">

            <!-- DUTY TIME (VERTICAL STYLE) -->
            <div class="form-group full">
                <label class="form-label">Duty Time <span class="required">*</span></label>
                <div class="duty-options">
                    <asp:RadioButtonList ID="rblDutyTime" runat="server" RepeatLayout="Table" RepeatDirection="Vertical" RepeatColumns="1">
                        <asp:ListItem Value="Part Time">&nbsp;Part Time</asp:ListItem>
                        <asp:ListItem Value="8 Hours">&nbsp;8 Hours</asp:ListItem>
                        <asp:ListItem Value="10 Hours">&nbsp;10 Hours</asp:ListItem>
                        <asp:ListItem Value="12 Hours">&nbsp;12 Hours</asp:ListItem>
                        <asp:ListItem Value="24 Hours / Live in">&nbsp;24 Hours / Live in</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <asp:RequiredFieldValidator ID="rfvDutyTime" runat="server" ControlToValidate="rblDutyTime" ErrorMessage="Please select duty time." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- PREFERRED LANGUAGE -->
            <div class="form-group">
                <label class="form-label">Preferred Language <span class="required">*</span></label>
                <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">Select Language</asp:ListItem>
                    <asp:ListItem>Kannada</asp:ListItem>
                    <asp:ListItem>Telugu</asp:ListItem>
                    <asp:ListItem>Hindi</asp:ListItem>                   
                    <asp:ListItem>Tamil</asp:ListItem>
                    <asp:ListItem>Malayalam</asp:ListItem>
                     <asp:ListItem>English</asp:ListItem>
                       <asp:ListItem>Bengali</asp:ListItem>
                    <asp:ListItem>Urdu</asp:ListItem>
                    <asp:ListItem>Other</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvLanguage" runat="server" ControlToValidate="ddlLanguage" InitialValue="" ErrorMessage="Please select a language." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- SALARY / BUDGET -->
            <div class="form-group">
                <label class="form-label">Salary / Budget <span class="required">*</span></label>
                <asp:TextBox ID="txtBudget" runat="server" CssClass="form-control" placeholder="e.g. ₹12,000 per month" MaxLength="50" />
                <asp:RequiredFieldValidator ID="rfvBudget" runat="server" ControlToValidate="txtBudget" ErrorMessage="Please enter your budget." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- JOINING DATE -->
            <div class="form-group full">
                <label class="form-label">Joining From <span class="required">*</span></label>
                <asp:TextBox ID="txtJoiningDate" runat="server" CssClass="form-control" TextMode="Date" style="max-width: 50%;" />
                <asp:RequiredFieldValidator ID="rfvJoiningDate" runat="server" ControlToValidate="txtJoiningDate" ErrorMessage="Please select a joining date." CssClass="validation" Display="Dynamic" />
            </div>

        </div>

        <!-- CONTACT DETAILS -->
        <div class="section-title">Contact Information</div>
        <div class="form-row">

            <!-- YOUR NAME -->
            <div class="form-group">
                <label class="form-label">Your Name <span class="required">*</span></label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your full name" MaxLength="100" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Please enter your name." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- MOBILE NUMBER -->
            <div class="form-group">
                <label class="form-label">Mobile Number <span class="required">*</span></label>
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Enter 10-digit mobile number" MaxLength="10" TextMode="SingleLine" />
                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" ErrorMessage="Please enter mobile number." CssClass="validation" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile" ValidationExpression="^[0-9]{10}$" ErrorMessage="Enter a valid 10-digit mobile number." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- WHATSAPP NUMBER -->
            <div class="form-group full">
                <label class="form-label">WhatsApp Number <span class="required">*</span></label>
                <asp:TextBox ID="txtWhatsApp" runat="server" CssClass="form-control" placeholder="Enter WhatsApp number if different" MaxLength="10" />
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtWhatsApp" ErrorMessage="Please enter WhatsApp number." CssClass="validation" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revWhatsApp" runat="server" ControlToValidate="txtWhatsApp" ValidationExpression="^$|^[0-9]{10}$" ErrorMessage="Enter a valid 10-digit WhatsApp number." CssClass="validation" Display="Dynamic" />
            </div>

            <!-- SUBMIT BUTTON -->
            <div class="form-group full" style="margin-top: 15px;">
                <asp:Button ID="btnPostRequirement" runat="server" Text="Post Your Requirement" CssClass="btn-submit" OnClick="btnPostRequirement_Click"/>
             
            </div>

        </div>

    </div>
</section>
</asp:Content>