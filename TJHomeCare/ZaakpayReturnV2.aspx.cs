using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
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

            string orderId = (Request.Form["orderId"] ?? String.Empty).Trim();
            string checksumSecret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            if (orderId.Length == 0 || checksumSecret.Length == 0)
            {
                ShowMessage("We could not identify this payment response. Please contact TJ Home Care.");
                return;
            }

            try
            {
                int bookingId;
                long expectedPaisa;
                long attemptPaisa;
                string token;
                string currentPaymentStatus;
                string currentBookingPaymentStatus;
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 1 B.BookingID, B.PublicToken, B.TotalAmount,
                           B.PaymentStatus AS BookingPaymentStatus,
                           P.Amount AS AttemptAmount, P.PaymentStatus AS AttemptPaymentStatus
                    FROM [sqladmin].[ConsultationBookingPayments] P WITH (UPDLOCK, ROWLOCK)
                    INNER JOIN [sqladmin].[ConsultationBookings] B ON B.BookingID=P.BookingID
                    WHERE P.MerchantOrderID=@OrderID AND P.GatewayName=N'Zaakpay';", con))
                {
                    cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                    con.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            ShowMessage("This payment reference was not found. Please contact TJ Home Care.");
                            return;
                        }
                        bookingId = Convert.ToInt32(r["BookingID"]);
                        token = Convert.ToString(r["PublicToken"]);
                        expectedPaisa = Convert.ToInt64(Math.Round(Convert.ToDecimal(r["TotalAmount"]) * 100M, 0, MidpointRounding.AwayFromZero));
                        attemptPaisa = Convert.ToInt64(Math.Round(Convert.ToDecimal(r["AttemptAmount"]) * 100M, 0, MidpointRounding.AwayFromZero));
                        currentPaymentStatus = Convert.ToString(r["AttemptPaymentStatus"]);
                        currentBookingPaymentStatus = Convert.ToString(r["BookingPaymentStatus"]);
                    }
                }

                // A repeated gateway POST must never downgrade a previously paid booking.
                if (String.Equals(currentPaymentStatus, "Paid", StringComparison.OrdinalIgnoreCase) &&
                    String.Equals(currentBookingPaymentStatus, "Paid", StringComparison.OrdinalIgnoreCase))
                {
                    RedirectToSuccess(token);
                    return;
                }

                if (!ZaakpayGateway.VerifyResponseChecksum(Request.Form, checksumSecret))
                {
                    string diag = ZaakpayGateway.DiagnoseResponseChecksum(Request.Form, checksumSecret);
                    var fields = new StringBuilder();
                    foreach (string k in Request.Form.AllKeys)
                        if (k != null && !k.Equals("checksum", StringComparison.OrdinalIgnoreCase))
                            fields.Append(k).Append("=").Append(Request.Form[k]).Append("&");
                    SaveVerificationFailure(orderId, "Checksum mismatch. " + diag + " | " + fields);
                    RedirectToPayment(token, "verify");
                    return;
                }

                string responseOrder = (Request.Form["orderId"] ?? String.Empty).Trim();
                string responseCode = (Request.Form["responseCode"] ?? String.Empty).Trim();
                string responseAmountText = (Request.Form["amount"] ?? String.Empty).Trim();
                string transactionId = (Request.Form["pgTransId"] ?? String.Empty).Trim();
                long responsePaisa;
                if (!String.Equals(orderId, responseOrder, StringComparison.Ordinal) ||
                    !Int64.TryParse(responseAmountText, NumberStyles.None, CultureInfo.InvariantCulture, out responsePaisa) ||
                    responsePaisa != expectedPaisa ||
                    responsePaisa != attemptPaisa)
                {
                    SaveVerificationFailure(orderId, "Zaakpay response order ID or amount did not match the stored booking.");
                    RedirectToPayment(token, "verify");
                    return;
                }

                string environment =
    (ConfigurationManager.AppSettings["ZaakpayEnvironment"]
     ?? "Staging").Trim();

                bool stagingSuccess =
                    String.Equals(environment, "Staging",
                        StringComparison.OrdinalIgnoreCase)
                    && responseCode == "402";

                bool paid =
                    (responseCode == "100" || stagingSuccess)
                    && transactionId.Length > 0;

                SaveVerifiedResponse(orderId, bookingId, transactionId, paid, BuildResponseSummary());

                if (paid) RedirectToSuccess(token);
                else RedirectToPayment(token, "failed");
            }
            catch (Exception)
            {
                ShowMessage("We could not complete payment verification. Please contact TJ Home Care before attempting another payment.");
            }
        }

        private void SaveVerifiedResponse(string orderId, int bookingId, string transactionId, bool paid, string responseSummary)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        string attemptStatus = paid ? "Paid" : "Failed";
                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookingPayments]
                            SET PaymentStatus=@Status, GatewayTransactionID=@TransactionID,
                                UpdatedOn=GETDATE(), GatewayResponse=@Response, IsVerified=1
                            WHERE MerchantOrderID=@OrderID AND GatewayName=N'Zaakpay'
                              AND PaymentStatus<>N'Paid';", con, tran))
                        {
                            cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = attemptStatus;
                            cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = transactionId.Length == 0 ? (object)DBNull.Value : transactionId;
                            cmd.Parameters.Add("@Response", SqlDbType.NVarChar, -1).Value = responseSummary;
                            cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                            cmd.ExecuteNonQuery();
                        }

                        if (paid)
                        {
                            using (SqlCommand cmd = new SqlCommand(@"
                                UPDATE [sqladmin].[ConsultationBookings]
                                SET PaymentStatus=N'Paid', BookingStatus=N'Confirmed',
                                    PaymentGateway=N'Zaakpay', PaymentOrderID=@OrderID,
                                    PaymentTransactionID=@TransactionID, PaidOn=GETDATE(), UpdatedDate=GETDATE()
                                WHERE BookingID=@BookingID AND PaymentStatus<>N'Paid';", con, tran))
                            {
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                                cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = transactionId;
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            using (SqlCommand cmd = new SqlCommand(@"
                                UPDATE [sqladmin].[ConsultationBookings]
                                SET PaymentStatus=N'Failed', PaymentGateway=N'Zaakpay',
                                    PaymentOrderID=@OrderID, UpdatedDate=GETDATE()
                                WHERE BookingID=@BookingID AND PaymentOrderID=@OrderID
                                  AND PaymentStatus<>N'Paid';", con, tran))
                            {
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                cmd.ExecuteNonQuery();
                            }
                        }
                        tran.Commit();
                    }
                    catch
                    {
                        tran.Rollback();
                        throw;
                    }
                }
            }
        }

        private void SaveVerificationFailure(string orderId, string note)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE [sqladmin].[ConsultationBookingPayments]
                SET PaymentStatus=N'VerificationFailed', UpdatedOn=GETDATE(),
                    GatewayResponse=@Response, IsVerified=0
                WHERE MerchantOrderID=@OrderID AND GatewayName=N'Zaakpay'
                  AND PaymentStatus<>N'Paid';", con))
            {
                cmd.Parameters.Add("@Response", SqlDbType.NVarChar, -1).Value = note;
                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private string BuildResponseSummary()
        {
            string[] names = new string[] { "orderId", "responseCode", "responseDescription", "amount", "paymentMode", "paymentMethod", "bank", "bankid", "pgTransId", "pgTransTime", "cardScheme", "cardToken" };
            StringBuilder output = new StringBuilder();
            int i;
            for (i = 0; i < names.Length; i++)
            {
                string value = Request.Form[names[i]];
                if (!String.IsNullOrEmpty(value))
                {
                    if (output.Length > 0) output.Append(" | ");
                    output.Append(names[i]).Append("=").Append(value);
                }
            }
            return output.ToString();
        }

        private void RedirectToSuccess(string token)
        {
            Response.Redirect(ResolveUrl("~/ConsultationBookingSuccessV2.aspx?t=" + HttpUtility.UrlEncode(token)), false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void RedirectToPayment(string token, string result)
        {
            Response.Redirect(ResolveUrl("~/ConsultationPaymentV2.aspx?t=" + HttpUtility.UrlEncode(token) + "&result=" + HttpUtility.UrlEncode(result)), false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowMessage(string message)
        {
            Response.Clear();
            Response.ContentType = "text/html";
            Response.Write("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>Payment Status</title></head><body style=\"font-family:Arial,sans-serif;padding:30px;color:#263238\"><h2>Payment Status</h2><p>" + HttpUtility.HtmlEncode(message) + "</p><a href=\"" + HttpUtility.HtmlAttributeEncode(ResolveUrl("~/")) + "\">Return to TJ Home Care</a></body></html>");
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
