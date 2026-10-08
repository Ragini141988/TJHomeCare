<%@ Page Title="Caregiver Details"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="viewcaregiverdetails.aspx.cs"
    Inherits="TJHomeCare.viewcaregiverdetails" %>


<asp:Content ID="Content1"
    ContentPlaceHolderID="TitleContent"
    runat="server">

    Caregiver Details

</asp:Content>


<asp:Content ID="Content2"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <style>

        /* =========================================================
           PAGE
           ========================================================= */

        .caregiver-details-page {
            max-width: 950px;
            margin: 0 auto;
            padding: 20px 15px 40px;
        }


        /* =========================================================
           HEADER
           ========================================================= */

        .details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .details-header h2 {
            margin: 0;
            font-size: 26px;
            font-weight: 700;
        }

        .back-link {
            display: inline-block;
            padding: 8px 14px;
            border: 1px solid #ddd;
            border-radius: 7px;
            color: #333;
            text-decoration: none;
            font-size: 13px;
            background: #fff;
        }

        .back-link:hover {
            background: #f5f5f5;
        }


        /* =========================================================
           MAIN CARD
           ========================================================= */

        .details-card {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
        }


        /* =========================================================
           Profile SECTION
           ========================================================= */

        .Profile-section {
            text-align: center;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .Profile-title {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .Profile-image {
            width: 100%;
            max-width: 650px;
            max-height: 400px;
            object-fit: contain;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #f8f8f8;
        }

        .no-Profile {
            display: inline-block;
            padding: 25px;
            background: #f7f7f7;
            border-radius: 8px;
            color: #777;
            font-size: 14px;
        }



         /* =========================================================
           Aadhar SECTION
           ========================================================= */

        .Aadhar-section {
            text-align: center;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .Aadhar-title {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .Aadhar-image {
            width: 100%;
            max-width: 650px;
            max-height: 400px;
            object-fit: contain;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #f8f8f8;
        }

        .no-Aadhar {
            display: inline-block;
            padding: 25px;
            background: #f7f7f7;
            border-radius: 8px;
            color: #777;
            font-size: 14px;
        }
        /* =========================================================
           SECTION
           ========================================================= */

        .details-section {
            margin-top: 20px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 2px solid #eee;
        }


        /* =========================================================
           DETAIL GRID
           ========================================================= */

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0;
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
        }

        .detail-item {
            display: flex;
            padding: 11px 13px;
            border-bottom: 1px solid #eee;
        }

        .detail-item:nth-child(odd) {
            border-right: 1px solid #eee;
        }

        .detail-label {
            width: 145px;
            flex-shrink: 0;
            font-weight: 600;
            color: #555;
            font-size: 13px;
        }

        .detail-value {
            flex: 1;
            color: #222;
            font-size: 13px;
            word-break: break-word;
        }


        /* =========================================================
           STATUS
           ========================================================= */

        .status {
            display: inline-block;
            padding: 5px 11px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-verified {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-rejected {
            background: #f8d7da;
            color: #842029;
        }


        /* =========================================================
           REMARKS
           ========================================================= */

        .remarks-box {
            padding: 13px;
            background: #f8f8f8;
            border: 1px solid #eee;
            border-radius: 8px;
            min-height: 50px;
            font-size: 13px;
            line-height: 1.6;
            white-space: pre-wrap;
        }


        /* =========================================================
           MESSAGE
           ========================================================= */

        .message-box {
            padding: 20px;
            text-align: center;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            color: #777;
        }


        /* =========================================================
           MOBILE
           ========================================================= */

        @media (max-width: 768px) {

            .caregiver-details-page {
                padding: 15px 10px 30px;
            }

            .details-header {
                align-items: flex-start;
                gap: 10px;
            }

            .details-header h2 {
                font-size: 21px;
            }

            .details-card {
                padding: 13px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .detail-item {
                display: block;
                padding: 10px 11px;
            }

            .detail-item:nth-child(odd) {
                border-right: none;
            }

            .detail-label {
                display: block;
                width: auto;
                margin-bottom: 3px;
                font-size: 12px;
            }

            .detail-value {
                display: block;
                font-size: 13px;
            }

            .Profile-image {
                max-height: 300px;
            }
        }


        @media (max-width: 420px) {

            .details-header {
                display: block;
            }

            .back-link {
                margin-top: 10px;
            }

            .details-header h2 {
                font-size: 20px;
            }

        }

    </style>

</asp:Content>


<asp:Content ID="Content3"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>


<asp:Content ID="Content4"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="caregiver-details-page">


        <!-- =====================================================
             HEADER
             ===================================================== -->

        <div class="details-header">

            <h2>
                Caregiver Details
            </h2>

            <a
                href="viewregisteredcaregiver.aspx"
                class="back-link">

                ← Back to Caregivers

            </a>

        </div>


        <!-- =====================================================
             MESSAGE
             ===================================================== -->

        <asp:Panel
            ID="pnlMessage"
            runat="server"
            CssClass="message-box"
            Visible="false">

            <asp:Label
                ID="lblMessage"
                runat="server">
            </asp:Label>

        </asp:Panel>


        <!-- =====================================================
             DETAILS
             ===================================================== -->

        <asp:Panel
            ID="pnlDetails"
            runat="server"
            CssClass="details-card"
            Visible="false">


            <!-- =================================================
                 Profile CARD
                 ================================================= -->

            <div class="Profile-section">

                <div class="Profile-title">
                    Profile Photo
                </div>


                <asp:Image
                    ID="imgProfile"
                    runat="server"
                    CssClass="Profile-image"
                    AlternateText="Profile" />


                <asp:Label
                    ID="lblNoProfile"
                    runat="server"
                    CssClass="no-Profile"
                    Visible="false">

                    Profile  image is not available.

                </asp:Label>

            </div>

              <!-- =================================================
                 Aadhar CARD
                 ================================================= -->

               <div class="Aadhar-section">

                <div class="Aadhar-title">
                    Aadhar Card
                </div>


                <asp:Image
                    ID="imgAadhar"
                    runat="server"
                    CssClass="Aadhar-image"
                    AlternateText="Aadhar Card" />


                <asp:Label
                    ID="lblNoAadhar"
                    runat="server"
                    CssClass="no-Aadhar"
                    Visible="false">

                    Aadhar  Card is not available.

                </asp:Label>

            </div>


            <!-- =================================================
                 BASIC INFORMATION
                 ================================================= -->

            <div class="details-section">

                <div class="section-title">
                    Basic Information
                </div>


                <div class="details-grid">


                    <div class="detail-item">

                        <div class="detail-label">
                            Caregiver ID
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblCaregiverID"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Full Name
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblFullName"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Age
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblAge"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Gender
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblGender"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Contact Number
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblContactNumber"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            City
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblCity"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Present Area
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblPresentArea"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                </div>

            </div>


            <!-- =================================================
                 PROFESSIONAL INFORMATION
                 ================================================= -->

            <div class="details-section">

                <div class="section-title">
                    Professional Information
                </div>


                <div class="details-grid">


                    <div class="detail-item">

                        <div class="detail-label">
                            Service Category
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblServiceCategory"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Languages Known
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblLanguages"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Qualification
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblQualification"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Experience
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblExperience"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Duty Preference
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblDutyPreference"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Preferred Work Areas
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblPreferredWorkAreas"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Joining Availability
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblJoiningAvailability"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Expected Salary
                        </div>

                        <div class="detail-value">
                            ₹
                            <asp:Label
                                ID="lblExpectedSalary"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                </div>

            </div>


            <!-- =================================================
                 RECRUITMENT INFORMATION
                 ================================================= -->

            <div class="details-section">

                <div class="section-title">
                    Recruitment Information
                </div>


                <div class="details-grid">


                    <div class="detail-item">

                        <div class="detail-label">
                            Recruiter
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblRecruiter"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Verification Status
                        </div>

                        <div class="detail-value">

                            <asp:Label
                                ID="lblVerificationStatus"
                                runat="server"
                                CssClass="status">
                            </asp:Label>

                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Registered Date
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblCreatedDate"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Updated Date
                        </div>

                        <div class="detail-value">
                            <asp:Label
                                ID="lblUpdatedDate"
                                runat="server">
                            </asp:Label>
                        </div>

                    </div>


                </div>

            </div>


            <!-- =================================================
                 REMARKS
                 ================================================= -->

            <div class="details-section">

                <div class="section-title">
                    Remarks
                </div>


                <div class="remarks-box">

                    <asp:Label
                        ID="lblRemarks"
                        runat="server">
                    </asp:Label>

                </div>

            </div>


        </asp:Panel>

    </div>

</asp:Content>