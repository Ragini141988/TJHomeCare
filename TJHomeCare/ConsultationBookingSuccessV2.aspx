<%@ Page Title="Consultation Booking Confirmed" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ConsultationBookingSuccessV2.aspx.cs" Inherits="TJHomeCare.ConsultationBookingSuccessV2" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
.success-wrap{max-width:1000px;margin:22px auto;padding:0 13px;font-family:Arial,sans-serif;color:#16231e}.success-hero{background:linear-gradient(110deg,#e9faf1,#d4f6e5);border:1px solid #c5ecd7;border-radius:18px;padding:28px 20px;text-align:center}.success-check{width:70px;height:70px;border-radius:50%;background:#16a34a;color:#fff;font-size:44px;line-height:70px;font-weight:700;margin:0 auto 10px}.success-hero h1{color:#075b40;font-size:34px;margin:4px 0}.success-hero p{font-size:17px;line-height:1.5;margin:7px 0 15px}.success-ref{display:inline-block;border:1px solid #83c6a2;border-radius:30px;padding:9px 18px;font-weight:700;background:rgba(255,255,255,.65)}
.success-card{background:#fff;border:1px solid #e3ece7;border-radius:15px;padding:20px;margin-top:17px;box-shadow:0 3px 14px rgba(0,0,0,.04)}.success-card h2{background:#087453;color:#fff;border-radius:9px;padding:9px 14px;font-size:22px;margin:0 0 10px}.success-row{display:grid;grid-template-columns:1fr 1.35fr;gap:15px;padding:11px 7px;border-bottom:1px solid #edf0ee}.success-row:last-child{border-bottom:0}.success-label{color:#4a5d54}.success-value{font-weight:700;overflow-wrap:anywhere}.paid{color:#087a39}.success-actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:19px}.success-actions a,.success-actions button{flex:1;min-width:180px;text-align:center;border:1px solid #087453;background:#fff;color:#075b40;text-decoration:none;border-radius:9px;padding:13px 12px;font-size:16px;font-weight:700;cursor:pointer}.success-help{background:#eef6ff;border-radius:10px;padding:14px;margin-top:17px}.success-help a{color:#075b40;font-weight:700}
@media(max-width:600px){.success-wrap{padding:0 9px;margin:12px auto}.success-hero{padding:22px 12px}.success-hero h1{font-size:27px}.success-card{padding:14px}.success-row{grid-template-columns:1fr;gap:4px;padding:10px 5px}.success-actions{display:grid;grid-template-columns:1fr}.success-actions a,.success-actions button{min-width:0}}
@media print{header,footer,.success-actions,.success-help{display:none!important}.success-wrap{max-width:100%;margin:0;padding:0}.success-hero,.success-card{box-shadow:none;break-inside:avoid}}
</style>
</asp:Content>
<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="success-wrap">
    <asp:Panel ID="pnlSuccess" runat="server">
        <div class="success-hero">
            <div class="success-check">&#10003;</div>
            <h1>Booking Confirmed!</h1>
            <p>Your payment has been recorded successfully and your consultation booking is confirmed.</p>
            <div class="success-ref">Booking ID: <asp:Label ID="lblBookingReference" runat="server" /></div>
        </div>
        <div class="success-card">
            <h2>Booking Details</h2>
            <div class="success-row"><div class="success-label">Consultation Service</div><div class="success-value"><asp:Label ID="lblService" runat="server" /></div></div>
            <div class="success-row"><div class="success-label">Professional</div><div class="success-value"><asp:Label ID="lblProfessional" runat="server" /></div></div>
            <div class="success-row"><div class="success-label">Appointment Date</div><div class="success-value"><asp:Label ID="lblDate" runat="server" /></div></div>
            <div class="success-row"><div class="success-label">Appointment Time</div><div class="success-value"><asp:Label ID="lblTime" runat="server" /></div></div>
            <div class="success-row"><div class="success-label">Consultation Mode</div><div class="success-value">Online (Video/Audio), subject to professional confirmation</div></div>
            <div class="success-row"><div class="success-label">Amount Paid</div><div class="success-value paid"><asp:Label ID="lblAmount" runat="server" /> &nbsp; <asp:Label ID="lblPaymentStatus" runat="server" /></div></div>
            <div class="success-row"><div class="success-label">Payment Reference</div><div class="success-value"><asp:Label ID="lblTransaction" runat="server" /></div></div>
        </div>
        <div class="success-card">
            <h2>What's Next?</h2>
            <p><strong>1. Appointment confirmation</strong><br />Our care team will contact you to reconfirm your appointment.</p>
            <p><strong>2. Receive consultation link</strong><br />The secure video consultation link will be shared through the contact channel confirmed by our care team.</p>
            <p><strong>3. Consult online</strong><br />Join at the confirmed time and receive professional guidance.</p>
        </div>
        <div class="success-actions">
            <button type="button" onclick="window.print();">Print / Save Receipt</button>
          <%--  <asp:HyperLink ID="lnkManage" runat="server" Text="Reschedule Appointment" />--%>
            <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/HomePage.aspx" Text="Back to Home" />
        </div>
        <div class="success-help"><strong>Need Help?</strong> Contact TJ Home Care: <a href="tel:+917013107986">+91 7013107986</a> &nbsp;|&nbsp; <a href="https://wa.me/917013107986" target="_blank">Chat on WhatsApp</a></div>
    </asp:Panel>
    <asp:Label ID="lblError" runat="server" CssClass="success-card" />
</div>
</asp:Content>
