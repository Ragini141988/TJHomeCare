using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class ApplyJob : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;
        private int RequirementID
        {
            get
            {
                int id;

                if (int.TryParse(Request.QueryString["id"], out id))
                    return id;

                return 0;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (RequirementID <= 0)
                {
                    lblMessage.Text = "Invalid job ID.";
                    btnApply.Enabled = false;
                    return;
                }

                LoadJobDetails();
            }

        }
        private void LoadJobDetails()
        {
            string query = @"
                SELECT
                    sc.ServiceName AS Service,
                    p.City,
                    p.Area,
                    p.DutyTime,
                    p.Budget
                FROM [sqladmin].[PostRequirements] p
                LEFT JOIN [sqladmin].[ServiceCategories] sc
                    ON TRY_CONVERT(INT, p.Service)
                       = sc.ServiceCategoryID
                WHERE p.RequirementID = @RequirementID";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue(
                    "@RequirementID", RequirementID);

                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblService.Text = Server.HtmlEncode(
                            Convert.ToString(dr["Service"]));

                        lblLocation.Text = Server.HtmlEncode(
                            Convert.ToString(dr["Area"]) + ", " +
                            Convert.ToString(dr["City"]));

                        lblDutyTime.Text = Server.HtmlEncode(
                            Convert.ToString(dr["DutyTime"]));

                        lblBudget.Text = Server.HtmlEncode(
                            Convert.ToString(dr["Budget"]));
                    }
                    else
                    {
                        lblMessage.Text =
                            "This job is no longer available.";

                        btnApply.Enabled = false;
                    }
                }
            }
        }
        protected void btnApply_Click(object sender, EventArgs e)
        {
            string name = txtApplicantName.Text.Trim();
            string mobile = txtApplicantMobile.Text.Trim();

            if (RequirementID <= 0)
            {
                lblMessage.Text = "Invalid job ID.";
                return;
            }

            if (string.IsNullOrWhiteSpace(name))
            {
                lblMessage.Text = "Please enter your name.";
                return;
            }

            if (!Regex.IsMatch(mobile, @"^[6-9]\d{9}$"))
            {
                lblMessage.Text =
                    "Please enter a valid 10-digit mobile number.";
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    con.Open();

                    // Step 1: Check whether the job exists
                    string jobQuery = @"
                SELECT COUNT(1)
                FROM [sqladmin].[PostRequirements]
                WHERE RequirementID = @RequirementID";

                    using (SqlCommand jobCmd =
                        new SqlCommand(jobQuery, con))
                    {
                        jobCmd.Parameters.AddWithValue(
                            "@RequirementID", RequirementID);

                        int jobExists = Convert.ToInt32(
                            jobCmd.ExecuteScalar());

                        if (jobExists == 0)
                        {
                            lblMessage.Text =
                                "This job is no longer available.";
                            return;
                        }
                    }

                    // Step 2: Find the caregiver using mobile number
                    object caregiverID = DBNull.Value;

                    string caregiverQuery = @"
                SELECT TOP 1 CaregiverID
                FROM [sqladmin].[CaregiverProfiles]
                WHERE LTRIM(RTRIM(ContactNumber)) = @Mobile
                ORDER BY CaregiverID DESC";

                    using (SqlCommand caregiverCmd =
                        new SqlCommand(caregiverQuery, con))
                    {
                        caregiverCmd.Parameters.AddWithValue(
                            "@Mobile", mobile);

                        object matchedID =
                            caregiverCmd.ExecuteScalar();

                        if (matchedID != null &&
                            matchedID != DBNull.Value)
                        {
                            caregiverID = matchedID;
                        }
                    }

                    // Step 3: Insert the application
                    string insertQuery = @"
                INSERT INTO [sqladmin].[JobApplications]
                (
                    RequirementID,
                    CaregiverID,
                    ApplicantName,
                    ApplicantMobile,
                    ApplicationStatus
                )
                VALUES
                (
                    @RequirementID,
                    @CaregiverID,
                    @ApplicantName,
                    @ApplicantMobile,
                    'Pending'
                )";

                    using (SqlCommand cmd =
                        new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue(
                            "@RequirementID", RequirementID);

                        cmd.Parameters.Add(
                            "@CaregiverID", System.Data.SqlDbType.Int
                        ).Value = caregiverID;

                        cmd.Parameters.AddWithValue(
                            "@ApplicantName", name);

                        cmd.Parameters.AddWithValue(
                            "@ApplicantMobile", mobile);

                        cmd.ExecuteNonQuery();
                    }

                    lblMessage.Text =
                        caregiverID == DBNull.Value
                        ? "Application submitted successfully! No matching registered caregiver was found."
                        : "Application submitted successfully! Caregiver ID: "
                            + caregiverID.ToString();

                    lblMessage.ForeColor =
                        System.Drawing.Color.Green;

                    btnApply.Enabled = false;
                    txtApplicantMobile.Text = "";
                    txtApplicantName.Text = "";
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2601 || ex.Number == 2627)
                {
                    lblMessage.Text =
                        "You have already applied for this job.";
                }
                else
                {
                    lblMessage.Text =
                        "Unable to submit application. Please try again.";
                }
            }
        }
    }
}
