<%@ Page Title="Consultation Payment" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ConsultationPaymentV2.aspx.cs" Inherits="TJHomeCare.ConsultationPaymentV2" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
.pay-wrap{max-width:760px;margin:28px auto;padding:0 13px;font-family:Arial,sans-serif}.pay-card{background:#fff;border:1px solid #e3eee8;border-radius:18px;padding:26px;box-shadow:0 5px 22px rgba(10,65,48,.08)}
.pay-title{color:#086448;font-size:30px;font-weight:800;margin:0 0 8px}.pay-note{background:#fff8e6;border:1px solid #f2d58c;border-radius:10px;padding:13px 15px;color:#6a4b00;margin:16px 0;line-height:1.5}
.pay-summary{background:#eaf7f0;border:1px solid #b9dfca;border-radius:12px;padding:16px;margin:20px 0}.pay-row{display:flex;justify-content:space-between;gap:12px;padding:7px 0}.pay-total{border-top:1px solid #a5cdb4;margin-top:7px;padding-top:12px;font-size:21px;font-weight:800;color:#075b40}
.pay-button{display:block;width:100%;border:0;border-radius:9px;background:#087453;color:white;padding:14px 16px;font-size:17px;font-weight:700;cursor:pointer}.pay-button:disabled{background:#9aa9a2;cursor:not-allowed}.pay-error{color:#b42318;font-weight:600;display:block;margin:12px 0}.pay-small{font-size:13px;color:#64736d;line-height:1.5;margin-top:12px}
@media(max-width:600px){.pay-wrap{margin:12px auto;padding:0 9px}.pay-card{padding:18px 15px}.pay-title{font-size:25px}}
</style>
</asp:Content>
<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="pay-wrap"><div class="pay-card">
    <h1 class="pay-title">Review &amp; Payment</h1>
    <p>Check your appointment information before continuing.</p>
    <asp:Label ID="lblError" runat="server" CssClass="pay-error" />
    <asp:Panel ID="pnlPayment" runat="server">
        <div><strong>Booking Reference:</strong> <asp:Label ID="lblBookingReference" runat="server" /></div>
        <div><strong>Professional:</strong> <asp:Label ID="lblProfessional" runat="server" /></div>
        <div><strong>Consultation:</strong> <asp:Label ID="lblService" runat="server" /></div>
        <div><strong>Appointment:</strong> <asp:Label ID="lblAppointment" runat="server" /></div>
        <div><strong>Customer:</strong> <asp:Label ID="lblCustomer" runat="server" /></div>
        <div class="pay-summary">
            <div class="pay-row"><span>Consultation Fee</span><strong><asp:Label ID="lblFee" runat="server" /></strong></div>
            <div class="pay-row"><span>GST (<asp:Label ID="lblGstPercent" runat="server" />%)</span><strong><asp:Label ID="lblGst" runat="server" /></strong></div>
            <div class="pay-row pay-total"><span>Total Payable</span><strong><asp:Label ID="lblTotal" runat="server" /></strong></div>
        </div>
        <asp:Label ID="lblModeMessage" runat="server" CssClass="pay-note" />
        <asp:Button ID="btnZaakpayPay" runat="server" Text="Proceed to Secure Payment" CssClass="pay-button" OnClick="btnZaakpayPay_Click" Visible="false" />
        <asp:Button ID="btnDemoPay" runat="server" Text="Simulate Successful Payment (DEMO ONLY)" CssClass="pay-button" OnClick="btnDemoPay_Click" Visible="false" />
        <div class="pay-small">Demo mode does not collect money and must never be used as proof of an actual customer payment. The Zaakpay Redirect Flow uses server-generated checksums and verifies the gateway response before marking a booking paid.</div>
    </asp:Panel>
</div></div>
</asp:Content>
