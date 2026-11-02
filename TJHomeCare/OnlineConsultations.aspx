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
        .consultation-how-it-works {
    max-width: 1100px;
    margin: 25px auto 35px;
    padding: 22px 25px;
    background: #f8fbff;
    border: 1px solid #e2eaf3;
    border-radius: 12px;
    line-height: 1.7;
}

.consultation-how-it-works h3 {
    color: #174a7c;
    font-size: 21px;
    font-weight: 700;
    margin-bottom: 18px;
}

.consultation-how-it-works ol {
    padding-left: 23px;
    margin-bottom: 0;
}

.consultation-how-it-works li {
    margin-bottom: 12px;
    color: #444;
}

.consultation-how-it-works li strong {
    color: #174a7c;
}

@media (max-width: 576px) {
    .consultation-how-it-works {
        padding: 16px;
        margin: 18px 10px;
    }

    .consultation-how-it-works h3 {
        font-size: 18px;
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
       
<!-- How Online Consultations Work -->
<div class="consultation-how-it-works">

    <h3>How Online Consultations Work</h3>

    <ol>
        <li>
            <strong>Choose Consultation:</strong>
            Select your required consultation category, including Doctors,
            Dietitians, Psychologists, Physiotherapists, Legal Consultants
            and Financial Counsellors.
        </li>

        <li>
            <strong>Book Consultation:</strong>
            Enter your details and preferred appointment date and time.
        </li>

        <li>
            <strong>Pay Online:</strong>
            Complete your consultation payment securely.
        </li>

        <li>
            <strong>Professional Assignment:</strong>
            TJ Home Care assigns a qualified, available professional
            based on your requirements.
        </li>

        <li>
            <strong>Booking Confirmation:</strong>
            Receive your booking details via WhatsApp or email.
            Our team will call you to coordinate a convenient appointment
            time, share your consultation link and assist you throughout
            the online consultation process.
        </li>

        <li>
            <strong>Consult Online:</strong>
            Connect with your assigned professional and receive expert
            guidance and recommendations. For doctor consultations,
            receive a digital prescription whenever medically appropriate.
        </li>
    </ol>

</div>
        <!-- CONSULTATION SERVICES -->
        <div class="consultation-grid">

            <!-- 1. GYNECOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/gynecologist3.png") %>"
                     alt="Gynecologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Gynecologist Online Consultation</h2>
                    <p>
                        Get guidance on women's health, menstrual health,
                        pregnancy and other gynecological concerns.
                    </p>
                    <a class="consultation-btn"
                      href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=11") %>">
                        Gynecologist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 2. DERMATOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/dermo.jpeg") %>"
                     alt="Dermatologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Dermatologist Online Consultation</h2>
                    <p>
                        Get professional guidance for skin, hair and nail
                        concerns and personalised skincare advice.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=12") %>">
                        Dermatologist Online Consultation
                    </a>
                </div>
            </div>

           
<div class="consultation-card">
    <img class="consultation-image"
         src="<%= ResolveUrl("~/Consultation/sexual_1200x675.jpg") %>"
         alt="Sexual Health and Wellness Online Doctor Consultation" />

    <div class="consultation-card-content">
        <h2>Sexual Health &amp; Wellness – Online Doctor Consultation</h2>

        <p>
            Consult a qualified doctor online for confidential guidance
            on sexual health, reproductive wellness, intimacy-related
            concerns and general sexual well-being in a safe,
            respectful and private environment.
        </p>

        <a class="consultation-btn"
           href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=18") %>">
            Book Online Consultation
            <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>
</div>


            <!-- 3. DIETICIAN -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/dietician_1200x675.jpg") %>"
                     alt="Dietician Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Dietician Online Consultation</h2>
                    <p>
                        Receive personalised nutrition guidance, healthy
                        eating advice and support for your wellness goals.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=9") %>">
                        Dietician Online Consultation
                    </a>
                </div>
            </div>

            <!-- 4. PSYCHOLOGIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/psycologist_1200x675.jpg") %>"
                     alt="Psychologist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Psychologist Online Consultation</h2>
                    <p>
                        Access professional support for stress, anxiety,
                        emotional well-being and everyday life challenges.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=14") %>">
                        Psychologist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 5. PHYSIOTHERAPIST -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/Physiotherapist_1200x675.jpg") %>"
                     alt="Physiotherapist Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Physiotherapist Online Consultation</h2>
                    <p>
                        Get expert guidance for mobility, pain management,
                        rehabilitation and suitable exercise routines.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=15") %>">
                        Physiotherapist Online Consultation
                    </a>
                </div>
            </div>

            <!-- 6. FINANCIAL COUNSELLOR -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/FinancialCounsellor.jpg_1200x675.jpg") %>"
                     alt="Financial Counsellor Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Financial Counsellor Online Consultation</h2>
                    <p>
                        Get guidance on budgeting, savings, financial planning
                        and managing your financial goals.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=16") %>">
                        Financial Counsellor Online Consultation
                    </a>
                </div>
            </div>

            <!-- 7. LEGAL -->
            <div class="consultation-card">
                <img class="consultation-image"
                     src="<%= ResolveUrl("~/Consultation/Legal_1200x675.jpg") %>"
                     alt="Legal Online Consultation" />

                <div class="consultation-card-content">
                    <h2>Legal Online Consultation</h2>
                    <p>
                        Seek guidance on family matters, documentation,
                        property concerns and other legal issues.
                    </p>
                    <a class="consultation-btn"
                       href="<%= ResolveUrl("~/BookConsultation.aspx?serviceId=17") %>">
                        Legal Online Consultation
                    </a>
                </div>
            </div>

        </div>
    </div>

</asp:Content>
