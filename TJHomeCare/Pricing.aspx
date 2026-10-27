<%@ Page Title="Pricing & Service Charges"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="Pricing.aspx.cs"
    Inherits="TJHomeCare.Pricing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Pricing & Service Charges | TJ Home Care
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .pricing-page {
        font-family: Arial, Helvetica, sans-serif;
        color: #263445;
        background: #f7f9fc;
        padding-bottom: 55px;
        line-height: 1.7;
    }

    .pricing-page * {
        box-sizing: border-box;
    }

    .pricing-container {
        width: 100%;
        max-width: 1180px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .pricing-hero {
        background: linear-gradient(135deg, #073b4c, #087e8b);
        color: #ffffff;
        padding: 65px 20px 60px;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .pricing-hero .hero-label {
        display: inline-block;
        padding: 7px 18px;
        border: 1px solid rgba(255,255,255,.45);
        border-radius: 30px;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 1px;
        text-transform: uppercase;
        margin-bottom: 18px;
    }

    .pricing-hero h1 {
        color: #ffffff;
        font-size: 40px;
        font-weight: 800;
        margin: 0 0 12px;
        line-height: 1.25;
    }

    .pricing-hero .hero-subtitle {
        color: #d8f3f4;
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 18px;
    }

    .pricing-hero .hero-description {
        max-width: 760px;
        margin: 0 auto;
        color: #f0ffff;
        font-size: 15px;
    }

    .pricing-notice {
        background: #e7f7f5;
        border: 1px solid #b9e6df;
        border-radius: 12px;
        padding: 17px 20px;
        margin: 28px auto 35px;
        color: #175b55;
        display: flex;
        align-items: flex-start;
        gap: 12px;
    }

    .pricing-notice i {
        font-size: 22px;
        margin-top: 3px;
    }

    .pricing-notice p {
        margin: 0;
    }

    .pricing-section {
        margin-bottom: 32px;
        background: #ffffff;
        border: 1px solid #e7edf3;
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 5px 20px rgba(20, 50, 70, .045);
        scroll-margin-top: 100px;
    }

    .pricing-section-header {
        display: flex;
        align-items: flex-start;
        gap: 15px;
        margin-bottom: 23px;
    }

    .pricing-section-icon {
        width: 52px;
        height: 52px;
        flex: 0 0 52px;
        border-radius: 14px;
        background: #e5f5f5;
        color: #087e8b;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 23px;
    }

    .pricing-section-header h2 {
        color: #123b50;
        font-size: 25px;
        font-weight: 800;
        margin: 0 0 5px;
        line-height: 1.35;
    }

    .pricing-section-header p {
        color: #667788;
        margin: 0;
        font-size: 14px;
    }

    .pricing-table-wrap {
        width: 100%;
        overflow-x: auto;
        border: 1px solid #e4ebf1;
        border-radius: 10px;
    }

    .pricing-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 430px;
        margin: 0;
    }

    .pricing-table th {
        background: #edf6f8;
        color: #17475a;
        text-align: left;
        padding: 15px 18px;
        font-size: 14px;
        font-weight: 800;
        border-bottom: 1px solid #dce8ed;
    }

    .pricing-table td {
        padding: 16px 18px;
        border-bottom: 1px solid #edf1f5;
        font-size: 14px;
        vertical-align: middle;
    }

    .pricing-table tr:last-child td {
        border-bottom: none;
    }

    .pricing-table tbody tr:hover {
        background: #f8fcfd;
    }

    .pricing-service {
        color: #243d50;
        font-weight: 700;
    }

    .pricing-amount {
        color: #087e8b;
        font-weight: 800;
        white-space: nowrap;
    }

    .pricing-gst-note {
        color: #718092;
        font-size: 12px;
        font-weight: 400;
        display: block;
        margin-top: 3px;
    }

    .pricing-subheading {
        color: #17475a;
        font-size: 18px;
        font-weight: 800;
        margin: 26px 0 12px;
    }

    .pricing-list {
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .pricing-list li {
        position: relative;
        padding: 7px 0 7px 29px;
        color: #536475;
        font-size: 14px;
    }

    .pricing-list li:before {
        content: "\f00c";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        position: absolute;
        left: 0;
        top: 10px;
        color: #0a9b84;
        font-size: 13px;
    }

    .pricing-info-box {
        margin-top: 22px;
        background: #f0f8ff;
        border: 1px solid #d7e9f8;
        border-left: 4px solid #087e8b;
        border-radius: 8px;
        padding: 17px 19px;
        color: #38546a;
        font-size: 14px;
    }

    .pricing-info-box strong {
        color: #17475a;
    }

    .pricing-calculation {
        background: linear-gradient(135deg, #f0fafa, #f4f8ff);
        border: 1px solid #d6e9ed;
        border-radius: 12px;
        padding: 23px;
        margin-top: 22px;
    }

    .pricing-calculation h3 {
        color: #17475a;
        font-size: 19px;
        font-weight: 800;
        margin: 0 0 8px;
    }

    .pricing-calculation > p {
        color: #607487;
        font-size: 14px;
        margin: 0 0 17px;
    }

    .calculation-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
    }

    .calculation-item {
        background: #ffffff;
        border: 1px solid #e0eaef;
        border-radius: 10px;
        padding: 16px;
    }

    .calculation-item span {
        display: block;
        color: #6a7b8b;
        font-size: 12px;
        margin-bottom: 5px;
    }

    .calculation-item strong {
        display: block;
        color: #087e8b;
        font-size: 21px;
        font-weight: 800;
    }

    .calculation-item small {
        display: block;
        margin-top: 4px;
        color: #82909d;
        font-size: 11px;
    }

    .replacement-banner {
        background: linear-gradient(135deg, #eaf9f4, #f3fbf8);
        border: 1px solid #ccebdd;
        border-radius: 12px;
        padding: 22px;
        display: flex;
        align-items: center;
        gap: 16px;
        margin-bottom: 22px;
    }

    .replacement-icon {
        width: 58px;
        height: 58px;
        min-width: 58px;
        border-radius: 50%;
        background: #d0f2e3;
        color: #13845b;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
    }

    .replacement-banner h3 {
        margin: 0 0 5px;
        color: #176447;
        font-size: 21px;
        font-weight: 800;
    }

    .replacement-banner p {
        margin: 0;
        color: #527467;
        font-size: 14px;
    }

    .policy-list {
        counter-reset: policy;
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .policy-list li {
        counter-increment: policy;
        position: relative;
        padding: 12px 0 12px 47px;
        border-bottom: 1px solid #edf1f5;
        color: #536475;
        font-size: 14px;
    }

    .policy-list li:last-child {
        border-bottom: none;
    }

    .policy-list li:before {
        content: counter(policy);
        position: absolute;
        left: 0;
        top: 10px;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background: #e7f5f6;
        color: #087e8b;
        font-size: 13px;
        font-weight: 800;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .pricing-two-column {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 22px;
    }

    .pricing-policy-card {
        background: #f8fafc;
        border: 1px solid #e7edf3;
        border-radius: 12px;
        padding: 22px;
    }

    .pricing-policy-card h3 {
        color: #17475a;
        font-size: 18px;
        font-weight: 800;
        margin: 0 0 13px;
    }

    .pricing-policy-card .pricing-list li {
        font-size: 13px;
    }

    .pricing-contact {
        background: linear-gradient(135deg, #073b4c, #087e8b);
        color: #ffffff;
        border-radius: 18px;
        padding: 38px 30px;
        text-align: center;
        margin-top: 10px;
    }

    .pricing-contact h2 {
        color: #ffffff;
        font-size: 28px;
        font-weight: 800;
        margin: 0 0 10px;
    }

    .pricing-contact > p {
        color: #e0f5f5;
        font-size: 14px;
        max-width: 650px;
        margin: 0 auto 22px;
    }

    .pricing-contact-details {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px 24px;
        margin-bottom: 24px;
    }

    .pricing-contact-details a {
        color: #ffffff;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        overflow-wrap: anywhere;
    }

    .pricing-contact-details a:hover {
        text-decoration: underline;
    }

    .pricing-contact-details i {
        margin-right: 7px;
        color: #a9f2df;
    }

    .pricing-contact-buttons {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 12px;
    }

    .pricing-contact-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 12px 23px;
        border-radius: 8px;
        background: #ffffff;
        color: #07576a !important;
        text-decoration: none !important;
        font-weight: 800;
        font-size: 14px;
        transition: .2s ease;
    }

    .pricing-contact-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0,0,0,.15);
    }

    .pricing-contact-btn.whatsapp {
        background: #25d366;
        color: #ffffff !important;
    }

    .pricing-footer-note {
        text-align: center;
        color: #7a8997;
        font-size: 12px;
        margin: 24px 0 0;
    }

    .pricing-last-updated {
        display: inline-block;
        margin-top: 8px;
        color: #607487;
        font-weight: 700;
    }

    @media (max-width: 768px) {
        .pricing-hero {
            padding: 45px 17px;
        }

        .pricing-hero h1 {
            font-size: 30px;
        }

        .pricing-hero .hero-subtitle {
            font-size: 15px;
        }

        .pricing-container {
            padding: 0 13px;
        }

        .pricing-section {
            padding: 21px 16px;
            margin-bottom: 20px;
            border-radius: 13px;
        }

        .pricing-section-header {
            gap: 11px;
        }

        .pricing-section-icon {
            width: 43px;
            height: 43px;
            flex-basis: 43px;
            font-size: 19px;
            border-radius: 11px;
        }

        .pricing-section-header h2 {
            font-size: 20px;
        }

        .pricing-section-header p {
            font-size: 13px;
        }

        .pricing-table th,
        .pricing-table td {
            padding: 13px 12px;
            font-size: 13px;
        }

        .calculation-grid {
            grid-template-columns: 1fr;
        }

        .calculation-item {
            padding: 14px;
        }

        .calculation-item strong {
            font-size: 20px;
        }

        .pricing-two-column {
            grid-template-columns: 1fr;
            gap: 15px;
        }

        .replacement-banner {
            align-items: flex-start;
            padding: 17px;
        }

        .replacement-icon {
            width: 45px;
            height: 45px;
            min-width: 45px;
            font-size: 20px;
        }

        .replacement-banner h3 {
            font-size: 18px;
        }

        .pricing-contact {
            padding: 30px 18px;
            border-radius: 13px;
        }

        .pricing-contact h2 {
            font-size: 23px;
        }

        .pricing-contact-buttons {
            flex-direction: column;
        }

        .pricing-contact-btn {
            width: 100%;
        }

        .pricing-contact-details {
            flex-direction: column;
            gap: 12px;
        }
    }

    @media (max-width: 400px) {
        .pricing-hero h1 {
            font-size: 26px;
        }

        .pricing-section-header h2 {
            font-size: 18px;
        }

        .pricing-section {
            padding: 17px 12px;
        }

        .pricing-notice {
            padding: 14px;
        }
    }
</style>

<div class="pricing-page">

    <!-- HERO SECTION -->
    <section class="pricing-hero">
        <div class="pricing-container">
            <span class="hero-label">TJ HOME CARE</span>

            <h1>Pricing &amp; Service Charges</h1>

            <p class="hero-subtitle">
                Transparent Pricing. Trusted Services. Professional Support.
            </p>

            <p class="hero-description">
                At TJ Home Care, we believe in clear, affordable and transparent
                pricing. We offer online professional consultations and home
                care staffing solutions to help individuals and families access
                the services they need.
            </p>
        </div>
    </section>

    <div class="pricing-container">

        <div class="pricing-notice">
            <i class="fa-solid fa-circle-info"></i>
            <p>
                <strong>Our pricing commitment:</strong>
                All applicable service charges and taxes are communicated to
                customers before payment confirmation. Prices listed below
                are exclusive of GST unless otherwise specified.
            </p>
        </div>

        <!-- SECTION 1: ONLINE CONSULTATIONS -->
        <section class="pricing-section" id="consultations">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-video"></i>
                </div>

                <div>
                    <h2>1. Online Consultation Services</h2>
                    <p>
                        Connect with qualified professionals through convenient
                        online appointments.
                    </p>
                </div>
            </div>

            <div class="pricing-table-wrap">
                <table class="pricing-table">
                    <thead>
                        <tr>
                            <th>Service</th>
                            <th>Consultation Fee</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td class="pricing-service">
                                <i class="fa-solid fa-user-doctor"></i>
                                Doctor Consultation
                            </td>
                            <td class="pricing-amount">
                                ₹999 + GST
                                <span class="pricing-gst-note">Per session</span>
                            </td>
                        </tr>

                        <tr>
                            <td class="pricing-service">
                                <i class="fa-solid fa-apple-whole"></i>
                                Dietitian Consultation
                            </td>
                            <td class="pricing-amount">
                                ₹499 + GST
                                <span class="pricing-gst-note">Per session</span>
                            </td>
                        </tr>

                        <tr>
                            <td class="pricing-service">
                                <i class="fa-solid fa-brain"></i>
                                Psychologist Consultation
                            </td>
                            <td class="pricing-amount">
                                ₹699 + GST
                                <span class="pricing-gst-note">Per session</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3 class="pricing-subheading">Important Information</h3>

            <ul class="pricing-list">
                <li>Consultation fees are charged per booked session.</li>
                <li>
                    Consultations are conducted online through video or other
                    agreed communication channels.
                </li>
                <li>
                    Appointment availability is subject to professional
                    confirmation.
                </li>
                <li>
                    Consultation duration and scope will be communicated
                    before booking.
                </li>
                <li>
                    Medicines, laboratory tests, additional consultations,
                    personalised diet plans, reports and other services,
                    where applicable, are charged separately.
                </li>
                <li>
                    Online consultations are not intended for medical
                    emergencies.
                </li>
            </ul>

        </section>

        <!-- SECTION 2: HOME CARE PLACEMENTS -->
        <section class="pricing-section" id="placements">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-house-chimney-user"></i>
                </div>

                <div>
                    <h2>2. Home Care Placement Services</h2>
                    <p>
                        Assistance in identifying and hiring suitable domestic
                        and home care personnel for your family.
                    </p>
                </div>
            </div>

            <div class="pricing-table-wrap">
                <table class="pricing-table">
                    <thead>
                        <tr>
                            <th>Placement Service</th>
                            <th>One-Time Placement Fee</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td class="pricing-service">Maid Placement</td>
                            <td class="pricing-amount">₹3,999 + GST</td>
                        </tr>

                        <tr>
                            <td class="pricing-service">Driver Placement</td>
                            <td class="pricing-amount">₹4,999 + GST</td>
                        </tr>

                        <tr>
                            <td class="pricing-service">Baby Caretaker Placement</td>
                            <td class="pricing-amount">₹4,999 + GST</td>
                        </tr>

                        <tr>
                            <td class="pricing-service">Patient Caretaker Placement</td>
                            <td class="pricing-amount">
                                15 Days' Agreed Salary + GST
                            </td>
                        </tr>

                        <tr>
                            <td class="pricing-service">Home Nurse Placement</td>
                            <td class="pricing-amount">
                                15 Days' Agreed Salary + GST
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3 class="pricing-subheading">
                What Our Placement Service Includes
            </h3>

            <ul class="pricing-list">
                <li>Understanding customer staffing requirements.</li>
                <li>Identifying and shortlisting suitable candidates.</li>
                <li>Coordinating candidate profiles and interviews.</li>
                <li>Facilitating salary and duty discussions.</li>
                <li>Assisting with candidate joining arrangements.</li>
                <li>
                    Replacement assistance under the applicable replacement
                    policy.
                </li>
            </ul>

            <div class="pricing-info-box">
                <strong>
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                    Employee Salary:
                </strong>
                The caregiver's or employee's agreed salary is separate from
                TJ Home Care's placement charges. Unless otherwise agreed in
                writing, the customer pays the salary directly to the
                selected employee.
            </div>

            <div class="pricing-calculation">

                <h3>
                    <i class="fa-solid fa-calculator"></i>
                    Placement Fee Calculation
                </h3>

                <p>
                    For Patient Caretaker and Home Nurse placements, the
                    placement fee is calculated as 50% of the agreed monthly
                    salary, assuming a 30-day salary month.
                </p>

                <p>
                    <strong>Example: Agreed monthly salary of ₹30,000</strong>
                </p>

                <div class="calculation-grid">

                    <div class="calculation-item">
                        <span>One-Time Placement Fee</span>
                        <strong>₹15,000</strong>
                        <small>50% of monthly salary</small>
                    </div>

                    <div class="calculation-item">
                        <span>GST</span>
                        <strong>Additional</strong>
                        <small>At the applicable rate</small>
                    </div>

                    <div class="calculation-item">
                        <span>Employee's Monthly Salary</span>
                        <strong>₹30,000</strong>
                        <small>Payable separately</small>
                    </div>

                </div>

            </div>

        </section>

        <!-- SECTION 3: REPLACEMENT POLICY -->
        <section class="pricing-section" id="replacement">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-arrows-rotate"></i>
                </div>

                <div>
                    <h2>3. 30-Day Replacement Policy</h2>
                    <p>
                        Our replacement assistance is designed to help families
                        find a suitable alternative when needed.
                    </p>
                </div>
            </div>

            <div class="replacement-banner">
                <div class="replacement-icon">
                    <i class="fa-solid fa-shield-heart"></i>
                </div>

                <div>
                    <h3>One Free Replacement Within 30 Days</h3>
                    <p>
                        One replacement candidate without an additional
                        placement fee, subject to the terms below.
                    </p>
                </div>
            </div>

            <ol class="policy-list">
                <li>
                    The replacement benefit applies when the placed employee
                    voluntarily leaves employment or is found unsuitable for
                    the agreed role during the first 30 days.
                </li>

                <li>
                    Customers must inform TJ Home Care within the
                    30-day replacement period.
                </li>

                <li>
                    One replacement candidate will be arranged without
                    charging an additional placement fee.
                </li>

                <li>
                    Replacement is subject to candidate availability,
                    location, salary expectations and the original job
                    requirements.
                </li>

                <li>
                    Changes in job location, duties, working hours or salary
                    may require revised placement charges.
                </li>

                <li>
                    The replacement benefit is available once per completed
                    and paid placement.
                </li>

                <li>
                    The 30-day period is calculated from the original joining
                    date and does not restart when a replacement joins.
                </li>
            </ol>

            <div class="pricing-info-box">
                <strong>Important:</strong>
                TJ Home Care will make reasonable efforts to identify a
                suitable replacement but does not guarantee immediate
                availability or a specific joining date.
            </div>

        </section>

        <!-- SECTION 4: PAYMENT TERMS -->
        <section class="pricing-section" id="payment">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-credit-card"></i>
                </div>

                <div>
                    <h2>4. Payment Terms</h2>
                    <p>
                        Clear payment conditions for consultations and
                        home care placement services.
                    </p>
                </div>
            </div>

            <div class="pricing-two-column">

                <div class="pricing-policy-card">
                    <h3>
                        <i class="fa-solid fa-video"></i>
                        Online Consultations
                    </h3>

                    <ul class="pricing-list">
                        <li>
                            Consultation fees must be paid in advance to
                            confirm an appointment.
                        </li>

                        <li>
                            Customers can pay using the payment options
                            made available through our authorised
                            payment gateway.
                        </li>

                        <li>
                            Booking confirmation will be provided after
                            successful payment and appointment confirmation.
                        </li>
                    </ul>
                </div>

                <div class="pricing-policy-card">
                    <h3>
                        <i class="fa-solid fa-user-check"></i>
                        Home Care Placements
                    </h3>

                    <ul class="pricing-list">
                        <li>
                            Placement charges become payable upon successful
                            candidate joining, unless otherwise agreed
                            in writing.
                        </li>

                        <li>
                            The applicable placement fee and taxes will be
                            communicated before payment.
                        </li>

                        <li>
                            Payments must be made through TJ Home Care's
                            authorised payment channels.
                        </li>

                        <li>
                            A payment receipt or applicable tax invoice
                            will be provided.
                        </li>
                    </ul>
                </div>

            </div>

        </section>

        <!-- SECTION 5: CANCELLATION AND REFUND -->
        <section class="pricing-section" id="refund">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-rotate-left"></i>
                </div>

                <div>
                    <h2>5. Cancellation &amp; Refund Policy</h2>
                    <p>
                        Our cancellation and refund terms for consultations
                        and placement services.
                    </p>
                </div>
            </div>

            <div class="pricing-two-column">

                <div class="pricing-policy-card">
                    <h3>Online Consultations</h3>

                    <ul class="pricing-list">
                        <li>
                            Customers may request cancellation or rescheduling
                            before the scheduled consultation.
                        </li>

                        <li>
                            Requests received at least 24 hours before the
                            appointment are eligible for rescheduling or
                            a refund.
                        </li>

                        <li>
                            Cancellations within 24 hours of the scheduled
                            appointment may not qualify for a refund.
                        </li>

                        <li>
                            If the assigned professional is unavailable and
                            an alternative appointment cannot be agreed upon,
                            the consultation fee will be refunded.
                        </li>

                        <li>
                            Once a consultation has been completed, the fee
                            is generally non-refundable.
                        </li>
                    </ul>
                </div>

                <div class="pricing-policy-card">
                    <h3>Home Care Placement Services</h3>

                    <ul class="pricing-list">
                        <li>
                            No placement fee is payable if no candidate joins,
                            unless a separate advance service charge has been
                            expressly agreed.
                        </li>

                        <li>
                            Once a candidate has successfully joined, the
                            placement fee is generally non-refundable.
                        </li>

                        <li>
                            Eligible early departures or suitability issues
                            will be handled through the 30-day replacement
                            policy.
                        </li>

                        <li>
                            Where TJ Home Care is unable to provide an agreed
                            paid service, applicable refunds will be reviewed
                            according to the circumstances and applicable law.
                        </li>
                    </ul>
                </div>

            </div>

            <div class="pricing-info-box">
                <strong>
                    <i class="fa-solid fa-clock"></i>
                    Refund Processing:
                </strong>
                Approved refunds will normally be initiated to the original
                payment method within 7 working days. Final credit timelines
                depend on the bank or payment provider.
            </div>

            <p style="color:#607487;font-size:13px;margin:18px 0 0;">
                Nothing in this policy limits customers' rights under
                applicable consumer protection laws.
            </p>

        </section>

        <!-- SECTION 6: GST -->
        <section class="pricing-section" id="taxes">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>

                <div>
                    <h2>6. GST &amp; Taxes</h2>
                    <p>
                        Tax information and applicable charges.
                    </p>
                </div>
            </div>

            <ul class="pricing-list">
                <li>All prices listed above are exclusive of GST.</li>

                <li>
                    GST will be charged at the applicable rate based on the
                    service classification and prevailing tax regulations.
                </li>

                <li>
                    The total payable amount, including applicable taxes,
                    will be displayed or communicated before payment.
                </li>

                <li>Tax invoices will be issued where applicable.</li>
            </ul>

        </section>

        <!-- SECTION 7: GENERAL TERMS -->
        <section class="pricing-section" id="terms">

            <div class="pricing-section-header">
                <div class="pricing-section-icon">
                    <i class="fa-solid fa-scale-balanced"></i>
                </div>

                <div>
                    <h2>7. General Terms &amp; Conditions</h2>
                    <p>
                        Important information about our services and
                        customer responsibilities.
                    </p>
                </div>
            </div>

            <ul class="pricing-list">
                <li>
                    TJ Home Care acts as a service facilitator for professional
                    consultations and home care staffing arrangements.
                </li>

                <li>
                    Home care placement services are subject to candidate
                    availability and customer requirements.
                </li>

                <li>
                    Customers are responsible for agreeing on salaries,
                    working hours, weekly offs, accommodation and other
                    employment conditions with the selected candidate.
                </li>

                <li>
                    Customers should independently satisfy themselves
                    regarding candidate suitability. Any background
                    verification offered by TJ Home Care will be
                    clearly communicated.
                </li>

                <li>
                    Professional consultations are provided by the respective
                    qualified professionals within their authorised scope
                    of practice.
                </li>

                <li>
                    TJ Home Care reserves the right to revise service prices
                    for future bookings. Confirmed bookings and paid orders
                    will remain subject to their agreed terms, except where
                    otherwise required by law.
                </li>
            </ul>

        </section>

        <!-- SECTION 8: CONTACT -->
        <section class="pricing-contact" id="contact">

            <h2>8. Contact &amp; Customer Support</h2>

            <p>
                Need help with bookings, service charges, payments,
                cancellations, refunds or replacement requests?
                Our support team is here to assist you.
            </p>

            <div class="pricing-contact-details">

                <a href="https://www.tjhomecare.com">
                    <i class="fa-solid fa-globe"></i>
                    www.tjhomecare.com
                </a>

                <a href="mailto:care@tjhomecare.com">
                    <i class="fa-solid fa-envelope"></i>
                    care@tjhomecare.com
                </a>

                <a href="tel:+919429693689">
                    <i class="fa-solid fa-phone"></i>
                    +91 94296 93689
                </a>

            </div>

            <div class="pricing-contact-buttons">

                <a class="pricing-contact-btn"
                   href="mailto:care@tjhomecare.com">
                    <i class="fa-solid fa-envelope"></i>
                    Email Us
                </a>

                <a class="pricing-contact-btn whatsapp"
                   href="https://wa.me/919429693689"
                   target="_blank"
                   rel="noopener noreferrer">
                    <i class="fa-brands fa-whatsapp"></i>
                    Chat on WhatsApp
                </a>

                <a class="pricing-contact-btn"
                   href="tel:+919429693689">
                    <i class="fa-solid fa-phone"></i>
                    Call Us
                </a>

            </div>

            <p style="margin:22px auto 0;font-size:13px;">
                <strong>Service Locations:</strong>
                Bangalore &amp; Hyderabad for home care placements.
                Online consultations are available across India, subject
                to professional availability and applicable regulations.
            </p>

        </section>

        <div class="pricing-footer-note">
            <span class="pricing-last-updated">
                Last Updated: 24 October 2026
            </span>

            <p>
                <strong>
                    TJ Home Care — Caring for Your Family,
                    Connecting You with Trusted Support.
                </strong>
            </p>
        </div>

    </div>

</div>

</asp:Content>