
<%@ Page Title="Terms & Conditions | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="TermsAndConditions.aspx.cs" Inherits="TJHomeCare.TermsAndConditions" %>

<asp:Content ID="TermsContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
.legal-page{background:#f7f9fc;padding:40px 16px 55px;color:#334155;font-family:Arial,Helvetica,sans-serif}
.legal-container{max-width:1000px;margin:auto}
.legal-header{background:linear-gradient(135deg,#0b3b60,#087e8b);padding:36px;color:#fff;border-radius:14px 14px 0 0}
.legal-header h1{font-size:32px;margin:0 0 12px;color:#fff}
.legal-header p{margin:7px 0;color:#e0f2fe;font-size:14px}
.legal-content{background:#fff;padding:32px;border-radius:0 0 14px 14px;box-shadow:0 8px 28px rgba(15,23,42,.07)}
.legal-intro{font-size:16px;line-height:1.8;margin:0 0 26px}
.legal-section{padding-bottom:22px;margin-bottom:24px;border-bottom:1px solid #e5eaf0}
.legal-section:last-child{border-bottom:0;margin-bottom:0;padding-bottom:0}
.legal-section h2{font-size:20px;color:#0b5875;margin:0 0 12px}
.legal-section p,.legal-section li{font-size:15px;line-height:1.8}
.legal-section p{margin:0 0 10px}
.legal-section ul{padding-left:24px;margin:8px 0}
.legal-section li{margin-bottom:5px}
.legal-contact{background:#f0f9ff;border-left:4px solid #087e8b;padding:20px;border-radius:7px}
.legal-contact p{margin-bottom:8px;overflow-wrap:anywhere}
.legal-contact a{color:#087e8b;text-decoration:none}
.legal-contact a:hover{text-decoration:underline}
@media(max-width:600px){
.legal-page{padding:22px 10px 35px}
.legal-header{padding:25px 20px}
.legal-header h1{font-size:26px}
.legal-content{padding:22px 18px}
.legal-section h2{font-size:18px}
.legal-section p,.legal-section li,.legal-intro{font-size:14px;line-height:1.8}
.legal-contact{padding:15px}
}
</style>

<div class="legal-page">
<div class="legal-container">

<div class="legal-header">
<h1>Terms &amp; Conditions</h1>
<p><strong>TJ Home Care – Trusted Hands for Every Home</strong></p>
<p>Operated by Sunshine Enterprises</p>
<p><strong>Effective Date:</strong> 19 October 2026</p>
</div>

<div class="legal-content">

<p class="legal-intro">
By accessing our website or booking our services, you agree to the following Terms &amp; Conditions.
</p>

<section class="legal-section">
<h2>1. About Our Services</h2>
<p>TJ Home Care is a home care and professional services platform operated by Sunshine Enterprises.</p>
<p>We facilitate the following services:</p>
<ul>
<li>Baby Care Services</li>
<li>Patient &amp; Elder Care Services</li>
<li>Home Nursing Services</li>
<li>Physiotherapy Services</li>
<li>Maid &amp; Housekeeping Services</li>
<li>Cook Services</li>
<li>Driver Services</li>
<li>Online Dietician Consultations</li>
<li>Online Psychology &amp; Counselling Services</li>
</ul>
<p>Services are subject to availability, location and professional eligibility.</p>
</section>

<section class="legal-section">
<h2>2. Booking Process</h2>
<p>Customers may submit service requirements through our website, phone or WhatsApp.</p>
<p>Our team will review the requirement, identify suitable available professionals and coordinate service arrangements.</p>
<p>A booking is confirmed only after the service terms, charges and applicable payment conditions have been accepted.</p>
</section>

<section class="legal-section">
<h2>3. Service Models</h2>
<p><strong>Placement Services:</strong> We connect customers with suitable professionals. Employment conditions and salary payments may be agreed directly between the customer and professional.</p>
<p><strong>Managed Services:</strong> TJ Home Care provides ongoing service coordination or management according to the agreed service plan.</p>
<p><strong>Online Consultations:</strong> Customers can book consultations with appropriately qualified dieticians and psychology professionals.</p>
</section>

<section class="legal-section">
<h2>4. Pricing and Payments</h2>
<p>All applicable charges will be communicated before booking confirmation.</p>
<p>Charges may include:</p>
<ul>
<li>One-time placement fees</li>
<li>Monthly management fees</li>
<li>Online consultation fees</li>
<li>Other agreed service charges</li>
<li>Applicable taxes</li>
</ul>
<p>Payments may be processed through Razorpay, UPI, bank transfer or other authorised payment methods.</p>
</section>

<section class="legal-section">
<h2>5. Online Healthcare Consultations</h2>
<p>Online consultations are intended to provide professional guidance within the practitioner's qualifications and permitted scope.</p>
<p>Clinical psychology services will be provided only by professionals who meet applicable qualification and registration requirements.</p>
<p>These services do not replace emergency medical care.</p>
</section>

<section class="legal-section">
<h2>6. Customer Responsibilities</h2>
<p>Customers must provide accurate information, maintain a safe environment, treat service professionals respectfully and comply with agreed payment and service conditions.</p>
</section>

<section class="legal-section">
<h2>7. Professional Responsibilities</h2>
<p>Service professionals are expected to provide accurate credentials, maintain confidentiality, follow professional standards and perform duties within their competence.</p>
</section>

<section class="legal-section">
<h2>8. Cancellation and Refunds</h2>
<p>Cancellations, rescheduling and refunds are governed by our Cancellation &amp; Refund Policy and applicable service agreements.</p>
<p><a href="<%= ResolveUrl("~/CancellationRefundPolicy.aspx") %>">View Cancellation &amp; Refund Policy</a></p>
</section>

<section class="legal-section">
<h2>9. Replacement Services</h2>
<p>Where a placement includes a replacement guarantee, the duration, eligibility and number of replacements will be communicated in the applicable service agreement.</p>
</section>

<section class="legal-section">
<h2>10. Service Availability</h2>
<p>TJ Home Care does not guarantee immediate availability of a particular professional, specific joining dates or guaranteed healthcare outcomes.</p>
</section>

<section class="legal-section">
<h2>11. Limitation of Liability</h2>
<p>TJ Home Care's responsibilities depend on the nature of the service and the applicable agreement.</p>
<p>Nothing in these terms excludes liability or consumer rights that cannot legally be excluded.</p>
</section>

<section class="legal-section">
<h2>12. Governing Law</h2>
<p>These terms are governed by the applicable laws of India. Disputes are subject to the jurisdiction of competent courts under applicable law.</p>
</section>

<section class="legal-section">
<h2>13. Contact</h2>
<div class="legal-contact">
<p><strong>TJ Home Care</strong></p>
<p>Operated by Sunshine Enterprises</p>
<p><strong>Email:</strong> <a href="mailto:care@tjhomecare.com">care@tjhomecare.com</a></p>
<p><strong>Phone / WhatsApp:</strong> <a href="https://wa.me/919429693689">+91 9429693689</a></p>
<p><strong>Website:</strong> <a href="https://www.tjhomecare.com">www.tjhomecare.com</a></p>
<p><strong>Registered Address:</strong></p>
<p>
Room No. 7 &amp; 8, Sai Krupa Complex, First Floor,<br />
D.No. 10-1-12, Ward No. 11,<br />
Railway Road, Kavali - 524201,<br />
SPSR Nellore District, Andhra Pradesh.
</p>
<p><strong>Phone:</strong> <a href="tel:+919059724821">+91 9059724821</a></p>
<p><strong>GST:</strong> 37ARRPM1229P3Z0</p>
</div>
</section>

</div>
</div>
</div>

</asp:Content>
