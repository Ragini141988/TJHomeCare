<%@ Page Title="Online Consultations" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OnlineConsultations.aspx.cs" Inherits="TJHomeCare.OnlineConsultations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Online Consultations | TJ Home Care
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .consultation-page {
            max-width: 1250px;
            margin: 30px auto;
            padding: 0 18px 40px;
            font-family: Arial, sans-serif;
            color: #243447;
        }

        .consultation-hero {
            background: linear-gradient(135deg, #eaf8fa, #f6fbff);
            border-radius: 18px;
            padding: 35px 25px;
            text-align: center;
            margin-bottom: 30px;
        }

        .consultation-hero h1 {
            color: #12445b;
            font-size: 34px;
            font-weight: 700;
            margin: 0 0 12px;
        }

        .consultation-hero p {
            max-width: 750px;
            margin: 0 auto;
            font-size: 16px;
            line-height: 1.7;
            color: #526170;
        }

        .consultation-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 24px;
        }

        .consultation-card {
            background: #fff;
            border: 1px solid #e3edf0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(25, 70, 85, 0.07);
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .consultation-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 22px rgba(25, 70, 85, 0.13);
        }

        .consultation-image {
            width: 100%;
            height: 215px;
            object-fit: cover;
            display: block;
        }

        .consultation-card-content {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .consultation-card h2 {
            font-size: 21px;
            line-height: 1.4;
            color: #12445b;
            margin: 0 0 10px;
        }

        .consultation-card p {
            font-size: 14px;
            line-height: 1.7;
            color: #586675;
            margin: 0 0 20px;
            flex: 1;
        }

        .consultation-btn {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 13px 12px;
            text-align: center;
            background: #087f83;
            color: #fff !important;
            text-decoration: none !important;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.5;
            transition: background 0.2s ease;
        }

        .consultation-btn:hover {
            background: #075e65;
        }

        @media (max-width: 900px) {
            .consultation-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 18px;
            }

            .consultation-image {
                height: 190px;
            }
        }

        @media (max-width: 560px) {
            .consultation-page {
                margin: 18px auto;
                padding: 0 12px 25px;
            }

            .consultation-hero {
                padding: 26px 17px;
                margin-bottom: 22px;
            }

            .consultation-hero h1 {
                font-size: 27px;
            }

            .consultation-hero p {
                font-size: 14px;
            }

            .consultation-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .consultation-image {
                height: 225px;
            }

            .consultation-card-content {
                padding: 17px;
            }

            .consultation-card h2 {
                font-size: 20px;
            }

            .consultation-btn {
                font-size: 14px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="consultation-page">

        <!-- PAGE HEADING -->
        <div class="consultation-hero">
            <h1>Online Consultations</h1>
            <p>
                Connect with experienced professionals from the comfort of your home.
                Get guidance, expert advice and personalised support with TJ Home Care.
            </p>
        </div>

        <!-- CONSULTATION SERVICES -->
        <div class="consultation-grid">

            <!-- 1. GYNECOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/gynecologist.jpg") %>"
                     alt="Gynecologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Gynecologist Online Consultation</h2>
                    <p>
                        Get guidance on women's health, menstrual health,
                        pregnancy and other gynecological concerns.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=gynecologist") %>">
                        Gynecologist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 2. DERMATOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/dermatologist.jpg") %>"
                     alt="Dermatologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Dermatologist Online Consultation</h2>
                    <p>
                        Get professional guidance for skin, hair and nail
                        concerns and personalised skincare advice.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=Dermatologist") %>">
                        Dermatologist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 3. DIETICIAN -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/dietician.jpg") %>"
                     alt="Dietician Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Dietician Online Consultation</h2>
                    <p>
                        Receive personalised nutrition guidance, healthy
                        eating advice and support for your wellness goals.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=dietician") %>">
                        Dietician Online Consultation
                    </a>
                </div>
            </div>

            <!-- 4. PSYCHOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/Psychologist.jpg") %>"
                     alt="Psychologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Psychologist Online Consultation</h2>
                    <p>
                        Access professional support for stress, anxiety,
                        emotional well-being and everyday life challenges.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=Psychologist") %>">
                        Psychologist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 5. PHYSIOTHERAPIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/Physiotherapist.jpeg") %>"
                     alt="Physiotherapist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Physiotherapist Online Consultation</h2>
                    <p>
                        Get expert guidance for mobility, pain management,
                        rehabilitation and suitable exercise routines.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=Physiotherapist") %>">
                        Physiotherapist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 6. FINANCIAL COUNSELLOR -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/Financial%20Counsellor.jpg") %>"
                     alt="Financial Counsellor Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Financial Counsellor Online Consultation</h2>
                    <p>
                        Get guidance on budgeting, savings, financial planning
                        and managing your financial goals.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=FinancialCounsellor") %>">
                        Financial Counsellor Online Consultation
                    </a>
                </div>
            </div>

            <!-- 7. LEGAL -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Images/legal.jpg") %>"
                     alt="Legal Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Legal Online Consultation</h2>
                    <p>
                        Seek guidance on family matters, documentation,
                        property concerns and other legal issues.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?service=legal") %>">
                        Legal Online Consultation
                    </a>
                </div>
            </div>

        </div>
    </div>

</asp:Content>
