using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class Candidates : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;
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
                LoadFilters();
                BindCandidates();
            }
            if (!IsPostBack)
            {
                BindServices();
            }
        }

        private void LoadFilters()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                BindFilter(con, ddlService, @"SELECT DISTINCT ServiceCategory AS Item FROM [sqladmin].[CaregiverProfiles] WHERE IsActive=1 AND NULLIF(LTRIM(RTRIM(ServiceCategory)),'') IS NOT NULL ORDER BY Item", "All services");
                BindFilter(con, ddlCity, @"SELECT DISTINCT City AS Item FROM [sqladmin].[CaregiverProfiles] WHERE IsActive=1 AND NULLIF(LTRIM(RTRIM(City)),'') IS NOT NULL ORDER BY Item", "All cities");
                // Values are distinct stored language strings; common comma-separated language lists are supported by the filter.
                BindFilter(con, ddlLanguage, @"SELECT DISTINCT LanguagesKnown AS Item FROM [sqladmin].[CaregiverProfiles] WHERE IsActive=1 AND NULLIF(LTRIM(RTRIM(LanguagesKnown)),'') IS NOT NULL ORDER BY Item", "All languages");
            }
        }

        private void BindFilter(SqlConnection con, DropDownList ddl, string sql, string prompt)
        {
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                ddl.Items.Clear();
                ddl.Items.Add(new ListItem(prompt, ""));
                while (reader.Read())
                {
                    string value = Convert.ToString(reader["Item"]);
                    ddl.Items.Add(new ListItem(value, value));
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            CurrentPage = 0;
            BindCandidates();
        }

        protected void PreviousPage(object sender, EventArgs e)
        {
            if (CurrentPage > 0) CurrentPage--;
            BindCandidates();
        }

        protected void NextPage(object sender, EventArgs e)
        {
            CurrentPage++;
            BindCandidates();
        }

        private void BindCandidates()
        {
            string filterSql = @"
        FROM [sqladmin].[CaregiverProfiles] C
        WHERE C.IsActive = 1

          AND (
              @Service = ''
              OR EXISTS
              (
                  SELECT 1
                  FROM [sqladmin].[CaregiverServices] CS
                  INNER JOIN [sqladmin].[ServiceCategories] SC
                      ON SC.ServiceCategoryID = CS.ServiceCategoryID
                  WHERE CS.CaregiverID = C.CaregiverID
                    AND SC.ServiceCategoryID = @Service
              )
          )

          AND (@City = '' OR C.City = @City)

          AND (
              @Language = ''
              OR C.LanguagesKnown = @Language
              OR ',' + REPLACE(
                     REPLACE(ISNULL(C.LanguagesKnown, ''), ', ', ','),
                     ' ,', ','
                 ) + ','
                 LIKE '%,' + @Language + ',%'
          )";

            string sql = @"
        SELECT
            C.CaregiverID,
            C.FullName,
            C.Age,
            C.Gender,

            COALESCE(
                NULLIF(
                    STUFF(
                        (
                            SELECT ', ' + SC.ServiceName
                            FROM [sqladmin].[CaregiverServices] CS
                            INNER JOIN [sqladmin].[ServiceCategories] SC
                                ON SC.ServiceCategoryID = CS.ServiceCategoryID
                            WHERE CS.CaregiverID = C.CaregiverID
                            ORDER BY SC.DisplayOrder, SC.ServiceName
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'),
                        1, 2, ''
                    ),
                    ''
                ),
                C.ServiceCategory
            ) AS ServiceCategory,

            C.City,
            L.PlaceName AS PresentArea,
            C.LanguagesKnown,
            C.Qualification,
            C.Experience,
            C.DutyPreference,
            C.ExpectedSalary,
            C.JoiningAvailability,
            C.ProfilePhoto

        FROM [sqladmin].[CaregiverProfiles] C

        LEFT JOIN [sqladmin].[LocalPlaces] L
            ON C.PresentAreaID = L.PlaceID

        WHERE C.IsActive = 1

          AND (
              @Service = ''
              OR EXISTS
              (
                  SELECT 1
                  FROM [sqladmin].[CaregiverServices] CS
                  INNER JOIN [sqladmin].[ServiceCategories] SC
                      ON SC.ServiceCategoryID = CS.ServiceCategoryID
                  WHERE CS.CaregiverID = C.CaregiverID
                    AND SC.ServiceCategoryID = @Service
              )
          )

          AND (@City = '' OR C.City = @City)

          AND (
              @Language = ''
              OR C.LanguagesKnown = @Language
              OR ',' + REPLACE(
                     REPLACE(ISNULL(C.LanguagesKnown, ''), ', ', ','),
                     ' ,', ','
                 ) + ','
                 LIKE '%,' + @Language + ',%'
          )

        ORDER BY C.CreatedDate DESC, C.CaregiverID DESC
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;";

            DataTable dt = new DataTable();
            int total;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    AddFilterParameters(cmd);

                    cmd.Parameters.Add("@Offset", SqlDbType.Int).Value =
                        CurrentPage * PageSize;

                    cmd.Parameters.Add("@PageSize", SqlDbType.Int).Value =
                        PageSize;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }

                using (SqlCommand countCmd =
                    new SqlCommand("SELECT COUNT(1) " + filterSql, con))
                {
                    AddFilterParameters(countCmd);

                    con.Open();
                    total = Convert.ToInt32(countCmd.ExecuteScalar());
                }
            }

            int pages = Math.Max(
                1,
                (int)Math.Ceiling(total / (double)PageSize));

            if (CurrentPage >= pages)
                CurrentPage = pages - 1;

            // Reload if the current page is beyond the filtered result count.
            if (CurrentPage * PageSize >= total && CurrentPage > 0)
            {
                CurrentPage = pages - 1;

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    AddFilterParameters(cmd);

                    cmd.Parameters.Add("@Offset", SqlDbType.Int).Value =
                        CurrentPage * PageSize;

                    cmd.Parameters.Add("@PageSize", SqlDbType.Int).Value =
                        PageSize;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        dt.Clear();
                        da.Fill(dt);
                    }
                }
            }

            rptCandidates.DataSource = dt;
            rptCandidates.DataBind();

            lblMessage.Text = total == 0
                ? "No candidates found for these filters."
                : "";

            lblPage.Text = "Page " + (CurrentPage + 1) +
                           " of " + pages;

            btnPrevious.Enabled = CurrentPage > 0;
            btnNext.Enabled = CurrentPage < pages - 1;
        }

        private void AddFilterParameters(SqlCommand cmd)
        {
            cmd.Parameters.Add("@Service", SqlDbType.NVarChar, 200)
                .Value = ddlService.SelectedValue ?? "";

            cmd.Parameters.Add("@City", SqlDbType.NVarChar, 100)
                .Value = ddlCity.SelectedValue ?? "";

            cmd.Parameters.Add("@Language", SqlDbType.NVarChar, 200)
                .Value = ddlLanguage.SelectedValue ?? "";
        }

        protected bool HasValue(object value)
        {
            return value != null && value != DBNull.Value && !String.IsNullOrWhiteSpace(Convert.ToString(value));
        }
        protected string DisplayValue(object value)
        {
            return HasValue(value) ? Convert.ToString(value) : "Not specified";
        }
        protected string GetPhotoUrl(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            byte[] bytes = value as byte[];
            if (bytes == null || bytes.Length == 0) return "";
            string mime = "image/jpeg";
            if (bytes.Length >= 8 && bytes[0] == 137 && bytes[1] == 80 && bytes[2] == 78 && bytes[3] == 71) mime = "image/png";
            else if (bytes.Length >= 6 && System.Text.Encoding.ASCII.GetString(bytes, 0, 3) == "GIF") mime = "image/gif";
            return "data:" + mime + ";base64," + Convert.ToBase64String(bytes);
        }
        private void BindServices()
        {
            string cs = ConfigurationManager
                .ConnectionStrings[
                    "hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT ServiceCategoryID, ServiceName
        FROM [sqladmin].[ServiceCategories]
        WHERE IsActive = 1
        ORDER BY DisplayOrder, ServiceName;", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlService.DataSource = dt;
                ddlService.DataTextField = "ServiceName";
                ddlService.DataValueField = "ServiceCategoryID";
                ddlService.DataBind();

                ddlService.Items.Insert(
                    0, new ListItem("Select Service", ""));
            }
        }
    }
}
