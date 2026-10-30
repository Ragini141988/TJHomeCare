<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConsultationBookingDetails.aspx.cs" Inherits="TJHomeCare.ConsultationBookingDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
     <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }

        .details-container {
            max-width: 950px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .details-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 3px 12px rgba(0,0,0,.05);
        }

        h2, h4 {
            color: #087f8c;
            font-weight: 700;
        }

        .detail-row {
            padding: 12px 0;
            border-bottom: 1px solid #edf0f2;
        }

        .detail-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #222;
            overflow-wrap: anywhere;
        }

        .profile-photo {
            width: 110px;
            height: 110px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #e7f6f7;
        }

        .btn-back {
            background: #087f8c;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-back:hover {
            background: #066570;
            color: white;
        }

        @media(max-width: 576px) {
            .details-container {
                margin: 15px auto;
            }

            .details-card {
                padding: 17px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
       <div class="details-container">

        <div class="details-card">

            <h2>Consultation Booking Details</h2>

            <p class="text-muted">
                Customer information and selected professional.
            </p>

            <asp:Label ID="lblMessage"
                runat="server"
                CssClass="text-danger d-block mb-3">
            </asp:Label>

            <asp:Panel ID="pnlDetails"
                runat="server"
                Visible="false">

                <h4 class="mt-3">Booking Information</h4>

                <div class="row">

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Booking ID</div>
                        <asp:Label ID="lblBookingID"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Booking Status</div>
                        <asp:Label ID="lblBookingStatus"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Service</div>
                        <asp:Label ID="lblServiceName"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Booking Date</div>
                        <asp:Label ID="lblCreatedDate"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                </div>

                <h4 class="mt-4">Customer Information</h4>

                <div class="row">

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Customer Name</div>
                        <asp:Label ID="lblCustomerName"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Gender</div>
                        <asp:Label ID="lblGender"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Email</div>
                        <asp:Label ID="lblEmail"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Contact Number</div>
                        <asp:Label ID="lblContactNumber"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">City</div>
                        <asp:Label ID="lblCity"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">State</div>
                        <asp:Label ID="lblState"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                </div>

                <h4 class="mt-4">Selected Caregiver Profile</h4>

                <div class="text-center mb-3">

                    <asp:Image ID="imgProfessional"
                        runat="server"
                        CssClass="profile-photo"
                        AlternateText="Professional profile photo"
                        Visible="false" />

                </div>

                <div class="row">

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Caregiver ID</div>
                        <asp:Label ID="lblCaregiverID"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Professional Name</div>
                        <asp:Label ID="lblProfessionalName"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Professional Email</div>
                        <asp:Label ID="lblProfessionalEmail"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Professional Contact</div>
                        <asp:Label ID="lblProfessionalContact"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Qualification</div>
                        <asp:Label ID="lblQualification"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Experience</div>
                        <asp:Label ID="lblExperience"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                    <div class="col-md-6 detail-row">
                        <div class="detail-label">Verification Status</div>
                        <asp:Label ID="lblVerificationStatus"
                            runat="server"
                            CssClass="detail-value" />
                    </div>

                </div>

            </asp:Panel>

            <div class="mt-4">
                <a href="ConsultationBookingsView.aspx"
                   class="btn-back">
                    Back to Consultation Bookings
                </a>
            </div>

        </div>

    </div>
</asp:Content>


