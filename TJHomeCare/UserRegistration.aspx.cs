using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static TabletJobs.com.CaregiverRegistration;

namespace TJHomeCare
{
    public partial class UserRegistration : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindServiceCategories();
            }

        }
        //New code for load category
        // Load active services from the central master table.
        private void BindServiceCategories()
        {
            const string sql = @"
                SELECT ServiceCategoryID, ServiceName
                FROM [sqladmin].[ServiceCategories]
                WHERE IsActive = 1
                ORDER BY DisplayOrder, ServiceName;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                cblServiceCategory.DataSource = dt;
                cblServiceCategory.DataTextField = "ServiceName";
                cblServiceCategory.DataValueField = "ServiceCategoryID";
                cblServiceCategory.DataBind();
            }
        }

        //Close load category
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<PlaceResult> GetPlaces(string searchText, string city)
        {
            List<PlaceResult> result = new List<PlaceResult>();

            if (string.IsNullOrWhiteSpace(searchText))
                return result;

            string connString =
                ConfigurationManager
                .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(connString))
            {
                string sql = @"
                SELECT TOP 30
                    PlaceID,
                    PlaceName
                FROM [sqladmin].[LocalPlaces]
                WHERE PlaceName LIKE @SearchText
                  AND (
                        @City = ''
                        OR UPPER(City) = @City
                      )
                ORDER BY
                    OrderColumn ASC,
                    PlaceName ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@SearchText", SqlDbType.NVarChar, 200).Value = "%" + searchText.Trim() + "%";
                    cmd.Parameters.Add("@City", SqlDbType.NVarChar, 300).Value = string.IsNullOrWhiteSpace(city) ? "" : city.Trim().ToUpper();

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(
                                new PlaceResult
                                {
                                    PlaceID = Convert.ToInt32(reader["PlaceID"]),
                                    PlaceName = reader["PlaceName"].ToString()
                                }
                            );
                        }
                    }
                }
            }

            return result;
        }

        // ================================
        // VALIDATIONS
        // ================================

        protected void cvServiceCategory_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = IsAnyCheckboxSelected(cblServiceCategory);
        }

        protected void cvLanguages_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = IsAnyCheckboxSelected(cblLanguages);
        }

        protected void cvDuty_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = IsAnyCheckboxSelected(cblDutyPreference);
        }

        private bool IsAnyCheckboxSelected(CheckBoxList checkBoxList)
        {
            foreach (ListItem item in checkBoxList.Items)
            {
                if (item.Selected)
                    return true;
            }
            return false;
        }

        // ================================
        // SAVE TO DATABASE
        // ================================


        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
            {
                ShowMessage("Please correct the highlighted fields.", false);
                return;
            }

            // 1. Registration Mode
            string registrationMode = ddlRegistrationMode.SelectedValue;

            if (registrationMode != "Self" && registrationMode != "Staff")
            {
                ShowMessage("Please select Registration Mode.", false);
                return;
            }

            // 2. Recruiter Name
            string recruiterName = null;

            if (registrationMode == "Staff")
            {
                if (ddlRecruiter.SelectedIndex <= 0 ||
                    string.IsNullOrWhiteSpace(ddlRecruiter.SelectedValue))
                {
                    ShowMessage("Please select a Recruiter.", false);
                    return;
                }

                recruiterName = ddlRecruiter.SelectedItem.Text;
            }

            // 3. Present Area ID validation
            int presentAreaID;

            if (!int.TryParse(hdnPresentAreaID.Value, out presentAreaID))
            {
                ShowMessage("Please select a valid Present Area from the list.", false);
                return;
            }

            if (!PlaceExists(presentAreaID))
            {
                ShowMessage("Selected Present Area is invalid. Please select again.", false);
                return;
            }

            // 4. Preferred Work Areas validation
            string preferredAreaIDs = hdnPreferredWorkAreaIDs.Value.Trim();

            List<int> validPreferredAreaIDs = new List<int>();

            if (!string.IsNullOrWhiteSpace(preferredAreaIDs))
            {
                string[] selectedIDs = preferredAreaIDs.Split(
                    new[] { ',' },
                    StringSplitOptions.RemoveEmptyEntries);

                foreach (string idText in selectedIDs)
                {
                    int placeID;

                    if (!int.TryParse(idText.Trim(), out placeID))
                    {
                        ShowMessage("Invalid Preferred Work Area selected.", false);
                        return;
                    }

                    if (!PlaceExists(placeID))
                    {
                        ShowMessage(
                            "One of the selected Preferred Work Areas is invalid.",
                            false);
                        return;
                    }

                    if (!validPreferredAreaIDs.Contains(placeID))
                    {
                        validPreferredAreaIDs.Add(placeID);
                    }
                }
            }

            string preferredWorkAreaIDsValue =
                validPreferredAreaIDs.Count > 0
                    ? string.Join(",", validPreferredAreaIDs)
                    : null;

            // 5. Checkbox values
            string serviceCategory = GetSelectedValues(cblServiceCategory);
            string languages = GetSelectedValues(cblLanguages);
            string dutyPreference = GetSelectedValues(cblDutyPreference);

            if (string.IsNullOrWhiteSpace(serviceCategory))
            {
                ShowMessage("Please select at least one Service Category.", false);
                return;
            }

            // 6. Age validation
            int age;

            if (!int.TryParse(txtAge.Text.Trim(), out age) ||
                age < 18 || age > 100)
            {
                ShowMessage("Age must be between 18 and 100.", false);
                return;
            }

            // 7. Contact Number validation
            string contactNumber = txtContactNumber.Text.Trim();

            if (contactNumber.Length != 10)
            {
                ShowMessage("Please enter a valid 10-digit Contact Number.", false);
                return;
            }

            foreach (char digit in contactNumber)
            {
                if (!char.IsDigit(digit))
                {
                    ShowMessage("Contact Number must contain only digits.", false);
                    return;
                }
            }

            // 8. Expected Budget validation
            // txtExpectedSalary is the textbox ID in the existing form.
            decimal expectedBudget;

            if (!decimal.TryParse(txtExpectedSalary.Text.Trim(), out expectedBudget) ||
                expectedBudget <= 0)
            {
                ShowMessage("Please enter a valid Expected Budget greater than zero.", false);
                return;
            }

            // 9. Save to CaregiverProfiles table
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            string sql = @"
INSERT INTO [sqladmin].[CaregiverProfiles]
(
    RegistrationMode,
    RecruiterName,
    ServiceCategory,
    FullName,
    Age,
    Gender,
    ContactNumber,
    Email,
    City,
    PresentAreaID,
    CompleteAddress,
    LanguagesKnown,
    Experience,
    DutyPreference,
    ExpectedSalary,
    PreferredWorkAreas,
    PreferredWorkAreaIDs,
    JoiningAvailability,
    VerificationStatus,
    Remarks,
    RegistrationDate,
    RegistrationStatus,
    IsActive
)
VALUES
(
    @RegistrationMode,
    @RecruiterName,
    @ServiceCategory,
    @FullName,
    @Age,
    @Gender,
    @ContactNumber,
    @Email,
    @City,
    @PresentAreaID,
    @CompleteAddress,
    @LanguagesKnown,
    @Experience,
    @DutyPreference,
    @ExpectedSalary,
    @PreferredWorkAreas,
    @PreferredWorkAreaIDs,
    @JoiningAvailability,
    @VerificationStatus,
    @Remarks,
    SYSDATETIME(),
    N'Registered',
    1
);

SELECT CAST(SCOPE_IDENTITY() AS INT);";

                            int caregiverID;

                            using (SqlCommand cmd =
                                new SqlCommand(sql, con, transaction))
                            {
                                cmd.Parameters.Add(
                                    "@RegistrationMode",
                                    SqlDbType.NVarChar, 20)
                                    .Value = registrationMode;

                                cmd.Parameters.Add(
                                    "@RecruiterName",
                                    SqlDbType.NVarChar, 100)
                                    .Value = string.IsNullOrWhiteSpace(recruiterName)
                                        ? (object)DBNull.Value
                                        : recruiterName;

                                cmd.Parameters.Add(
                                    "@ServiceCategory",
                                    SqlDbType.NVarChar, 500)
                                    .Value = serviceCategory;

                                cmd.Parameters.Add(
                                    "@FullName",
                                    SqlDbType.NVarChar, 200)
                                    .Value = txtFullName.Text.Trim();

                                cmd.Parameters.Add(
                                    "@Age",
                                    SqlDbType.Int)
                                    .Value = age;

                                cmd.Parameters.Add(
                                    "@Gender",
                                    SqlDbType.NVarChar, 20)
                                    .Value = ddlGender.SelectedValue;

                                // CaregiverProfiles.ContactNumber is nvarchar(20).
                                cmd.Parameters.Add(
                                    "@ContactNumber",
                                    SqlDbType.NVarChar, 20)
                                    .Value = contactNumber;

                                cmd.Parameters.Add(
                                    "@Email",
                                    SqlDbType.NVarChar, 200)
                                    .Value = string.IsNullOrWhiteSpace(txtEmail.Text)
                                        ? (object)DBNull.Value
                                        : txtEmail.Text.Trim();

                                cmd.Parameters.Add(
                                    "@City",
                                    SqlDbType.NVarChar, 100)
                                    .Value = ddlCity.SelectedValue;

                                cmd.Parameters.Add(
                                    "@PresentAreaID",
                                    SqlDbType.Int)
                                    .Value = presentAreaID;

                                cmd.Parameters.Add(
                                    "@CompleteAddress",
                                    SqlDbType.NVarChar, 500)
                                    .Value = string.IsNullOrWhiteSpace(txtAddress.Text)
                                        ? (object)DBNull.Value
                                        : txtAddress.Text.Trim();

                                // UserRegistration.PreferredLanguages maps to
                                // CaregiverProfiles.LanguagesKnown.
                                cmd.Parameters.Add(
                                    "@LanguagesKnown",
                                    SqlDbType.NVarChar, 500)
                                    .Value = languages ?? string.Empty;

                                // No Experience field is collected by this form.
                                // Keep it empty until an Experience input is added.
                                cmd.Parameters.Add(
                                    "@Experience",
                                    SqlDbType.NVarChar, 50)
                                    .Value = string.Empty;

                                cmd.Parameters.Add(
                                    "@DutyPreference",
                                    SqlDbType.NVarChar, 500)
                                    .Value = dutyPreference;

                                // UserRegistration.ExpectedBudget maps to
                                // CaregiverProfiles.ExpectedSalary.
                                SqlParameter salaryParameter =
                                    cmd.Parameters.Add(
                                        "@ExpectedSalary",
                                        SqlDbType.Decimal);

                                salaryParameter.Precision = 10;
                                salaryParameter.Scale = 2;
                                salaryParameter.Value = expectedBudget;

                                cmd.Parameters.Add(
                                    "@PreferredWorkAreas",
                                    SqlDbType.NVarChar, 1000)
                                    .Value = string.IsNullOrWhiteSpace(
                                        txtPreferredWorkAreas.Text)
                                        ? (object)DBNull.Value
                                        : txtPreferredWorkAreas.Text.Trim();

                                cmd.Parameters.Add(
                                    "@PreferredWorkAreaIDs",
                                    SqlDbType.NVarChar, 500)
                                    .Value = string.IsNullOrWhiteSpace(
                                        preferredWorkAreaIDsValue)
                                        ? (object)DBNull.Value
                                        : preferredWorkAreaIDsValue;

                                cmd.Parameters.Add(
                                    "@JoiningAvailability",
                                    SqlDbType.NVarChar, 50)
                                    .Value = ddlJoiningAvailability.SelectedValue;

                                cmd.Parameters.Add(
                                    "@VerificationStatus",
                                    SqlDbType.NVarChar, 30)
                                    .Value = "Pending";

                                cmd.Parameters.Add(
                                    "@Remarks",
                                    SqlDbType.NVarChar, 1000)
                                    .Value = string.IsNullOrWhiteSpace(txtRemarks.Text)
                                        ? (object)DBNull.Value
                                        : txtRemarks.Text.Trim();

                                object result = cmd.ExecuteScalar();

                                if (result == null || result == DBNull.Value)
                                {
                                    throw new Exception(
                                        "Unable to save caregiver registration.");
                                }

                                caregiverID = Convert.ToInt32(result);
                            }

                            transaction.Commit();

                            ShowMessage(
                                "Registration saved successfully. Caregiver ID: " +
                                caregiverID,
                                true);
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception in production rather than exposing database details.
                System.Diagnostics.Trace.TraceError(ex.ToString());

                ShowMessage(
                    "An error occurred while saving the registration. Please try again.",
                    false);
            }
        }
        private bool PlaceExists(int placeID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string sql = "SELECT COUNT(1) FROM [sqladmin].[LocalPlaces] WHERE PlaceID = @PlaceID;";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@PlaceID", SqlDbType.Int).Value = placeID;
                    con.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private string GetSelectedValues(CheckBoxList checkBoxList)
        {
            List<string> values = new List<string>();
            foreach (ListItem item in checkBoxList.Items)
            {
                if (item.Selected)
                {
                    values.Add(item.Text);
                }
            }
            return string.Join(", ", values);
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Visible = true;
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = success ? "message success" : "message error";
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            ddlRegistrationMode.SelectedIndex = 0;
            ddlRecruiter.SelectedIndex = 0;
            txtFullName.Text = "";
            txtAge.Text = "";
            ddlGender.SelectedIndex = 0;
            txtContactNumber.Text = "";
            txtEmail.Text = "";
            ddlCity.SelectedIndex = 0;
            txtPresentArea.Text = "";
            hdnPresentAreaID.Value = "";
            txtExpectedSalary.Text = "";
            ddlJoiningAvailability.SelectedIndex = 0;
            txtPreferredWorkAreas.Text = "";
            hdnPreferredWorkAreaIDs.Value = "";
            txtAddress.Text = "";
            txtRemarks.Text = "";
            lblMessage.Visible = false;
            lblMessage.Text = "";
           

            foreach (ListItem item in cblServiceCategory.Items) item.Selected = false;
            foreach (ListItem item in cblLanguages.Items) item.Selected = false;
            foreach (ListItem item in cblDutyPreference.Items) item.Selected = false;
        }

        public class PlaceResult
        {
            public int PlaceID { get; set; }
            public string PlaceName { get; set; }
        }
    }
}