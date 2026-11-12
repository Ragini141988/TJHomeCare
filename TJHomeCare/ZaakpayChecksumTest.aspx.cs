using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ZaakpayChecksumTest : Page
    {
        private bool _accessGranted;

        protected void Page_Load(object sender, EventArgs e)
        {
            _accessGranted = ValidateAccess();
        }

        private bool ValidateAccess()
        {
            string configuredToken =
                (ConfigurationManager.AppSettings["ZaakpayChecksumTestToken"] ?? String.Empty).Trim();

            string suppliedToken;
            if (IsPostBack)
                suppliedToken = (accessToken.Value ?? String.Empty).Trim();
            else
                suppliedToken = (Request.QueryString["token"] ?? String.Empty).Trim();

            bool valid = !String.IsNullOrEmpty(configuredToken) &&
                         !String.IsNullOrEmpty(suppliedToken) &&
                         SecureEquals(configuredToken, suppliedToken);

            pnlTest.Visible = valid;
            if (valid)
            {
                accessToken.Value = suppliedToken;
                lblAccess.Text = String.Empty;
            }
            else
            {
                lblAccess.Text = "Access denied. Check the temporary diagnostic URL/token configuration.";
            }

            return valid;
        }

        protected void btnTest_Click(object sender, EventArgs e)
        {
            // Recheck access on the event as well as during Page_Load.
            if (!_accessGranted || !ValidateAccess())
                return;

            string secret =
                (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();

            if (String.IsNullOrEmpty(secret))
            {
                ShowError("ZaakpaySecretKey is missing from server-side web.config appSettings.");
                return;
            }

            string rawPayload = (txtPayload.Text ?? String.Empty).Trim();
            if (String.IsNullOrEmpty(rawPayload))
            {
                ShowError("Paste the raw URL-encoded callback form body first.");
                return;
            }

            if (rawPayload.Length > 30000)
            {
                ShowError("The pasted payload is longer than expected. Check that you copied only the callback form body.");
                return;
            }

            try
            {
                // Parse the same URL-encoded format used by an HTML form POST.
                NameValueCollection callback = HttpUtility.ParseQueryString(rawPayload);
                bool checksumValid = ZaakpayGateway.VerifyResponseChecksum(callback, secret);
                string diagnosis = ZaakpayGateway.DiagnoseResponseChecksum(callback, secret);
                string responseCode = callback["responseCode"];
                string orderId = callback["orderId"];
                int fieldCount = callback.AllKeys.Length;

                if (checksumValid)
                {
                    lblResult.Text = "CHECKSUM VALID";
                    lblResult.Style["background"] = "#e7f6ed";
                    lblResult.Style["color"] = "#176b36";
                }
                else
                {
                    lblResult.Text = "CHECKSUM INVALID";
                    lblResult.Style["background"] = "#fdecec";
                    lblResult.Style["color"] = "#9b2424";
                }

                // Do not display callback values, checksum strings, card data, email or phone.
                string safeOrderReference = MaskReference(orderId);
                lblDetails.Text =
                    "Response code: " + HttpUtility.HtmlEncode(String.IsNullOrEmpty(responseCode) ? "(missing)" : responseCode) + "\r\n" +
                    "Order reference: " + HttpUtility.HtmlEncode(safeOrderReference) + "\r\n" +
                    "Posted field count (including checksum): " + fieldCount.ToString() + "\r\n" +
                    "Diagnostic result: " + HttpUtility.HtmlEncode(diagnosis) + "\r\n\r\n" +
                    "No callback values or checksum values have been displayed or stored.";
            }
            catch (Exception)
            {
                ShowError("Could not parse the payload. Paste the raw URL-encoded body, not the formatted key/value view.");
            }
        }

        private void ShowError(string message)
        {
            lblResult.Text = "TEST NOT RUN";
            lblResult.Style["background"] = "#fff7e6";
            lblResult.Style["color"] = "#8a5900";
            lblDetails.Text = HttpUtility.HtmlEncode(message);
        }

        private static string MaskReference(string value)
        {
            if (String.IsNullOrEmpty(value))
                return "(missing)";
            if (value.Length <= 8)
                return "********";
            return value.Substring(0, 4) + "********" + value.Substring(value.Length - 4, 4);
        }

        private static bool SecureEquals(string first, string second)
        {
            if (first == null || second == null || first.Length != second.Length)
                return false;

            int difference = 0;
            int i;
            for (i = 0; i < first.Length; i++)
                difference |= first[i] ^ second[i];

            return difference == 0;
        }
    }
}
