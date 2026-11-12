using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ZaakpayCheckStatus : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAuthorized())
            {
                Response.StatusCode = 403;
                Response.TrySkipIisCustomErrors = true;
                Response.Clear();
                Response.Write("Access denied. Use the temporary diagnostic URL provided by your administrator.");
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                string orderId = Request.QueryString["orderId"];
                if (!String.IsNullOrEmpty(orderId))
                    txtOrderId.Text = orderId.Trim();
            }
        }

        protected void btnCheck_Click(object sender, EventArgs e)
        {
            if (!IsAuthorized())
            {
                ShowResult("Access denied. The temporary access token is missing or invalid.", true);
                return;
            }

            string orderId = (txtOrderId.Text ?? String.Empty).Trim();
            if (orderId.Length == 0 || orderId.Length > 100)
            {
                ShowResult("Enter a valid Merchant Order ID (maximum 100 characters).", true);
                return;
            }

            string merchantId = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
            string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            string environment = (ConfigurationManager.AppSettings["ZaakpayEnvironment"] ?? "Staging").Trim();

            if (merchantId.Length == 0 || secret.Length == 0)
            {
                ShowResult("ZaakpayMerchantIdentifier or ZaakpaySecretKey is missing from web.config appSettings.", true);
                return;
            }

            try
            {
                string json = "{\"merchantIdentifier\":" + JsonString(merchantId) +
                              ",\"orderId\":" + JsonString(orderId) +
                              ",\"version\":13}";
                string checksum = ZaakpayGateway.HmacSha256(json, secret);
                string host = String.Equals(environment, "Live", StringComparison.OrdinalIgnoreCase)
                    ? "https://api.zaakpay.com"
                    : "https://zaakstaging.zaakpay.com";
                string url = host + "/api/payments/v1/status";

                string responseText = PostJson(url, json, checksum);
                DisplayStatus(responseText, orderId);
            }
            catch (WebException ex)
            {
                string detail = "Zaakpay Check Status request failed.";
                HttpWebResponse http = ex.Response as HttpWebResponse;
                if (http != null)
                    detail += " HTTP status: " + ((int)http.StatusCode).ToString() + " " + http.StatusDescription + ".";
                ShowResult(detail + " Check the configured environment and gateway credentials. No booking data was changed.", true);
            }
            catch (Exception ex)
            {
                ShowResult("Unable to check the transaction: " + ex.Message + " No booking data was changed.", true);
            }
        }

        private bool IsAuthorized()
        {
            string expected = ConfigurationManager.AppSettings["ZaakpayCheckStatusToken"];
            string supplied = Request.QueryString["token"];
            if (String.IsNullOrEmpty(expected) || String.IsNullOrEmpty(supplied) || expected.Length != supplied.Length)
                return false;

            int diff = 0;
            int i;
            for (i = 0; i < expected.Length; i++) diff |= expected[i] ^ supplied[i];
            return diff == 0;
        }

        private static string PostJson(string url, string json, string checksum)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // TLS 1.2 for .NET Framework
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.Accept = "application/json";
            request.Headers["checksum"] = checksum;
            request.Timeout = 30000;
            request.ReadWriteTimeout = 30000;

            byte[] body = Encoding.UTF8.GetBytes(json);
            request.ContentLength = body.Length;
            using (Stream stream = request.GetRequestStream())
                stream.Write(body, 0, body.Length);

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            using (Stream stream = response.GetResponseStream())
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
                return reader.ReadToEnd();
        }

        private void DisplayStatus(string json, string requestedOrderId)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            object parsed = serializer.DeserializeObject(json);
            Dictionary<string, object> root = parsed as Dictionary<string, object>;
            if (root == null)
            {
                ShowResult("Zaakpay returned an unreadable response. No booking data was changed.", true);
                return;
            }

            string apiStatus = GetValue(root, "status");
            string messageCode = GetNestedValue(root, "message", "code");
            string messageText = GetNestedValue(root, "message", "text");

            Dictionary<string, object> data = GetDictionary(root, "data");
            object ordersObject;
            if (data == null || !data.TryGetValue("orders", out ordersObject))
            {
                ShowResult("API status: " + apiStatus + "\r\nMessage code: " + messageCode + "\r\nMessage: " + messageText + "\r\nNo transaction order details were returned. No booking data was changed.", true);
                return;
            }

            object first = null;
            object[] objectArray = ordersObject as object[];
            ArrayList arrayList = ordersObject as ArrayList;
            if (objectArray != null && objectArray.Length > 0) first = objectArray[0];
            else if (arrayList != null && arrayList.Count > 0) first = arrayList[0];

            Dictionary<string, object> order = first as Dictionary<string, object>;
            if (order == null)
            {
                ShowResult("API status: " + apiStatus + "\r\nMessage code: " + messageCode + "\r\nMessage: " + messageText + "\r\nNo transaction was found for this order ID. No booking data was changed.", true);
                return;
            }

            string actualOrderId = GetNestedValue(order, "orderDetail", "orderId");
            string transactionId = GetNestedValue(order, "orderDetail", "txnId");
            string amountPaisa = GetNestedValue(order, "orderDetail", "amount");
            string txnStatus = GetValue(order, "txnStatus");
            string responseCode = GetValue(order, "responseCode");
            string responseDescription = GetValue(order, "responseDescription");
            string txnDate = GetValue(order, "txnDate");

            if (!String.Equals(actualOrderId, requestedOrderId, StringComparison.Ordinal))
            {
                ShowResult("The order ID returned by Zaakpay did not match the requested order ID. Do not update the booking. Contact support.", true);
                return;
            }

            string statusText;
            switch (txnStatus)
            {
                case "0": statusText = "SUCCESS"; break;
                case "1": statusText = "FAILURE"; break;
                case "2": statusText = "PENDING"; break;
                case "3": statusText = "REFUND"; break;
                case "4": statusText = "PARTIAL REFUND"; break;
                case "5": statusText = "CHARGEBACK REVERTED"; break;
                case "6": statusText = "CHARGEBACK"; break;
                case "7": statusText = "PARTIAL CHARGEBACK REVERTED"; break;
                case "8": statusText = "PARTIAL CHARGEBACK"; break;
                default: statusText = "UNKNOWN / NOT RETURNED"; break;
            }

            StringBuilder output = new StringBuilder();
            output.Append("Zaakpay API status: ").Append(apiStatus).Append("\r\n");
            output.Append("API message code: ").Append(messageCode).Append("\r\n");
            output.Append("API message: ").Append(messageText).Append("\r\n\r\n");
            output.Append("Merchant Order ID: ").Append(actualOrderId).Append("\r\n");
            output.Append("Transaction status: ").Append(statusText).Append(" (txnStatus=").Append(txnStatus).Append(")\r\n");
            output.Append("Response code: ").Append(responseCode).Append("\r\n");
            output.Append("Response description: ").Append(responseDescription).Append("\r\n");
            output.Append("Gateway transaction ID: ").Append(transactionId).Append("\r\n");
            output.Append("Amount: ").Append(amountPaisa).Append(" paise\r\n");
            output.Append("Transaction date: ").Append(txnDate).Append("\r\n\r\n");
            output.Append("This page only queried Zaakpay. It did NOT change the ConsultationBookings or ConsultationBookingPayments tables.");
            ShowResult(output.ToString(), false);
        }

        private static Dictionary<string, object> GetDictionary(Dictionary<string, object> source, string key)
        {
            if (source == null) return null;
            object value;
            if (!source.TryGetValue(key, out value)) return null;
            return value as Dictionary<string, object>;
        }

        private static string GetNestedValue(Dictionary<string, object> source, string parent, string child)
        {
            return GetValue(GetDictionary(source, parent), child);
        }

        private static string GetValue(Dictionary<string, object> source, string key)
        {
            if (source == null) return String.Empty;
            object value;
            if (!source.TryGetValue(key, out value) || value == null) return String.Empty;
            return Convert.ToString(value);
        }

        private void ShowResult(string message, bool isError)
        {
            pnlResult.Visible = true;
            pnlResult.CssClass = isError ? "result error" : "result";
            litResult.Text = "<pre style=\"margin:0;font-family:Arial,sans-serif;white-space:pre-wrap\">" + HttpUtility.HtmlEncode(message) + "</pre>";
        }

        private static string JsonString(string value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Serialize(value);
        }
    }
}
