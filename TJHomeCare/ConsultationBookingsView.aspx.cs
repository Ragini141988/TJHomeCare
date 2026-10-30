using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace TJHomeCare
{
    public partial class ConsultationBookingsView
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
                LoadServices();
                BindBookings();
            }
        }

        private void LoadServices()
        {
            string query = @"
                SELECT ServiceCategoryID, ServiceName
                FROM [sqladmin].[ServiceCategories]
                WHERE IsActive = 1
                ORDER BY DisplayOrder, ServiceName;";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    ddlService.DataSource = reader;
                    ddlService.DataTextField = "ServiceName";
                    ddlService.DataValueField = "ServiceCategoryID";
                    ddlService.DataBind();
                }
            }
        }

        private void BindBookings()
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
                    B.UpdatedDate,

                    CP.FullName AS ProfessionalName,

                    SC.ServiceName

                FROM [sqladmin].[ConsultationBookings] B

                INNER JOIN [sqladmin].[CaregiverProfiles] CP
                    ON B.CaregiverID = CP.CaregiverID

                INNER JOIN [sqladmin].[ServiceCategories] SC
                    ON B.ServiceCategoryID = SC.ServiceCategoryID

                INNER JOIN [sqladmin].[CaregiverServices] CS
                    ON CS.CaregiverID = B.CaregiverID
                    AND CS.ServiceCategoryID = B.ServiceCategoryID

                WHERE
                    (
                        @ServiceCategoryID = 0
                        OR B.ServiceCategoryID = @ServiceCategoryID
                    )

                    AND
                    (
                        @Status = ''
                        OR B.BookingStatus = @Status
                    )

                    AND
                    (
                        @Search = ''
                        OR B.CustomerName LIKE @SearchPattern
                        OR B.Email LIKE @SearchPattern
                        OR B.ContactNumber LIKE @SearchPattern
                        OR CP.FullName LIKE @SearchPattern
                        OR SC.ServiceName LIKE @SearchPattern
                    )

                ORDER BY
                    B.CreatedDate DESC,
                    B.BookingID DESC;";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    int serviceCategoryID = 0;

                    int.TryParse(
                        ddlService.SelectedValue,
                        out serviceCategoryID);

                    string status = ddlStatus.SelectedValue;
                    string search = txtSearch.Text.Trim();

                    cmd.Parameters.Add(
                        "@ServiceCategoryID",
                        SqlDbType.Int).Value = serviceCategoryID;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.NVarChar,
                        30).Value = status;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.NVarChar,
                        254).Value = search;

                    cmd.Parameters.Add(
                        "@SearchPattern",
                        SqlDbType.NVarChar,
                        260).Value = "%" + search + "%";

                    DataTable dt = new DataTable();

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }

                    lvBookings.DataSource = dt;
                    lvBookings.DataBind();

                    lblBookingCount.Text =
                        dt.Rows.Count.ToString();

                    lblMessage.Text = "";
                }
            }
            catch (Exception)
            {
                lvBookings.DataSource = null;
                lvBookings.DataBind();

                lblBookingCount.Text = "0";

                lblMessage.Text =
                    "Unable to load consultation bookings. " +
                    "Please try again later.";
            }
        }

        protected void btnSearch_Click(
            object sender,
            EventArgs e)
        {
            dpBookings.SetPageProperties(0, 10, false);

            BindBookings();
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ddlService.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            txtSearch.Text = "";

            dpBookings.SetPageProperties(0, 10, false);

            BindBookings();
        }

        protected void lvBookings_PagePropertiesChanging(
            object sender,
            System.Web.UI.WebControls.PagePropertiesChangingEventArgs e)
        {
            dpBookings.SetPageProperties(
                e.StartRowIndex,
                e.MaximumRows,
                false);

            BindBookings();
        }
    }
}