
<%@ Page Title="Privacy Policy | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="PrivacyPolicy.aspx.cs" Inherits="TJHomeCare.PrivacyPolicy" %>

<asp:Content ID="PrivacyPolicyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .tj-privacy-page {
            background: #f7f9fc;
            padding: 45px 16px 60px;
            color: #334155;
            font-family: Arial, Helvetica, sans-serif;
        }

        .tj-privacy-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .tj-privacy-header {
            background: linear-gradient(135deg, #0b3b60, #087e8b);
            color: #ffffff;
            padding: 42px 35px;
            border-radius: 16px 16px 0 0;
        }

        .tj-privacy-header h1 {
            font-size: 34px;
            margin: 0 0 12px;
            color: #ffffff;
            font-weight: 700;
        }

        .tj-privacy-header .tj-tagline {
            font-size: 17px;
            margin: 0 0 18px;
            color: #e0f2fe;
        }

        .tj-privacy-header p {
            margin: 7px 0;
            color: #f1f5f9;
            font-size: 14px;
        }

        .tj-privacy-content {
            background: #ffffff;
            padding: 35px;
            border-radius: 0 0 16px 16px;
            box-shadow: 0 8px 28px rgba(15, 23, 42, 0.07);
        }

        .tj-privacy-intro {
            font-size: 16px;
            line-height: 1.85;
            margin: 0 0 28px;
        }

        .tj-privacy-section {
            margin: 0 0 28px;
            padding-bottom: 22px;
            border-bottom: 1px solid #e5eaf0;
        }

        .tj-privacy-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
        }

        .tj-privacy-section h2 {
            color: #0b5875;
            font-size: 21px;
            margin: 0 0 13px;
            font-weight: 700;
        }

        .tj-privacy-section p {
            font-size: 15px;
            line-height: 1.8;
            margin: 0 0 12px;
        }

        .tj-privacy-section ul {
            margin: 8px 0 0;
            padding-left: 24px;
        }

        .tj-privacy-section li {
            font-size: 15px;
            line-height: 1.8;
            margin-bottom: 7px;
        }

        .tj-privacy-contact {
            background: #f0f9ff;
            border: 1px solid #dbeafe;
            border-left: 4px solid #087e8b;
            padding: 22px;
            border-radius: 8px;
        }

        .tj-privacy-contact p {
            margin-bottom: 8px;
            overflow-wrap: anywhere;
        }

        .tj-privacy-contact strong {
            color: #164e63;
        }

        .tj-privacy-contact a {
            color: #087e8b;
            text-decoration: none;
        }

        .tj-privacy-contact a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .tj-privacy-page {
                padding: 22px 10px 35px;
            }

            .tj-privacy-header {
                padding: 28px 20px;
                border-radius: 12px 12px 0 0;
            }

            .tj-privacy-header h1 {
                font-size: 27px;
            }

            .tj-privacy-header .tj-tagline {
                font-size: 15px;
                line-height: 1.6;
            }

            .tj-privacy-content {
                padding: 22px 18px;
                border-radius: 0 0 12px 12px;
            }

            .tj-privacy-section h2 {
                font-size: 19px;
            }

            .tj-privacy-section p,
            .tj-privacy-section li,
            .tj-privacy-intro {
                font-size: 14px;
                line-height: 1.8;
            }

            .tj-privacy-contact {
                padding: 16px;
            }
        }
    </style>

    <div class="tj-privacy-page">
        <div class="tj-privacy-container">

            <div class="tj-privacy-header">
                <h1>Privacy Policy</h1>
                <p class="tj-tagline">
                    TJ Home Care – Trusted Hands for Every Home
                </p>
                <p><strong>Operated by:</strong> Sunshine Enterprises</p>
                <p><strong>Effective Date:</strong> 19 October 2026</p>
            </div>

            <div class="tj-privacy-content">

                <p class="tj-privacy-intro">
                    TJ Home Care, operated by Sunshine Enterprises, respects
                    the privacy of its customers, service professionals and
                    website visitors. We are committed to protecting personal
                    information collected through our website and service
                    operations.
                </p>

                <section class="tj-privacy-section">
                    <h2>1. Information We Collect</h2>
                    <p>We may collect the following information:</p>
                    <ul>
                        <li>Name, mobile number, email address and residential address.</li>
                        <li>Location and service requirements.</li>
                        <li>Patient care, baby care and home nursing requirements.</li>
                        <li>Health and nutrition information voluntarily provided for consultations.</li>
                        <li>Appointment and booking details.</li>
                        <li>Professional qualifications, experience and identification information of service providers.</li>
                        <li>Payment transaction references and billing details.</li>
                        <li>Website usage information and cookies.</li>
                    </ul>
                </section>

                <section class="tj-privacy-section">
                    <h2>2. Purpose of Information Collection</h2>
                    <p>We use collected information to:</p>
                    <ul>
                        <li>Process customer enquiries and bookings.</li>
                        <li>Connect customers with suitable service professionals.</li>
                        <li>Arrange home care services and online consultations.</li>
                        <li>Coordinate interviews, appointments and service delivery.</li>
                        <li>Process payments and generate invoices.</li>
                        <li>Provide customer support.</li>
                        <li>Improve our services.</li>
                        <li>Comply with applicable legal obligations.</li>
                    </ul>
                </section>

                <section class="tj-privacy-section">
                    <h2>3. Sharing of Information</h2>
                    <p>
                        Relevant personal information may be shared with assigned
                        caregivers, nurses, physiotherapists, dieticians,
                        psychologists, service coordinators and authorised
                        technology partners when necessary to provide requested
                        services.
                    </p>
                    <p>
                        We do not sell personal information to third-party
                        advertisers.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>4. Health Information</h2>
                    <p>
                        Health-related information will be handled with
                        appropriate confidentiality and access controls.
                        We will obtain consent or rely on another lawful basis
                        where required for processing and sharing sensitive
                        information.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>5. Payment Security</h2>
                    <p>
                        Online payments may be processed through Razorpay or
                        other authorised payment gateway providers.
                    </p>
                    <p>
                        TJ Home Care does not intentionally store complete
                        debit card details, credit card numbers, CVV numbers
                        or banking passwords.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>6. Data Security</h2>
                    <p>
                        We implement reasonable security measures to protect
                        information from unauthorised access, misuse or
                        disclosure.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>7. Data Retention and User Rights</h2>
                    <p>
                        Information is retained only as long as necessary for
                        service delivery, business requirements and applicable
                        legal obligations.
                    </p>
                    <p>
                        Users may request correction, access, withdrawal of
                        consent or deletion of personal information, subject
                        to applicable law.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>8. Cookies</h2>
                    <p>
                        Our website may use cookies and similar technologies
                        to improve functionality and understand website usage.
                        Consent will be obtained where required.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>9. Changes to Privacy Policy</h2>
                    <p>
                        We may update this policy periodically. Any changes
                        will be published on this website.
                    </p>
                </section>

                <section class="tj-privacy-section">
                    <h2>10. Contact Information</h2>

                    <div class="tj-privacy-contact">
                        <p><strong>Business Name:</strong> TJ Home Care</p>
                        <p><strong>Operated by:</strong> Sunshine Enterprises</p>

                        <p>
                            <strong>Website:</strong>
                            <a href="https://www.tjhomecare.com"
                               target="_blank" rel="noopener noreferrer">
                                www.tjhomecare.com
                            </a>
                        </p>

                        <p>
                            <strong>Email:</strong>
                            <a href="mailto:care@tjhomecare.com">
                                care@tjhomecare.com
                            </a>
                        </p>

                        <p>
                            <strong>Phone / WhatsApp:</strong>
                            <a href="https://wa.me/919429693689"
                               target="_blank" rel="noopener noreferrer">
                                +91 9429693689
                            </a>
                        </p>

                        <p><strong>Registered Address:</strong></p>
                        <p>
                            Room No. 7 &amp; 8, Sai Krupa Complex, First Floor,<br />
                            D.No. 10-1-12, Ward No. 11,<br />
                            Railway Road, Kavali - 524201,<br />
                            SPSR Nellore District, Andhra Pradesh.
                        </p>

                        <p>
                            <strong>Registered Phone:</strong>
                            <a href="tel:+919059724821">
                                +91 9059724821
                            </a>
                        </p>

                        <p>
                            <strong>GST:</strong> 37ARRPM1229P3Z0
                        </p>
                    </div>
                </section>

            </div>
        </div>
    </div>

</asp:Content>
