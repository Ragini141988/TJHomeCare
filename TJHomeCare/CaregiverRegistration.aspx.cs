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


        private int EditCaregiverID
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["CaregiverID"], out id) ? id : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindServiceCategories();
                if (EditCaregiverID > 0)
                {
                    LoadCaregiverForEdit(EditCaregiverID);
                    btnSave.Text = "Update Caregiver";
                    btnClear.Text = "Cancel";
                    Page.Title = "Edit Caregiver";
                }
            }
        }

        private void LoadCaregiverForEdit(int caregiverID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                const string sql = @"SELECT CaregiverID, RecruiterName, ServiceCategory, FullName, Age, Gender,
ContactNumber, City, PresentAreaID, LanguagesKnown, Qualification, Experience,
DutyPreference, ExpectedSalary, PreferredWorkAreas, JoiningAvailability, Remarks
FROM [sqladmin].[CaregiverProfiles] WHERE CaregiverID=@CaregiverID;";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = caregiverID;
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                        {
                            ShowMessage("Caregiver record was not found.", false);
                            btnSave.Enabled = false;
                            return;
                        }
                        SetDropDownValue(ddlRecruiter, Convert.ToString(dr["RecruiterName"]));
                        txtFullName.Text = Convert.ToString(dr["FullName"]);
                        txtAge.Text = Convert.ToString(dr["Age"]);
                        SetDropDownValue(ddlGender, Convert.ToString(dr["Gender"]));
                        txtContactNumber.Text = Convert.ToString(dr["ContactNumber"]);
                        SetDropDownValue(ddlCity, Convert.ToString(dr["City"]));
                        hdnPresentAreaID.Value = dr["PresentAreaID"] == DBNull.Value ? "" : Convert.ToString(dr["PresentAreaID"]);
                        txtPresentArea.Text =
                                   Server.HtmlEncode(
                                       GetPreferredWorkAreaNames(dr["PresentAreaID"].ToString()));
                        SetDropDownValue(ddlQualification, Convert.ToString(dr["Qualification"]));
                        SetDropDownValue(ddlExperience, Convert.ToString(dr["Experience"]));
                        txtExpectedSalary.Text = Convert.ToString(dr["ExpectedSalary"]);
                        SetDropDownValue(ddlJoiningAvailability, Convert.ToString(dr["JoiningAvailability"]));
                        txtPreferredWorkAreas.Text = Server.HtmlEncode(
                                       GetPreferredWorkAreaNames(Convert.ToString(dr["PreferredWorkAreas"])));
                        hdnPreferredWorkAreaIDs.Value = Convert.ToString(dr["PreferredWorkAreas"]);
                        txtRemarks.Text = Convert.ToString(dr["Remarks"]);
                        SetCheckBoxValues(cblLanguages, Convert.ToString(dr["LanguagesKnown"]));
                        SetCheckBoxValues(cblDutyPreference, Convert.ToString(dr["DutyPreference"]));
                    }
                }
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ServiceCategoryID FROM [sqladmin].[CaregiverServices] WHERE CaregiverID=@CaregiverID", con))
                {
                    cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = caregiverID;
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            ListItem item = cblServiceCategory.Items.FindByValue(Convert.ToString(dr["ServiceCategoryID"]));
                            if (item != null) item.Selected = true;
                        }
                    }
                }
            }
        }

        private void SetDropDownValue(DropDownList ddl, string value)
        {
            ListItem item = ddl.Items.FindByValue(value);
            if (item != null) ddl.SelectedValue = value;
        }

        private void SetCheckBoxValues(CheckBoxList list, string csv)
        {
            string[] values = (csv ?? "").Split(',');
            foreach (ListItem item in list.Items)
                item.Selected = Array.Exists(values, v =>
                    v.Trim().Equals(item.Value, StringComparison.OrdinalIgnoreCase) ||
                    v.Trim().Equals(item.Text, StringComparison.OrdinalIgnoreCase));
        }

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
IF @CaregiverID > 0
BEGIN
    UPDATE [sqladmin].[CaregiverProfiles]
    SET RecruiterName=@RecruiterName, ServiceCategory=@ServiceCategory,
        FullName=@FullName, Age=@Age, Gender=@Gender, ContactNumber=@ContactNumber,
        City=@City, PresentAreaID=@PresentAreaID, LanguagesKnown=@LanguagesKnown,
        Qualification=@Qualification, Experience=@Experience, DutyPreference=@DutyPreference,
        ExpectedSalary=@ExpectedSalary, PreferredWorkAreas=@PreferredWorkAreas,
        JoiningAvailability=@JoiningAvailability,
        ProfilePhoto=COALESCE(@ProfilePhoto, ProfilePhoto),
        ProfilePhotoName=COALESCE(@ProfilePhotoName, ProfilePhotoName),
        Remarks=@Remarks, AadharPhoto=COALESCE(@AadharPhoto, AadharPhoto)
    WHERE CaregiverID=@CaregiverID;
    SELECT @CaregiverID;
END
ELSE
BEGIN
    INSERT INTO [sqladmin].[CaregiverProfiles]
    (RecruiterName, ServiceCategory, FullName, Age, Gender, ContactNumber, City,
     PresentAreaID, LanguagesKnown, Qualification, Experience, DutyPreference,
     ExpectedSalary, PreferredWorkAreas, JoiningAvailability, ProfilePhoto,
     ProfilePhotoName, VerificationStatus, Remarks, CreatedDate, AadharPhoto)
    VALUES
    (@RecruiterName, @ServiceCategory, @FullName, @Age, @Gender, @ContactNumber, @City,
     @PresentAreaID, @LanguagesKnown, @Qualification, @Experience, @DutyPreference,
     @ExpectedSalary, @PreferredWorkAreas, @JoiningAvailability, @ProfilePhoto,
     @ProfilePhotoName, 'Pending', @Remarks, GETDATE(), @AadharPhoto);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END
";


                            int caregiverID;


                            using (SqlCommand cmd =
                                new SqlCommand(
                                    sql,
                                    con,
                                    transaction))
                            {
                                // =====================================
                                cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = EditCaregiverID;

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
                            // SAVE SELECTED SERVICES IN MAPPING TABLE
                            // One row per caregiver per selected service.
                            // The old comma-separated column is retained
                            // temporarily for backward compatibility.
                            // =========================================

                            if (EditCaregiverID > 0)
                            {
                                using (SqlCommand deleteMappings = new SqlCommand(
                                    "DELETE FROM [sqladmin].[CaregiverServices] WHERE CaregiverID=@CaregiverID",
                                    con, transaction))
                                {
                                    deleteMappings.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = caregiverID;
                                    deleteMappings.ExecuteNonQuery();
                                }
                            }

                            const string serviceMapSql = @"
                                INSERT INTO [sqladmin].[CaregiverServices]
                                    (CaregiverID, ServiceCategoryID)
                                VALUES
                                    (@CaregiverID, @ServiceCategoryID);";

                            foreach (ListItem item in cblServiceCategory.Items)
                            {
                                if (!item.Selected)
                                    continue;

                                int serviceCategoryID;
                                if (!int.TryParse(item.Value, out serviceCategoryID))
                                {
                                    throw new Exception(
                                        "A selected service category has an invalid ID.");
                                }

                                using (SqlCommand mapCmd =
                                    new SqlCommand(serviceMapSql, con, transaction))
                                {
                                    mapCmd.Parameters.Add(
                                        "@CaregiverID", SqlDbType.Int).Value = caregiverID;

                                    mapCmd.Parameters.Add(
                                        "@ServiceCategoryID", SqlDbType.Int).Value =
                                        serviceCategoryID;

                                    mapCmd.ExecuteNonQuery();
                                }
                            }

                            // =========================================
                            // COMMIT TRANSACTION
                            // =========================================

                            transaction.Commit();


                            // =========================================
                            // SUCCESS
                            // =========================================

                            ShowMessage(
                                EditCaregiverID > 0
                                    ? "Caregiver profile updated successfully."
                                    : "Caregiver profile registered successfully. Caregiver ID: " + caregiverID,
                                true);

                            if (EditCaregiverID > 0)
                            {
                                Response.Redirect("CaregiverList.aspx", false);
                                Context.ApplicationInstance.CompleteRequest();
                                return;
                            }
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
            if (EditCaregiverID > 0)
            {
                Response.Redirect("CaregiverList.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
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
        private string GetPreferredWorkAreaNames(string preferredAreaIDs)
        {
            if (string.IsNullOrWhiteSpace(preferredAreaIDs))
                return "-";


            string[] idArray =
                preferredAreaIDs.Split(
                    new[] { ',' },
                    StringSplitOptions.RemoveEmptyEntries);


            List<int> placeIDs =
                new List<int>();


            foreach (string idText in idArray)
            {
                int placeID;

                if (int.TryParse(idText.Trim(), out placeID))
                {
                    if (!placeIDs.Contains(placeID))
                    {
                        placeIDs.Add(placeID);
                    }
                }
            }


            if (placeIDs.Count == 0)
                return "-";


            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                List<string> parameterNames =
                    new List<string>();


                using (SqlCommand cmd =
                    new SqlCommand())
                {
                    cmd.Connection = con;


                    for (int i = 0; i < placeIDs.Count; i++)
                    {
                        string parameterName =
                            "@PlaceID" + i;

                        parameterNames.Add(parameterName);

                        cmd.Parameters.Add(
                            parameterName,
                            SqlDbType.Int)
                            .Value = placeIDs[i];
                    }


                    string sql = @"
                SELECT PlaceID, PlaceName
                FROM [sqladmin].[LocalPlaces]
                WHERE PlaceID IN (" +
                        string.Join(",", parameterNames) + @")
                ORDER BY OrderColumn ASC, PlaceName ASC";


                    cmd.CommandText = sql;


                    con.Open();


                    Dictionary<int, string> placeNames =
                        new Dictionary<int, string>();


                    using (SqlDataReader areaReader =
                        cmd.ExecuteReader())
                    {
                        while (areaReader.Read())
                        {
                            int placeID =
                                Convert.ToInt32(
                                    areaReader["PlaceID"]);


                            string placeName =
                                areaReader["PlaceName"].ToString();


                            if (!placeNames.ContainsKey(placeID))
                            {
                                placeNames.Add(
                                    placeID,
                                    placeName);
                            }
                        }
                    }


                    List<string> names =
                        new List<string>();


                    // Keep the same order as the IDs
                    // stored in PreferredWorkAreas

                    foreach (int placeID in placeIDs)
                    {
                        string placeName;

                        if (placeNames.TryGetValue(
                            placeID,
                            out placeName))
                        {
                            names.Add(placeName);
                        }
                    }


                    if (names.Count == 0)
                        return "-";


                    return string.Join(", ", names);
                }
            }
        }
    }
}