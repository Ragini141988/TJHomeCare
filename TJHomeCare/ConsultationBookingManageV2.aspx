<%@ Page Title="Manage Consultation Booking" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ConsultationBookingManageV2.aspx.cs" Inherits="TJHomeCare.ConsultationBookingManageV2" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
.manage-wrap{max-width:780px;margin:25px auto;padding:0 13px;font-family:Arial,sans-serif}.manage-card{background:#fff;border:1px solid #e1ece6;border-radius:16px;padding:24px;box-shadow:0 4px 17px rgba(0,0,0,.05)}.manage-title{color:#086448;font-size:29px;font-weight:800;margin:0 0 8px}.manage-info{background:#eaf7f0;border-left:4px solid #087453;padding:13px 15px;border-radius:7px;line-height:1.7;margin:17px 0}.manage-section{border-top:1px solid #e7eeea;padding-top:18px;margin-top:18px}.manage-section h2{font-size:21px;color:#075b40;margin:0 0 13px}.manage-label{display:block;font-weight:700;margin:11px 0 6px}.manage-input{width:100%;box-sizing:border-box;min-height:44px;padding:10px 12px;border:1px solid #cad5d0;border-radius:8px;font:16px Arial}.manage-button{border:0;background:#087453;color:#fff;border-radius:8px;padding:12px 18px;font-weight:700;font-size:16px;cursor:pointer;margin-top:11px}.manage-cancel{background:#a52a2a}.manage-error{display:block;color:#b42318;font-weight:600;margin:12px 0}.manage-success{display:block;background:#eaf7f0;color:#075b40;border-radius:8px;padding:12px;margin:12px 0}.manage-muted{font-size:13px;color:#64736d;line-height:1.5}
@media(max-width:600px){.manage-wrap{margin:12px auto;padding:0 9px}.manage-card{padding:18px 14px}.manage-title{font-size:25px}}
</style>
</asp:Content>
<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="manage-wrap"><div class="manage-card">
    <h1 class="manage-title">Manage Your Consultation</h1>
    <asp:Label ID="lblError" runat="server" CssClass="manage-error" />
    <asp:Label ID="lblResult" runat="server" CssClass="manage-success" />
    <asp:Panel ID="pnlManage" runat="server">
        <div class="manage-info">
            <strong>Booking ID:</strong> <asp:Label ID="lblBookingReference" runat="server" /><br />
            <strong>Professional:</strong> <asp:Label ID="lblProfessional" runat="server" /><br />
            <strong>Service:</strong> <asp:Label ID="lblService" runat="server" /><br />
            <strong>Current Appointment:</strong> <asp:Label ID="lblCurrentAppointment" runat="server" /><br />
            <strong>Booking Status:</strong> <asp:Label ID="lblBookingStatus" runat="server" />
        </div>
        <div class="manage-section">
            <h2>Request Rescheduling</h2>
            <label class="manage-label" for="<%= txtNewDate.ClientID %>">New Preferred Date</label>
            <asp:TextBox ID="txtNewDate" runat="server" CssClass="manage-input" TextMode="Date" />
            <label class="manage-label" for="<%= txtNewTime.ClientID %>">New Preferred Time</label>
            <asp:TextBox ID="txtNewTime" runat="server" CssClass="manage-input" TextMode="Time" />
            <label class="manage-label" for="<%= txtRescheduleNote.ClientID %>">Note (Optional)</label>
            <asp:TextBox ID="txtRescheduleNote" runat="server" CssClass="manage-input" TextMode="MultiLine" Rows="2" MaxLength="500" />
            <asp:Button ID="btnReschedule" runat="server" Text="Submit Reschedule Request" CssClass="manage-button" OnClick="btnReschedule_Click" />
        </div>
        <div class="manage-section">
            <h2>Request Cancellation</h2>
            <label class="manage-label" for="<%= txtCancelNote.ClientID %>">Reason (Optional)</label>
            <asp:TextBox ID="txtCancelNote" runat="server" CssClass="manage-input" TextMode="MultiLine" Rows="2" MaxLength="500" />
            <asp:Button ID="btnCancel" runat="server" Text="Request Cancellation" CssClass="manage-button manage-cancel" OnClick="btnCancel_Click" OnClientClick="return confirm('Submit a cancellation request for this consultation?');" />
            <p class="manage-muted">This sends a request to the TJ Home Care team. It does not immediately cancel the booking or automatically issue a refund. The team will review it according to the cancellation and refund policy.</p>
        </div>
    </asp:Panel>
</div></div>
</asp:Content>
