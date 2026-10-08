using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TabletJobs.com
{
    public partial class CaregiverRegistration : Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<PlaceResult> GetPlaces(string searchText, string city)
        {
            List<PlaceResult> result = new List<PlaceResult>();

            if (string.IsNullOrWhiteSpace(searchText))
                return result;

            string connectionString =
                ConfigurationManager
                .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
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
                    cmd.Parameters.Add(
                        "@SearchText",
                        SqlDbType.NVarChar,
                        200
                    ).Value = "%" + searchText.Trim() + "%";

                    cmd.Parameters.Add(
                        "@City",
                        SqlDbType.NVarChar,
                        300
                    ).Value = string.IsNullOrWhiteSpace(city)
                                ? ""
                                : city.Trim().ToUpper();

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(
                                new PlaceResult
                                {
                                    PlaceID = Convert.ToInt32(
                                        reader["PlaceID"]
                                    ),

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
        // SERVICE CATEGORY VALIDATION
        // ================================

        protected void cvServiceCategory_ServerValidate(
            object source,
            ServerValidateEventArgs args)
        {
            args.IsValid = IsAnyCheckboxSelected(cblServiceCategory);
        }


        // ================================
        // LANGUAGE VALIDATION
        // ================================

        protected void cvLanguages_ServerValidate(
            object source,
            ServerValidateEventArgs args)
        {
            args.IsValid = IsAnyCheckboxSelected(cblLanguages);
        }


        // ================================
        // DUTY VALIDATION
        // ================================

        protected void cvDuty_ServerValidate(
            object source,
            ServerValidateEventArgs args)
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
        // SAVE
        // ================================

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please correct the highlighted fields.",
                    false);

                return;
            }


            // =========================================================
            // PRESENT AREA VALIDATION
            // =========================================================

            int presentAreaID;

            if (!int.TryParse(
                hdnPresentAreaID.Value,
                out presentAreaID))
            {
                ShowMessage(
                    "Please select a valid Present Area from the list.",
                    false);

                return;
            }


            // Check whether Present Area exists
            if (!PlaceExists(presentAreaID))
            {
                ShowMessage(
                    "Selected Present Area is invalid. Please select again.",
                    false);

                return;
            }


            // =========================================================
            // PREFERRED WORK AREAS
            // =========================================================

            string preferredAreaIDs =
                hdnPreferredWorkAreaIDs.Value.Trim();

            // Preferred Work Areas is optional.


            // Validate selected Place IDs
            List<int> validPreferredAreaIDs =
                new List<int>();


            if (!string.IsNullOrWhiteSpace(preferredAreaIDs))
            {
                string[] selectedIDs =
                    preferredAreaIDs.Split(
                        new[] { ',' },
                        StringSplitOptions.RemoveEmptyEntries);


                foreach (string idText in selectedIDs)
                {
                    int placeID;

                    if (!int.TryParse(
                        idText.Trim(),
                        out placeID))
                    {
                        ShowMessage(
                            "Invalid Preferred Work Area selected.",
                            false);

                        return;
                    }


                    // Make sure PlaceID really exists
                    if (!PlaceExists(placeID))
                    {
                        ShowMessage(
                            "One of the selected Preferred Work Areas is invalid.",
                            false);

                        return;
                    }


                    // Avoid duplicate IDs
                    if (!validPreferredAreaIDs.Contains(placeID))
                    {
                        validPreferredAreaIDs.Add(placeID);
                    }
                }
            }


            // Store IDs as:
            // 1,3,8

            string preferredWorkAreasValue =
                validPreferredAreaIDs.Count > 0
                    ? string.Join(",", validPreferredAreaIDs)
                    : null;


            // =========================================================
            // PROFILE PHOTO - OPTIONAL
            // =========================================================

            byte[] photoBytes = null;

            byte[] photoBytes1 = null;
            string profilePhotoName = null;


            if (fuProfilePhoto.HasFile)
            {
                // Maximum 2 MB
                if (fuProfilePhoto.PostedFile.ContentLength >
                    2 * 1024 * 1024)
                {
                    ShowMessage(
                        "Profile photo must be less than or equal to 2 MB.",
                        false);

                    return;
                }


                string extension =
                    Path.GetExtension(
                        fuProfilePhoto.FileName)
                    .ToLowerInvariant();


                string[] allowedExtensions =
                {
            ".jpg",
            ".jpeg",
            ".png"
        };


                if (Array.IndexOf(
                    allowedExtensions,
                    extension) < 0)
                {
                    ShowMessage(
                        "Only JPG, JPEG and PNG files are allowed for Profile Photo.",
                        false);

                    return;
                }


                // Read Profile Photo
                using (BinaryReader reader =
                    new BinaryReader(
                        fuProfilePhoto.PostedFile.InputStream))
                {
                    photoBytes =
                        reader.ReadBytes(
                            fuProfilePhoto.PostedFile.ContentLength);
                }


                profilePhotoName =
                    Path.GetFileName(
                        fuProfilePhoto.FileName);
            }


            // =========================================================
            // AADHAR PHOTO - MANDATORY
            // =========================================================

            if (fupaadhar.HasFile)
            {



                // Maximum 2 MB
                if (fupaadhar.PostedFile.ContentLength >
                    2 * 1024 * 1024)
                {
                    ShowMessage(
                        "Aadhar photo must be less than or equal to 2 MB.",
                        false);

                    return;
                }


                string aadharExtension =
                    Path.GetExtension(
                        fupaadhar.FileName)
                    .ToLowerInvariant();


                string[] allowedAadharExtensions =
                {
        ".jpg",
        ".jpeg",
        ".png"
    };


                if (Array.IndexOf(
                    allowedAadharExtensions,
                    aadharExtension) < 0)
                {
                    ShowMessage(
                        "Only JPG, JPEG and PNG files are allowed for Aadhar Photo.",
                        false);

                    return;
                }


                // Read Aadhar Photo
               

                using (BinaryReader reader =
                    new BinaryReader(
                        fupaadhar.PostedFile.InputStream))
                {
                    photoBytes1 =
                        reader.ReadBytes(
                            fupaadhar.PostedFile.ContentLength);
                }

            }
            // =========================================================
            // CHECKBOX VALUES
            // =========================================================

            string serviceCategory =
                GetSelectedValues(
                    cblServiceCategory);


            string languages =
                GetSelectedValues(
                    cblLanguages);


            string dutyPreference =
                GetSelectedValues(
                    cblDutyPreference);


            // =========================================================
            // SALARY VALIDATION
            // =========================================================

            decimal expectedSalary;

            if (!decimal.TryParse(
                txtExpectedSalary.Text.Trim(),
                out expectedSalary))
            {
                ShowMessage(
                    "Please enter a valid expected salary.",
                    false);

                return;
            }


            if (expectedSalary <= 0)
            {
                ShowMessage(
                    "Expected salary must be greater than zero.",
                    false);

                return;
            }


            // =========================================================
            // AGE VALIDATION
            // =========================================================

            int age;

            if (!int.TryParse(
                txtAge.Text.Trim(),
                out age))
            {
                ShowMessage(
                    "Please enter a valid age.",
                    false);

                return;
            }


            if (age < 18 || age > 70)
            {
                ShowMessage(
                    "Age must be between 18 and 70.",
                    false);

                return;
            }


            // =========================================================
            // SAVE TO DATABASE
            // =========================================================

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    con.Open();


                    // =================================================
                    // TRANSACTION
                    // =================================================

                    using (SqlTransaction transaction =
                        con.BeginTransaction())
                    {
                        try
                        {
                            // =========================================
                            // INSERT CAREGIVER
                            // =========================================

                            string sql = @"

INSERT INTO [sqladmin].[CaregiverProfiles]
(
    RecruiterName,
    ServiceCategory,
    FullName,
    Age,
    Gender,
    ContactNumber,
    City,
    PresentAreaID,
    LanguagesKnown,
    Qualification,
    Experience,
    DutyPreference,
    ExpectedSalary,
    PreferredWorkAreas,
    JoiningAvailability,
    ProfilePhoto,
    ProfilePhotoName,
    VerificationStatus,
    Remarks,
    CreatedDate,
    AadharPhoto
)
VALUES
(
    @RecruiterName,
    @ServiceCategory,
    @FullName,
    @Age,
    @Gender,
    @ContactNumber,
    @City,
    @PresentAreaID,
    @LanguagesKnown,
    @Qualification,
    @Experience,
    @DutyPreference,
    @ExpectedSalary,
    @PreferredWorkAreas,
    @JoiningAvailability,
    @ProfilePhoto,
    @ProfilePhotoName,
    'Pending',
    @Remarks,
    GETDATE(),
    @AadharPhoto
);

SELECT CAST(SCOPE_IDENTITY() AS INT);
";


                            int caregiverID;


                            using (SqlCommand cmd =
                                new SqlCommand(
                                    sql,
                                    con,
                                    transaction))
                            {
                                // =====================================
                                // RECRUITER
                                // =====================================

                                cmd.Parameters.Add(
                                    "@RecruiterName",
                                    SqlDbType.NVarChar,
                                    100)
                                    .Value =
                                    ddlRecruiter.SelectedValue;


                                // =====================================
                                // SERVICE CATEGORY
                                // =====================================

                                cmd.Parameters.Add(
                                    "@ServiceCategory",
                                    SqlDbType.NVarChar,
                                    500)
                                    .Value =
                                    serviceCategory;


                                // =====================================
                                // FULL NAME
                                // =====================================

                                cmd.Parameters.Add(
                                    "@FullName",
                                    SqlDbType.NVarChar,
                                    200)
                                    .Value =
                                    txtFullName.Text.Trim();


                                // =====================================
                                // AGE
                                // =====================================

                                cmd.Parameters.Add(
                                    "@Age",
                                    SqlDbType.Int)
                                    .Value =
                                    age;


                                // =====================================
                                // GENDER
                                // =====================================

                                cmd.Parameters.Add(
                                    "@Gender",
                                    SqlDbType.NVarChar,
                                    20)
                                    .Value =
                                    ddlGender.SelectedValue;


                                // =====================================
                                // CONTACT NUMBER
                                // =====================================

                                cmd.Parameters.Add(
                                    "@ContactNumber",
                                    SqlDbType.NVarChar,
                                    20)
                                    .Value =
                                    txtContactNumber.Text.Trim();


                                // =====================================
                                // CITY
                                // =====================================

                                cmd.Parameters.Add(
                                    "@City",
                                    SqlDbType.NVarChar,
                                    100)
                                    .Value =
                                    ddlCity.SelectedValue;


                                // =====================================
                                // PRESENT AREA
                                // =====================================

                                cmd.Parameters.Add(
                                    "@PresentAreaID",
                                    SqlDbType.Int)
                                    .Value =
                                    presentAreaID;


                                // =====================================
                                // LANGUAGES
                                // =====================================

                                cmd.Parameters.Add(
                                    "@LanguagesKnown",
                                    SqlDbType.NVarChar,
                                    500)
                                    .Value =
                                    languages;


                                // =====================================
                                // QUALIFICATION
                                // =====================================

                                cmd.Parameters.Add(
                                    "@Qualification",
                                    SqlDbType.NVarChar,
                                    100)
                                    .Value =
                                    string.IsNullOrWhiteSpace(
                                        ddlQualification.SelectedValue)
                                    ? (object)DBNull.Value
                                    : ddlQualification.SelectedValue;


                                // =====================================
                                // EXPERIENCE
                                // =====================================

                                cmd.Parameters.Add(
                                    "@Experience",
                                    SqlDbType.NVarChar,
                                    50)
                                    .Value =
                                    ddlExperience.SelectedValue;


                                // =====================================
                                // DUTY PREFERENCE
                                // =====================================

                                cmd.Parameters.Add(
                                    "@DutyPreference",
                                    SqlDbType.NVarChar,
                                    500)
                                    .Value =
                                    dutyPreference;


                                // =====================================
                                // EXPECTED SALARY
                                // =====================================

                                SqlParameter salaryParameter =
                                    cmd.Parameters.Add(
                                        "@ExpectedSalary",
                                        SqlDbType.Decimal);

                                salaryParameter.Precision = 10;
                                salaryParameter.Scale = 2;

                                salaryParameter.Value =
                                    expectedSalary;


                                // =====================================
                                // PREFERRED WORK AREAS
                                // =====================================

                                cmd.Parameters.Add(
                                    "@PreferredWorkAreas",
                                    SqlDbType.NVarChar,
                                    1000)
                                    .Value =
                                    string.IsNullOrWhiteSpace(
                                        preferredWorkAreasValue)
                                    ? (object)DBNull.Value
                                    : preferredWorkAreasValue;


                                // =====================================
                                // JOINING AVAILABILITY
                                // =====================================

                                cmd.Parameters.Add(
                                    "@JoiningAvailability",
                                    SqlDbType.NVarChar,
                                    50)
                                    .Value =
                                    ddlJoiningAvailability.SelectedValue;


                                // =====================================
                                // PROFILE PHOTO - OPTIONAL
                                // =====================================

                                SqlParameter photoParameter =
                                    cmd.Parameters.Add(
                                        "@ProfilePhoto",
                                        SqlDbType.VarBinary,
                                        -1);

                                photoParameter.Value =
                                    photoBytes != null
                                    ? (object)photoBytes
                                    : DBNull.Value;


                                // =====================================
                                // PROFILE PHOTO NAME - OPTIONAL
                                // =====================================

                                cmd.Parameters.Add(
                                    "@ProfilePhotoName",
                                    SqlDbType.NVarChar,
                                    200)
                                    .Value =
                                    profilePhotoName != null
                                    ? (object)profilePhotoName
                                    : DBNull.Value;


                                // =====================================
                                // REMARKS
                                // =====================================

                                cmd.Parameters.Add(
                                    "@Remarks",
                                    SqlDbType.NVarChar,
                                    1000)
                                    .Value =
                                    string.IsNullOrWhiteSpace(
                                        txtRemarks.Text)
                                    ? (object)DBNull.Value
                                    : txtRemarks.Text.Trim();


                                // =====================================
                                // AADHAR PHOTO - MANDATORY
                                // =====================================

                                SqlParameter aadharParameter =
                                    cmd.Parameters.Add(
                                        "@AadharPhoto",
                                        SqlDbType.VarBinary,
                                        -1);

                           


                                aadharParameter.Value =
                                   photoBytes1 != null
                                    ? (object)photoBytes1
                                    : DBNull.Value;

                                // =====================================
                                // EXECUTE
                                // =====================================

                                object result =
                                    cmd.ExecuteScalar();


                                if (result == null ||
                                    result == DBNull.Value)
                                {
                                    throw new Exception(
                                        "Unable to create caregiver profile.");
                                }


                                caregiverID =
                                    Convert.ToInt32(result);
                            }


                            // =========================================
                            // COMMIT TRANSACTION
                            // =========================================

                            transaction.Commit();


                            // =========================================
                            // SUCCESS
                            // =========================================

                            ShowMessage(
                                "Caregiver profile registered successfully. " +
                                "Caregiver ID: " +
                                caregiverID,
                                true);


                            ClearForm();
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
                ShowMessage(
                    "Error while saving caregiver profile: " +
                    ex.Message,
                    false);
            }
        }

        // ================================
        // PRESENT AREA SEARCH
        // ================================


        // ================================
        // CHECK PLACE
        // ================================

        private bool PlaceExists(int placeID)
        {
            using (SqlConnection con =
                   new SqlConnection(connectionString))
            {
                string sql = @"

SELECT COUNT(1)
FROM [sqladmin].[LocalPlaces]
WHERE PlaceID = @PlaceID;";


                using (SqlCommand cmd =
                       new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(
                        "@PlaceID",
                        SqlDbType.Int)
                        .Value = placeID;


                    con.Open();


                    return Convert.ToInt32(
                        cmd.ExecuteScalar()) > 0;
                }
            }
        }


        // ================================
        // CHECKBOX VALUES
        // ================================

        private string GetSelectedValues(
            CheckBoxList checkBoxList)
        {
            List<string> values =
                new List<string>();


            foreach (ListItem item in
                     checkBoxList.Items)
            {
                if (item.Selected)
                {
                    values.Add(item.Text);
                }
            }


            return string.Join(", ", values);
        }


        // ================================
        // MESSAGE
        // ================================

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.Visible = true;

            lblMessage.Text =
                Server.HtmlEncode(message);

            lblMessage.CssClass =
                success
                    ? "message success"
                    : "message error";
        }


        // ================================
        // CLEAR
        // ================================

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ClearForm();
        }


        private void ClearForm()
        {
            ddlRecruiter.SelectedIndex = 0;

            txtFullName.Text = "";
            txtAge.Text = "";
            ddlGender.SelectedIndex = 0;
            txtContactNumber.Text = "";
            ddlCity.SelectedIndex = 0;

            txtPresentArea.Text = "";
            hdnPresentAreaID.Value = "";

            ddlQualification.SelectedIndex = 0;
            ddlExperience.SelectedIndex = 0;

            txtExpectedSalary.Text = "";
            ddlJoiningAvailability.SelectedIndex = 0;

            txtPreferredWorkAreas.Text = "";
            txtRemarks.Text = "";

            foreach (ListItem item in cblServiceCategory.Items)
                item.Selected = false;

            foreach (ListItem item in cblLanguages.Items)
                item.Selected = false;

            foreach (ListItem item in cblDutyPreference.Items)
                item.Selected = false;
        }


        // ================================
        // SEARCH RESULT CLASS
        // ================================

        public class PlaceResult
        {
            public int PlaceID { get; set; }

            public string PlaceName { get; set; }
        }

        protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}