using System;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;

namespace TJHomeCare
{
    /// <summary>
    /// Zaakpay Express Checkout (Redirect Flow) helpers.
    /// The merchant secret must be loaded from server-side configuration.
    /// </summary>
    public static class ZaakpayGateway
    {
        private static readonly string[] ResponseChecksumFields = new string[]
        {
            "amount", "bank", "bankid", "cardId", "cardScheme", "cardToken",
            "cardhashid", "doRedirect", "orderId", "paymentMethod", "paymentMode",
            "responseCode", "responseDescription", "productDescription",
            "product1Description", "product2Description", "product3Description",
            "product4Description", "pgTransId", "pgTransTime"
        };

        public static string CalculateRequestChecksum(System.Collections.Generic.SortedDictionary<string, string> values, string secret)
        {
            StringBuilder data = new StringBuilder();
            foreach (System.Collections.Generic.KeyValuePair<string, string> item in values)
            {
                if (!String.IsNullOrEmpty(item.Value))
                    data.Append(item.Key).Append("=").Append(item.Value).Append("&");
            }
            return HmacSha256(data.ToString(), secret);
        }

        public static bool VerifyResponseChecksum(NameValueCollection values, string secret)
        {
            if (values == null) return false;
            string supplied = values["checksum"];
            if (String.IsNullOrEmpty(supplied)) return false;

            StringBuilder data = new StringBuilder();
            int used = 0;
            int i;
            for (i = 0; i < ResponseChecksumFields.Length; i++)
            {
                string name = ResponseChecksumFields[i];
                string value = values[name];
                // Zaakpay's response checksum example includes the response fields
                // in this exact documented sequence. Omit absent/empty optional fields.
                if (value != null && value.Length > 0)
                {
                    data.Append(name).Append("=").Append(value).Append("&");
                    used++;
                }
            }
            if (used == 0) return false;
            string expected = HmacSha256(data.ToString(), secret);
            return FixedTimeEquals(expected, supplied.Trim());
        }

        public static string GetStagingOrLiveEndpoint(string environment)
        {
            if (String.Equals(environment, "Live", StringComparison.OrdinalIgnoreCase))
                return "https://api.zaakpay.com/api/paymentTransact/V13";
            return "https://zaakstaging.zaakpay.com/api/paymentTransact/V13";
        }

        public static string HmacSha256(string data, string secret)
        {
            if (String.IsNullOrEmpty(secret)) throw new ArgumentException("Zaakpay secret key is not configured.");
            byte[] keyBytes = Encoding.UTF8.GetBytes(secret);
            byte[] dataBytes = Encoding.UTF8.GetBytes(data ?? String.Empty);
            using (HMACSHA256 hmac = new HMACSHA256(keyBytes))
            {
                byte[] hash = hmac.ComputeHash(dataBytes);
                StringBuilder output = new StringBuilder(hash.Length * 2);
                int i;
                for (i = 0; i < hash.Length; i++) output.Append(hash[i].ToString("x2"));
                return output.ToString();
            }
        }

        private static bool FixedTimeEquals(string a, string b)
        {
            if (a == null || b == null || a.Length != b.Length) return false;
            int difference = 0;
            int i;
            for (i = 0; i < a.Length; i++) difference |= a[i] ^ b[i];
            return difference == 0;
        }
    }
}
