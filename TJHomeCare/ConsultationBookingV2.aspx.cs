using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Net.Mail;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ConsultationBookingV2 : Page
    {
        private int CaregiverID
        {
            get { int id; int.TryParse(Request.QueryString["caregiverId"], out id); return id; }
        }

        private int ServiceCategoryID
        {
            get { int id; int.TryParse(Request.QueryString["serviceId"], out id); return id; }
        }

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
            txtAppointmentTime.Attributes["step"] = "60";
            if (!IsPostBack)
            {
                txtAppointmentDate.Attributes["min"] = DateTime.Today.ToString("yyyy-MM-dd");
               
                LoadConsultationDetails();
            }
        }

        private bool LoadConsultationDetails()
        {
            string query = @"
                SELECT TOP 1 CP.CaregiverID, CP.FullName, SC.ServiceCategoryID,
                       SC.ServiceName, P.ConsultationFee, P.GSTPercent
                FROM [sqladmin].[GynecologistProfiles] CP
                INNER JOIN [sqladmin].[DoctorServices] CS ON CP.CaregiverID = CS.CaregiverID
                INNER JOIN [sqladmin].[ServiceCategories] SC ON CS.ServiceCategoryID = SC.ServiceCategoryID
                INNER JOIN [sqladmin].[ConsultationServicePricing] P ON P.ServiceCategoryID = SC.ServiceCategoryID AND P.IsActive = 1
                WHERE CP.CaregiverID = @CaregiverID AND SC.ServiceCategoryID = @ServiceCategoryID;";

            if (CaregiverID <= 0 || ServiceCategoryID <= 0)
            {
                ShowError("Invalid consultation details. Please select a professional again.");
                btnContinue.Enabled = false;
                return false;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = CaregiverID;
                    cmd.Parameters.Add("@ServiceCategoryID", SqlDbType.Int).Value = ServiceCategoryID;
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowError("This professional/service is unavailable or its consultation price has not been configured. Please contact TJ Home Care.");
                            btnContinue.Enabled = false;
                            return false;
                        }

                        string professional = Convert.ToString(reader["FullName"]);
                        string service = Convert.ToString(reader["ServiceName"]);
                        decimal fee = Convert.ToDecimal(reader["ConsultationFee"]);
                        decimal gstPercent = Convert.ToDecimal(reader["GSTPercent"]);
                        decimal gst = Math.Round(fee * gstPercent / 100M, 2, MidpointRounding.AwayFromZero);
                        decimal total = fee + gst;

                        lblProfessionalName.Text = HttpUtility.HtmlEncode(professional);
                        lblServiceName.Text = HttpUtility.HtmlEncode(service);
                        lblFee.Text = FormatMoney(fee);
                        lblGstPercent.Text = gstPercent.ToString("0.##");
                        lblGstAmount.Text = FormatMoney(gst);
                        lblTotalAmount.Text = FormatMoney(total);
                        btnContinue.Enabled = true;
                        lblErrorMessage.Text = "";
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                ShowError("Unable to load consultation details. Please try again later.");
                btnContinue.Enabled = false;
                return false;
            }
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid) return;

            if (!chkTerms.Checked)
            {
                ShowError("Please accept the consultation terms, cancellation/refund policy and privacy policy.");
                return;
            }

            if (!LoadConsultationDetails()) return;

            DateTime appointmentDate;
            if (!DateTime.TryParseExact(txtAppointmentDate.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out appointmentDate) || appointmentDate.Date < DateTime.Today)
            {
                ShowError("Please select a valid appointment date (today or a future date).");
                return;
            }

            DateTime appointmentTime;
            if (!DateTime.TryParseExact(txtAppointmentTime.Text.Trim(), new string[] { "HH:mm", "H:mm" }, CultureInfo.InvariantCulture, DateTimeStyles.None, out appointmentTime))
            {
                ShowError("Please select a valid appointment time.");
                return;
            }

            string email = txtEmail.Text.Trim();
            try { new MailAddress(email); }
            catch { ShowError("Please enter a valid email address."); return; }

            string bookingToken = Guid.NewGuid().ToString("N");
            string bookingReference = "TJHC-" + DateTime.Now.ToString("yyyyMMdd") + "-" + Guid.NewGuid().ToString("N").Substring(0, 6).ToUpperInvariant();

            string insertSql = @"
                INSERT INTO [sqladmin].[ConsultationBookings]
                (CaregiverID, ServiceCategoryID, CustomerName, Gender, City, State, Email,
                 ContactNumber, BookingStatus, CreatedDate, AppointmentDate, AppointmentTime,
                 ConsultationReason, BookingReference, ConsultationFee, GSTPercent, GSTAmount,
                 TotalAmount, PaymentStatus, PublicToken)
                SELECT @CaregiverID, @ServiceCategoryID, @CustomerName, @Gender, @City, @State,
                       @Email, @ContactNumber, N'Pending', GETDATE(), @AppointmentDate,
                       @AppointmentTime, @ConsultationReason, @BookingReference, P.ConsultationFee,
                       P.GSTPercent, ROUND(P.ConsultationFee * P.GSTPercent / 100.0, 2),
                       P.ConsultationFee + ROUND(P.ConsultationFee * P.GSTPercent / 100.0, 2),
                       N'Pending', @PublicToken
                FROM [sqladmin].[ConsultationServicePricing] P
                WHERE P.ServiceCategoryID = @ServiceCategoryID AND P.IsActive = 1;
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            try
            {
                int bookingId;
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(insertSql, con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = CaregiverID;
                    cmd.Parameters.Add("@ServiceCategoryID", SqlDbType.Int).Value = ServiceCategoryID;
                    cmd.Parameters.Add("@CustomerName", SqlDbType.NVarChar, 100).Value = txtCustomerName.Text.Trim();
                    cmd.Parameters.Add("@Gender", SqlDbType.NVarChar, 30).Value = ddlGender.SelectedValue;
                    cmd.Parameters.Add("@City", SqlDbType.NVarChar, 100).Value = txtCity.Text.Trim();
                    cmd.Parameters.Add("@State", SqlDbType.NVarChar, 100).Value = txtState.Text.Trim();
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 254).Value = email;
                    cmd.Parameters.Add("@ContactNumber", SqlDbType.NVarChar, 20).Value = txtContactNumber.Text.Trim();
                    cmd.Parameters.Add("@AppointmentDate", SqlDbType.Date).Value = appointmentDate.Date;
                    cmd.Parameters.Add("@AppointmentTime", SqlDbType.NVarChar, 10).Value = appointmentTime.ToString("HH:mm");
                    cmd.Parameters.Add("@ConsultationReason", SqlDbType.NVarChar, 1000).Value = String.IsNullOrWhiteSpace(txtReason.Text) ? (object)DBNull.Value : txtReason.Text.Trim();
                    cmd.Parameters.Add("@BookingReference", SqlDbType.NVarChar, 40).Value = bookingReference;
                    cmd.Parameters.Add("@PublicToken", SqlDbType.NVarChar, 64).Value = bookingToken;
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value)
                    {
                        ShowError("The consultation price is not configured. Please contact TJ Home Care.");
                        return;
                    }
                    bookingId = Convert.ToInt32(result);
                }

                Response.Redirect(ResolveUrl("~/ConsultationPaymentV2.aspx?t=" + HttpUtility.UrlEncode(bookingToken)), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception)
            {
                ShowError("We could not save your booking. Please try again later.");
            }
        }

        private static string FormatMoney(decimal amount)
        {
            return "₹" + amount.ToString("N2", CultureInfo.GetCultureInfo("en-IN"));
        }

        private void ShowError(string message)
        {
            lblErrorMessage.Text = HttpUtility.HtmlEncode(message);
        }
    }
}
