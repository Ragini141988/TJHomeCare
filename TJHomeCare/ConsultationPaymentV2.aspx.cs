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
        private string Token { get { return (Request.QueryString["t"] ?? "").Trim(); } }
        private string ConnectionString
        {
            get
            {
                ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"];
                if (settings == null) throw new ConfigurationErrorsException("Connection string hospi2yp_tabletjobssConnectionString_V02 was not found.");
                return settings.ConnectionString;
            }
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

            string sql = @"
                SELECT B.BookingID, B.BookingReference, B.CustomerName, B.AppointmentDate,
                       B.AppointmentTime, B.ConsultationFee, B.GSTPercent, B.GSTAmount,
                       B.TotalAmount, B.PaymentStatus, CP.FullName, SC.ServiceName
                FROM [sqladmin].[ConsultationBookings] B
                INNER JOIN [sqladmin].[CaregiverProfiles] CP ON CP.CaregiverID = B.CaregiverID
                INNER JOIN [sqladmin].[ServiceCategories] SC ON SC.ServiceCategoryID = B.ServiceCategoryID
                WHERE B.PublicToken = @Token;";

            try
            {
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
                        DateTime d = Convert.ToDateTime(r["AppointmentDate"]);
                        lblAppointment.Text = d.ToString("ddd, dd MMM yyyy") + " at " + HttpUtility.HtmlEncode(Convert.ToString(r["AppointmentTime"]));
                        lblFee.Text = Money(Convert.ToDecimal(r["ConsultationFee"]));
                        lblGstPercent.Text = Convert.ToDecimal(r["GSTPercent"]).ToString("0.##");
                        lblGst.Text = Money(Convert.ToDecimal(r["GSTAmount"]));
                        lblTotal.Text = Money(Convert.ToDecimal(r["TotalAmount"]));

                        string status = Convert.ToString(r["PaymentStatus"]);
                        if (String.Equals(status, "Paid", StringComparison.OrdinalIgnoreCase))
                        {
                            Response.Redirect(ResolveUrl("~/ConsultationBookingSuccessV2.aspx?t=" + HttpUtility.UrlEncode(Token)), false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }
                    }
                }

                string mode = (ConfigurationManager.AppSettings["ConsultationPaymentMode"] ?? "Disabled").Trim();
                string result = (Request.QueryString["result"] ?? String.Empty).Trim();
                if (result == "failed") ShowError("The payment was not completed. You may try again or contact TJ Home Care.");
                else if (result == "verify") ShowError("We could not verify the payment response. No payment has been marked as successful. Please contact TJ Home Care with your booking reference.");

                if (String.Equals(mode, "Demo", StringComparison.OrdinalIgnoreCase))
                {
                    btnDemoPay.Visible = true;
                    btnZaakpayPay.Visible = false;
                    lblModeMessage.Text = "TEST MODE: no real payment will be collected. The button below records a simulated payment only.";
                }
                else if (String.Equals(mode, "Zaakpay", StringComparison.OrdinalIgnoreCase))
                {
                    btnDemoPay.Visible = false;
                    bool configured = IsZaakpayConfigured();
                    btnZaakpayPay.Visible = configured;
                    btnZaakpayPay.Enabled = configured;
                    lblModeMessage.Text = configured
                        ? "You will be redirected to Zaakpay's secure hosted checkout. Do not refresh the page while the payment request is starting."
                        : "Zaakpay configuration is incomplete. Please contact the website administrator.";
                }
                else
                {
                    btnDemoPay.Visible = false;
                    btnZaakpayPay.Visible = false;
                    lblModeMessage.Text = "Online payment is currently disabled. Please contact TJ Home Care.";
                }
            }
            catch (Exception)
            {
                ShowError("Unable to load payment details. Please try again later.");
                pnlPayment.Visible = false;
            }
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
                                    if (!r.Read()) throw new Exception("Booking not found.");
                                    if (String.Equals(Convert.ToString(r["PaymentStatus"]), "Paid", StringComparison.OrdinalIgnoreCase))
                                        throw new Exception("This booking is already paid.");
                                    bookingId = Convert.ToInt32(r["BookingID"]);
                                    amount = Convert.ToDecimal(r["TotalAmount"]);
                                }
                            }

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
                                p.Precision = 10; p.Scale = 2; p.Value = amount;
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
                                if (cmd.ExecuteNonQuery() != 1) throw new Exception("Booking could not be updated.");
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
            catch (Exception)
            {
                ShowError("We could not create the Zaakpay payment request. Please retry or contact TJ Home Care.");
            }
        }

        private static bool IsZaakpayConfigured()
        {
            string merchant = (ConfigurationManager.AppSettings["ZaakpayMerchantIdentifier"] ?? String.Empty).Trim();
            string secret = (ConfigurationManager.AppSettings["ZaakpaySecretKey"] ?? String.Empty).Trim();
            return merchant.Length > 0 && secret.Length > 0 &&
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
                                    if (!r.Read()) throw new Exception("Booking not found.");
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
                                p.Precision = 10; p.Scale = 2; p.Value = amount;
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
                                    throw new Exception("Payment could not be recorded.");
                            }
                        }
                        tran.Commit();
                        Response.Redirect(ResolveUrl("~/ConsultationBookingSuccessV2.aspx?t=" + HttpUtility.UrlEncode(Token)), false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    catch
                    {
                        tran.Rollback();
                        ShowError("We could not record the test payment. Please retry or contact TJ Home Care.");
                    }
                }
            }
        }

        private static string Money(decimal value)
        {
            return "₹" + value.ToString("N2", CultureInfo.GetCultureInfo("en-IN"));
        }

        private void ShowError(string message) { lblError.Text = HttpUtility.HtmlEncode(message); }
    }
}
