
<%@ Page Title="Cancellation & Refund Policy | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="CancellationRefundPolicy.aspx.cs" Inherits="TJHomeCare.CancellationRefundPolicy" %>

<asp:Content ID="RefundContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
.refund-page{background:#f7f9fc;padding:40px 16px 55px;color:#334155;font-family:Arial,Helvetica,sans-serif}
.refund-container{max-width:1000px;margin:auto}
.refund-header{background:linear-gradient(135deg,#0b3b60,#087e8b);padding:36px;color:#fff;border-radius:14px 14px 0 0}
.refund-header h1{font-size:32px;margin:0 0 12px;color:#fff}
.refund-header p{margin:7px 0;color:#e0f2fe;font-size:14px}
.refund-content{background:#fff;padding:32px;border-radius:0 0 14px 14px;box-shadow:0 8px 28px rgba(15,23,42,.07)}
.refund-intro{font-size:16px;line-height:1.8;margin:0 0 26px}
.refund-section{padding-bottom:22px;margin-bottom:24px;border-bottom:1px solid #e5eaf0}
.refund-section:last-child{border-bottom:0;margin-bottom:0;padding-bottom:0}
.refund-section h2{font-size:20px;color:#0b5875;margin:0 0 12px}
.refund-section p,.refund-section li{font-size:15px;line-height:1.8}
.refund-section p{margin:0 0 10px}
.refund-section ul{padding-left:24px;margin:8px 0}
.refund-section li{margin-bottom:5px}
.refund-contact{background:#f0f9ff;border-left:4px solid #087e8b;padding:20px;border-radius:7px}
.refund-contact p{margin-bottom:8px}
.refund-contact a{color:#087e8b;text-decoration:none}
.refund-contact a:hover{text-decoration:underline}
@media(max-width:600px){
.refund-page{padding:22px 10px 35px}
.refund-header{padding:25px 20px}
.refund-header h1{font-size:26px}
.refund-content{padding:22px 18px}
.refund-section h2{font-size:18px}
.refund-section p,.refund-section li,.refund-intro{font-size:14px;line-height:1.8}
.refund-contact{padding:15px}
}
</style>

<div class="refund-page">
<div class="refund-container">

<div class="refund-header">
<h1>Cancellation &amp; Refund Policy</h1>
<p><strong>TJ Home Care – Trusted Hands for Every Home</strong></p>
<p>Operated by Sunshine Enterprises</p>
<p><strong>Effective Date:</strong> 19 October 2026</p>
</div>

<div class="refund-content">

<p class="refund-intro">
TJ Home Care is committed to transparent cancellation and refund procedures.
</p>

<section class="refund-section">
<h2>1. Online Dietician &amp; Psychology Consultations</h2>
<ul>
<li>Customers may cancel or reschedule appointments at least 24 hours before the scheduled session.</li>
<li>Eligible cancellations made at least 24 hours in advance will receive a full refund.</li>
<li>Cancellations within 24 hours of the appointment may not be eligible for a refund.</li>
<li>If the assigned professional is unavailable and an acceptable alternative cannot be arranged, the customer may request a full refund.</li>
<li>Completed consultation sessions are generally non-refundable, except in cases of verified service failure or where required by law.</li>
</ul>
</section>

<section class="refund-section">
<h2>2. Home Care Placement Services</h2>
<p>For baby care, patient care, home nursing, maids, cooks and drivers:</p>
<ul>
<li>Placement fees will be communicated before booking confirmation.</li>
<li>Where applicable, replacement guarantees will be specified in the service agreement.</li>
<li>If an agreed placement cannot be provided, the customer may request a refund in accordance with the applicable agreement and law.</li>
<li>Refund requests after successful placement will be reviewed under the agreed service terms and applicable consumer rights.</li>
</ul>
</section>

<section class="refund-section">
<h2>3. Managed Home Care Services</h2>
<p>Refunds and cancellations for monthly managed services will be governed by the service agreement.</p>
<p>Any refund for unused service periods will depend on the agreed billing conditions and services already delivered.</p>
</section>

<section class="refund-section">
<h2>4. Duplicate Payments</h2>
<p>Verified duplicate or excess payments will be refunded.</p>
</section>

<section class="refund-section">
<h2>5. Refund Processing</h2>
<p>Approved refunds will normally be initiated within 5–7 business days after approval.</p>
<p>The amount may take additional time to reflect in the original payment method depending on the bank or payment provider.</p>
</section>

<section class="refund-section">
<h2>6. Refund Method</h2>
<p>Approved refunds will ordinarily be processed through the original payment method, subject to payment provider capabilities and applicable regulations.</p>
</section>

<section class="refund-section">
<h2>7. Requesting a Refund</h2>
<p>Customers may contact:</p>
<div class="refund-contact">
<p><strong>Email:</strong> <a href="mailto:care@tjhomecare.com">care@tjhomecare.com</a></p>
<p><strong>Phone / WhatsApp:</strong> <a href="https://wa.me/919429693689">+91 9429693689</a></p>
<p>Please provide the booking details, registered mobile number, payment reference and reason for the request.</p>
</div>
</section>

<section class="refund-section">
<h2>8. Customer Rights</h2>
<p>This policy does not restrict statutory consumer rights under applicable Indian law.</p>
</section>

<section class="refund-section">
<h2>Contact TJ Home Care</h2>
<div class="refund-contact">
<p><strong>Operated by:</strong> Sunshine Enterprises</p>
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

<p style="margin-top:25px">
<a href="<%= ResolveUrl("~/TermsAndConditions.aspx") %>">View Terms &amp; Conditions</a>
</p>

</div>
</div>
</div>

</asp:Content>
