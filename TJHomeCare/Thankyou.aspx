<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Thankyou.aspx.cs" Inherits="TJHomeCare.Thankyou" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style>
    .thankyou-page {
        min-height: 85vh;
        padding: 60px 20px;
        background: linear-gradient(135deg, #f4f8ff, #eef7f5);
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .thankyou-card {
        width: 100%;
        max-width: 650px;
        background: #ffffff;
        border-radius: 24px;
        padding: 55px 45px;
        text-align: center;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
    }

    .success-icon {
        width: 85px;
        height: 85px;
        margin: 0 auto 25px;
        border-radius: 50%;
        background: linear-gradient(135deg, #0b5ed7, #084298);
        color: #ffffff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 42px;
        font-weight: bold;
        box-shadow: 0 12px 30px rgba(11, 94, 215, 0.25);
    }

    .thankyou-card h1 {
        margin: 0 0 15px;
        color: #1d2939;
        font-size: 36px;
        font-weight: 700;
    }

    .thankyou-card p {
        color: #667085;
        font-size: 16px;
        line-height: 1.7;
        margin: 0 auto 30px;
        max-width: 500px;
    }

    .review-message {
        background: #f8fafc;
        border: 1px solid #eaecf0;
        border-radius: 14px;
        padding: 20px;
        margin-bottom: 30px;
        color: #475467;
        font-size: 14px;
    }

    .review-message strong {
        color: #0b5ed7;
    }

    .back-btn {
        display: inline-block;
        padding: 13px 28px;
        border-radius: 10px;
        background: linear-gradient(135deg, #0b5ed7, #084298);
        color: #ffffff !important;
        text-decoration: none;
        font-size: 15px;
        font-weight: 600;
        box-shadow: 0 8px 20px rgba(11, 94, 215, 0.22);
        transition: all 0.3s ease;
    }

    .back-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 25px rgba(11, 94, 215, 0.30);
        text-decoration: none;
    }

    .small-note {
        margin-top: 20px;
        color: #98a2b3;
        font-size: 12px;
    }

    @media (max-width: 600px) {

        .thankyou-page {
            padding: 30px 15px;
        }

        .thankyou-card {
            padding: 40px 25px;
        }

        .thankyou-card h1 {
            font-size: 29px;
        }

        .success-icon {
            width: 75px;
            height: 75px;
            font-size: 36px;
        }
    }
</style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<section class="thankyou-page">

        <div class="thankyou-card">

            <div class="success-icon">
                ✓
            </div>

            <h1>Thank You for Your Review!</h1>

            <p>
                We truly appreciate you taking the time to share your
                experience with us.
            </p>

            <div class="review-message">
                Your feedback is valuable to us and helps us
                <strong>improve our service</strong>
                and serve you better.
            </div>

            <a href="Review.aspx" class="back-btn">
                Submit Another Review
            </a>

            <div class="small-note">
                Thank you for choosing our service.
            </div>

        </div>

    </section>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Thank You
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">

<style>

    /* ==============================
       PAGE
       ============================== */

    .thankyou-page {
        min-height: 85vh;
        padding: 60px 20px;
       background: linear-gradient(135deg, #f2fbfa, #ffffff);
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Open Sans', Arial, sans-serif;
    }


    /* ==============================
       CARD
       ============================== */

    .thankyou-card {
        width: 100%;
        max-width: 680px;
        background: #ffffff;
        border-radius: 26px;
        padding: 60px 50px;
        text-align: center;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
        position: relative;
        overflow: hidden;
        border: 1px solid #dce9e7;
    }

    .thankyou-card:before {
        content: "";
        position: absolute;
        width: 180px;
        height: 180px;
        border-radius: 50%;
       background: rgba(23, 123, 120, 0.05);
        top: -90px;
        right: -70px;
    }

    .thankyou-card:after {
        content: "";
        position: absolute;
        width: 150px;
        height: 150px;
        border-radius: 50%;
        background: rgba(16, 185, 129, 0.04);
        bottom: -80px;
        left: -60px;
    }


    /* ==============================
       SUCCESS ICON
       ============================== */

    .success-icon {
        width: 88px;
        height: 88px;
        margin: 0 auto 28px;
        border-radius: 50%;
        background: linear-gradient(135deg, #177b78, #105d5b);
        color: #ffffff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 42px;
        font-weight: 700;
        box-shadow: 0 12px 30px rgba(23, 123, 120, 0.25);
        position: relative;
        z-index: 1;
        animation: successPop 0.5s ease-out;
    }

    @keyframes successPop {

        0% {
            transform: scale(0.7);
            opacity: 0;
        }

        100% {
            transform: scale(1);
            opacity: 1;
        }
    }


    /* ==============================
       HEADING
       ============================== */

    .thankyou-card h1 {
        margin: 0 0 14px;
       color: #24343b;
        font-size: 36px;
        line-height: 1.25;
        font-weight: 700;
        letter-spacing: -0.5px;
        position: relative;
        z-index: 1;
    }

    .thankyou-card > p {
        color: #667085;
        font-size: 16px;
        line-height: 1.7;
        margin: 0 auto 28px;
        max-width: 520px;
        position: relative;
        z-index: 1;
    }


    /* ==============================
       MESSAGE BOX
       ============================== */

    .review-message {
        background: linear-gradient(135deg, #f8fafc, #f4f8ff);
        border: 1px solid #e4e7ec;
        border-radius: 15px;
        padding: 20px 22px;
        margin: 0 auto 30px;
        max-width: 520px;
        color: #475467;
        font-size: 14px;
        line-height: 1.6;
        position: relative;
        z-index: 1;
    }

    .review-message strong {
        color: #0b5ed7;
        font-weight: 700;
    }


    /* ==============================
       BUTTON
       ============================== */

    .back-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 14px 30px;
        border-radius: 11px;
        background: linear-gradient(135deg, #0b5ed7, #084298);
        color: #ffffff !important;
        text-decoration: none;
        font-family: "Segoe UI", Arial, sans-serif;
        font-size: 15px;
        font-weight: 600;
        box-shadow: 0 8px 20px rgba(11, 94, 215, 0.22);
        transition: all 0.3s ease;
        position: relative;
        z-index: 1;
    }

    .back-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 28px rgba(11, 94, 215, 0.30);
        text-decoration: none;
        color: #ffffff !important;
    }


    /* ==============================
       SMALL NOTE
       ============================== */

    .small-note {
        margin-top: 20px;
        color: #98a2b3;
        font-size: 12px;
        position: relative;
        z-index: 1;
    }


    /* ==============================
       MOBILE
       ============================== */

    @media (max-width: 600px) {

        .thankyou-page {
            padding: 30px 15px;
        }

        .thankyou-card {
            padding: 45px 25px;
            border-radius: 22px;
        }

        .thankyou-card h1 {
            font-size: 29px;
        }

        .thankyou-card > p {
            font-size: 15px;
        }

        .success-icon {
            width: 76px;
            height: 76px;
            font-size: 36px;
        }

        .back-btn {
            width: 100%;
            box-sizing: border-box;
        }
    }

</style>

</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

<section class="thankyou-page">

    <div class="thankyou-card">


        <!-- SUCCESS ICON -->

        <div class="success-icon">
            ✓
        </div>


        <!-- HEADING -->

        <h1>
            Thank You for Your Review!
        </h1>


        <!-- DESCRIPTION -->

        <p>
            We truly appreciate you taking the time to share
            your experience with us.
        </p>


        <!-- MESSAGE -->

        <div class="review-message">

            Your feedback is valuable to us and helps us
            <strong>improve our service</strong>
            and serve you better.

        </div>


        <!-- BUTTON -->

        <a href="Review.aspx" class="back-btn">
            Submit Another Review
        </a>


        <!-- NOTE -->

        <div class="small-note">
            Thank you for choosing our service.
        </div>


    </div>

</section>

</asp:Content>

