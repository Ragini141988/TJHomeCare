using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;

namespace TJHomeCare
{
    /// <summary>
    /// Server-to-server Zaakpay Check Status API client.
    /// C# 5 / .NET Framework 4.7.2+ compatible.
    /// </summary>
    public sealed class ZaakpayStatusResult
    {
        public bool ApiStatus;
        public bool? DataSuccess;
        public string ApiMessageCode = String.Empty;
        public string ApiMessage = String.Empty;
        public string MerchantIdentifier = String.Empty;
        public string OrderId = String.Empty;
        public string TransactionId = String.Empty;
        public string AmountPaisa = String.Empty;
        public string TransactionStatus = String.Empty;
        public string ResponseCode = String.Empty;
        public string ResponseDescription = String.Empty;
        public string TransactionDate = String.Empty;

        public bool ApiSuccess
        {
            get
            {
                // Do not gate a real order record on the envelope-level Boolean.
                // This merchant's live response has returned status=false while
                // message.code=100 and the order details show txnStatus=0,
                // responseCode=228 (captured), amount and transaction ID.
                // The reconciler independently checks merchant ID, exact order
                // ID, booking/attempt amount, txnStatus and transaction ID.
                // ApiStatus and DataSuccess remain in diagnostics for audit.
                return ApiMessageCode == "100";
            }
        }

        public bool IsSuccessfulTransaction
        {
            get
            {
                return ApiSuccess && TransactionStatus == "0" &&
                       !String.IsNullOrEmpty(TransactionId);
            }
        }

        public string ToSafeSummary()
        {
            StringBuilder s = new StringBuilder();
            s.Append("VerificationSource=ZaakpayCheckStatusAPI");
            s.Append(" | ApiStatus=").Append(ApiStatus ? "true" : "false");
            s.Append(" | DataSuccess=").Append(DataSuccess.HasValue ? (DataSuccess.Value ? "true" : "false") : "not-returned");
            s.Append(" | ApiMessageCode=").Append(ApiMessageCode);
            s.Append(" | ApiMessage=").Append(Safe(ApiMessage));
            s.Append(" | MerchantIdentifier=").Append(MerchantIdentifier);
            s.Append(" | OrderId=").Append(OrderId);
            s.Append(" | TxnStatus=").Append(TransactionStatus);
            s.Append(" | ResponseCode=").Append(ResponseCode);
            s.Append(" | ResponseDescription=").Append(Safe(ResponseDescription));
            s.Append(" | AmountPaisa=").Append(AmountPaisa);
            s.Append(" | TransactionId=").Append(TransactionId);
            s.Append(" | TransactionDate=").Append(TransactionDate);
            return s.ToString();
        }

        private static string Safe(string value)
        {
            if (String.IsNullOrEmpty(value)) return String.Empty;
            return value.Replace("|", "/").Replace("\r", " ").Replace("\n", " ");
        }
    }

    public static class ZaakpayStatusClient
    {
        public static ZaakpayStatusResult Check(string orderId, string merchantIdentifier,
            string secretKey, string environment)
        {
            if (String.IsNullOrEmpty(orderId)) throw new ArgumentException("Merchant order ID is required.");
            if (String.IsNullOrEmpty(merchantIdentifier)) throw new ArgumentException("Zaakpay merchant identifier is not configured.");
            if (String.IsNullOrEmpty(secretKey)) throw new ArgumentException("Zaakpay secret key is not configured.");

            // Version 13 is included in the exact JSON body covered by the HMAC.
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string json = "{\"merchantIdentifier\":" + serializer.Serialize(merchantIdentifier) +
                          ",\"orderId\":" + serializer.Serialize(orderId) +
                          ",\"version\":13}";
            string checksum = ZaakpayGateway.HmacSha256(json, secretKey);

            string host;
            if (String.Equals(environment, "Live", StringComparison.OrdinalIgnoreCase))
                host = "https://api.zaakpay.com";
            else if (String.Equals(environment, "Staging", StringComparison.OrdinalIgnoreCase))
                host = "https://zaakstaging.zaakpay.com";
            else
                throw new InvalidOperationException("ZaakpayEnvironment must be Live or Staging.");

            string responseJson = PostJson(host + "/api/payments/v1/status", json, checksum);
            return ParseResponse(responseJson);
        }

        private static string PostJson(string url, string json, string checksum)
        {
            // The application is configured for .NET Framework 4.7.2 / 4.8.
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // TLS 1.2

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

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                using (Stream stream = response.GetResponseStream())
                using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
                    return reader.ReadToEnd();
            }
            catch (WebException ex)
            {
                string detail = "Zaakpay Check Status API request failed";
                HttpWebResponse response = ex.Response as HttpWebResponse;
                if (response != null)
                    detail += " (HTTP " + ((int)response.StatusCode).ToString() + ")";
                throw new InvalidOperationException(detail + ".", ex);
            }
        }

        private static ZaakpayStatusResult ParseResponse(string json)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            object parsed = serializer.DeserializeObject(json);
            Dictionary<string, object> root = parsed as Dictionary<string, object>;
            if (root == null) throw new InvalidOperationException("Zaakpay returned an unreadable Check Status response.");

            ZaakpayStatusResult result = new ZaakpayStatusResult();
            result.ApiStatus = String.Equals(GetValue(root, "status"), "true", StringComparison.OrdinalIgnoreCase);

            Dictionary<string, object> message = GetDictionary(root, "message");
            result.ApiMessageCode = GetValue(message, "code");
            result.ApiMessage = GetValue(message, "text");

            Dictionary<string, object> data = GetDictionary(root, "data");
            if (data == null) return result;

            string dataSuccess = GetValue(data, "success");
            if (dataSuccess.Length > 0)
                result.DataSuccess = String.Equals(dataSuccess, "true", StringComparison.OrdinalIgnoreCase);

            result.MerchantIdentifier = GetValue(data, "merchantIdentifier");
            object ordersObject;
            if (!data.TryGetValue("orders", out ordersObject) || ordersObject == null)
                return result;

            object first = null;
            object[] objectArray = ordersObject as object[];
            ArrayList arrayList = ordersObject as ArrayList;
            if (objectArray != null && objectArray.Length > 0) first = objectArray[0];
            else if (arrayList != null && arrayList.Count > 0) first = arrayList[0];

            Dictionary<string, object> order = first as Dictionary<string, object>;
            if (order == null) return result;

            Dictionary<string, object> detail = GetDictionary(order, "orderDetail");
            result.OrderId = GetValue(detail, "orderId");
            result.TransactionId = GetValue(detail, "txnId");
            result.AmountPaisa = GetValue(detail, "amount");
            result.TransactionStatus = GetValue(order, "txnStatus");
            result.ResponseCode = GetValue(order, "responseCode");
            result.ResponseDescription = GetValue(order, "responseDescription");
            result.TransactionDate = GetValue(order, "txnDate");
            return result;
        }

        private static Dictionary<string, object> GetDictionary(Dictionary<string, object> source, string key)
        {
            if (source == null) return null;
            object value;
            if (!TryGetValueIgnoreCase(source, key, out value)) return null;
            return value as Dictionary<string, object>;
        }

        private static string GetValue(Dictionary<string, object> source, string key)
        {
            if (source == null) return String.Empty;
            object value;
            if (!TryGetValueIgnoreCase(source, key, out value) || value == null) return String.Empty;
            return Convert.ToString(value, System.Globalization.CultureInfo.InvariantCulture);
        }

        private static bool TryGetValueIgnoreCase(Dictionary<string, object> source, string key, out object value)
        {
            if (source.TryGetValue(key, out value)) return true;
            foreach (KeyValuePair<string, object> item in source)
            {
                if (String.Equals(item.Key, key, StringComparison.OrdinalIgnoreCase))
                {
                    value = item.Value;
                    return true;
                }
            }
            value = null;
            return false;
        }
    }
}
