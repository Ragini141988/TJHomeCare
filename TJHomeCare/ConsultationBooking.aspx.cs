using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class ConsultationBooking : Page
    {
        private int CaregiverID
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["caregiverId"], out id);
                return id;
            }
        }

        private int ServiceCategoryID
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["serviceId"], out id);
                return id;
            }
        }

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
                pnlBookingForm.Visible = true;
                pnlSuccess.Visible = false;

                LoadConsultationDetails();
            }
        }

        private void LoadConsultationDetails()
        {
            if (CaregiverID <= 0 || ServiceCategoryID <= 0)
            {
                ShowError(
                    "Invalid consultation details. Please select a professional again.");

                btnSubmit.Enabled = false;
                return;
            }

            string query = @"
                SELECT TOP 1
                    CP.CaregiverID,
                    CP.FullName,
                    SC.ServiceCategoryID,
                    SC.ServiceName
                FROM [sqladmin].[CaregiverProfiles] CP
                INNER JOIN [sqladmin].[CaregiverServices] CS
                    ON CP.CaregiverID = CS.CaregiverID
                INNER JOIN [sqladmin].[ServiceCategories] SC
                    ON CS.ServiceCategoryID = SC.ServiceCategoryID
                WHERE CP.CaregiverID = @CaregiverID
                  AND SC.ServiceCategoryID = @ServiceCategoryID;";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int)
                        .Value = CaregiverID;

                    cmd.Parameters.Add("@ServiceCategoryID", SqlDbType.Int)
                        .Value = ServiceCategoryID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblProfessionalName.Text =
                                HttpUtility.HtmlEncode(
                                    Convert.ToString(reader["FullName"]));

                            lblServiceName.Text =
                                HttpUtility.HtmlEncode(
                                    Convert.ToString(reader["ServiceName"]));

                            btnSubmit.Enabled = true;
                            lblErrorMessage.Text = "";
                        }
                        else
                        {
                            ShowError(
                                "This professional is not available for the selected service. Please choose another professional.");

                            btnSubmit.Enabled = false;
                        }
                    }
                }
            }
            catch (Exception)
            {
                ShowError(
                    "Unable to load consultation details. Please try again later.");

                btnSubmit.Enabled = false;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
                return;

            if (CaregiverID <= 0 || ServiceCategoryID <= 0)
            {
                ShowError(
                    "Invalid booking details. Please select the professional again.");
                return;
            }

            // Revalidate the selected professional and service.
            LoadConsultationDetails();

            if (!btnSubmit.Enabled)
                return;

            string customerName = txtCustomerName.Text.Trim();
            string gender = ddlGender.SelectedValue;
            string city = txtCity.Text.Trim();
            string state = txtState.Text.Trim();
            string email = txtEmail.Text.Trim();
            string contactNumber = txtContactNumber.Text.Trim();

            if (customerName.Length == 0 ||
                gender.Length == 0 ||
                city.Length == 0 ||
                state.Length == 0 ||
                email.Length == 0 ||
                contactNumber.Length == 0)
            {
                ShowError("Please complete all required fields.");
                return;
            }

            string insertQuery = @"
                INSERT INTO [sqladmin].[ConsultationBookings]
                (
                    CaregiverID,
                    ServiceCategoryID,
                    CustomerName,
                    Gender,
                    City,
                    State,
                    Email,
                    ContactNumber,
                    BookingStatus,
                    CreatedDate
                )
                VALUES
                (
                    @CaregiverID,
                    @ServiceCategoryID,
                    @CustomerName,
                    @Gender,
                    @City,
                    @State,
                    @Email,
                    @ContactNumber,
                    @BookingStatus,
                    GETDATE()
                );

                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            try
            {
                int bookingID;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int)
                        .Value = CaregiverID;

                    cmd.Parameters.Add("@ServiceCategoryID", SqlDbType.Int)
                        .Value = ServiceCategoryID;

                    cmd.Parameters.Add("@CustomerName", SqlDbType.NVarChar, 100)
                        .Value = customerName;

                    cmd.Parameters.Add("@Gender", SqlDbType.NVarChar, 30)
                        .Value = gender;

                    cmd.Parameters.Add("@City", SqlDbType.NVarChar, 100)
                        .Value = city;

                    cmd.Parameters.Add("@State", SqlDbType.NVarChar, 100)
                        .Value = state;

                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 254)
                        .Value = email;

                    cmd.Parameters.Add("@ContactNumber", SqlDbType.NVarChar, 20)
                        .Value = contactNumber;

                    cmd.Parameters.Add("@BookingStatus", SqlDbType.NVarChar, 30)
                        .Value = "Pending";

                    con.Open();

                    bookingID = Convert.ToInt32(
                        cmd.ExecuteScalar());
                }

                // Show success only after SQL Server saves the booking.
                pnlBookingForm.Visible = false;
                pnlSuccess.Visible = true;

                lblSuccessMessage.Text =
                    "Thank you! Your consultation booking has been submitted successfully. " +
                    "Your booking reference number is " + bookingID +
                    ". Our team will contact you soon.";

                lblErrorMessage.Text = "";
            }
            catch (Exception)
            {
                ShowError(
                    "We could not save your booking. Please try again later.");
            }
        }

        private void ShowError(string message)
        {
            lblErrorMessage.Text = HttpUtility.HtmlEncode(message);
        }
    }
}
