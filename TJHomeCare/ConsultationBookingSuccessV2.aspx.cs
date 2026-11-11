using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ConsultationBookingSuccessV2 : Page
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
            if (!IsPostBack) LoadConfirmation();
        }

        private void LoadConfirmation()
        {
            if (Token.Length != 32) { ShowError("Invalid booking link."); return; }
            string sql = @"
                SELECT B.BookingReference, B.PaymentStatus, B.TotalAmount, B.AppointmentDate,
                       B.AppointmentTime, B.PaymentTransactionID, CP.FullName, SC.ServiceName
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
                        if (!r.Read()) { ShowError("Booking details were not found. Please contact TJ Home Care."); return; }
                        string paymentStatus = Convert.ToString(r["PaymentStatus"]);
                        if (!String.Equals(paymentStatus, "Paid", StringComparison.OrdinalIgnoreCase))
                        {
                            ShowError("Payment is not marked as successful yet. Please check the payment status or contact TJ Home Care.");
                            return;
                        }
                        lblBookingReference.Text = HttpUtility.HtmlEncode(Convert.ToString(r["BookingReference"]));
                        lblService.Text = HttpUtility.HtmlEncode(Convert.ToString(r["ServiceName"]));
                        lblProfessional.Text = HttpUtility.HtmlEncode(Convert.ToString(r["FullName"]));
                        lblDate.Text = Convert.ToDateTime(r["AppointmentDate"]).ToString("ddd, dd MMM yyyy");
                        lblTime.Text = HttpUtility.HtmlEncode(Convert.ToString(r["AppointmentTime"]));
                        lblAmount.Text = "₹" + Convert.ToDecimal(r["TotalAmount"]).ToString("N2", CultureInfo.GetCultureInfo("en-IN"));
                        lblPaymentStatus.Text = "Paid";
                        lblTransaction.Text = HttpUtility.HtmlEncode(Convert.ToString(r["PaymentTransactionID"]));
                        //lnkManage.NavigateUrl = "ConsultationBookingManageV2.aspx?t=" + HttpUtility.UrlEncode(Token);
                        pnlSuccess.Visible = true;
                        lblError.Visible = false;
                    }
                }
            }
            catch (Exception)
            {
                ShowError("Unable to load your confirmation details. Please try again later.");
            }
        }

        private void ShowError(string message)
        {
            pnlSuccess.Visible = false;
            lblError.Visible = true;
            lblError.Text = HttpUtility.HtmlEncode(message);
        }
    }
}
