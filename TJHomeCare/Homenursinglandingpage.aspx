<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Homenursinglandingpage.aspx.cs" Inherits="TJHomeCare.Homenursinglandingpage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
 Home Nursing Services | TJ Home Care
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

<style>
    /* Common Settings */

    .nursing-page,
    .nursing-page * {
        box-sizing: border-box;
    }

    .nursing-page {
        width: 100%;
        background: #f5f9fc;
        padding: 35px 15px;
        font-family: Arial, sans-serif;
        color: #263746;
        overflow-x: hidden;
    }

    /* Main Container */

    .nursing-container {
        width: 100%;
        max-width: 1250px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: minmax(0, 1.08fr) minmax(0, 0.92fr);
        gap: 25px;
        align-items: start;
    }

    .nursing-left {
        width: 100%;
        min-width: 0;
        padding: 20px 5px;
    }

    /* Brand */

    .nursing-brand {
    color: #087f8c;
    font-size: 22px;
    font-weight: 800;
    margin-bottom: 22px;
    letter-spacing: 1px;
    text-align: center;
}

    .nursing-brand span {
        color: #48a86b;
    }

    /* Heading */

    .nursing-heading {
        font-size: 37px;
        line-height: 1.2;
        font-weight: 800;
        color: #123d59;
        margin-bottom: 15px;
        overflow-wrap: break-word;
    }

    .nursing-heading span {
        color: #159b86;
    }

    .nursing-description {
        color: #61717d;
        font-size: 15px;
        line-height: 1.8;
        margin-bottom: 22px;
    }

    /* Nursing Image */
    .nursing-hero-container {
        position: relative;
        width: 100%;
        max-width: 640px;
        border-radius: 15px;
        overflow: hidden;
        margin-bottom: 25px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    }
    .nursing-hero {
        display: block;
        width: 100%;
        height: 380px;
        object-fit: cover;
        object-position: center;
    }

    /* Price Box */

    .price-overlay-box {
        position: absolute;
        bottom: 20px;
        left: 20px;
        background: rgba(255, 255, 255, 0.95);
        border-left: 5px solid #20a477;
        padding: 12px 18px;
        border-radius: 9px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.15);
    }

    .price-overlay-box small {
        color: #557469;
        display: block;
        font-size: 12px;
        font-weight: 600;
    }

    .price-overlay-box strong {
        font-size: 22px;
        color: #087d60;
    }

    /* Services */

    .service-heading {
        font-size: 22px;
        color: #153f59;
        font-weight: 800;
        margin-bottom: 15px;
    }

    .service-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
    }

    .service-card {
        background: white;
        border: 1px solid #e2edf0;
        border-radius: 11px;
        padding: 16px 10px;
        min-height: 105px;
        text-align: center;
        box-shadow: 0 3px 12px rgba(20,60,80,.04);
        min-width: 0;
    }

    .service-icon {
        font-size: 27px;
        margin-bottom: 8px;
    }

    .service-card strong {
        display: block;
        font-size: 13px;
        color: #24495d;
        line-height: 1.4;
        overflow-wrap: break-word;
    }

    /* Booking Form */

    .booking-card {
        width: 100%;
        min-width: 0;
        background: #ffffff;
        border-radius: 17px;
        padding: 27px;
        box-shadow: 0 8px 35px rgba(25,70,90,.10);
        border: 1px solid #e7eff2;
    }

    .booking-title {
        color: #123f5c;
        font-size: 25px;
        font-weight: 800;
        margin-bottom: 7px;
    }

    .booking-subtitle {
        color: #71808b;
        font-size: 13px;
        margin-bottom: 22px;
        line-height: 1.6;
    }

    /* Form Controls */

    .form-label-custom {
        font-size: 13px;
        font-weight: 700;
        color: #344d5c;
        margin-bottom: 7px;
        display: block;
    }

    .form-control-custom {
        display: block;
        width: 100%;
        max-width: 100%;
        height: 43px;
        border: 1px solid #dce5e9;
        border-radius: 7px;
        padding: 9px 12px;
        font-size: 14px;
        color: #354955;
        background: #fff;
        outline: none;
    }

    .form-control-custom:focus {
        border-color: #169b8a;
        box-shadow: 0 0 0 3px rgba(22,155,138,.10);
    }

    .form-control-custom.textarea {
        height: 85px;
        resize: vertical;
    }

    .form-row-custom {
        display: grid;
        grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
        gap: 14px;
        margin-bottom: 15px;
    }

    .form-group-custom {
        width: 100%;
        min-width: 0;
        margin-bottom: 15px;
    }

    .required-star {
        color: #e34d4d;
    }

    /* Privacy */

    .privacy-row {
        display: flex;
        align-items: flex-start;
        gap: 8px;
        font-size: 12px;
        color: #667781;
        margin: 17px 0;
        line-height: 1.6;
    }

    .privacy-row input {
        flex-shrink: 0;
        margin-top: 3px;
    }

    /* Submit Button */

    .submit-nursing {
        display: block;
        width: 100%;
        background: #119b83;
        border: none;
        color: white;
        padding: 14px;
        font-size: 15px;
        font-weight: 700;
        border-radius: 8px;
        cursor: pointer;
        transition: .3s;
    }

    .submit-nursing:hover {
        background: #087c6a;
    }

    .form-message {
        display: block;
        margin-top: 13px;
        font-size: 14px;
        font-weight: 600;
        text-align: center;
    }

    .validation-error {
        color: #dc3545;
        font-size: 11px;
    }

    /* Bottom Benefits */

    .benefits-section {
        width: 100%;
        max-width: 1250px;
        margin: 30px auto 0;
        background: #eaf5f5;
        border-radius: 13px;
        padding: 23px 15px;
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 15px;
        text-align: center;
    }

    .benefit-item {
        min-width: 0;
    }

    .benefit-item strong {
        display: block;
        color: #174c60;
        font-size: 14px;
        margin-top: 7px;
    }

    .benefit-icon {
        font-size: 27px;
    }

    /* Tablet View */

    @media screen and (max-width: 850px) {

        .nursing-page {
            padding: 20px 15px;
        }

        .nursing-container {
            grid-template-columns: minmax(0, 1fr);
            gap: 20px;
        }

        .nursing-left {
            padding: 10px 0;
        }

        .nursing-heading {
            font-size: 30px;
        }

        .nursing-hero {
            width: 100%;
            max-width: 640px;
            height: auto;
        }

        .booking-card {
            padding: 22px;
        }

        .benefits-section {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    /* Mobile View */

    @media screen and (max-width: 550px) {

        .nursing-page {
            width: 100%;
            padding: 15px 10px;
        }

        .nursing-container {
            width: 100%;
            grid-template-columns: minmax(0, 1fr);
            gap: 15px;
        }

        .nursing-left {
            width: 100%;
            padding: 5px 0;
        }

        .nursing-brand {
            font-size: 19px;
            margin-bottom: 15px;
        }

        .nursing-heading {
            font-size: 26px;
            line-height: 1.3;
        }

        .nursing-description {
            font-size: 14px;
            line-height: 1.7;
        }

        .nursing-hero {
            width: 100%;
            max-width: 100%;
            height: auto;
            object-fit: contain;
            border-radius: 12px;
        }

        .price-box {
            padding: 13px 15px;
        }

        .price-box strong {
            font-size: 22px;
        }

        .service-heading {
            font-size: 20px;
        }

        .service-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
        }

        .service-card {
            padding: 13px 8px;
            min-height: 100px;
        }

        .service-card strong {
            font-size: 12px;
        }

        .booking-card {
            width: 100%;
            padding: 18px 15px;
            border-radius: 13px;
        }

        .booking-title {
            font-size: 22px;
        }

        .booking-subtitle {
            font-size: 13px;
        }

        .form-row-custom {
            grid-template-columns: minmax(0, 1fr);
            gap: 0;
        }

        .form-control-custom {
            width: 100%;
            font-size: 14px;
        }

        .submit-nursing {
            font-size: 14px;
            padding: 13px 8px;
        }

        .benefits-section {
            width: 100%;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px 10px;
            padding: 20px 10px;
        }

        .benefit-item strong {
            font-size: 12px;
            line-height: 1.5;
        }

        .benefit-icon {
            font-size: 24px;
        }
    }

    /* Very Small Mobile Screens */

    @media screen and (max-width: 360px) {

        .nursing-heading {
            font-size: 23px;
        }

        .booking-card {
            padding: 15px 12px;
        }

        .service-card {
            padding: 12px 5px;
        }

        .service-card strong {
            font-size: 11px;
        }
    }

</style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<div class="nursing-page">

    <div class="nursing-container">

        <!-- LEFT SIDE: HOME NURSING INFORMATION -->

        <div class="nursing-left">

            <div class="nursing-brand">
                <span>Home Nursing Enquiry Form</span>
            </div>

            <h1 class="nursing-heading">
                Professional Home Nursing
                <span>Services at Your Doorstep In Hyderabad & Bangalore</span>
            </h1>

            <p class="nursing-description">
                Get trusted and professional nursing care for your loved ones
                in the comfort of your home. Our experienced nursing staff
                provides personalized care for patients, elderly people
                and individuals recovering from illness or surgery.
            </p>

           <!-- Image with Overlay Price Box -->
            <div class="nursing-hero-container">
                <img src="images/homenure02.jpeg"
                     class="nursing-hero"
                     alt="Home Nursing Care" runat="server" />
                
                <div class="price-overlay-box">
                    <small>12+ Years of Expertise in Nursing Recruitment</small>
                   <%-- <strong>₹1,000 / Day</strong>--%>
                </div>
            </div>

            <div class="price-box">
                <small>Home Nursing Services Starting From</small>
                <strong>₹1,000 / Day</strong>
            </div>

            <h3 class="service-heading">
                Our Home Nursing Services
            </h3>

            <div class="service-grid">

                <div class="service-card">
                    <div class="service-icon">🩺</div>
                    <strong>Basic Nursing Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">💉</div>
                    <strong>Advanced Nursing Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">🏥</div>
                    <strong>ICU / Critical Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">❤️</div>
                    <strong>Post-Surgery Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">🧑‍⚕️</div>
                    <strong>Stroke & Paralysis Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">👴</div>
                    <strong>Elderly Nursing Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">🛏️</div>
                    <strong>Bedridden Patient Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">💊</div>
                    <strong>Tracheostomy Care</strong>
                </div>

                <div class="service-card">
                    <div class="service-icon">🤝</div>
                    <strong>Palliative Care</strong>
                </div>

            </div>

        </div>

        <!-- RIGHT SIDE: CUSTOMER ENQUIRY FORM -->

        <div class="booking-card">

            <h2 class="booking-title">
                Book a Home Nurse
            </h2>

            <p class="booking-subtitle">
                Tell us your requirements. Our team will contact you
                with nurse availability and pricing details.
            </p>

            <asp:ValidationSummary ID="vsNursing"
                runat="server"
                ValidationGroup="Nursing"
                CssClass="validation-error" />

            <div class="form-group-custom">
                <label class="form-label-custom">
                    Your Name <span class="required-star">*</span>
                </label>

                <asp:TextBox ID="txtCustomerName" runat="server"
                    CssClass="form-control-custom"
                    MaxLength="150"
                    placeholder="Enter your full name" />

                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                    ControlToValidate="txtCustomerName"
                    ErrorMessage="Please enter your name."
                    CssClass="validation-error"
                    ValidationGroup="Nursing"
                    Display="Dynamic" />
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">
                    Mobile Number <span class="required-star">*</span>
                </label>

                <asp:TextBox ID="txtMobile" runat="server"
                    CssClass="form-control-custom"
                    MaxLength="10"
                    TextMode="Phone"
                    placeholder="Enter 10 digit mobile number" />

                <asp:RequiredFieldValidator ID="rfvMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ErrorMessage="Please enter mobile number."
                    CssClass="validation-error"
                    ValidationGroup="Nursing"
                    Display="Dynamic" />

                <asp:RegularExpressionValidator ID="revMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ValidationExpression="^[6-9][0-9]{9}$"
                    ErrorMessage="Enter a valid 10 digit mobile number."
                    CssClass="validation-error"
                    ValidationGroup="Nursing"
                    Display="Dynamic" />
            </div>

            <div class="form-row-custom">

                <div class="form-group-custom">
                    <label class="form-label-custom">
                        City <span class="required-star">*</span>
                    </label>

                    <asp:DropDownList ID="ddlCity" runat="server"
                        CssClass="form-control-custom">
                        <asp:ListItem Value="">Select City</asp:ListItem>
                        <asp:ListItem Value="Hyderabad">Hyderabad</asp:ListItem>
                        <asp:ListItem Value="Bangalore">Bangalore</asp:ListItem>
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                        ControlToValidate="ddlCity"
                        InitialValue=""
                        ErrorMessage="Please select city."
                        CssClass="validation-error"
                        ValidationGroup="Nursing"
                        Display="Dynamic" />
                </div>

                <div class="form-group-custom">
                    <label class="form-label-custom">
                        Area / Locality <span class="required-star">*</span>
                    </label>

                    <asp:TextBox ID="txtArea" runat="server"
                        CssClass="form-control-custom"
                        MaxLength="150"
                        placeholder="Enter your area" />

                    <asp:RequiredFieldValidator ID="rfvArea" runat="server"
                        ControlToValidate="txtArea"
                        ErrorMessage="Please enter area."
                        CssClass="validation-error"
                        ValidationGroup="Nursing"
                        Display="Dynamic" />
                </div>

            </div>

            <div class="form-row-custom">

                <div class="form-group-custom">
                    <label class="form-label-custom">Patient Age</label>

                    <asp:TextBox ID="txtPatientAge" runat="server"
                        CssClass="form-control-custom"
                        TextMode="Number"
                        placeholder="Enter age" />
                </div>

                <div class="form-group-custom">
                    <label class="form-label-custom">Preferred Start Date</label>

                    <asp:TextBox ID="txtStartDate" runat="server"
                        CssClass="form-control-custom"
                        TextMode="Date" />
                </div>

            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">
                    Type of Nursing Care Required
                    <span class="required-star">*</span>
                </label>

                <asp:DropDownList ID="ddlNursingCare" runat="server"
                    CssClass="form-control-custom">

                    <asp:ListItem Value="">Select Nursing Care</asp:ListItem>
                    <asp:ListItem>Basic Nursing Care</asp:ListItem>
                    <asp:ListItem>Advanced Nursing Care</asp:ListItem>
                    <asp:ListItem>ICU / Critical Care Nursing</asp:ListItem>
                    <asp:ListItem>Post-Surgery Care</asp:ListItem>
                    <asp:ListItem>Stroke &amp; Paralysis Care</asp:ListItem>
                    <asp:ListItem>Elderly Nursing Care</asp:ListItem>
                    <asp:ListItem>Bedridden Patient Care</asp:ListItem>
                    <asp:ListItem>Tracheostomy Care</asp:ListItem>
                    <asp:ListItem>Palliative &amp; Long-Term Care</asp:ListItem>

                </asp:DropDownList>

                <asp:RequiredFieldValidator ID="rfvCare" runat="server"
                    ControlToValidate="ddlNursingCare"
                    InitialValue=""
                    ErrorMessage="Please select nursing care type."
                    CssClass="validation-error"
                    ValidationGroup="Nursing"
                    Display="Dynamic" />
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">
                    Required Duty Hours <span class="required-star">*</span>
                </label>

                <asp:DropDownList ID="ddlDutyHours" runat="server"
                    CssClass="form-control-custom">

                    <asp:ListItem Value="">Select Duty Hours</asp:ListItem>
                    <asp:ListItem>8 Hours</asp:ListItem>
                    <asp:ListItem>12 Hours</asp:ListItem>
                    <asp:ListItem>24 Hours</asp:ListItem>
                    <asp:ListItem>Live-in Care</asp:ListItem>

                </asp:DropDownList>

                <asp:RequiredFieldValidator ID="rfvDuty" runat="server"
                    ControlToValidate="ddlDutyHours"
                    InitialValue=""
                    ErrorMessage="Please select duty hours."
                    CssClass="validation-error"
                    ValidationGroup="Nursing"
                    Display="Dynamic" />
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">
                    Additional Patient Requirements
                </label>

                <asp:TextBox ID="txtRequirements" runat="server"
                    CssClass="form-control-custom textarea"
                    TextMode="MultiLine"
                    MaxLength="2000"
                    placeholder="Please describe the patient's condition or special requirements..." />
            </div>

            <div class="privacy-row">
                <asp:CheckBox ID="chkPrivacy" runat="server" />
                <label for="<%= chkPrivacy.ClientID %>">
                    I agree to the Privacy Policy and consent to being
                    contacted by TJ Home Care regarding my enquiry.
                </label>
            </div>

            <asp:Button ID="btnSubmitEnquiry" runat="server"
                Text="Get Home Nurse Availability→"
                CssClass="submit-nursing"
                ValidationGroup="Nursing"
                OnClick="btnSubmitEnquiry_Click" />

            <asp:Label ID="lblMessage" runat="server"
                CssClass="form-message" />

        </div>

    </div>

    <!-- BOTTOM BENEFITS -->

    <div class="benefits-section">

        <div class="benefit-item">
            <div class="benefit-icon">🛡️</div>
            <strong>Qualified & Verified Nurses</strong>
        </div>

        <div class="benefit-item">
            <div class="benefit-icon">🎓</div>
            <strong>ANM / GNM / B.Sc Nursing</strong>
        </div>

        <div class="benefit-item">
            <div class="benefit-icon">⏰</div>
            <strong>Flexible Duty Hours</strong>
        </div>

        <div class="benefit-item">
            <div class="benefit-icon">🏠</div>
            <strong>Short & Long-Term Care</strong>
        </div>

    </div>

</div>

</asp:Content>
