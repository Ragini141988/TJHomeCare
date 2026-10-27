using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class HomeCareEnquiry : Page
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
                LoadServiceCategories();
            }
        }

        private void LoadServiceCategories()
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT ServiceCategoryID, ServiceName
                    FROM ServiceCategories
                    WHERE IsActive = 1
                    ORDER BY DisplayOrder, ServiceName;";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    ddlService.DataSource =
                        cmd.ExecuteReader();

                    ddlService.DataTextField = "ServiceName";

                    ddlService.DataValueField =
                        "ServiceCategoryID";

                    ddlService.DataBind();
                }
            }

            ddlService.Items.Insert(
                0,
                new System.Web.UI.WebControls.ListItem(
                    "Select a service", ""));
        }

        protected void btnGetCallBack_Click(
            object sender, EventArgs e)
        {
            Page.Validate("Enquiry");

            if (!Page.IsValid)
            {
                return;
            }

            string fullName = txtFullName.Text.Trim();

            string mobile = txtMobileNumber.Text.Trim();

            string city = rblCity.SelectedValue;

            string area = txtArea.Text.Trim();

            string dutyHours = rblDutyHours.SelectedValue;

            string requiredWhen = rblRequiredWhen.SelectedValue;

            string additionalRequirements =
                txtRequirements.Text.Trim();

            int serviceCategoryID;

            if (!int.TryParse(
                ddlService.SelectedValue,
                out serviceCategoryID))
            {
                ShowMessage(
                    "Please select a valid service category.",
                    false);

                return;
            }

            if (fullName.Length > 150 ||
                area.Length > 150 ||
                additionalRequirements.Length > 1000)
            {
                ShowMessage(
                    "One or more fields exceed the permitted length.",
                    false);

                return;
            }

            if (!Regex.IsMatch(
                mobile, "^[6-9][0-9]{9}$"))
            {
                ShowMessage(
                    "Please enter a valid 10-digit mobile number.",
                    false);

                return;
            }

            //if (city != "Hyderabad" &&
            //    city != "Bangalore")
            //{
            //    ShowMessage(
            //        "Please select a valid city.",
            //        false);

            //    return;
            //}

            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(area))
            {
                ShowMessage(
                    "Please complete all required fields.",
                    false);

                return;
            }

            string query = @"
                INSERT INTO HomeCareEnquiries
                (
                    FullName,
                    MobileNumber,
                    City,
                    Area,
                    ServiceCategoryID,
                    DutyHours,
                    RequiredWhen,
                    AdditionalRequirements,
                    CallbackStatus,
                    CreatedDate
                )
                SELECT
                    @FullName,
                    @MobileNumber,
                    @City,
                    @Area,
                    @ServiceCategoryID,
                    @DutyHours,
                    @RequiredWhen,
                    @AdditionalRequirements,
                    'Pending',
                    GETDATE()
                WHERE EXISTS
                (
                    SELECT 1
                    FROM ServiceCategories
                    WHERE ServiceCategoryID =
                        @ServiceCategoryID
                      AND IsActive = 1
                );

                SELECT CAST(@@ROWCOUNT AS INT);";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                cmd.Parameters.Add(
                    "@FullName",
                    SqlDbType.NVarChar, 150).Value = fullName;

                cmd.Parameters.Add(
                    "@MobileNumber",
                    SqlDbType.VarChar, 10).Value = mobile;

                cmd.Parameters.Add(
                    "@City",
                    SqlDbType.NVarChar, 50).Value = city;

                cmd.Parameters.Add(
                    "@Area",
                    SqlDbType.NVarChar, 150).Value = area;

                cmd.Parameters.Add(
                    "@ServiceCategoryID",
                    SqlDbType.Int).Value =
                    serviceCategoryID;

                cmd.Parameters.Add(
                    "@DutyHours",
                    SqlDbType.NVarChar, 30).Value =
                    dutyHours;

                cmd.Parameters.Add(
                    "@RequiredWhen",
                    SqlDbType.NVarChar, 30).Value =
                    requiredWhen;

                cmd.Parameters.Add(
                    "@AdditionalRequirements",
                    SqlDbType.NVarChar, 1000).Value =
                    string.IsNullOrWhiteSpace(
                        additionalRequirements)
                    ? (object)DBNull.Value
                    : additionalRequirements;

                con.Open();

                int rowsInserted = Convert.ToInt32(
                    cmd.ExecuteScalar());

                if (rowsInserted == 1)
                {
                    ClearForm();

                    ShowMessage(
                        "Thank you! Your enquiry has been submitted successfully. Our care coordinator will contact you.",
                        true);
                }
                else
                {
                    ShowMessage(
                        "The selected service is unavailable. Please select another service.",
                        false);
                }
            }
        }

        private void ClearForm()
        {
            txtFullName.Text = "";

            txtMobileNumber.Text = "";

            txtArea.Text = "";

            txtRequirements.Text = "";

            ddlService.SelectedIndex = 0;

            rblCity.SelectedIndex = 0;

            rblDutyHours.ClearSelection();

            rblRequiredWhen.ClearSelection();
        }

        private void ShowMessage(
            string message, bool success)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);

            lblMessage.Visible = true;

            lblMessage.CssClass = success
                ? "hc-message hc-success"
                : "hc-message hc-error";
        }
    }
}