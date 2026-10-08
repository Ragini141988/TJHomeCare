using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class viewcaregiverdetails : Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings[
                    "hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCaregiverDetails();
            }
        }


        // =========================================================
        // LOAD CAREGIVER DETAILS
        // =========================================================

        private void LoadCaregiverDetails()
        {
            string idText = Request.QueryString["id"];

            int caregiverID;

            if (!int.TryParse(idText, out caregiverID))
            {
                ShowError("Invalid caregiver ID.");
                return;
            }


            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        CaregiverID,
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
                        VerificationStatus,
                        Remarks,
                        CreatedDate,
                        UpdatedDate,
                        ProfilePhoto,
AadharPhoto
                    FROM [sqladmin].[CaregiverProfiles]
                    WHERE CaregiverID = @CaregiverID";


                using (SqlCommand cmd =
                    new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(
                        "@CaregiverID",
                        SqlDbType.Int)
                        .Value = caregiverID;


                    con.Open();


                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowError(
                                "Caregiver profile was not found.");

                            return;
                        }


                        // =============================================
                        // BASIC INFORMATION
                        // =============================================

                        lblCaregiverID.Text =
                            reader["CaregiverID"].ToString();


                        lblFullName.Text =
                            Server.HtmlEncode(
                                reader["FullName"].ToString());


                        lblAge.Text =
                            reader["Age"].ToString();


                        lblGender.Text =
                            Server.HtmlEncode(
                                reader["Gender"].ToString());


                        lblContactNumber.Text =
                            Server.HtmlEncode(
                                reader["ContactNumber"].ToString());


                        lblCity.Text =
                            Server.HtmlEncode(
                                reader["City"].ToString());


                        // =============================================
                        // PRESENT AREA
                        // =============================================

                        int presentAreaID =
                            Convert.ToInt32(
                                reader["PresentAreaID"]);


                        lblPresentArea.Text =
                            Server.HtmlEncode(
                                GetPlaceName(presentAreaID));


                        // =============================================
                        // PROFESSIONAL INFORMATION
                        // =============================================

                        lblServiceCategory.Text =
                            Server.HtmlEncode(
                                reader["ServiceCategory"].ToString());


                        lblLanguages.Text =
                            Server.HtmlEncode(
                                reader["LanguagesKnown"].ToString());


                        lblQualification.Text =
                            reader["Qualification"] == DBNull.Value
                            ? "-"
                            : Server.HtmlEncode(
                                reader["Qualification"].ToString());


                        lblExperience.Text =
                            Server.HtmlEncode(
                                reader["Experience"].ToString());


                        lblDutyPreference.Text =
                            Server.HtmlEncode(
                                reader["DutyPreference"].ToString());

                        // =============================================================
                        // PREFERRED WORK AREAS
                        // =============================================================

                        if (reader["PreferredWorkAreas"] != DBNull.Value)
                        {
                            string preferredAreaIDs =
                                reader["PreferredWorkAreas"].ToString().Trim();

                            if (!string.IsNullOrWhiteSpace(preferredAreaIDs))
                            {
                                lblPreferredWorkAreas.Text =
                                    Server.HtmlEncode(
                                        GetPreferredWorkAreaNames(preferredAreaIDs));
                            }
                            else
                            {
                                lblPreferredWorkAreas.Text = "-";
                            }
                        }
                        else
                        {
                            lblPreferredWorkAreas.Text = "-";
                        }


                        lblJoiningAvailability.Text =
                            Server.HtmlEncode(
                                reader["JoiningAvailability"].ToString());


                        // =============================================
                        // SALARY
                        // =============================================

                        decimal expectedSalary =
                            Convert.ToDecimal(
                                reader["ExpectedSalary"]);


                        lblExpectedSalary.Text =
                            expectedSalary.ToString("N2");


                        // =============================================
                        // RECRUITMENT INFORMATION
                        // =============================================

                        lblRecruiter.Text =
                            Server.HtmlEncode(
                                reader["RecruiterName"].ToString());


                        string verificationStatus =
                            reader["VerificationStatus"].ToString();


                        lblVerificationStatus.Text =
                            Server.HtmlEncode(
                                verificationStatus);


                        lblVerificationStatus.CssClass =
                            GetStatusClass(
                                verificationStatus);


                        // =============================================
                        // CREATED DATE
                        // =============================================

                        if (reader["CreatedDate"] != DBNull.Value)
                        {
                            DateTime createdDate =
                                Convert.ToDateTime(
                                    reader["CreatedDate"]);


                            lblCreatedDate.Text =
                                createdDate.ToString(
                                    "dd-MMM-yyyy hh:mm tt");
                        }
                        else
                        {
                            lblCreatedDate.Text = "-";
                        }


                        // =============================================
                        // UPDATED DATE
                        // =============================================

                        if (reader["UpdatedDate"] != DBNull.Value)
                        {
                            DateTime updatedDate =
                                Convert.ToDateTime(
                                    reader["UpdatedDate"]);


                            lblUpdatedDate.Text =
                                updatedDate.ToString(
                                    "dd-MMM-yyyy hh:mm tt");
                        }
                        else
                        {
                            lblUpdatedDate.Text = "-";
                        }


                        // =============================================
                        // REMARKS
                        // =============================================

                        if (reader["Remarks"] != DBNull.Value &&
                            !string.IsNullOrWhiteSpace(
                                reader["Remarks"].ToString()))
                        {
                            lblRemarks.Text =
                                Server.HtmlEncode(
                                    reader["Remarks"].ToString());
                        }
                        else
                        {
                            lblRemarks.Text =
                                "No remarks available.";
                        }


                        // =============================================
                        // PROFILE PHOTO
                        // =============================================

                        if (reader["ProfilePhoto"] != DBNull.Value)
                        {
                            byte[] imageBytes =
                                (byte[])reader["ProfilePhoto"];


                            if (imageBytes != null &&
                                imageBytes.Length > 0)
                            {
                                string base64 =
                                    Convert.ToBase64String(
                                        imageBytes);


                                imgProfile.ImageUrl =
                                    "data:image/jpeg;base64," +
                                    base64;


                                imgProfile.Visible = true;
                                lblNoProfile.Visible = false;
                            }
                            else
                            {
                                imgProfile.Visible = false;
                                lblNoProfile.Visible = true;
                            }
                        }
                        else
                        {
                            imgProfile.Visible = false;
                            lblNoProfile.Visible = true;
                        }


                        // =============================================
                        // AADHAR PHOTO
                        // =============================================

                        if (reader["AadharPhoto"] != DBNull.Value)
                        {
                            byte[] imageBytes =
                                (byte[])reader["AadharPhoto"];


                            if (imageBytes != null &&
                                imageBytes.Length > 0)
                            {
                                string base64 =
                                    Convert.ToBase64String(
                                        imageBytes);


                                imgAadhar.ImageUrl =
                                    "data:image/jpeg;base64," +
                                    base64;


                                imgAadhar.Visible = true;
                                lblNoAadhar.Visible = false;
                            }
                            else
                            {
                                imgAadhar.Visible = false;
                                lblNoAadhar.Visible = true;
                            }
                        }
                        else
                        {
                            imgAadhar.Visible = false;
                            lblNoAadhar.Visible = true;
                        }

                        // =============================================
                        // SHOW DETAILS
                        // =============================================

                        pnlMessage.Visible = false;
                        pnlDetails.Visible = true;
                    }
                }
            }
        }


        // =========================================================
        // GET PLACE NAME
        // =========================================================

        private string GetPlaceName(int placeID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT PlaceName
                    FROM [sqladmin].[LocalPlaces]
                    WHERE PlaceID = @PlaceID";


                using (SqlCommand cmd =
                    new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(
                        "@PlaceID",
                        SqlDbType.Int)
                        .Value = placeID;


                    con.Open();


                    object result =
                        cmd.ExecuteScalar();


                    if (result == null ||
                        result == DBNull.Value)
                    {
                        return "-";
                    }


                    return result.ToString();
                }
            }
        }


        // =========================================================
        // STATUS CSS
        // =========================================================

        private string GetStatusClass(
            string status)
        {
            if (string.IsNullOrWhiteSpace(status))
            {
                return "status";
            }


            switch (status.Trim().ToLower())
            {
                case "verified":
                    return "status status-verified";


                case "rejected":
                    return "status status-rejected";


                case "pending":
                    return "status status-pending";


                default:
                    return "status";
            }
        }


        // =========================================================
        // ERROR
        // =========================================================

        private void ShowError(
            string message)
        {
            pnlDetails.Visible = false;

            pnlMessage.Visible = true;

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
        // =========================================================
        // GET PREFERRED WORK AREA NAMES
        // =========================================================

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
