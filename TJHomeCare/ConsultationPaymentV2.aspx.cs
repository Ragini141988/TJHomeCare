using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ConsultationPaymentV2 : Page
    {
        private string Token { get { return (Request.QueryString["t"] ?? String.Empty).Trim(); } }

        private string ConnectionString
        {
            get
            {
                ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"];
                if (settings == null) throw new ConfigurationErrorsException("Connection string hospi2yp_tabletjobssConnectionString_V02 was not found.");
                return settings.ConnectionString;
            }
        }

        private sealed class LatestAttempt
        {
            public string OrderID;
            public string Status;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadBooking();
        }

        private void LoadBooking()
        {
            if (Token.Length != 32)
            {
                ShowError("This payment link is invalid. Please return to the consultation page and try again.");
                pnlPayment.Visible = false;
                return;
            }

            const string sql = @"
                SELECT B.BookingID, B.BookingReference, B.CustomerName, B.AppointmentDate,
                       B.AppointmentTime, B.ConsultationFee, B.GSTPercent, B.GSTAmount,
                       B.TotalAmount, B.PaymentStatus, CP.FullName, SC.ServiceName
                FROM [sqladmin].[ConsultationBookings] B
                INNER JOIN [sqladmin].[CaregiverProfiles] CP ON CP.CaregiverID = B.CaregiverID
                INNER JOIN [sqladmin].[ServiceCategories] SC ON SC.ServiceCategoryID = B.ServiceCategoryID
                WHERE B.PublicToken = @Token;";

            try
            {
                string bookingStatus;
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                    con.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            ShowError("Booking details could not be found. Please contact TJ Home Care.");
                            pnlPayment.Visible = false;
                            return;
                        }

                        lblBookingReference.Text = HttpUtility.HtmlEncode(Convert.ToString(r["BookingReference"]));
                        lblProfessional.Text = HttpUtility.HtmlEncode(Convert.ToString(r["FullName"]));
                        lblService.Text = HttpUtility.HtmlEncode(Convert.ToString(r["ServiceName"]));
                        lblCustomer.Text = HttpUtility.HtmlEncode(Convert.ToString(r["CustomerName"]));
                        DateTime appointmentDate = Convert.ToDateTime(r["AppointmentDate"]);
                        lblAppointment.Text = appointmentDate.ToString("ddd, dd MMM yyyy") + " at " + HttpUtility.HtmlEncode(Convert.ToString(r["AppointmentTime"]));
                        lblFee.Text = Money(Convert.ToDecimal(r["ConsultationFee"]));
                        lblGstPercent.Text = Convert.ToDecimal(r["GSTPercent"]).ToString("0.##");
                        lblGst.Text = Money(Convert.ToDecimal(r["GSTAmount"]));
                        lblTotal.Text = Money(Convert.ToDecimal(r["TotalAmount"]));
                        bookingStatus = Convert.ToString(r["PaymentStatus"]);
                    }
                }

                if (String.Equals(bookingStatus, "Paid", StringComparison.OrdinalIgnoreCase))
                {
                    RedirectToSuccess();
                    return;
                }

                string mode = (ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim();
                LatestAttempt latest = GetLatestAttempt();

                if (latest != null && String.Equals(latest.Status, "Paid", StringComparison.OrdinalIgnoreCase))
                {
                    // A previously verified attempt should already have confirmed the booking.
                    // Run the same status check to safely repair any interrupted database update.
                    CheckLatestStatusAndRespond(latest, false);
                    return;
                }

                if (latest != null && IsUnresolved(latest.Status))
                {
                    ShowPendingControls("A previous payment request is awaiting confirmation. Do not make another payment. Select Check Payment Status below.");
                    return;
                }

                ShowPayControls(mode);
                string result = (Request.QueryString["result"] ?? String.Empty).Trim();
                if (result == "failed" || (latest != null && String.Equals(latest.Status, "Failed", StringComparison.OrdinalIgnoreCase)))
                    ShowError("Zaakpay confirmed that the previous payment was not completed. You may try again.");
                else if (result == "verify")
                    ShowError("We could not confirm the previous payment yet. Please check its status before trying again.");
            }
            catch (Exception)
            {
                ShowError("Unable to load payment details. Please try again later.");
                pnlPayment.Visible = false;
            }
        }

        protected void btnCheckStatus_Click(object sender, EventArgs e)
        {
            if (Token.Length != 32)
            {
                ShowError("This payment link is invalid.");
                ShowPendingControls("Please contact TJ Home Care with your booking reference.");
                return;
            }

            try
            {
                LatestAttempt latest = GetLatestAttempt();
                if (latest == null || String.IsNullOrEmpty(latest.OrderID))
                {
                    ShowError("No Zaakpay payment attempt was found for this booking.");
                    ShowPayControls((ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim());
                    return;
                }
                CheckLatestStatusAndRespond(latest, true);
            }
            catch (Exception)
            {
                ShowError("Zaakpay could not be reached right now. Do not make another payment. Please try Check Payment Status again shortly.");
                ShowPendingControls("The previous payment is still unresolved. A new payment is disabled to prevent a duplicate charge.");
            }
        }

        private void CheckLatestStatusAndRespond(LatestAttempt latest, bool showMessages)
        {
            string merchant = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
            string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            string environment = (ConfigurationManager.AppSettings["ZaakpayEnvironment"] ?? String.Empty).Trim();
            if (merchant.Length == 0 || secret.Length == 0 || environment.Length == 0)
                throw new ConfigurationErrorsException("Zaakpay is not fully configured.");

            ZaakpayReconcileResult result = ZaakpayPaymentReconciler.CheckAndUpdate(
                ConnectionString, latest.OrderID, merchant, secret, environment);

            if (String.Equals(result.State, "Paid", StringComparison.OrdinalIgnoreCase))
            {
                RedirectToSuccess();
                return;
            }

            if (String.Equals(result.State, "Failed", StringComparison.OrdinalIgnoreCase))
            {
                ShowError("Zaakpay confirmed that this payment failed. You may retry the payment.");
                ShowPayControls((ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim());
                return;
            }

            if (showMessages) ShowError("Zaakpay has not confirmed the final result yet. Please do not pay again.");
            ShowPendingControls("The payment status is pending or requires review. Check again shortly, or contact TJ Home Care. A new payment is disabled for your safety.");
        }

        private LatestAttempt GetLatestAttempt()
        {
            const string sql = @"
                SELECT TOP 1 P.MerchantOrderID, P.PaymentStatus
                FROM [sqladmin].[ConsultationBookingPayments] P
                INNER JOIN [sqladmin].[ConsultationBookings] B ON B.BookingID=P.BookingID
                WHERE B.PublicToken=@Token AND P.GatewayName=N'Zaakpay'
                ORDER BY P.PaymentID DESC;";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return null;
                    LatestAttempt latest = new LatestAttempt();
                    latest.OrderID = Convert.ToString(r["MerchantOrderID"]);
                    latest.Status = Convert.ToString(r["PaymentStatus"]);
                    return latest;
                }
            }
        }

        private static bool IsUnresolved(string status)
        {
            return String.Equals(status, "Initiated", StringComparison.OrdinalIgnoreCase) ||
                   String.Equals(status, "Processing", StringComparison.OrdinalIgnoreCase) ||
                   String.Equals(status, "VerificationFailed", StringComparison.OrdinalIgnoreCase);
        }

        private void ShowPayControls(string mode)
        {
            btnCheckStatus.Visible = false;
            btnCheckStatus.Enabled = false;

            if (String.Equals(mode, "Demo", StringComparison.OrdinalIgnoreCase))
            {
                btnDemoPay.Visible = true;
                btnZaakpayPay.Visible = false;
                lblModeMessage.Text = HttpUtility.HtmlEncode("TEST MODE: no real payment will be collected. The button below records a simulated payment only.");
                lblPaymentNote.Text = HttpUtility.HtmlEncode("Demo transactions are for layout and workflow testing only. They are not proof of actual customer payment.");
            }
            else if (String.Equals(mode, "Zaakpay", StringComparison.OrdinalIgnoreCase))
            {
                btnDemoPay.Visible = false;
                bool configured = IsZaakpayConfigured();
                btnZaakpayPay.Visible = configured;
                btnZaakpayPay.Enabled = configured;
                lblModeMessage.Text = HttpUtility.HtmlEncode(configured
                    ? "You will be redirected to Zaakpay's secure hosted checkout. Do not refresh the page while the payment request is starting."
                    : "Zaakpay configuration is incomplete. Please contact the website administrator.");
                lblPaymentNote.Text = HttpUtility.HtmlEncode("Your booking is confirmed only after TJ Home Care verifies the transaction directly with Zaakpay.");
            }
            else
            {
                btnDemoPay.Visible = false;
                btnZaakpayPay.Visible = false;
                lblModeMessage.Text = HttpUtility.HtmlEncode("Online payment is currently disabled. Please contact TJ Home Care.");
                lblPaymentNote.Text = String.Empty;
            }
        }

        private void ShowPendingControls(string message)
        {
            btnDemoPay.Visible = false;
            btnZaakpayPay.Visible = false;
            btnCheckStatus.Visible = true;
            btnCheckStatus.Enabled = true;
            lblModeMessage.Text = HttpUtility.HtmlEncode(message);
            lblPaymentNote.Text = HttpUtility.HtmlEncode("A new payment is temporarily disabled until the earlier Zaakpay transaction is confirmed as failed or successful.");
        }

        protected void btnZaakpayPay_Click(object sender, EventArgs e)
        {
            if (!String.Equals((ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim(), "Zaakpay", StringComparison.OrdinalIgnoreCase) || !IsZaakpayConfigured())
            {
                ShowError("Zaakpay payment is not configured.");
                return;
            }
            if (Token.Length != 32) { ShowError("Invalid booking link."); return; }

            string orderId = "TJHC" + DateTime.UtcNow.ToString("yyMMddHHmmss", CultureInfo.InvariantCulture) + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpperInvariant();
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        try
                        {
                            int bookingId;
                            decimal amount;
                            using (SqlCommand cmd = new SqlCommand(@"
                                SELECT BookingID, TotalAmount, PaymentStatus
                                FROM [sqladmin].[ConsultationBookings] WITH (UPDLOCK, ROWLOCK)
                                WHERE PublicToken=@Token;", con, tran))
                            {
                                cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                                using (SqlDataReader r = cmd.ExecuteReader())
                                {
                                    if (!r.Read()) throw new InvalidOperationException("Booking not found.");
                                    if (String.Equals(Convert.ToString(r["PaymentStatus"]), "Paid", StringComparison.OrdinalIgnoreCase))
                                        throw new InvalidOperationException("This booking is already paid.");
                                    bookingId = Convert.ToInt32(r["BookingID"]);
                                    amount = Convert.ToDecimal(r["TotalAmount"]);
                                }
                            }

                            // Serialize attempts for this booking and prevent a second charge
                            // while the latest Zaakpay attempt is unresolved.
                            using (SqlCommand cmd = new SqlCommand(@"
                                SELECT TOP 1 PaymentStatus
                                FROM [sqladmin].[ConsultationBookingPayments] WITH (UPDLOCK, HOLDLOCK)
                                WHERE BookingID=@BookingID AND GatewayName=N'Zaakpay'
                                ORDER BY PaymentID DESC;", con, tran))
                            {
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                object previous = cmd.ExecuteScalar();
                                if (previous != null && previous != DBNull.Value && IsUnresolved(Convert.ToString(previous)))
                                    throw new InvalidOperationException("A previous payment is still being verified. Use Check Payment Status before trying again.");
                            }

                            long amountPaisa = Convert.ToInt64(Math.Round(amount * 100M, 0, MidpointRounding.AwayFromZero));
                            if (amountPaisa < 100 || amountPaisa > 10000000)
                                throw new InvalidOperationException("The amount is outside Zaakpay's permitted transaction range.");

                            using (SqlCommand cmd = new SqlCommand(@"
                                INSERT INTO [sqladmin].[ConsultationBookingPayments]
                                (BookingID, GatewayName, MerchantOrderID, Amount, Currency,
                                 PaymentStatus, InitiatedOn, UpdatedOn, IsVerified)
                                VALUES (@BookingID, N'Zaakpay', @OrderID, @Amount, 'INR',
                                        N'Initiated', GETDATE(), GETDATE(), 0);", con, tran))
                            {
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                                SqlParameter p = cmd.Parameters.Add("@Amount", SqlDbType.Decimal);
                                p.Precision = 10;
                                p.Scale = 2;
                                p.Value = amount;
                                cmd.ExecuteNonQuery();
                            }

                            using (SqlCommand cmd = new SqlCommand(@"
                                UPDATE [sqladmin].[ConsultationBookings]
                                SET PaymentGateway=N'Zaakpay', PaymentOrderID=@OrderID,
                                    PaymentStatus=N'Pending', UpdatedDate=GETDATE()
                                WHERE BookingID=@BookingID AND PaymentStatus<>N'Paid';", con, tran))
                            {
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                if (cmd.ExecuteNonQuery() != 1) throw new InvalidOperationException("Booking could not be updated.");
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

                Response.Redirect(ResolveUrl("~/ZaakpayRedirectV2.aspx?o=" + HttpUtility.UrlEncode(orderId)), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (InvalidOperationException ex)
            {
                ShowError(ex.Message);
                try
                {
                    LatestAttempt latest = GetLatestAttempt();
                    if (latest != null && IsUnresolved(latest.Status))
                        ShowPendingControls("A previous payment is still being verified. Please check its status before trying again.");
                }
                catch { }
            }
            catch (Exception)
            {
                ShowError("We could not create the Zaakpay payment request. Please retry or contact TJ Home Care.");
            }
        }

        private static bool IsZaakpayConfigured()
        {
            string merchant = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
            string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            string environment = (ConfigurationManager.AppSettings["ZaakpayEnvironment"] ?? String.Empty).Trim();
            return merchant.Length > 0 && secret.Length > 0 &&
                   environment.Length > 0 &&
                   merchant.IndexOf("REPLACE", StringComparison.OrdinalIgnoreCase) < 0 &&
                   secret.IndexOf("REPLACE", StringComparison.OrdinalIgnoreCase) < 0;
        }

        protected void btnDemoPay_Click(object sender, EventArgs e)
        {
            string mode = (ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim();
            if (!String.Equals(mode, "Demo", StringComparison.OrdinalIgnoreCase))
            {
                ShowError("Demo payment is disabled.");
                btnDemoPay.Enabled = false;
                return;
            }
            if (Token.Length != 32) { ShowError("Invalid booking link."); return; }

            string tx = "DEMO-" + Guid.NewGuid().ToString("N").ToUpperInvariant();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        int changed;
                        decimal amount;
                        int bookingId;
                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookings]
                            SET PaymentStatus=N'Paid', BookingStatus=N'Confirmed',
                                PaymentGateway=N'DEMO', PaymentTransactionID=@TransactionID,
                                PaidOn=GETDATE(), UpdatedDate=GETDATE()
                            WHERE PublicToken=@Token AND PaymentStatus<>N'Paid';
                            SELECT @@ROWCOUNT;", con, tran))
                        {
                            cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = tx;
                            cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                            changed = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                        if (changed == 1)
                        {
                            using (SqlCommand cmd = new SqlCommand("SELECT BookingID, TotalAmount FROM [sqladmin].[ConsultationBookings] WHERE PublicToken=@Token;", con, tran))
                            {
                                cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                                using (SqlDataReader r = cmd.ExecuteReader())
                                {
                                    if (!r.Read()) throw new InvalidOperationException("Booking not found.");
                                    bookingId = Convert.ToInt32(r["BookingID"]);
                                    amount = Convert.ToDecimal(r["TotalAmount"]);
                                }
                            }
                            using (SqlCommand cmd = new SqlCommand(@"
                                INSERT INTO [sqladmin].[ConsultationBookingPayments]
                                (BookingID, GatewayName, MerchantOrderID, GatewayTransactionID,
                                 Amount, Currency, PaymentStatus, InitiatedOn, UpdatedOn,
                                 GatewayResponse, IsVerified)
                                VALUES (@BookingID, N'DEMO', @OrderID, @TransactionID,
                                        @Amount, 'INR', N'Paid', GETDATE(), GETDATE(),
                                        N'DEMO TEST PAYMENT ONLY - no funds collected.', 1);", con, tran))
                            {
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = "DEMO-ORDER-" + bookingId.ToString();
                                cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = tx;
                                SqlParameter p = cmd.Parameters.Add("@Amount", SqlDbType.Decimal);
                                p.Precision = 10;
                                p.Scale = 2;
                                p.Value = amount;
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            using (SqlCommand cmd = new SqlCommand("SELECT PaymentStatus FROM [sqladmin].[ConsultationBookings] WHERE PublicToken=@Token;", con, tran))
                            {
                                cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                                object current = cmd.ExecuteScalar();
                                if (current == null || current == DBNull.Value || !String.Equals(Convert.ToString(current), "Paid", StringComparison.OrdinalIgnoreCase))
                                    throw new InvalidOperationException("Payment could not be recorded.");
                            }
                        }
                        tran.Commit();
                        RedirectToSuccess();
                    }
                    catch
                    {
                        tran.Rollback();
                        ShowError("We could not record the test payment. Please retry or contact TJ Home Care.");
                    }
                }
            }
        }

        private void RedirectToSuccess()
        {
            Response.Redirect(ResolveUrl("~/ConsultationBookingSuccessV2.aspx?t=" + HttpUtility.UrlEncode(Token)), false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private static string Money(decimal value)
        {
            return "₹" + value.ToString("N2", CultureInfo.GetCultureInfo("en-IN"));
        }

        private void ShowError(string message)
        {
            lblError.Text = HttpUtility.HtmlEncode(message);
        }
    }
}
