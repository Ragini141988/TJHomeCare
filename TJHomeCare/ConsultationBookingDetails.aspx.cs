using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace TJHomeCare
{
    public partial class ConsultationBookingDetails
        : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                   .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                   .ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int bookingID;

                if (!int.TryParse(
                    Request.QueryString["id"],
                    out bookingID) || bookingID <= 0)
                {
                    ShowError("Invalid booking reference.");
                    return;
                }

                LoadBookingDetails(bookingID);
            }
        }

        private void LoadBookingDetails(int bookingID)
        {
            string query = @"
                SELECT
                    B.BookingID,
                    B.CaregiverID,
                    B.ServiceCategoryID,
                    B.CustomerName,
                    B.Gender,
                    B.City,
                    B.State,
                    B.Email,
                    B.ContactNumber,
                    B.BookingStatus,
                    B.CreatedDate,

                    CP.FullName AS ProfessionalName,
                    CP.Email AS ProfessionalEmail,
                    CP.ContactNumber AS ProfessionalContact,
                    CP.Qualification,
                    CP.Experience,
                    CP.VerificationStatus,
                    CP.ProfilePhotoPath,

                    SC.ServiceName

                FROM [sqladmin].[ConsultationBookings] B

                INNER JOIN [sqladmin].[CaregiverProfiles] CP
                    ON B.CaregiverID = CP.CaregiverID

                INNER JOIN [sqladmin].[ServiceCategories] SC
                    ON B.ServiceCategoryID = SC.ServiceCategoryID

                INNER JOIN [sqladmin].[CaregiverServices] CS
                    ON CS.CaregiverID = B.CaregiverID
                    AND CS.ServiceCategoryID = B.ServiceCategoryID

                WHERE B.BookingID = @BookingID;";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@BookingID",
                        SqlDbType.Int).Value = bookingID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowError(
                                "Booking not found, or the associated " +
                                "professional or service is unavailable.");

                            return;
                        }

                        lblBookingID.Text =
                            SafeText(reader["BookingID"]);

                        lblBookingStatus.Text =
                            SafeText(reader["BookingStatus"]);

                        lblServiceName.Text =
                            SafeText(reader["ServiceName"]);

                        lblCreatedDate.Text =
                            reader["CreatedDate"] == DBNull.Value
                            ? "-"
                            : Convert.ToDateTime(
                                reader["CreatedDate"])
                                .ToString("dd-MMM-yyyy hh:mm tt");

                        lblCustomerName.Text =
                            SafeText(reader["CustomerName"]);

                        lblGender.Text =
                            SafeText(reader["Gender"]);

                        lblEmail.Text =
                            SafeText(reader["Email"]);

                        lblContactNumber.Text =
                            SafeText(reader["ContactNumber"]);

                        lblCity.Text =
                            SafeText(reader["City"]);

                        lblState.Text =
                            SafeText(reader["State"]);

                        lblCaregiverID.Text =
                            SafeText(reader["CaregiverID"]);

                        lblProfessionalName.Text =
                            SafeText(reader["ProfessionalName"]);

                        lblProfessionalEmail.Text =
                            SafeText(reader["ProfessionalEmail"]);

                        lblProfessionalContact.Text =
                            SafeText(reader["ProfessionalContact"]);

                        lblQualification.Text =
                            SafeText(reader["Qualification"]);

                        lblExperience.Text =
                            SafeText(reader["Experience"]);

                        lblVerificationStatus.Text =
                            SafeText(reader["VerificationStatus"]);

                        string photoPath =
                            Convert.ToString(
                                reader["ProfilePhotoPath"]);

                        if (!string.IsNullOrWhiteSpace(photoPath))
                        {
                            // Only allow application-local URLs.
                            // Do not accept arbitrary external URLs.
                            if (photoPath.StartsWith("~/",
                                StringComparison.Ordinal))
                            {
                                imgProfessional.ImageUrl =
                                    ResolveUrl(photoPath);

                                imgProfessional.Visible = true;
                            }
                            else if (photoPath.StartsWith("/",
                                StringComparison.Ordinal)
                                && !photoPath.StartsWith("//",
                                    StringComparison.Ordinal))
                            {
                                imgProfessional.ImageUrl =
                                    ResolveUrl("~" + photoPath);

                                imgProfessional.Visible = true;
                            }
                        }

                        pnlDetails.Visible = true;
                        lblMessage.Text = "";
                    }
                }
            }
            catch (Exception exception)
            {
                pnlDetails.Visible = false;

                ShowError(
                    "Unable to load booking details. Please try again later.");
            }
        }

        private string SafeText(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return "-";
            }

            string text = Convert.ToString(value);

            if (string.IsNullOrWhiteSpace(text))
            {
                return "-";
            }

            return HttpUtility.HtmlEncode(text);
        }

        private void ShowError(string message)
        {
            pnlDetails.Visible = false;

            lblMessage.Text =
                HttpUtility.HtmlEncode(message);
        }
    }
}