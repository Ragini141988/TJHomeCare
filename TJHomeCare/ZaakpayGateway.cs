using System;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Collections.Generic;

namespace TJHomeCare
{
    /// <summary>
    /// Zaakpay Express Checkout (Redirect Flow) helpers.
    /// The merchant secret must be loaded from server-side configuration.
    /// </summary>
    public static class ZaakpayGateway
    {
        private static readonly string[] ResponseChecksumFields =
 {
    "amount",
    "bank",
    "bankid",
    "cardId",
    "cardScheme",
    "cardToken",
    "cardhashid",
    "doRedirect",
    "orderId",
    "paymentMethod",
    "paymentMode",
    "responseCode",
    "responseDescription",
    "productDescription",
    "product1Description",
    "product2Description",
    "product3Description",
    "product4Description",
    "pgTransId",
    "pgTransTime"
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

        public static bool VerifyResponseChecksum(
    NameValueCollection values,
    string secret)
        {
            if (values == null || String.IsNullOrEmpty(secret))
                return false;

            string supplied = values["checksum"];

            if (String.IsNullOrEmpty(supplied))
                return false;

            StringBuilder data = new StringBuilder();

            for (int i = 0; i < ResponseChecksumFields.Length; i++)
            {
                string name = ResponseChecksumFields[i];

                // Same logic as the working Response.aspx
                string value = values[name];

                if (value != null)
                {
                    data.Append(name)
                        .Append("=")
                        .Append(value)
                        .Append("&");
                }
            }

            string expected = HmacSha256(
                data.ToString(),
                secret);

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
            if (a == null || b == null || a.Length != b.Length)
                return false;

            int difference = 0;

            for (int i = 0; i < a.Length; i++)
            {
                difference |=
                    Char.ToLowerInvariant(a[i]) ^
                    Char.ToLowerInvariant(b[i]);
            }

            return difference == 0;
        }
        public static string DiagnoseResponseChecksum(NameValueCollection v, string secret)
        {
            string supplied = (v["checksum"] ?? "").Trim().ToLowerInvariant();
            var keys = new List<string>();
            foreach (string k in v.AllKeys) if (k != null && !k.Equals("checksum", StringComparison.OrdinalIgnoreCase)) keys.Add(k);

            var variants = new Dictionary<string, string>();

            // A: documented list, only fields present
            var a = new StringBuilder();
            foreach (string n in ResponseChecksumFields) if (v[n] != null) a.Append(n).Append("=").Append(v[n]).Append("&");
            variants["A_listed_present"] = a.ToString();

            // B: documented list, missing fields sent as empty
            var b = new StringBuilder();
            foreach (string n in ResponseChecksumFields) b.Append(n).Append("=").Append(v[n] ?? "").Append("&");
            variants["B_listed_all"] = b.ToString();

            // C: every posted field in the order received
            var c = new StringBuilder();
            foreach (string k in keys) c.Append(k).Append("=").Append(v[k]).Append("&");
            variants["C_received_order"] = c.ToString();

            // D: every posted field, alphabetical
            var sorted = new List<string>(keys); sorted.Sort(StringComparer.Ordinal);
            var d = new StringBuilder();
            foreach (string k in sorted) d.Append(k).Append("=").Append(v[k]).Append("&");
            variants["D_alphabetical"] = d.ToString();

            // E: every posted field in the order received, non-empty values only
            var e = new StringBuilder();
            foreach (string k in keys) if (!String.IsNullOrEmpty(v[k])) e.Append(k).Append("=").Append(v[k]).Append("&");
            variants["E_received_nonempty"] = e.ToString();

            foreach (var item in variants)
                if (HmacSha256(item.Value, secret) == supplied) return "MATCH=" + item.Key;

            return "NOMATCH";
        }
    }
}
