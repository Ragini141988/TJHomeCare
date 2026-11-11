<%@ Page Title="Book Online Consultation" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ConsultationBookingV2.aspx.cs" Inherits="TJHomeCare.ConsultationBookingV2" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
.v2-wrap{max-width:900px;margin:24px auto;padding:0 14px;font-family:Arial,sans-serif;color:#18232b}
.v2-card{background:#fff;border:1px solid #e7efeb;border-radius:18px;padding:28px;box-shadow:0 5px 22px rgba(12,62,47,.08)}
.v2-title{font-size:clamp(25px,4vw,36px);font-weight:800;color:#086448;margin:0 0 5px}
.v2-subtitle{font-size:16px;color:#535f63;line-height:1.5;margin:0 0 22px}
.v2-selected{background:#eaf6f1;border-left:5px solid #087453;border-radius:7px;padding:13px 16px;line-height:1.8;margin-bottom:20px}
.v2-grid{display:grid;grid-template-columns:1fr 1fr;gap:15px 18px}
.v2-field{min-width:0}.v2-field.full{grid-column:1/-1}
.v2-label{display:block;font-weight:700;margin:0 0 7px;color:#263238}
.v2-input{width:100%;box-sizing:border-box;min-height:45px;padding:10px 12px;border:1px solid #cbd5d2;border-radius:8px;background:#fff;font:16px Arial,sans-serif;color:#1e292d}
.v2-input:focus{outline:0;border-color:#087453;box-shadow:0 0 0 3px rgba(8,116,83,.12)}
.v2-input.textarea{min-height:82px;resize:vertical}
.v2-error{display:block;color:#b42318;margin:12px 0;font-weight:600}
.v2-validation{display:block;color:#b42318;font-size:13px;margin-top:4px}
.v2-terms{display:flex;gap:9px;align-items:flex-start;line-height:1.5;margin:18px 0}
.v2-terms a{color:#086448;text-decoration:underline}
.v2-summary{background:#eaf7f0;border:1px solid #b9dfca;border-radius:13px;padding:16px 18px;margin:19px 0}
.v2-summary h3{font-size:21px;color:#075b40;margin:0 0 12px}
.v2-price-row{display:flex;justify-content:space-between;gap:15px;padding:5px 0}
.v2-total{border-top:1px solid #9ac9ae;margin-top:8px;padding-top:12px;font-weight:800;color:#075b40;font-size:21px}
.v2-submit{width:100%;border:0;border-radius:9px;background:#087453;color:white;padding:14px 18px;font-size:18px;font-weight:700;cursor:pointer}
.v2-submit:hover{background:#055c40}.v2-small{font-size:13px;color:#64736d;margin-top:10px}
@media(max-width:640px){.v2-wrap{margin:12px auto;padding:0 9px}.v2-card{padding:18px 15px;border-radius:14px}.v2-grid{grid-template-columns:1fr;gap:13px}.v2-field.full{grid-column:auto}.v2-subtitle{font-size:15px}}
</style>
</asp:Content>

<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="v2-wrap"><div class="v2-card">
    <h1 class="v2-title">Book Online Consultation</h1>
    <p class="v2-subtitle">Consult with trusted healthcare professionals from the comfort of your home.</p>

    <div class="v2-selected">
        <strong>Selected Professional:</strong> <asp:Label ID="lblProfessionalName" runat="server" />
        <br /><strong>Consultation Service:</strong> <asp:Label ID="lblServiceName" runat="server" />
    </div>

    <asp:Label ID="lblErrorMessage" runat="server" CssClass="v2-error" EnableViewState="false" />

    <div class="v2-grid">
        <div class="v2-field full">
            <label class="v2-label" for="<%= txtCustomerName.ClientID %>">Your Name *</label>
            <asp:TextBox ID="txtCustomerName" runat="server" CssClass="v2-input" MaxLength="100" />
            <asp:RequiredFieldValidator ID="rfvCustomerName" runat="server" ControlToValidate="txtCustomerName" ErrorMessage="Please enter your name." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field full">
            <label class="v2-label" for="<%= ddlGender.ClientID %>">Gender *</label>
            <asp:DropDownList ID="ddlGender" runat="server" CssClass="v2-input">
                <asp:ListItem Text="Select Gender" Value="" /><asp:ListItem Text="Female" Value="Female" /><asp:ListItem Text="Male" Value="Male" /><asp:ListItem Text="Other" Value="Other" /><asp:ListItem Text="Prefer not to say" Value="Prefer not to say" />
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvGender" runat="server" ControlToValidate="ddlGender" InitialValue="" ErrorMessage="Please select your gender." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field">
            <label class="v2-label" for="<%= txtCity.ClientID %>">Your City *</label>
            <asp:TextBox ID="txtCity" runat="server" CssClass="v2-input" MaxLength="100" />
            <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" ErrorMessage="Please enter your city." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field">
            <label class="v2-label" for="<%= txtState.ClientID %>">State *</label>
            <asp:TextBox ID="txtState" runat="server" CssClass="v2-input" MaxLength="100" />
            <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" ErrorMessage="Please enter your state." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field full">
            <label class="v2-label" for="<%= txtEmail.ClientID %>">Email Address *</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="v2-input" TextMode="Email" MaxLength="254" />
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Please enter your email address." CssClass="v2-validation" Display="Dynamic" />
            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Please enter a valid email address." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field full">
            <label class="v2-label" for="<%= txtContactNumber.ClientID %>">Contact Number *</label>
            <asp:TextBox ID="txtContactNumber" runat="server" CssClass="v2-input" TextMode="Phone" MaxLength="20" />
            <asp:RequiredFieldValidator ID="rfvContactNumber" runat="server" ControlToValidate="txtContactNumber" ErrorMessage="Please enter your contact number." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field">
            <label class="v2-label" for="<%= txtAppointmentDate.ClientID %>">Preferred Date *</label>
            <asp:TextBox ID="txtAppointmentDate" runat="server" CssClass="v2-input" TextMode="Date" />
            <asp:RequiredFieldValidator ID="rfvAppointmentDate" runat="server" ControlToValidate="txtAppointmentDate" ErrorMessage="Please select a date." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field">
            <label class="v2-label" for="<%= txtAppointmentTime.ClientID %>">Preferred Time *</label>
            <asp:TextBox ID="txtAppointmentTime" runat="server" CssClass="v2-input" TextMode="Time" />
            <asp:RequiredFieldValidator ID="rfvAppointmentTime" runat="server" ControlToValidate="txtAppointmentTime" ErrorMessage="Please select a time." CssClass="v2-validation" Display="Dynamic" />
        </div>
        <div class="v2-field full">
            <label class="v2-label" for="<%= txtReason.ClientID %>">Reason for Consultation (Optional)</label>
            <asp:TextBox ID="txtReason" runat="server" CssClass="v2-input textarea" TextMode="MultiLine" Rows="3" MaxLength="1000" placeholder="Briefly describe your concern." />
        </div>
    </div>

    <div class="v2-terms">
        <asp:CheckBox ID="chkTerms" runat="server" />
        <span>I agree to the <a href="TermsAndConditions.aspx" target="_blank">Consultation Terms &amp; Conditions</a>, <a href="CancellationRefundPolicy.aspx" target="_blank">Cancellation and Refund Policy</a>, and <a href="PrivacyPolicy.aspx" target="_blank">Privacy Policy</a> of TJ Home Care. <strong>*</strong></span>
    </div>

    <div class="v2-summary">
        <h3>Booking Summary</h3>
        <div class="v2-price-row"><span>Consultation Fee</span><strong><asp:Label ID="lblFee" runat="server" /></strong></div>
        <div class="v2-price-row"><span>GST (<asp:Label ID="lblGstPercent" runat="server" />%)</span><strong><asp:Label ID="lblGstAmount" runat="server" /></strong></div>
        <div class="v2-price-row v2-total"><span>Total Payable</span><strong><asp:Label ID="lblTotalAmount" runat="server" /></strong></div>
    </div>

    <asp:Button ID="btnContinue" runat="server" Text="Proceed to Payment" CssClass="v2-submit" OnClick="btnContinue_Click" />
    <div class="v2-small">Your booking is created as pending until the payment result is verified.</div>
</div></div>
</asp:Content>
