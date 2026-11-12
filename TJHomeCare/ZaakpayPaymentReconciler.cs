using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace TJHomeCare
{
    public sealed class ZaakpayReconcileResult
    {
        public string State = "Pending"; // Paid, Failed, Pending
        public string BookingToken = String.Empty;
        public string OrderId = String.Empty;
        public string Message = String.Empty;
    }

    /// <summary>
    /// One shared server-side reconciliation path for both Zaakpay's browser
    /// return callback and the customer's Check Payment Status button.
    /// Never trusts browser-posted amount, status or transaction ID.
    /// </summary>
    public static class ZaakpayPaymentReconciler
    {
        private sealed class LocalPayment
        {
            public long PaymentID;
            public int BookingID;
            public string BookingToken;
            public decimal BookingAmount;
            public decimal AttemptAmount;
            public string BookingStatus;
            public string AttemptStatus;
        }

        public static ZaakpayReconcileResult CheckAndUpdate(string connectionString,
            string orderId, string merchantIdentifier, string secretKey, string environment)
        {
            if (String.IsNullOrEmpty(connectionString)) throw new ArgumentException("Database connection string is required.");
            if (String.IsNullOrEmpty(orderId)) throw new ArgumentException("Merchant order ID is required.");

            LocalPayment local = LoadLocalPayment(connectionString, orderId);
            ZaakpayReconcileResult result = new ZaakpayReconcileResult();
            result.BookingToken = local.BookingToken;
            result.OrderId = orderId;

            if (String.Equals(local.AttemptStatus, "Paid", StringComparison.OrdinalIgnoreCase) &&
                String.Equals(local.BookingStatus, "Paid", StringComparison.OrdinalIgnoreCase))
            {
                result.State = "Paid";
                result.Message = "This payment was already verified and recorded.";
                return result;
            }

            ZaakpayStatusResult gateway = ZaakpayStatusClient.Check(orderId, merchantIdentifier, secretKey, environment);

            if (!gateway.ApiSuccess ||
                !String.Equals(gateway.OrderId, orderId, StringComparison.Ordinal) ||
                !String.Equals(gateway.MerchantIdentifier, merchantIdentifier, StringComparison.Ordinal))
            {
                result.State = "Pending";
                result.Message = "Zaakpay has not returned a complete, matching status response. Do not make another payment yet.";
                SavePending(connectionString, local.PaymentID, gateway.ToSafeSummary());
                return result;
            }

            long statusPaisa;
            long bookingPaisa = ToPaisa(local.BookingAmount);
            long attemptPaisa = ToPaisa(local.AttemptAmount);
            if (!Int64.TryParse(gateway.AmountPaisa, NumberStyles.None, CultureInfo.InvariantCulture, out statusPaisa) ||
                statusPaisa != bookingPaisa || statusPaisa != attemptPaisa)
            {
                result.State = "Pending";
                result.Message = "The amount returned by Zaakpay does not match the stored booking. Do not make another payment; contact TJ Home Care.";
                SavePending(connectionString, local.PaymentID, "Amount mismatch. " + gateway.ToSafeSummary());
                return result;
            }

            if (gateway.IsSuccessfulTransaction)
            {
                SaveSuccessful(connectionString, local, orderId, gateway.TransactionId, gateway.ToSafeSummary());
                result.State = "Paid";
                result.Message = "Zaakpay confirmed the payment successfully.";
                return result;
            }

            if (gateway.TransactionStatus == "1")
            {
                SaveFailed(connectionString, local, orderId, gateway.TransactionId, gateway.ToSafeSummary());
                result.State = "Failed";
                result.Message = "Zaakpay confirmed that this transaction failed. You may retry the payment.";
                return result;
            }

            result.State = "Pending";
            result.Message = "Zaakpay reports that this transaction is still pending or needs manual review. Do not make another payment yet.";
            SavePending(connectionString, local.PaymentID, gateway.ToSafeSummary());
            return result;
        }

        private static LocalPayment LoadLocalPayment(string connectionString, string orderId)
        {
            const string sql = @"
                SELECT TOP 1 P.PaymentID, P.BookingID, P.Amount AS AttemptAmount,
                       P.PaymentStatus AS AttemptStatus, B.PublicToken,
                       B.TotalAmount AS BookingAmount, B.PaymentStatus AS BookingStatus
                FROM [sqladmin].[ConsultationBookingPayments] P
                INNER JOIN [sqladmin].[ConsultationBookings] B ON B.BookingID=P.BookingID
                WHERE P.MerchantOrderID=@OrderID AND P.GatewayName=N'Zaakpay';";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) throw new InvalidOperationException("No TJ Home Care payment attempt matches this Zaakpay order ID.");
                    LocalPayment p = new LocalPayment();
                    p.PaymentID = Convert.ToInt64(r["PaymentID"]);
                    p.BookingID = Convert.ToInt32(r["BookingID"]);
                    p.AttemptAmount = Convert.ToDecimal(r["AttemptAmount"]);
                    p.AttemptStatus = Convert.ToString(r["AttemptStatus"]);
                    p.BookingToken = Convert.ToString(r["PublicToken"]);
                    p.BookingAmount = Convert.ToDecimal(r["BookingAmount"]);
                    p.BookingStatus = Convert.ToString(r["BookingStatus"]);
                    return p;
                }
            }
        }

        private static void SaveSuccessful(string connectionString, LocalPayment local,
            string orderId, string transactionId, string summary)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        int changed;
                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookingPayments]
                            SET PaymentStatus=N'Paid', GatewayTransactionID=@TransactionID,
                                UpdatedOn=GETDATE(), GatewayResponse=@Response, IsVerified=1
                            WHERE PaymentID=@PaymentID AND BookingID=@BookingID
                              AND MerchantOrderID=@OrderID AND GatewayName=N'Zaakpay'
                              AND PaymentStatus<>N'Paid';", con, tran))
                        {
                            cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = transactionId;
                            cmd.Parameters.Add("@Response", SqlDbType.NVarChar, -1).Value = summary;
                            cmd.Parameters.Add("@PaymentID", SqlDbType.BigInt).Value = local.PaymentID;
                            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = local.BookingID;
                            cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                            changed = cmd.ExecuteNonQuery();
                        }

                        if (changed == 0)
                        {
                            using (SqlCommand cmd = new SqlCommand(@"
                                SELECT COUNT(1) FROM [sqladmin].[ConsultationBookingPayments]
                                WHERE PaymentID=@PaymentID AND BookingID=@BookingID
                                  AND MerchantOrderID=@OrderID AND PaymentStatus=N'Paid'
                                  AND GatewayTransactionID=@TransactionID;", con, tran))
                            {
                                cmd.Parameters.Add("@PaymentID", SqlDbType.BigInt).Value = local.PaymentID;
                                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = local.BookingID;
                                cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                                cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = transactionId;
                                if (Convert.ToInt32(cmd.ExecuteScalar()) != 1)
                                    throw new InvalidOperationException("The verified payment attempt could not be updated safely.");
                            }
                        }

                        // A confirmed Zaakpay payment settles the booking. Never overwrite an existing paid transaction.
                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookings]
                            SET PaymentStatus=N'Paid', BookingStatus=N'Confirmed',
                                PaymentGateway=N'Zaakpay', PaymentOrderID=@OrderID,
                                PaymentTransactionID=@TransactionID,
                                PaidOn=ISNULL(PaidOn, GETDATE()), UpdatedDate=GETDATE()
                            WHERE BookingID=@BookingID AND PaymentStatus<>N'Paid';", con, tran))
                        {
                            cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                            cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = transactionId;
                            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = local.BookingID;
                            cmd.ExecuteNonQuery();
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

        private static void SaveFailed(string connectionString, LocalPayment local,
            string orderId, string transactionId, string summary)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookingPayments]
                            SET PaymentStatus=N'Failed', GatewayTransactionID=@TransactionID,
                                UpdatedOn=GETDATE(), GatewayResponse=@Response, IsVerified=1
                            WHERE PaymentID=@PaymentID AND BookingID=@BookingID
                              AND MerchantOrderID=@OrderID AND GatewayName=N'Zaakpay'
                              AND PaymentStatus<>N'Paid';", con, tran))
                        {
                            cmd.Parameters.Add("@TransactionID", SqlDbType.NVarChar, 100).Value = String.IsNullOrEmpty(transactionId) ? (object)DBNull.Value : transactionId;
                            cmd.Parameters.Add("@Response", SqlDbType.NVarChar, -1).Value = summary;
                            cmd.Parameters.Add("@PaymentID", SqlDbType.BigInt).Value = local.PaymentID;
                            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = local.BookingID;
                            cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                            cmd.ExecuteNonQuery();
                        }

                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE [sqladmin].[ConsultationBookings]
                            SET PaymentStatus=N'Failed', PaymentGateway=N'Zaakpay',
                                PaymentOrderID=@OrderID, UpdatedDate=GETDATE()
                            WHERE BookingID=@BookingID AND PaymentOrderID=@OrderID
                              AND PaymentStatus<>N'Paid';", con, tran))
                        {
                            cmd.Parameters.Add("@OrderID", SqlDbType.NVarChar, 100).Value = orderId;
                            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = local.BookingID;
                            cmd.ExecuteNonQuery();
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

        private static void SavePending(string connectionString, long paymentId, string summary)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE [sqladmin].[ConsultationBookingPayments]
                SET PaymentStatus=N'VerificationFailed', UpdatedOn=GETDATE(),
                    GatewayResponse=@Response, IsVerified=0
                WHERE PaymentID=@PaymentID AND PaymentStatus<>N'Paid';", con))
            {
                cmd.Parameters.Add("@Response", SqlDbType.NVarChar, -1).Value = summary;
                cmd.Parameters.Add("@PaymentID", SqlDbType.BigInt).Value = paymentId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static long ToPaisa(decimal rupees)
        {
            return Convert.ToInt64(Math.Round(rupees * 100M, 0, MidpointRounding.AwayFromZero));
        }
    }
}
