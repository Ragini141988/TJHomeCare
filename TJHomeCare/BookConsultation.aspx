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
            padding: 20px;
            color: #243247;
        }

        .consultation-results-heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .consultation-results-heading h1 {
            color: #174a75;
            font-size: 30px;
            margin-bottom: 10px;
        }

        .consultation-results-heading p {
            color: #64748b;
            line-height: 1.6;
        }

        .consultation-results-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .consultation-professional-card {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: #fff;
            border: 1px solid #e1e8f0;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, .06);
        }

        .consultation-professional-photo {
            display: block;
            width: 100%;
            height: 230px;
            object-fit: cover;
            background: #edf2f7;
        }

        .consultation-professional-content {
            padding: 22px;
            flex: 1;
        }

        .consultation-professional-content h2 {
            margin: 0 0 16px;
            color: #174a75;
            font-size: 22px;
            overflow-wrap: anywhere;
        }

        .consultation-professional-detail {
            margin: 11px 0;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .consultation-professional-detail strong {
            color: #334155;
        }

        .consultation-booking-btn {
            display: block;
            margin-top: 20px;
            padding: 13px 16px;
            border-radius: 8px;
            background: #087f8c;
            color: #fff !important;
            text-align: center;
            text-decoration: none !important;
            font-weight: 600;
            transition: background .2s ease;
        }

        .consultation-booking-btn:hover {
            background: #066772;
        }

        .consultation-results-message {
            display: block;
            padding: 16px;
            margin: 20px 0;
            border-radius: 8px;
            background: #fff;
            color: #475569;
            text-align: center;
            line-height: 1.6;
        }

        .consultation-back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #174a75;
            text-decoration: none;
            font-weight: 600;
        }

        .consultation-back-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 700px) {
            .consultation-results-page {
                margin: 15px auto;
                padding: 12px;
            }

            .consultation-results-heading h1 {
                font-size: 25px;
            }

            .consultation-results-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .consultation-professional-content {
                padding: 18px;
            }

            .consultation-professional-content h2 {
                font-size: 20px;
            }

            .consultation-professional-photo {
                height: 210px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="consultation-results-page">

        <a class="consultation-back-link"
           href="<%= ResolveUrl("~/") %>">
            &#8592; Back to TJ Home Care
        </a>

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

                        <asp:Image ID="imgProfessional"
                            runat="server"
                            CssClass="consultation-professional-photo"
                            ImageUrl='<%# ResolveProfilePhoto(
                                Eval("ProfilePhoto"),
                                Eval("ProfilePhotoName")) %>'
                            AlternateText="Professional profile photo"
                            Visible='<%# HasProfilePhoto(
                                Eval("ProfilePhoto"),
                                Eval("ProfilePhotoName")) %>' />

                        <div class="consultation-professional-content">

                            <h2><%#: Eval("FullName") %></h2>

                            <div class="consultation-professional-detail">
                                <strong>Service:</strong>
                                <%#: Eval("ServiceName") %>
                            </div>

                            <div class="consultation-professional-detail">
                                <strong>Qualification:</strong>
                                <%#: DisplayValue(Eval("Qualification")) %>
                            </div>

                            <div class="consultation-professional-detail">
                                <strong>Experience:</strong>
                                <%#: FormatExperience(Eval("Experience")) %>
                            </div>

                            <div class="consultation-professional-detail">
                                <strong>Languages Known:</strong>
                                <%#: DisplayValue(Eval("LanguagesKnown")) %>
                            </div>

                            <div class="consultation-professional-detail">
                                <strong>Available Timings:</strong>
                                <%#: DisplayValue(Eval("DutyPreference")) %>
                            </div>

                            <a class="consultation-booking-btn"
                               href='<%# ResolveUrl(
                                   "~/ConsultationBooking.aspx?caregiverId="
                                   + Eval("CaregiverID")) %>'>
                                Book Online Consultation
                            </a>

                        </div>
                    </article>

                </ItemTemplate>
            </asp:Repeater>

        </div>

    </div>

</asp:Content>

