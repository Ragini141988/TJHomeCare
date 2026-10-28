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
                LoadRecentCaregivers();
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
            // ServiceCategoryID is the new source of truth.
            // The old r.Service value is retained as a fallback while existing
            // requirement records are being migrated.
            string query = @"
        SELECT TOP (10)
            r.RequirementID,
            COALESCE(sc.ServiceName, NULLIF(r.Service, ''), 'Not specified') AS Service,
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
        LEFT JOIN [sqladmin].[ServiceCategories] sc
            ON r.ServiceCategoryID = sc.ServiceCategoryID
        LEFT JOIN [sqladmin].[LocalPlaces] lp
            ON TRY_CONVERT(INT, r.Area) = lp.PlaceID
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

        protected string GetInitials(object name)
        {
            string fullName = Convert.ToString(name);

            if (string.IsNullOrWhiteSpace(fullName))
                return "TJ";

            string[] parts = fullName.Trim().Split(
                new char[] { ' ' },
                StringSplitOptions.RemoveEmptyEntries);

            if (parts.Length == 1)
                return parts[0].Substring(0, 1).ToUpperInvariant();

            return (parts[0].Substring(0, 1) +
                    parts[parts.Length - 1].Substring(0, 1))
                    .ToUpperInvariant();
        }

        private void LoadRecentCaregivers()
        {
            // Build the displayed service list from CaregiverServices and
            // ServiceCategories. Keep the old text as a fallback until all
            // existing caregiver profiles have been migrated.
            string query = @"
                SELECT TOP (5)
                    C.CaregiverID,
                    C.FullName,
                    COALESCE(NULLIF(ServiceList.ServiceCategory, ''), C.ServiceCategory) AS ServiceCategory,
                    C.City,
                    L.PlaceName AS PresentArea,
                    C.Experience,
                    C.LanguagesKnown,
                    C.ProfilePhoto
                FROM [sqladmin].[CaregiverProfiles] C
                OUTER APPLY
                (
                    SELECT STUFF
                    (
                        (
                            SELECT ', ' + SC.ServiceName
                            FROM [sqladmin].[CaregiverServices] CS
                            INNER JOIN [sqladmin].[ServiceCategories] SC
                                ON SC.ServiceCategoryID = CS.ServiceCategoryID
                            WHERE CS.CaregiverID = C.CaregiverID
                              AND SC.IsActive = 1
                            ORDER BY SC.DisplayOrder, SC.ServiceName
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'),
                        1, 2, ''
                    ) AS ServiceCategory
                ) AS ServiceList
                LEFT JOIN [sqladmin].[LocalPlaces] L
                    ON C.PresentAreaID = L.PlaceID
                WHERE C.IsActive = 1
                ORDER BY C.CreatedDate DESC, C.CaregiverID DESC;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (!dt.Columns.Contains("ProfilePhoto"))
                    dt.Columns.Add("ProfilePhoto", typeof(byte[]));
                rptRecentCaregivers.DataSource = dt;
                rptRecentCaregivers.DataBind();
            }
        }

        protected string GetPhotoUrl(object photo)
        {
            if (photo == null || photo == DBNull.Value)
                return String.Empty;

            byte[] bytes = photo as byte[];
            if (bytes == null || bytes.Length == 0)
                return String.Empty;

            // If the database does not store MIME type, JPEG is the fallback.
            string mime = "image/jpeg";
            if (bytes.Length >= 8 &&
                bytes[0] == 0x89 && bytes[1] == 0x50 &&
                bytes[2] == 0x4E && bytes[3] == 0x47)
                mime = "image/png";
            else if (bytes.Length >= 3 &&
                     bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
                mime = "image/jpeg";
            else if (bytes.Length >= 6 &&
                     System.Text.Encoding.ASCII.GetString(bytes, 0, 3) == "GIF")
                mime = "image/gif";

            return "data:" + mime + ";base64," + Convert.ToBase64String(bytes);
        }

        //protected void rptRecentRequirements_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{

        //}

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
