using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ConsultationBookingManageV2 : Page
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
            if (!IsPostBack)
            {
                txtNewDate.Attributes["min"] = DateTime.Today.ToString("yyyy-MM-dd");
                LoadBooking();
            }
        }

        private void LoadBooking()
        {
            if (Token.Length != 32) { ShowError("Invalid booking link."); pnlManage.Visible = false; return; }
            string sql = @"
                SELECT B.BookingReference, B.BookingStatus, B.PaymentStatus, B.AppointmentDate,
                       B.AppointmentTime, CP.FullName, SC.ServiceName
                FROM [sqladmin].[ConsultationBookings] B
                INNER JOIN [sqladmin].[CaregiverProfiles] CP ON CP.CaregiverID=B.CaregiverID
                INNER JOIN [sqladmin].[ServiceCategories] SC ON SC.ServiceCategoryID=B.ServiceCategoryID
                WHERE B.PublicToken=@Token;";
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                    con.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (!r.Read()) { ShowError("Booking details could not be found."); pnlManage.Visible = false; return; }
                        string bookingStatus = Convert.ToString(r["BookingStatus"]);
                        lblBookingReference.Text = HttpUtility.HtmlEncode(Convert.ToString(r["BookingReference"]));
                        lblProfessional.Text = HttpUtility.HtmlEncode(Convert.ToString(r["FullName"]));
                        lblService.Text = HttpUtility.HtmlEncode(Convert.ToString(r["ServiceName"]));
                        lblCurrentAppointment.Text = Convert.ToDateTime(r["AppointmentDate"]).ToString("ddd, dd MMM yyyy") + " at " + HttpUtility.HtmlEncode(Convert.ToString(r["AppointmentTime"]));
                        lblBookingStatus.Text = HttpUtility.HtmlEncode(bookingStatus + " / Payment: " + Convert.ToString(r["PaymentStatus"]));
                        bool canManage = !String.Equals(bookingStatus, "Cancelled", StringComparison.OrdinalIgnoreCase) && !String.Equals(bookingStatus, "Completed", StringComparison.OrdinalIgnoreCase);
                        btnReschedule.Enabled = canManage;
                        btnCancel.Enabled = canManage;
                        if (!canManage) ShowError("This booking is already " + bookingStatus.ToLowerInvariant() + " and cannot be changed here.");
                    }
                }
            }
            catch (Exception)
            {
                ShowError("Unable to load booking details. Please contact TJ Home Care.");
                pnlManage.Visible = false;
            }
        }

        protected void btnReschedule_Click(object sender, EventArgs e)
        {
            DateTime newDate;
            DateTime newTime;
            if (!DateTime.TryParseExact(txtNewDate.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out newDate) || newDate.Date < DateTime.Today)
            {
                ShowError("Please choose a valid future date or today's date."); return;
            }
            if (!DateTime.TryParseExact(txtNewTime.Text.Trim(), new string[] { "HH:mm", "H:mm" }, CultureInfo.InvariantCulture, DateTimeStyles.None, out newTime))
            {
                ShowError("Please choose a valid preferred time."); return;
            }
            string sql = @"
                UPDATE [sqladmin].[ConsultationBookings]
                SET RequestedAppointmentDate=@RequestedDate,
                    RequestedAppointmentTime=@RequestedTime,
                    RescheduleRequestedOn=GETDATE(),
                    CustomerRequestNote=@Note,
                    UpdatedDate=GETDATE()
                WHERE PublicToken=@Token AND BookingStatus NOT IN (N'Cancelled',N'Completed');";
            try
            {
                int rows;
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@RequestedDate", SqlDbType.Date).Value = newDate.Date;
                    cmd.Parameters.Add("@RequestedTime", SqlDbType.NVarChar, 10).Value = newTime.ToString("HH:mm");
                    cmd.Parameters.Add("@Note", SqlDbType.NVarChar, 500).Value = String.IsNullOrWhiteSpace(txtRescheduleNote.Text) ? (object)DBNull.Value : txtRescheduleNote.Text.Trim();
                    cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                    con.Open(); rows = cmd.ExecuteNonQuery();
                }
                if (rows > 0) { ShowResult("Your rescheduling request has been sent to TJ Home Care. The current appointment remains unchanged until the team confirms the new time."); LoadBooking(); }
                else ShowError("This booking can no longer be changed.");
            }
            catch (Exception) { ShowError("We could not submit your rescheduling request. Please try again later."); }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            string sql = @"
                UPDATE [sqladmin].[ConsultationBookings]
                SET CancellationRequestedOn=GETDATE(),
                    CustomerRequestNote=@Note,
                    UpdatedDate=GETDATE()
                WHERE PublicToken=@Token AND BookingStatus NOT IN (N'Cancelled',N'Completed');";
            try
            {
                int rows;
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@Note", SqlDbType.NVarChar, 500).Value = String.IsNullOrWhiteSpace(txtCancelNote.Text) ? (object)DBNull.Value : txtCancelNote.Text.Trim();
                    cmd.Parameters.Add("@Token", SqlDbType.NVarChar, 64).Value = Token;
                    con.Open(); rows = cmd.ExecuteNonQuery();
                }
                if (rows > 0) { ShowResult("Your cancellation request has been sent to TJ Home Care. The booking is not cancelled until the team reviews and updates it."); LoadBooking(); }
                else ShowError("This booking can no longer be changed.");
            }
            catch (Exception) { ShowError("We could not submit your cancellation request. Please try again later."); }
        }

        private void ShowError(string message) { lblError.Text = HttpUtility.HtmlEncode(message); }
        private void ShowResult(string message) { lblResult.Text = HttpUtility.HtmlEncode(message); }
    }
}
