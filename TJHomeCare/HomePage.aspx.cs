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
    public partial class HomePage : System.Web.UI.Page
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
                LoadReviews();
            }
            if (!IsPostBack)
            {
                LoadRecentRequirements();
            }
        }
        private void LoadReviews()
        {
            string query = @"
            SELECT TOP (6)
                   [ReviewId],
                   [Name],
                   [Rating],
                   [Remarks],
                   [ReviewDate],
                   [City]
            FROM [sqladmin].[Reviews]
            WHERE [IsActive] = 1
            ORDER BY [ReviewDate] DESC, [ReviewId] DESC;";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        da.Fill(dt);

                        rptReviews.DataSource = dt;
                        rptReviews.DataBind();
                    }
                }
            }
        }

        public string GetStars(object rating)
        {
            int stars = 0;

            if (rating != null && rating != DBNull.Value)
            {
                int.TryParse(rating.ToString(), out stars);
            }

            // Keep the rating between 0 and 5.
            stars = Math.Max(0, Math.Min(5, stars));

            return new string('★', stars)
                 + new string('☆', 5 - stars);
        }

        public string GetInitial(object name)
        {
            if (name == null || name == DBNull.Value)
            {
                return "?";
            }

            string reviewerName = name.ToString().Trim();

            if (string.IsNullOrEmpty(reviewerName))
            {
                return "?";
            }

            return Server.HtmlEncode(
                reviewerName.Substring(0, 1).ToUpperInvariant());
        }

        private void LoadRecentRequirements()
        {
            string query = @"
        SELECT TOP (10)
            r.RequirementID,
            r.Service,
            COALESCE(
                NULLIF(r.City, ''),
                lp.City,
                'Not specified'
            ) AS City,
            COALESCE(
                lp.PlaceName,
                NULLIF(r.Area, '')
            ) AS Area,
            r.DutyTime,
            r.Budget,
            r.CreatedDate
        FROM [sqladmin].[PostRequirements] r
        LEFT JOIN [sqladmin].[LocalPlaces] lp
            ON  r.Area = lp.PlaceID
        ORDER BY r.CreatedDate DESC, r.RequirementID DESC;";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptRecentRequirements.DataSource = dt;
                rptRecentRequirements.DataBind();
            }
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



    }
}
