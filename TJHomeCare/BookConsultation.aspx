
<%@ Page Title="Online Consultation Professionals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookConsultation.aspx.cs" Inherits="TJHomeCare.BookConsultation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Online Consultation Professionals | TJ Home Care
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">

<style>
    .consultation-results-page {
        max-width: 1100px;
        margin: 35px auto;
        padding: 15px;
        color: #111;
    }

    .consultation-navigation {
        margin-bottom: 22px;
        display: flex;<a href="BookConsultation.aspx.cs">BookConsultation.aspx.cs</a>
        flex-wrap: wrap;
        gap: 18px;
    }

    .consultation-back-link {
        color: #174a75;
        text-decoration: none;
        font-size: 15px;
        font-weight: 600;
    }

    .consultation-back-link:hover {
        text-decoration: underline;
    }

    .consultation-results-heading {
        text-align: center;
        margin-bottom: 28px;
    }

    .consultation-results-heading h1 {
        font-size: 30px;
        color: #174a75;
        margin-bottom: 8px;
    }

    .consultation-results-heading p {
        color: #64748b;
        line-height: 1.6;
    }

    /* PROFESSIONAL CARD */

    .consultation-results-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 25px;
    }

    .consultation-professional-card {
        background: #fff;
        border: 2px solid #e3e3e3;
        border-radius: 30px;
        padding: 35px;
        overflow: hidden;
    }

    /* TOP PROFILE SECTION */

    .consultation-profile-top {
        display: flex;
        align-items: flex-start;
        gap: 35px;
    }

    .consultation-photo-wrapper {
        width: 350px;
        min-width: 300px;
        height: 350px;
        position: relative;
        flex-shrink: 0;
    }

    .consultation-professional-photo {
        width: 100%;
        height: 100%;
        display: block;
        object-fit: cover;
        object-position: center;
        border-radius: 32px;
        background: #f0f0f0;
    }

    /* INITIALS WHEN PHOTO IS NOT AVAILABLE */

    .consultation-profile-initials {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 32px;
        background: #e9edf2;
        color: #174a75;
        font-size: 90px;
        font-weight: 600;
        letter-spacing: 3px;
        text-transform: uppercase;
    }

    .consultation-profile-info {
        flex: 1;
        min-width: 0;
    }

    .consultation-professional-name {
        font-size: 40px;
        line-height: 1.25;
        font-weight: 600;
        color: #111;
        margin: 8px 0 25px;
        overflow-wrap: anywhere;
    }

    .consultation-qualification {
        font-size: 29px;
        font-weight: 500;
        line-height: 1.4;
        margin-bottom: 20px;
        color: #111;
    }

    .consultation-specialization {
        font-size: 25px;
        line-height: 1.5;
        color: #666;
        margin-bottom: 22px;
    }

    .consultation-experience {
        font-size: 25px;
        line-height: 1.5;
        margin-bottom: 22px;
        color: #222;
    }

    .consultation-experience i {
        color: #666;
        margin-right: 10px;
    }

    .consultation-availability {
        display: inline-block;
        padding: 8px 20px;
        border-radius: 30px;
        background: #d9f3e3;
        color: #148443;
        font-size: 21px;
        margin-top: 12px;
    }

    .consultation-timing {
        font-size: 17px;
        color: #555;
        margin-top: 15px;
        line-height: 1.5;
    }

    /* CONDITIONS SECTION */

    .consultation-section-divider {
        border: 0;
        border-top: 2px solid #eeeeee;
        margin: 45px 0 35px;
    }

    .consultation-conditions-title {
        font-size: 29px;
        font-weight: 600;
        color: #111;
        margin-bottom: 25px;
    }

    .consultation-conditions {
        font-size: 24px;
        line-height: 1.9;
        color: #222;
        overflow-wrap: anywhere;
    }

    /* FEE */

    .consultation-fee {
        font-size: 19px;
        color: #666;
        margin-top: 30px;
        margin-bottom: 25px;
    }

    /* BOOKING BUTTON */

    .consultation-booking-btn {
        display: block;
        width: 100%;
        padding: 19px 20px;
        border-radius: 50px;
        background: #0b0b0b;
        color: #fff !important;
        text-align: center;
        text-decoration: none !important;
        font-size: 23px;
        font-weight: 500;
        transition: background .2s ease;
        box-sizing: border-box;
    }

    .consultation-booking-btn:hover {
        background: #333;
        color: #fff !important;
    }

    /* NO RESULTS */

    .consultation-results-message {
        display: block;
        padding: 25px;
        margin: 20px 0;
        border-radius: 12px;
        background: #f8fafc;
        color: #475569;
        text-align: center;
        line-height: 1.8;
    }

    /* TABLET */

    @media (max-width: 900px) {

        .consultation-professional-card {
            padding: 25px;
        }

        .consultation-profile-top {
            gap: 25px;
        }

        .consultation-photo-wrapper {
            width: 270px;
            min-width: 250px;
            height: 300px;
        }

        .consultation-professional-name {
            font-size: 31px;
        }

        .consultation-qualification {
            font-size: 23px;
        }

        .consultation-specialization,
        .consultation-experience {
            font-size: 20px;
        }
    }

    /* MOBILE */

    @media (max-width: 600px) {

        .consultation-results-page {
            margin: 15px auto;
            padding: 10px;
        }

        .consultation-results-heading h1 {
            font-size: 25px;
        }

        .consultation-professional-card {
            padding: 18px;
            border-radius: 20px;
        }

        .consultation-profile-top {
            flex-direction: column;
            gap: 22px;
        }

        .consultation-photo-wrapper {
            width: 100%;
            min-width: 0;
            height: 280px;
        }

        .consultation-professional-photo,
        .consultation-profile-initials {
            border-radius: 20px;
        }

        .consultation-profile-initials {
            font-size: 70px;
        }

        .consultation-profile-info {
            width: 100%;
        }

        .consultation-professional-name {
            font-size: 28px;
            margin: 0 0 15px;
        }

        .consultation-qualification {
            font-size: 21px;
            margin-bottom: 12px;
        }

        .consultation-specialization {
            font-size: 18px;
            margin-bottom: 15px;
        }

        .consultation-experience {
            font-size: 18px;
            margin-bottom: 12px;
        }

        .consultation-availability {
            font-size: 16px;
            padding: 7px 14px;
        }

        .consultation-section-divider {
            margin: 30px 0 25px;
        }

        .consultation-conditions-title {
            font-size: 23px;
            margin-bottom: 15px;
        }

        .consultation-conditions {
            font-size: 18px;
            line-height: 1.8;
        }

        .consultation-fee {
            font-size: 16px;
            margin-top: 22px;
        }

        .consultation-booking-btn {
            font-size: 18px;
            padding: 16px 12px;
        }
    }
</style>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

<div class="consultation-results-page">

    <div class="consultation-navigation">

        <a class="consultation-back-link"
           href="<%= ResolveUrl("~/") %>">
            &#8592; Back to TJ Home Care
        </a>

        <a class="consultation-back-link"
           href="<%= ResolveUrl("~/OnlineConsultations.aspx") %>">
            &#8592; Back to Online Consultation
        </a>

    </div>

    <div class="consultation-results-heading">

        <h1>
            <asp:Literal ID="litHeading" runat="server" />
        </h1>

        <p>
            Explore our available professionals and request an
            online consultation from the comfort of your home.
        </p>

    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        CssClass="consultation-results-message"
        Visible="false" />

    <div class="consultation-results-grid">

        <asp:Repeater ID="rptProfessionals" runat="server">

            <ItemTemplate>

                <article class="consultation-professional-card">

                    <!-- PROFILE TOP SECTION -->

                    <div class="consultation-profile-top">

                        <div class="consultation-photo-wrapper">

                            <!-- SHOW PHOTO IF AVAILABLE -->

                            <asp:Image ID="imgProfessional"
                                runat="server"
                                CssClass="consultation-professional-photo"
                                ImageUrl='<%# ResolveProfilePhoto(
                                    Eval("ProfilePhoto"),
                                    Eval("ProfilePhotoName")) %>'
                                AlternateText='<%# Eval("FullName") %>'
                                Visible='<%# HasProfilePhoto(
                                    Eval("ProfilePhoto"),
                                    Eval("ProfilePhotoName")) %>' />

                            <!-- SHOW INITIALS IF PHOTO NOT AVAILABLE -->

                            <asp:Panel ID="pnlInitials"
                                runat="server"
                                CssClass="consultation-profile-initials"
                                Visible='<%# !HasProfilePhoto(
                                    Eval("ProfilePhoto"),
                                    Eval("ProfilePhotoName")) %>'>

                                <%#: GetInitials(Eval("FullName")) %>

                            </asp:Panel>

                        </div>

                        <div class="consultation-profile-info">

                            <h2 class="consultation-professional-name">
                                <%#: Eval("FullName") %>
                            </h2>

                            <div class="consultation-qualification">
                                <%#: DisplayValue(Eval("Qualification")) %>
                            </div>

                            <div class="consultation-specialization">
                                <%#: Eval("ServiceName") %> |
                                Specialist
                            </div>

                            <div class="consultation-experience">

                                <i class="fa-solid fa-briefcase-medical"></i>

                                <%#: FormatExperience(Eval("Experience")) %>
                                of Experience

                            </div>

                            <div class="consultation-availability">

                                <i class="fa-solid fa-circle-check"></i>
                                Online Consultation Available

                            </div>

                            <div class="consultation-timing">

                                <strong>Available Timings:</strong>
                                <%#: DisplayValue(Eval("DutyPreference")) %>

                            </div>

                        </div>

                    </div>

                    <!-- CONDITIONS TREATED -->

                    <hr class="consultation-section-divider" />

                    <h3 class="consultation-conditions-title">
                        Conditions Treated
                    </h3>

                    <div class="consultation-conditions">

                        <%#: DisplayValue(Eval("Remarks")) %>

                    </div>

                    <!-- CONSULTATION FEE -->

                    <div class="consultation-fee">

                        Consultation Fee:
                        <%#: GetConsultationFee(Eval("ServiceName")) %>

                    </div>

                    <!-- BOOKING BUTTON -->

                    <a class="consultation-booking-btn"
                       href='<%# ResolveUrl(
                           "~/ConsultationBooking.aspx?caregiverId="
                           + Eval("CaregiverID")
                           + "&serviceId="
                           + Eval("ServiceCategoryID")) %>'>

                        Book Online Consultation

                    </a>

                </article>

            </ItemTemplate>

        </asp:Repeater>

    </div>

</div>

</asp:Content>
