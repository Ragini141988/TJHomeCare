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
    public partial class ViewJobApplications : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadApplications();
            }
        }

        private void LoadApplications()
        {
            try
            {

                string query = @"
    SELECT
        JA.ApplicationID,
        JA.RequirementID,
        SC.ServiceName AS Service,
        PR.City,
        PR.Area,
        JA.ApplicantName,
        JA.ApplicantMobile,
        JA.CaregiverID,
        JA.AppliedOn,
        JA.ApplicationStatus
    FROM [sqladmin].[JobApplications] AS JA
    LEFT JOIN [sqladmin].[PostRequirements] AS PR
        ON JA.RequirementID = PR.RequirementID
    LEFT JOIN [sqladmin].[ServiceCategories] AS SC
        ON TRY_CONVERT(INT, PR.Service) = SC.ServiceCategoryID
    ORDER BY
        JA.AppliedOn DESC,
        JA.ApplicationID DESC;";


                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                using (SqlDataAdapter da =
                    new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptApplications.DataSource = dt;
                    rptApplications.DataBind();

                    lblTotal.Text = dt.Rows.Count.ToString();

                    lblMessage.Text =
                        "Showing " + dt.Rows.Count +
                        " application record(s).";

                    lblMessage.ForeColor =
                        System.Drawing.Color.DarkGreen;
                }
            }
            catch (Exception)
            {
                lblTotal.Text = "0";

                lblMessage.Text =
                    "Unable to load applications. Please check the connection string, database, and table columns.";

                lblMessage.ForeColor =
                    System.Drawing.Color.Red;
            }
        }
       
       
    }
}