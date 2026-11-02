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
    public partial class ViewJobs : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    LoadJobs();
            //    LoadTotalApplied();
            //}
            if (!IsPostBack)
            {
                int requirementId;

                if (int.TryParse(Request.QueryString["id"], out requirementId))
                {
                    LoadJobs(requirementId);
                }
                else
                {
                    LoadJobs();
                }

                LoadTotalApplied();
            }
        }

        private void LoadJobs()
        {

            string query = @"
  SELECT
    p.RequirementID,
    sc.ServiceName AS Service,
    p.City,
    L.PlaceName AS Area,
    p.DutyTime,
    p.PreferredLanguage,
    p.Budget,
    p.JoiningDate
FROM [sqladmin].[PostRequirements] p

LEFT JOIN [sqladmin].[ServiceCategories] sc
    ON TRY_CONVERT(INT, p.Service) = sc.ServiceCategoryID

LEFT JOIN [sqladmin].[LocalPlaces] L
    ON p.PresentAreaID = L.PlaceID

ORDER BY p.RequirementID DESC;";


            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();

                da.Fill(dt);

                lblTotalJobs.Text = dt.Rows.Count.ToString();

                rptJobs.DataSource = dt;
                rptJobs.DataBind();

                pnlNoJobs.Visible = dt.Rows.Count == 0;
            }
        }

        //New Method

        private void LoadJobs(int requirementId)
        {
            string query = @"
SELECT
    p.RequirementID,
    sc.ServiceName AS Service,
    p.City,
    L.PlaceName AS Area,
    p.DutyTime,
    p.PreferredLanguage,
    p.Budget,
    p.JoiningDate
FROM [sqladmin].[PostRequirements] p
LEFT JOIN [sqladmin].[ServiceCategories] sc
    ON TRY_CONVERT(INT, p.Service) = sc.ServiceCategoryID
LEFT JOIN [sqladmin].[LocalPlaces] L
    ON p.PresentAreaID = L.PlaceID

WHERE p.RequirementID = @RequirementID
ORDER BY p.RequirementID DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@RequirementID", requirementId);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    lblTotalJobs.Text = dt.Rows.Count.ToString();

                    rptJobs.DataSource = dt;
                    rptJobs.DataBind();

                    pnlNoJobs.Visible = dt.Rows.Count == 0;
                }
            }
        }
        //Close New Method
        protected void rptJobs_ItemCommand(
            object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Apply")
            {
                string requirementId = Convert.ToString(e.CommandArgument);

                // Application page will receive the selected RequirementID.
                Response.Redirect(
                    ResolveUrl("~/ApplyJob.aspx?id=") +
                    Server.UrlEncode(requirementId));
            }
        }

        private void LoadTotalApplied()
        {
            try
            {
                string query = @"
            SELECT COUNT(*)
            FROM [sqladmin].[JobApplications];";

                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    int totalApplied = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalApplied.Text = totalApplied.ToString();
                }
            }
            catch (Exception)
            {
                lblTotalApplied.Text = "0";
            }
        }

    }
}