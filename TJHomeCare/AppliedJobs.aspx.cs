using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class AppliedJobs : System.Web.UI.Page
    {
        private readonly string connectionString =
           ConfigurationManager.ConnectionStrings[
               "hospi2yp_tabletjobssConnectionString_V02"
           ].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSummary();
                LoadServiceFilter();
                LoadCityFilter();
                LoadAppliedJobs();
            }
        }

        // Dashboard Summary
        private void LoadSummary()
        {
            string query = @"
                SELECT
                    COUNT(*) AS TotalApplications,

                    SUM(CASE
                        WHEN ApplicationStatus = 'Pending'
                        THEN 1 ELSE 0 END) AS PendingApplications,

                    SUM(CASE
                        WHEN ApplicationStatus = 'Approved'
                        THEN 1 ELSE 0 END) AS ApprovedApplications,

                    SUM(CASE
                        WHEN ApplicationStatus = 'Rejected'
                        THEN 1 ELSE 0 END) AS RejectedApplications

                FROM [sqladmin].[JobApplications]";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblTotal.Text =
                            Convert.ToString(dr["TotalApplications"]);

                        lblPending.Text =
                            Convert.ToString(dr["PendingApplications"]);

                        lblApproved.Text =
                            Convert.ToString(dr["ApprovedApplications"]);

                        lblRejected.Text =
                            Convert.ToString(dr["RejectedApplications"]);
                    }
                }
            }
        }

        // Load Service Dropdown
        private void LoadServiceFilter()
        {
            string query = @"
                SELECT DISTINCT SC.ServiceName
                FROM [sqladmin].[JobApplications] JA

                INNER JOIN [sqladmin].[PostRequirements] PR
                    ON JA.RequirementID = PR.RequirementID

                INNER JOIN [sqladmin].[ServiceCategories] SC
                    ON TRY_CONVERT(INT, PR.Service)
                       = SC.ServiceCategoryID

                WHERE SC.ServiceName IS NOT NULL

                ORDER BY SC.ServiceName";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlService.DataSource = dr;
                    ddlService.DataTextField = "ServiceName";
                    ddlService.DataValueField = "ServiceName";
                    ddlService.DataBind();
                }
            }

            ddlService.Items.Insert(
                0, new System.Web.UI.WebControls.ListItem(
                    "All Services", ""));
        }

        // Load City Dropdown
        private void LoadCityFilter()
        {
            string query = @"
                SELECT DISTINCT PR.City
                FROM [sqladmin].[JobApplications] JA

                INNER JOIN [sqladmin].[PostRequirements] PR
                    ON JA.RequirementID = PR.RequirementID

                WHERE PR.City IS NOT NULL
                ORDER BY PR.City";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlCity.DataSource = dr;
                    ddlCity.DataTextField = "City";
                    ddlCity.DataValueField = "City";
                    ddlCity.DataBind();
                }
            }

            ddlCity.Items.Insert(
                0, new System.Web.UI.WebControls.ListItem(
                    "All Cities", ""));
        }

        // Load Applications with Filters
        private void LoadAppliedJobs()
        {
            string query = @"
        SELECT
            JA.ApplicationID,
            JA.RequirementID,
            JA.ApplicantName,
            JA.ApplicantMobile,
            JA.AppliedOn,
            JA.ApplicationStatus,

            ISNULL(SC.ServiceName,
                CONVERT(NVARCHAR(100), PR.Service)) AS Service,

            PR.City,
            PR.Area,
            PR.DutyTime,
            PR.Budget,
            PR.JoiningDate,
            PR.PreferredLanguage

        FROM [sqladmin].[JobApplications] JA

        INNER JOIN [sqladmin].[PostRequirements] PR
            ON JA.RequirementID = PR.RequirementID

        LEFT JOIN [sqladmin].[ServiceCategories] SC
            ON TRY_CONVERT(INT, PR.Service)
               = SC.ServiceCategoryID

        WHERE
            (
                @Status = ''
                OR LTRIM(RTRIM(JA.ApplicationStatus)) = @Status
            )

            AND
            (
                @Service = ''
                OR SC.ServiceName = @Service
            )

            AND
            (
                @City = ''
                OR PR.City = @City
            )

            AND
            (
                @Search = ''
                OR JA.ApplicantName LIKE @SearchPattern
                OR JA.ApplicantMobile LIKE @SearchPattern
                OR ISNULL(PR.Area, '') LIKE @SearchPattern
                OR ISNULL(PR.City, '') LIKE @SearchPattern
                OR ISNULL(SC.ServiceName, '') LIKE @SearchPattern
            )

        ORDER BY JA.AppliedOn DESC";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                string search = txtSearch.Text.Trim();

                cmd.Parameters.Add(
                    "@Status", SqlDbType.NVarChar, 50
                ).Value = ddlStatus.SelectedValue.Trim();

                cmd.Parameters.Add(
                    "@Service", SqlDbType.NVarChar, 100
                ).Value = ddlService.SelectedValue.Trim();

                cmd.Parameters.Add(
                    "@City", SqlDbType.NVarChar, 100
                ).Value = ddlCity.SelectedValue.Trim();

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 200
                ).Value = search;

                cmd.Parameters.Add(
                    "@SearchPattern", SqlDbType.NVarChar, 202
                ).Value = "%" + search + "%";

                using (SqlDataAdapter da =
                    new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    rptAppliedJobs.DataSource = dt;
                    rptAppliedJobs.DataBind();

                    lblShowing.Text = dt.Rows.Count.ToString();

                    pnlNoRecords.Visible = dt.Rows.Count == 0;
                }
            }
        }
        
       
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadAppliedJobs();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedIndex = 0;
            ddlService.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;

            LoadAppliedJobs();
        }
    }
}
    