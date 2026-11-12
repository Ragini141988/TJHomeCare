<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Linq" %>
<script runat="server">
    // ====== CONFIG (tjhomecare) - replace with your real values ======
    const string MerchantId = "e439c2db7b7a431ea45170005e09de3a";
    const string SecretKey  = "82ed872ddd7f4d8e9c81ed46b4463160";
    // Keys from the main Zaakpay dashboard are LIVE keys => false (real Rs 10 will be charged).
    // true only if you have separate sandbox/staging credentials.
    const bool   UseStaging = false;
    const string StagingUrl = "https://zaakstaging.zaakpay.com/api/paymentTransact/V13";
    const string LiveUrl    = "https://api.zaakpay.com/api/paymentTransact/V13";
    // Must be on the same domain as the Website URL saved in dashboard > Integration Urls
    const string ReturnUrl  = "https://tjhomecare.com/ZaakpayReturnV2.aspx";
    // ================================================================

    protected void btnPay_Click(object sender, EventArgs e)
    {
        var p = new Dictionary<string, string>
        {
            { "merchantIdentifier", MerchantId },
            { "orderId", "TJ" + DateTime.Now.ToString("yyyyMMddHHmmss") },
            { "amount", "118" },               // paise => Rs 10.00
            { "currency", "INR" },
            { "buyerEmail", txtEmail.Text.Trim() },
            { "buyerFirstName", txtName.Text.Trim() },
            { "buyerPhoneNumber", txtPhone.Text.Trim() },
            { "productDescription", "TJ Homecare test payment" },
            { "returnUrl", ReturnUrl },
            { "txnType", "1" },
            { "mode", "0" }
        };

        // Checksum string: alphabetical order, name=value& (empty values skipped)
        var sb = new StringBuilder();
        foreach (var kv in p.Where(k => !string.IsNullOrEmpty(k.Value))
                            .OrderBy(k => k.Key, StringComparer.Ordinal))
            sb.Append(kv.Key).Append('=').Append(kv.Value).Append('&');

        string checksum;
        using (var h = new HMACSHA256(Encoding.UTF8.GetBytes(SecretKey)))
            checksum = BitConverter.ToString(h.ComputeHash(Encoding.UTF8.GetBytes(sb.ToString())))
                                   .Replace("-", "").ToLower();
        p["checksum"] = checksum;

        var html = new StringBuilder();
        html.Append("<html><body onload='document.forms[0].submit()'>Redirecting to Zaakpay...");
        html.AppendFormat("<form method='post' action='{0}'>", UseStaging ? StagingUrl : LiveUrl);
        foreach (var kv in p)
            html.AppendFormat("<input type='hidden' name='{0}' value='{1}' />",
                kv.Key, HttpUtility.HtmlAttributeEncode(kv.Value));
        html.Append("</form></body></html>");

        Response.Clear();
        Response.Write(html.ToString());
        Response.End();
    }
</script>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Zaakpay Test - TJ Homecare</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f8; }
        .box { max-width:360px; margin:60px auto; background:#fff; padding:24px; border-radius:8px; box-shadow:0 2px 8px #0002; }
        input[type=text] { width:100%; padding:8px; margin:6px 0 14px; box-sizing:border-box; }
        .btn { width:100%; padding:10px; background:#0a7cff; color:#fff; border:0; border-radius:4px; font-size:16px; cursor:pointer; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <h3>TJ Homecare – Test Payment</h3>
            <label>Name</label>
            <asp:TextBox ID="txtName" runat="server" Text="Test" />
            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" Text="test@example.com" />
            <label>Phone</label>
            <asp:TextBox ID="txtPhone" runat="server" Text="9999999999" />
            <p><b>Amount: ₹ 10.00</b></p>
            <asp:Button ID="btnPay" runat="server" Text="Pay ₹10" CssClass="btn" OnClick="btnPay_Click" />
        </div>
    </form>
</body>
</html>
