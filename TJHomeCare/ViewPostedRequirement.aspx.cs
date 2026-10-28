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
    public partial class ViewPostedRequirement : System.Web.UI.Page
    {
        private readonly string connectionString =
         ConfigurationManager
             .ConnectionStrings[
                 "hospi2yp_tabletjobssConnectionString_V02"]
             .ConnectionString;
        private const int PageSize = 9;
        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] == null ? 0 : (int)ViewState["CurrentPage"]; }
            set { ViewState["CurrentPage"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRecentRequirements();
            }
        }
private void LoadRecentRequirements()
        {
            string query = @"
        SELECT
            r.RequirementID,
            COALESCE(
                sc.ServiceName,
                NULLIF(r.Service, ''),
                'Not specified'
            ) AS Service,
            COALESCE(
                NULLIF(r.City, ''),
                lp.City,
                'Not specified'
            ) AS City,
            COALESCE(
                lp.PlaceName,
                NULLIF(r.Area, ''),
                'Not specified'
            ) AS Area,
            r.DutyTime,
            r.Budget,
            r.CreatedDate
        FROM [sqladmin].[PostRequirements] r
        LEFT JOIN [sqladmin].[ServiceCategories] sc
            ON r.ServiceCategoryID = sc.ServiceCategoryID
        LEFT JOIN [sqladmin].[LocalPlaces] lp
            ON TRY_CONVERT(INT, r.Area) = lp.PlaceID
        ORDER BY r.CreatedDate DESC, r.RequirementID DESC
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.Add("@Offset", SqlDbType.Int).Value =
                    CurrentPage * PageSize;

                cmd.Parameters.Add("@PageSize", SqlDbType.Int).Value =
                    PageSize;

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptRecentRequirements.DataSource = dt;
                rptRecentRequirements.DataBind();
            }

            UpdatePagination();
        }
       
private void UpdatePagination()
        {
            int totalRecords = GetTotalRequirements();

            int totalPages = (int)Math.Ceiling(
                (double)totalRecords / PageSize);

            if (totalPages == 0)
                totalPages = 1;

            if (CurrentPage >= totalPages)
                CurrentPage = totalPages - 1;

            if (CurrentPage < 0)
                CurrentPage = 0;

            lblPage.Text = "Page " + (CurrentPage + 1) +
                           " of " + totalPages;

            btnPrevious.Enabled = CurrentPage > 0;
            btnNext.Enabled = CurrentPage < totalPages - 1;
        }

        private int GetTotalRequirements()
        {
            string query =
                "SELECT COUNT(*) FROM [sqladmin].[PostRequirements]";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        protected void PreviousPage(object sender, EventArgs e)
        {
            if (CurrentPage > 0)
            {
                CurrentPage--;
                LoadRecentRequirements();
            }
        }

        protected void NextPage(object sender, EventArgs e)
        {
            int totalRecords = GetTotalRequirements();
            int totalPages = (int)Math.Ceiling(
                (double)totalRecords / PageSize);

            if (CurrentPage < totalPages - 1)
            {
                CurrentPage++;
                LoadRecentRequirements();
            }
        }

        protected bool IsNewRequirement(object value)
        {
            if (value == null || value == DBNull.Value)
                return false;

            DateTime posted = Convert.ToDateTime(value);

            return posted <= DateTime.Now &&
                   posted >= DateTime.Now.AddHours(-24);
        }
        protected string GetServiceClass(object value)
        {
            string service = Convert.ToString(value).ToLowerInvariant();

            if (service.Contains("baby"))
                return "baby";

            if (service.Contains("elder"))
                return "elder";

            if (service.Contains("patient"))
                return "patient";

            if (service.Contains("nurse") ||
                service.Contains("nursing"))
                return "nurse";

            if (service.Contains("maid") ||
                service.Contains("household"))
                return "maid";

            if (service.Contains("cook") ||
                service.Contains("cooking"))
                return "cook";

            return "baby";
        }

        protected string GetServiceIcon(object value)
        {
            string service = Convert.ToString(value).ToLowerInvariant();

            if (service.Contains("baby"))
                return "fa-solid fa-baby";

            if (service.Contains("elder"))
                return "fa-solid fa-person-cane";

            if (service.Contains("patient"))
                return "fa-solid fa-user-nurse";

            if (service.Contains("nurse") ||
                service.Contains("nursing"))
                return "fa-solid fa-user-nurse";

            if (service.Contains("maid") ||
                service.Contains("household"))
                return "fa-solid fa-broom";

            if (service.Contains("cook") ||
                service.Contains("cooking"))
                return "fa-solid fa-utensils";

            return "fa-solid fa-house";
        }
        protected bool HasValue(object value)
        {
            return value != null &&
                   value != DBNull.Value &&
                   !string.IsNullOrWhiteSpace(value.ToString());
        }

        protected string DisplayValue(object value)
        {
            return HasValue(value) ? value.ToString() : "Not specified";
        }
       
        protected string GetPostedTime(object value)
        {
            if (value == null || value == DBNull.Value)
                return "";

            DateTime posted = Convert.ToDateTime(value);
            TimeSpan elapsed = DateTime.Now - posted;

            if (elapsed.TotalMinutes < 1)
                return "Just now";

            if (elapsed.TotalHours < 1)
                return (int)elapsed.TotalMinutes + " minutes ago";

            if (elapsed.TotalHours < 24)
                return (int)elapsed.TotalHours + " hours ago";

            if (elapsed.TotalDays < 2)
                return "1 day ago";

            if (elapsed.TotalDays < 7)
                return (int)elapsed.TotalDays + " days ago";

            return posted.ToString("dd MMM yyyy");
        }
        protected void rptRecentRequirements_ItemCommand(
          object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteRequirement")
                return;

            int requirementID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out requirementID))
            {
                Response.Write("Invalid Requirement ID: " +
                    Convert.ToString(e.CommandArgument));
                return;
            }

            string query = @"
        DELETE FROM [sqladmin].[PostRequirements]
        WHERE RequirementID = @RequirementID;";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                cmd.Parameters.Add(
                    "@RequirementID", SqlDbType.Int).Value =
                    requirementID;

                con.Open();

                int rowsDeleted = cmd.ExecuteNonQuery();

                if (rowsDeleted > 0)
                {
                    LoadRecentRequirements();

                    Response.Write(
                        "Requirement ID " + requirementID +
                        " deleted successfully.");
                }
                else
                {
                    Response.Write(
                        "No record deleted. Requirement ID: " +
                        requirementID);
                }
            }
        }
    }
}