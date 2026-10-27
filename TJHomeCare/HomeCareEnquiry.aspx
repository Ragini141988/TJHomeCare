<%@ Page Title="Home Care Enquiry"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="HomeCareEnquiry.aspx.cs"
    Inherits="TJHomeCare.HomeCareEnquiry"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

 <style>
     .hc-enquiry-page { padding: 35px 15px; background: #f5f7fb; min-height: 80vh; font-family: Arial, sans-serif; }
.hc-enquiry-card { max-width: 760px; margin: 0 auto; background: #fff; padding: 32px; border: 1px solid #e3e7ed; border-radius: 22px; box-shadow: 0 8px 30px rgba(0,0,0,.05); }
.hc-heading { display: flex; align-items: flex-start; gap: 16px; margin-bottom: 24px; }
.hc-home-icon { font-size: 34px; flex-shrink: 0; }
.hc-heading h1 { font-size: 29px; line-height: 1.3; margin: 0 0 8px; color: #202b38; }
.hc-subtitle { color: #737b85; font-size: 16px; margin: 0; }
.hc-description { color: #5d6671; font-size: 17px; line-height: 1.7; margin: 20px 0 26px; }
.hc-field { margin-bottom: 23px; }
.hc-label { display: block; font-size: 16px; font-weight: 600; margin-bottom: 10px; color: #343d48; }

/* Keep this only for TextBoxes and DropDownLists */
.hc-input { display: block; width: 100%; box-sizing: border-box; min-height: 54px; padding: 14px 16px; border: 1px solid #d5dbe2; border-radius: 12px; background: #fff; font-size: 16px; color: #242b33; }
.hc-input:focus { outline: none; border-color: #167a62; box-shadow: 0 0 0 3px rgba(22,122,98,.10); }

/* FIXED RADIO WRAPPER STYLES */
.hc-radio-wrapper { display: flex; flex-direction: column; gap: 12px; padding: 5px 0; }
.hc-radio-horizontal { display: flex; flex-wrap: wrap; gap: 12px 20px; padding: 5px 0; }

/* Formats the raw individual radio layout items rendered by ASP.NET */
.hc-radio-wrapper span, .hc-radio-horizontal span { display: inline-flex; align-items: center; margin: 0; }
.hc-radio-wrapper label, .hc-radio-horizontal label { font-weight: 400; font-size: 16px; color: #242b33; display: inline-flex; align-items: center; margin: 0 0 0 8px; cursor: pointer; }
.hc-radio-wrapper input[type="radio"], .hc-radio-horizontal input[type="radio"] { width: 19px; height: 19px; accent-color: #167a62; margin: 0; cursor: pointer; flex-shrink: 0; }

.hc-note { padding: 15px; background: #f2faf6; border-radius: 12px; color: #52645b; font-size: 14px; line-height: 1.6; margin: 20px 0; }
.hc-submit { display: block; width: 100%; min-height: 56px; background: #167a62; color: #fff; border: none; border-radius: 12px; padding: 15px 20px; font-size: 17px; font-weight: 700; cursor: pointer; }
.hc-submit:hover { background: #10644f; }
.hc-submit:disabled { opacity: .65; cursor: wait; }
.hc-message { display: block; padding: 12px 14px; margin: 15px 0; border-radius: 9px; line-height: 1.5; }
.hc-error { color: #a32020; background: #fff0f0; }
.hc-success { color: #17613e; background: #eaf8ef; }
.hc-validation { display: block; color: #c62828; font-size: 13px; margin-top: 6px; }

@media (max-width: 600px) {
  .hc-enquiry-page { padding: 15px 10px; }
  .hc-enquiry-card { padding: 20px 16px; border-radius: 16px; }
  .hc-heading h1 { font-size: 23px; }
  .hc-home-icon { font-size: 27px; }
  .hc-description { font-size: 15px; }
  .hc-input { min-height: 52px; font-size: 16px; }
  .hc-radio-horizontal { flex-direction: column; gap: 12px; }
}

 </style>

    <div class="hc-enquiry-page">

        <div class="hc-enquiry-card">

            <div class="hc-heading">
                <div class="hc-home-icon">&#127968;</div>

                <div>
                    <h1>Find Trusted Help for Your Home</h1>

                    <p class="hc-subtitle">
                        Bangalore &amp; Hyderabad | TJ Home Care
                    </p>
                </div>
            </div>

            <p class="hc-description">
                Tell us what you need. Our care coordinator will
                contact you with suitable options.
            </p>

            <asp:Label ID="lblMessage"
                runat="server"
                Visible="false"
                CssClass="hc-message" />

            <asp:ValidationSummary ID="vsEnquiry"
                runat="server"
                ValidationGroup="Enquiry"
                CssClass="hc-message hc-error"
                HeaderText="Please correct the following:" />

            <div class="hc-field">

                <label class="hc-label" for="<%= txtFullName.ClientID %>">
                    Full Name *
                </label>

                <asp:TextBox ID="txtFullName"
                    runat="server"
                    CssClass="hc-input"
                    MaxLength="150"
                    placeholder="Enter your name" />

                <asp:RequiredFieldValidator
                    ID="rfvFullName"
                    runat="server"
                    ControlToValidate="txtFullName"
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please enter your full name."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <label class="hc-label"
                    for="<%= txtMobileNumber.ClientID %>">
                    Mobile / WhatsApp Number *
                </label>

                <asp:TextBox ID="txtMobileNumber"
                    runat="server"
                    CssClass="hc-input"
                    MaxLength="10"
                    TextMode="Phone"
                    placeholder="10-digit mobile number" />

                <asp:RequiredFieldValidator
                    ID="rfvMobile"
                    runat="server"
                    ControlToValidate="txtMobileNumber"
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please enter your mobile number."
                    CssClass="hc-validation"
                    Display="Dynamic" />

                <asp:RegularExpressionValidator
                    ID="revMobile"
                    runat="server"
                    ControlToValidate="txtMobileNumber"
                    ValidationGroup="Enquiry"
                    ValidationExpression="^[6-9][0-9]{9}$"
                    ErrorMessage="Enter a valid 10-digit Indian mobile number."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <span class="hc-label">City *</span>

                <asp:RadioButtonList ID="rblCity"
                    runat="server"
                    CssClass="hc-radio"
                    RepeatDirection="Vertical"
                    RepeatLayout="Flow">

                    <asp:ListItem Text="Hyderabad (Home Care Services)" Value="Hyderabad (Home Care Services)" Selected="True" />

                    <asp:ListItem Text="Bangalore (Home Care Services)" Value="Bangalore (Home Care Services)" />

                    <asp:ListItem Text="Online Consultation (PAN India)" Value="Online Consultation (PAN India)"/>


                    

                </asp:RadioButtonList>

                <asp:RequiredFieldValidator
                    ID="rfvCity"
                    runat="server"
                    ControlToValidate="rblCity"
                    InitialValue=""
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please select a city."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <label class="hc-label" for="<%= txtArea.ClientID %>">
                    Area / Locality *
                </label>

                <asp:TextBox ID="txtArea"
                    runat="server"
                    CssClass="hc-input"
                    MaxLength="150"
                    placeholder="e.g. Gachibowli, Kondapur, Whitefield" />

                <asp:RequiredFieldValidator
                    ID="rfvArea"
                    runat="server"
                    ControlToValidate="txtArea"
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please enter your area or locality."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <label class="hc-label"
                    for="<%= ddlService.ClientID %>">
                    Service Required *
                </label>

                <asp:DropDownList ID="ddlService"
                    runat="server"
                    CssClass="hc-input"
                    AppendDataBoundItems="false">

                    <asp:ListItem
                        Text="Select a service"
                        Value=""
                        Selected="True" />

                </asp:DropDownList>

                <asp:RequiredFieldValidator
                    ID="rfvService"
                    runat="server"
                    ControlToValidate="ddlService"
                    InitialValue=""
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please select a service."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <span class="hc-label">Duty Hours *</span>

                <asp:RadioButtonList ID="rblDutyHours"
                    runat="server"
                    CssClass="hc-radio"
                    RepeatDirection="Vertical"
                    RepeatLayout="Flow">

                    <asp:ListItem Text="8 Hours" Value="8 Hours" />

                    <asp:ListItem Text="10 Hours" Value="10 Hours" />

                    <asp:ListItem Text="12 Hours" Value="12 Hours" />

                    <asp:ListItem
                        Text="24 Hours / Live-in"
                        Value="24 Hours / Live-in" />

                </asp:RadioButtonList>

                <asp:RequiredFieldValidator
                    ID="rfvDutyHours"
                    runat="server"
                    ControlToValidate="rblDutyHours"
                    InitialValue=""
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please select duty hours."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <span class="hc-label">
                    When Do You Need the Service? *
                </span>

                <asp:RadioButtonList ID="rblRequiredWhen"
                    runat="server"
                    CssClass="hc-radio"
                    RepeatDirection="Vertical"
                    RepeatLayout="Flow">

                    <asp:ListItem Text="Immediately" Value="Immediately" />

                    <asp:ListItem Text="Within 7 Days" Value="Within 7 Days" />

                    <asp:ListItem Text="Within 30 Days" Value="Within 30 Days" />

                    <asp:ListItem Text="Just Exploring" Value="Just Exploring" />

                </asp:RadioButtonList>

                <asp:RequiredFieldValidator
                    ID="rfvRequiredWhen"
                    runat="server"
                    ControlToValidate="rblRequiredWhen"
                    InitialValue=""
                    ValidationGroup="Enquiry"
                    ErrorMessage="Please select when you need the service."
                    CssClass="hc-validation"
                    Display="Dynamic" />

            </div>

            <div class="hc-field">

                <label class="hc-label"
                    for="<%= txtRequirements.ClientID %>">
                    Additional Requirements (Optional)
                </label>

                <asp:TextBox ID="txtRequirements"
                    runat="server"
                    CssClass="hc-input"
                    TextMode="MultiLine"
                    Rows="4"
                    MaxLength="1000"
                    placeholder="Language preference, duties, special requirements..." />

            </div>

            <div class="hc-note">
                &#128274;
                Your details will be used to contact you about your
                service enquiry. Please provide accurate contact
                information so our coordinator can reach you.
            </div>

            <asp:Button ID="btnGetCallBack"
                runat="server"
                Text="Get A Call Back"
                CssClass="hc-submit"
                ValidationGroup="Enquiry"
                OnClick="btnGetCallBack_Click"
                UseSubmitBehavior="true" />

        </div>

    </div>

</asp:Content>