<%@ Page Title="Book Online Consultation"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="ConsultationBooking.aspx.cs"
    Inherits="TJHomeCare.ConsultationBooking" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .consultation-booking-wrapper {
            max-width: 750px;
            margin: 35px auto;
            padding: 25px;
            font-family: Arial, sans-serif;
        }

        .consultation-booking-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.09);
        }

        .consultation-booking-card h2 {
            color: #176b55;
            margin-bottom: 10px;
        }

        .booking-subtitle {
            color: #666666;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .selected-consultation {
            background: #f0f8f5;
            border-left: 4px solid #176b55;
            padding: 15px;
            margin-bottom: 25px;
            line-height: 1.8;
        }

        .booking-field {
            margin-bottom: 18px;
        }

        .booking-field label {
            display: block;
            font-weight: 600;
            margin-bottom: 7px;
            color: #333333;
        }

        .booking-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cccccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 15px;
        }

        .booking-submit {
            background: #176b55;
            color: #ffffff;
            border: none;
            padding: 13px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }

        .booking-submit:hover {
            background: #10513f;
        }

        .booking-error {
            display: block;
            color: #c62828;
            margin-bottom: 15px;
        }

        .booking-success {
            text-align: center;
            padding: 25px 10px;
        }

        .booking-success h2 {
            color: #176b55;
        }

        .booking-back-link {
            display: inline-block;
            margin-top: 20px;
            color: #176b55;
            text-decoration: none;
            font-weight: 600;
        }

        .booking-validation {
            display: block;
            color: #c62828;
            font-size: 13px;
            margin-top: 5px;
        }

        @media (max-width: 600px) {
            .consultation-booking-wrapper {
                margin: 15px auto;
                padding: 12px;
            }

            .consultation-booking-card {
                padding: 20px;
            }
        }
    </style>

</asp:Content>


<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="consultation-booking-wrapper">

        <div class="consultation-booking-card">

            <asp:Panel ID="pnlBookingForm"
                runat="server"
                Visible="true">

                <h2>Book Online Consultation</h2>

                <p class="booking-subtitle">
                    Please provide your details. Our team will contact
                    you regarding your consultation booking.
                </p>

                <div class="selected-consultation">

                    <strong>Selected Professional:</strong>
                    <asp:Label ID="lblProfessionalName"
                        runat="server" />

                    <br />

                    <strong>Consultation Service:</strong>
                    <asp:Label ID="lblServiceName"
                        runat="server" />

                </div>

                <asp:Label ID="lblErrorMessage"
                    runat="server"
                    CssClass="booking-error"
                    EnableViewState="false" />

                <div class="booking-field">

                    <label for="<%= txtCustomerName.ClientID %>">
                        Your Name *
                    </label>

                    <asp:TextBox ID="txtCustomerName"
                        runat="server"
                        CssClass="booking-input"
                        MaxLength="100" />

                    <asp:RequiredFieldValidator
                        ID="rfvCustomerName"
                        runat="server"
                        ControlToValidate="txtCustomerName"
                        ErrorMessage="Please enter your name."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <div class="booking-field">

                    <label for="<%= ddlGender.ClientID %>">
                        Gender *
                    </label>

                    <asp:DropDownList ID="ddlGender"
                        runat="server"
                        CssClass="booking-input">

                        <asp:ListItem Text="Select Gender"
                            Value="" />

                        <asp:ListItem Text="Female"
                            Value="Female" />

                        <asp:ListItem Text="Male"
                            Value="Male" />

                        <asp:ListItem Text="Other"
                            Value="Other" />

                        <asp:ListItem Text="Prefer not to say"
                            Value="Prefer not to say" />

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        ID="rfvGender"
                        runat="server"
                        ControlToValidate="ddlGender"
                        InitialValue=""
                        ErrorMessage="Please select your gender."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <div class="booking-field">

                    <label for="<%= txtCity.ClientID %>">
                        Your City *
                    </label>

                    <asp:TextBox ID="txtCity"
                        runat="server"
                        CssClass="booking-input"
                        MaxLength="100" />

                    <asp:RequiredFieldValidator
                        ID="rfvCity"
                        runat="server"
                        ControlToValidate="txtCity"
                        ErrorMessage="Please enter your city."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <div class="booking-field">

                    <label for="<%= txtState.ClientID %>">
                        State *
                    </label>

                    <asp:TextBox ID="txtState"
                        runat="server"
                        CssClass="booking-input"
                        MaxLength="100" />

                    <asp:RequiredFieldValidator
                        ID="rfvState"
                        runat="server"
                        ControlToValidate="txtState"
                        ErrorMessage="Please enter your state."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <div class="booking-field">

                    <label for="<%= txtEmail.ClientID %>">
                        Email Address *
                    </label>

                    <asp:TextBox ID="txtEmail"
                        runat="server"
                        CssClass="booking-input"
                        TextMode="Email"
                        MaxLength="254" />

                    <asp:RequiredFieldValidator
                        ID="rfvEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Please enter your email address."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator
                        ID="revEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Please enter a valid email address."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <div class="booking-field">

                    <label for="<%= txtContactNumber.ClientID %>">
                        Contact Number *
                    </label>

                    <asp:TextBox ID="txtContactNumber"
                        runat="server"
                        CssClass="booking-input"
                        TextMode="Phone"
                        MaxLength="20" />

                    <asp:RequiredFieldValidator
                        ID="rfvContactNumber"
                        runat="server"
                        ControlToValidate="txtContactNumber"
                        ErrorMessage="Please enter your contact number."
                        CssClass="booking-validation"
                        Display="Dynamic" />

                </div>

                <asp:Button ID="btnSubmit"
                    runat="server"
                    Text="Submit Booking"
                    CssClass="booking-submit"
                    OnClick="btnSubmit_Click"
                    CausesValidation="true" />

            </asp:Panel>


            <asp:Panel ID="pnlSuccess"
                runat="server"
                Visible="false"
                CssClass="booking-success">

                <h2>Booking Submitted Successfully!</h2>

                <p>
                    <asp:Label ID="lblSuccessMessage"
                        runat="server" />
                </p>

                <a href="<%= ResolveUrl("~/HomePage.aspx") %>"
                    class="booking-back-link">
                    Back to Home
                </a>

            </asp:Panel>

        </div>

    </div>

</asp:Content>
