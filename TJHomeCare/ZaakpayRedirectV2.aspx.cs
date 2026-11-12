using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ZaakpayRedirectV2 : Page
    {
        private string ConnectionString
        {
            get
            {
                ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"];
                if (settings == null) throw new ConfigurationErrorsException("The TJ Home Care SQL connection string was not found.");
                return settings.ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string orderId = (Request.QueryString["o"] ?? String.Empty).Trim();
            if (orderId.Length == 0 || orderId.Length > 40)
            {
                WriteMessage("Invalid payment request. Please return to TJ Home Care and try again.");
                return;
            }

            try
            {
                string mode = (ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim();
                string environment = (ConfigurationManager.AppSettings["ZaakpayEnvironment"] ?? "Staging").Trim();
                string merchant = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
                string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
                if (!String.Equals(mode, "Zaakpay", StringComparison.OrdinalIgnoreCase) ||
                    merchant.Length == 0 || secret.Length == 0 ||
                    merchant.IndexOf("REPLACE", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    secret.IndexOf("REPLACE", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    WriteMessage("Online payment is not configured. Please contact TJ Home Care.");
                    return;
                }

                SortedDictionary<string, string> values = new SortedDictionary<string, string>(StringComparer.Ordinal);
                string customerName, email, phone, city, state, serviceName, currency;
                decimal amount;
                int paymentId;
                string sql = @"
                    SELECT TOP 1 P.PaymentID, P.Amount, B.CustomerName, B.Email, B.ContactNumber,
                           B.City, B.State, SC.ServiceName
                    FROM [sqladmin].[ConsultationBookingPayments] P
                    INNER JOIN [sqladmin].[ConsultationBookings] B ON B.BookingID = P.BookingID
                    INNER JOIN [sqladmin].[ServiceCategories] SC ON SC.ServiceCategoryID = B.ServiceCategoryID
                    WHERE P.MerchantOrderID = @OrderID
                      AND P.GatewayName = N'Zaakpay'
                      AND P.PaymentStatus = N'Initiated'
                      AND B.PaymentStatus <> N'Paid';";

                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                    con.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            WriteMessage("This payment request has expired or has already been processed. Please return to your booking page.");
                            return;
                        }
                        paymentId = Convert.ToInt32(r["PaymentID"]);
                        amount = Convert.ToDecimal(r["Amount"]);
                        customerName = Convert.ToString(r["CustomerName"]);
                        email = Convert.ToString(r["Email"]);
                        phone = Convert.ToString(r["ContactNumber"]);
                        city = Convert.ToString(r["City"]);
                        state = Convert.ToString(r["State"]);
                        serviceName = Convert.ToString(r["ServiceName"]);
                    }
                }

                long paisa = Convert.ToInt64(Math.Round(amount * 100M, 0, MidpointRounding.AwayFromZero));
                if (paisa < 100 || paisa > 10000000)
                {
                    WriteMessage("The booking amount is outside the permitted Zaakpay transaction range. Please contact TJ Home Care.");
                    return;
                }

                values.Add("amount", paisa.ToString(CultureInfo.InvariantCulture));
                values.Add("buyerEmail", email);
                string firstName = GetBuyerFirstName(customerName);

                if (firstName.Length > 0)
                {
                    values.Add("buyerFirstName", firstName);
                }
                AddOptional(values, "buyerPhoneNumber", DigitsOnly(phone));
                AddOptional(values, "buyerCity", CleanAlphabetic(city, 30));
                AddOptional(values, "buyerState", CleanAlphabetic(state, 30));
                values.Add("buyerCountry", "India");
                values.Add("currency", "INR");
                values.Add("merchantIdentifier", merchant);
                values.Add("merchantIpAddress", GetClientIpAddress());
                values.Add("mode", "0");
                values.Add("orderId", orderId);
                values.Add("productDescription", "TJ Home Care Online Consultation");
                values.Add("purpose", "0");
                values.Add("returnUrl", GetReturnUrl());
                values.Add("txnType", "1");
                values.Add("zpPayOption", "1");
                string checksum = ZaakpayGateway.CalculateRequestChecksum(values, secret);

                // Mark the request as sent before generating the auto-submit form.
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE [sqladmin].[ConsultationBookingPayments]
                    SET PaymentStatus = N'Processing', UpdatedOn = GETDATE()
                    WHERE PaymentID = @PaymentID AND PaymentStatus = N'Initiated';", con))
                {
                    cmd.Parameters.Add("@PaymentID", SqlDbType.BigInt).Value = paymentId;
                    con.Open();
                    if (cmd.ExecuteNonQuery() != 1)
                    {
                        WriteMessage("This payment request is no longer available. Please return to TJ Home Care.");
                        return;
                    }
                }

                string endpoint = ZaakpayGateway.GetStagingOrLiveEndpoint(environment);
                StringBuilder html = new StringBuilder();
                html.Append("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>Redirecting to secure payment</title></head>");
                html.Append("<body style=\"font-family:Arial,sans-serif;text-align:center;padding:40px;color:#174b3b\"><h2>Redirecting to secure payment...</h2><p>Please do not refresh or close this page.</p>");
                html.Append("<form id=\"zaakpayForm\" method=\"post\" action=\"").Append(HttpUtility.HtmlAttributeEncode(endpoint)).Append("\">");
                foreach (KeyValuePair<string, string> item in values)
                    AddHidden(html, item.Key, item.Value);
                AddHidden(html, "checksum", checksum);
                html.Append("<noscript><button type=\"submit\">Continue to Payment</button></noscript></form>");
                html.Append("<script>document.getElementById('zaakpayForm').submit();</script></body></html>");
                Response.Clear();
                Response.ContentType = "text/html";
                Response.Charset = "utf-8";
                Response.Write(html.ToString());
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception)
            {
                WriteMessage("We could not start the payment session. Please return to TJ Home Care and try again.");
            }
        }
        private static string GetBuyerFirstName(string fullName)
        {
            if (String.IsNullOrEmpty(fullName))
                return String.Empty;

            string[] parts = fullName.Trim().Split(
                new char[] { ' ' },
                StringSplitOptions.RemoveEmptyEntries);

            if (parts.Length == 0)
                return String.Empty;

            StringBuilder result = new StringBuilder();

            for (int i = 0; i < parts[0].Length && result.Length < 30; i++)
            {
                char c = parts[0][i];

                if ((c >= 'A' && c <= 'Z') ||
                    (c >= 'a' && c <= 'z') ||
                    (c >= '0' && c <= '9'))
                {
                    result.Append(c);
                }
            }

            return result.ToString();
        }
        private string GetReturnUrl()
        {
            string configured = (ConfigurationManager.AppSettings["ZaakpayReturnUrl"] ?? String.Empty).Trim();
            if (configured.Length > 0)
            {
                Uri parsed;
                if (!Uri.TryCreate(configured, UriKind.Absolute, out parsed) || (parsed.Scheme != Uri.UriSchemeHttps && parsed.Scheme != Uri.UriSchemeHttp))
                    throw new ConfigurationErrorsException("ZaakpayReturnUrl must be an absolute HTTP/HTTPS URL.");
                return configured;
            }
            return Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/ZaakpayReturnV2.aspx");
        }

        private string GetClientIpAddress()
        {
            string forwarded = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (!String.IsNullOrEmpty(forwarded)) return forwarded.Split(',')[0].Trim();
            return Request.UserHostAddress ?? String.Empty;
        }

        private static void AddOptional(SortedDictionary<string, string> values, string key, string value)
        {
            if (!String.IsNullOrEmpty(value)) values.Add(key, value);
        }

        private static string DigitsOnly(string value)
        {
            StringBuilder result = new StringBuilder();
            if (value != null)
            {
                int i;
                for (i = 0; i < value.Length; i++) if (Char.IsDigit(value[i])) result.Append(value[i]);
            }
            return result.ToString();
        }

        private static string CleanAlphabetic(string value, int maxLength)
        {
            StringBuilder result = new StringBuilder();
            if (value != null)
            {
                int i;
                for (i = 0; i < value.Length && result.Length < maxLength; i++)
                {
                    char c = value[i];
                    if (Char.IsLetter(c) || c == ' ') result.Append(c);
                }
            }
            string cleaned = result.ToString().Trim();
            if (cleaned.Length < 3) return String.Empty;
            return cleaned;
        }

        private static void AddHidden(StringBuilder html, string name, string value)
        {
            html.Append("<input type=\"hidden\" name=\"").Append(HttpUtility.HtmlAttributeEncode(name));
            html.Append("\" value=\"").Append(HttpUtility.HtmlAttributeEncode(value ?? String.Empty)).Append("\" />");
        }

        private void WriteMessage(string message)
        {
            Response.Clear();
            Response.ContentType = "text/html";
            Response.Write("<!doctype html><html><head><meta charset=\"utf-8\"></head><body style=\"font-family:Arial,sans-serif;padding:30px\"><h3>Payment could not be started</h3><p>" + HttpUtility.HtmlEncode(message) + "</p><a href=\"" + HttpUtility.HtmlAttributeEncode(ResolveUrl("~/")) + "\">Return to TJ Home Care</a></body></html>");
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
