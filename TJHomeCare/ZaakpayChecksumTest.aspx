<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZaakpayChecksumTest.aspx.cs" Inherits="TJHomeCare.ZaakpayChecksumTest" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Zaakpay Checksum Test</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style type="text/css">
        body { font-family: Arial, sans-serif; background: #f5f7fa; margin: 0; padding: 24px; color: #243043; }
        .test-box { max-width: 850px; margin: 20px auto; background: #fff; padding: 24px; border: 1px solid #dce2e8; border-radius: 8px; }
        h2 { margin-top: 0; color: #087f8c; }
        .help { color: #566273; line-height: 1.5; }
        .payload { width: 100%; box-sizing: border-box; min-height: 220px; padding: 12px; border: 1px solid #cbd3dc; border-radius: 5px; font-family: Consolas, monospace; font-size: 13px; }
        .test-button { margin-top: 14px; background: #087f8c; border: 0; color: #fff; padding: 11px 22px; border-radius: 5px; cursor: pointer; }
        .result { display: block; margin-top: 18px; padding: 14px; border-radius: 5px; font-weight: bold; }
        .details { display: block; margin-top: 10px; padding: 12px; background: #f3f6f8; border-radius: 5px; font-weight: normal; white-space: pre-wrap; line-height: 1.5; }
        .warning { color: #9a5a00; background: #fff7e6; padding: 12px; border-radius: 5px; line-height: 1.5; }
        .denied { color: #a32626; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="test-box">
            <h2>Zaakpay Response Checksum Test</h2>
            <asp:HiddenField ID="accessToken" runat="server" />
            <asp:Label ID="lblAccess" runat="server" CssClass="denied" />

            <asp:Panel ID="pnlTest" runat="server">
                <p class="help">
                    Paste the raw URL-encoded callback form body captured from the existing
                    <strong>ZaakpayReturnV2.aspx</strong> request. It should look like
                    <code>orderId=...&amp;responseCode=100&amp;...&amp;checksum=...</code>.
                    Do not paste the Secret Key here.
                </p>
                <div class="warning">
                    This diagnostic uses the ZaakpayGateway.VerifyResponseChecksum method and
                    ZaakpaySecretKey already configured on the server. Do not share the callback
                    payload; it can contain customer/payment data.
                </div>
                <p>
                    <asp:TextBox ID="txtPayload" runat="server" TextMode="MultiLine"
                        CssClass="payload" Rows="12"
                        placeholder="Paste raw callback body here: amount=...&amp;orderId=...&amp;checksum=..." />
                </p>
                <asp:Button ID="btnTest" runat="server" Text="Validate Checksum"
                    CssClass="test-button" OnClick="btnTest_Click" />
                <asp:Label ID="lblResult" runat="server" CssClass="result" />
                <asp:Label ID="lblDetails" runat="server" CssClass="details" />
            </asp:Panel>
        </div>
    </form>
</body>
</html>
