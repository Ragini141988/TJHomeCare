using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ZaakpayReturnV2 : Page
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
            if (!String.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
            {
                ShowMessage("Invalid payment response. Please return to your booking page.");
                return;
            }

            // orderId is used only to locate the locally-created attempt.
            // Payment success, amount and transaction ID are obtained from Zaakpay's
            // signed server-to-server Check Status API, never from browser form fields.
            string orderId = (Request.Form["orderId"] ?? String.Empty).Trim();
            string merchant = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
            string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            string environment = (ConfigurationManager.AppSettings["ZaakpayEnvironment"] ?? String.Empty).Trim();

            if (orderId.Length == 0 || merchant.Length == 0 || secret.Length == 0 || environment.Length == 0)
            {
                ShowMessage("We received a payment response but could not identify the transaction configuration. Do not pay again. Please contact TJ Home Care.");
                return;
            }

            try
            {
                ZaakpayReconcileResult result = ZaakpayPaymentReconciler.CheckAndUpdate(
                    ConnectionString, orderId, merchant, secret, environment);

                if (String.Equals(result.State, "Paid", StringComparison.OrdinalIgnoreCase))
                {
                    RedirectTo("~/ConsultationBookingSuccessV2.aspx?t=" + HttpUtility.UrlEncode(result.BookingToken));
                    return;
                }

                if (String.Equals(result.State, "Failed", StringComparison.OrdinalIgnoreCase))
                {
                    RedirectTo("~/ConsultationPaymentV2.aspx?t=" + HttpUtility.UrlEncode(result.BookingToken) + "&result=failed");
                    return;
                }

                RedirectTo("~/ConsultationPaymentV2.aspx?t=" + HttpUtility.UrlEncode(result.BookingToken) + "&result=verify");
            }
            catch (Exception)
            {
                // Leave the attempt unresolved. The payment page will show a
                // Check Payment Status button and will not allow another charge.
                ShowMessage("We received your payment response, but could not confirm the final status with Zaakpay right now. Please do not pay again. Return to the payment page and use Check Payment Status, or contact TJ Home Care.");
            }
        }

        private void RedirectTo(string relativeUrl)
        {
            Response.Redirect(ResolveUrl(relativeUrl), false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowMessage(string message)
        {
            Response.Clear();
            Response.ContentType = "text/html";
            Response.Charset = "utf-8";
            Response.Write("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>Payment Status</title></head><body style=\"font-family:Arial,sans-serif;padding:30px;color:#263238\"><h2>Payment Status</h2><p>" + HttpUtility.HtmlEncode(message) + "</p><p><a href=\"" + HttpUtility.HtmlAttributeEncode(ResolveUrl("~/")) + "\">Return to TJ Home Care</a></p></body></html>");
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
