<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<script runat="server">
    // Must match the SecretKey in Default.aspx
    const string SecretKey = "82ed872ddd7f4d8e9c81ed46b4463160";

    // Order defined in Zaakpay docs for response checksum
    static readonly string[] Order = {
        "amount","bank","bankid","cardId","cardScheme","cardToken","cardhashid","doRedirect",
        "orderId","paymentMethod","paymentMode","responseCode","responseDescription",
        "productDescription","product1Description","product2Description","product3Description",
        "product4Description","pgTransId","pgTransTime"
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Request.Form["responseCode"] ?? "";
        string desc = Request.Form["responseDescription"] ?? "";
        string orderId = Request.Form["orderId"] ?? "";
        string recv = Request.Form["checksum"] ?? "";

        var data = new StringBuilder();
        foreach (var name in Order)
        {
            string v = Request.Form[name];   // case-insensitive lookup
            if (v != null) data.Append(name).Append('=').Append(v).Append('&');
        }

        string calc;
        using (var h = new HMACSHA256(Encoding.UTF8.GetBytes(SecretKey)))
            calc = BitConverter.ToString(h.ComputeHash(Encoding.UTF8.GetBytes(data.ToString()))).Replace("-", "").ToLower();

        bool valid = calc == recv.ToLower();
        bool success = code == "100";

        lblStatus.Text = success ? "Payment Successful" : "Payment Failed";
        lblStatus.ForeColor = success ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        lblDetails.Text = "Order ID: " + Server.HtmlEncode(orderId) +
                          "<br/>Code: " + Server.HtmlEncode(code) +
                          "<br/>Message: " + Server.HtmlEncode(desc) +
                          "<br/>Checksum valid: " + valid;

        var sb = new StringBuilder();
        foreach (string k in Request.Form.AllKeys)
            sb.Append("<tr><td>" + Server.HtmlEncode(k) + "</td><td>" + Server.HtmlEncode(Request.Form[k]) + "</td></tr>");
        litAll.Text = sb.ToString();
    }
</script>
<!DOCTYPE html>
<html>
<head runat="server"><title>Payment Result</title></head>
<body style="font-family:Arial">
    <form id="form1" runat="server">
        <h2><asp:Label ID="lblStatus" runat="server" /></h2>
        <p><asp:Label ID="lblDetails" runat="server" /></p>
        <h4>Raw response</h4>
        <table border="1" cellpadding="4"><asp:Literal ID="litAll" runat="server" /></table>
        <p><a href="Webform3.aspx">Back</a></p>
    </form>
</body>
</html>
