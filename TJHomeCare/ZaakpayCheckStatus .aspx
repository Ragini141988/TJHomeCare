<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZaakpayCheckStatus .aspx.cs" Inherits="TJHomeCare.ZaakpayCheckStatus" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Zaakpay Transaction Status Check</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f7f8; margin: 0; padding: 24px; color: #243238; }
        .panel { max-width: 680px; margin: 30px auto; background: #fff; border: 1px solid #dce5e7; border-radius: 10px; padding: 24px; box-shadow: 0 4px 18px rgba(0,0,0,.05); }
        h2 { color: #087f68; margin-top: 0; }
        label { display: block; font-weight: 700; margin: 16px 0 7px; }
        input[type=text] { box-sizing: border-box; width: 100%; padding: 12px; border: 1px solid #bac8cc; border-radius: 6px; font-size: 15px; }
        .btn { margin-top: 18px; padding: 12px 20px; border: 0; border-radius: 6px; background: #087f68; color: white; font-size: 15px; font-weight: 700; cursor: pointer; }
        .result { margin-top: 22px; padding: 14px; border-radius: 6px; background: #f1f7f5; border: 1px solid #d1e6dd; white-space: pre-wrap; overflow-wrap: anywhere; }
        .note { color: #65757a; font-size: 13px; line-height: 1.5; margin-top: 16px; }
        .error { background: #fff4f2; border-color: #edc4be; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="panel">
            <h2>Zaakpay Transaction Status Check</h2>
            <p>Check an existing Zaakpay order directly with the gateway. This page does not initiate a payment and does not update your booking.</p>
            <label for="txtOrderId">Merchant Order ID</label>
            <asp:TextBox ID="txtOrderId" runat="server" />
            <asp:Button ID="btnCheck" runat="server" Text="Check Transaction Status" CssClass="btn" OnClick="btnCheck_Click" />
            <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="result">
                <asp:Literal ID="litResult" runat="server" />
            </asp:Panel>
            <p class="note">Use the exact MerchantOrderID stored in ConsultationBookingPayments. Remove this diagnostic page and its temporary access token after reconciliation.</p>
        </div>
    </form>
</body>
</html>
