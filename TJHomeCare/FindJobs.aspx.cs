using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class FindJobs : System.Web.UI.Page
    {
        private const int PageSize = 9;

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings[
                        "hospi2yp_tabletjobssConnectionString_V02"]
                    .ConnectionString;
            }
        }

        private int CurrentPage
        {
            get
            {
                return ViewState["CurrentPage"] == null
                    ? 0
                    : (int)ViewState["CurrentPage"];
            }
            set
            {
                ViewState["CurrentPage"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadServices();
                LoadCities();

                SelectQueryStringValue(
                    ddlService, Request.QueryString["service"]);

                SelectQueryStringValue(
                    ddlCity, Request.QueryString["city"]);

                LoadAreas();
                SelectQueryStringValue(
                    ddlArea, Request.QueryString["area"]);

                CurrentPage = 0;
                BindRequirements();
            }
        }

        private void LoadServices()
        {
            LoadDropdown(
                ddlService,
                @"SELECT ServiceName
                  FROM [sqladmin].[ServiceCategories]
                  WHERE IsActive = 1
                  ORDER BY DisplayOrder, ServiceName",
                "All Services");
        }

        private void LoadCities()
        {
            LoadDropdown(
                ddlCity,
                @"SELECT City
                  FROM
                  (
                      SELECT DISTINCT City
                      FROM [sqladmin].[PostRequirements]
                      WHERE City IS NOT NULL
                        AND LTRIM(RTRIM(City)) <> ''
                  ) C
                  ORDER BY City",
                "All Cities");
        }

        private void LoadAreas()
        {
            ddlArea.Items.Clear();
            ddlArea.Items.Add(
                new ListItem("All Areas", ""));

            string city = ddlCity.SelectedValue;

            string sql = @"
                SELECT DISTINCT lp.PlaceID, lp.PlaceName
                FROM [sqladmin].[LocalPlaces] lp
                WHERE (@City = ''
                       OR lp.City = @City)
                ORDER BY lp.PlaceName;";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@City", SqlDbType.NVarChar, 100).Value = city;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlArea.Items.Add(
                            new ListItem(
                                reader["PlaceName"].ToString(),
                                reader["PlaceID"].ToString()));
                    }
                }
            }
        }

        private void LoadDropdown(
            DropDownList ddl,
            string sql,
            string firstText)
        {
            ddl.Items.Clear();
            ddl.Items.Add(new ListItem(firstText, ""));

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string value = Convert.ToString(
                            reader[0]);

                        ddl.Items.Add(new ListItem(value, value));
                    }
                }
            }
        }

        private void SelectQueryStringValue(
            DropDownList ddl, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return;

            ListItem item = ddl.Items.FindByValue(value);

            if (item == null)
            {
                item = ddl.Items.FindByText(value);
            }

            if (item != null)
                ddl.SelectedValue = item.Value;
        }

        protected void ddlCity_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            LoadAreas();
            CurrentPage = 0;
            BindRequirements();
        }

        protected void btnSearch_Click(
            object sender, EventArgs e)
        {
            CurrentPage = 0;
            BindRequirements();
        }

        protected void btnClear_Click(
            object sender, EventArgs e)
        {
            ddlService.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;

            LoadAreas();

            CurrentPage = 0;
            BindRequirements();
        }

        protected void btnPrevious_Click(
            object sender, EventArgs e)
        {
            if (CurrentPage > 0)
                CurrentPage--;

            BindRequirements();
        }

        protected void btnNext_Click(
            object sender, EventArgs e)
        {
            CurrentPage++;
            BindRequirements();
        }

        private void BindRequirements()
        {
            string service = ddlService.SelectedValue;
            string city = ddlCity.SelectedValue;
            string area = ddlArea.SelectedValue;

            // Prefer the normalized ServiceCategoryID when the column exists.
            // Otherwise keep compatibility with legacy text in PostRequirements.Service.
            bool hasServiceCategoryId;
            using (SqlConnection schemaCon = new SqlConnection(ConnectionString))
            using (SqlCommand schemaCmd = new SqlCommand(
                "SELECT CASE WHEN COL_LENGTH('[sqladmin].[PostRequirements]', 'ServiceCategoryID') IS NULL THEN 0 ELSE 1 END",
                schemaCon))
            {
                schemaCon.Open();
                hasServiceCategoryId = Convert.ToInt32(schemaCmd.ExecuteScalar()) == 1;
            }

            string legacyServiceMatch = @"(
                    r.Service LIKE '%' + @Service + '%' OR
                    (@Service = 'Maid' AND r.Service LIKE '%House Maid%') OR
                    (@Service = 'Baby Care Taker' AND r.Service LIKE '%Baby Caretaker%') OR
                    (@Service = 'Patient Care Taker' AND r.Service LIKE '%Patient Caretaker%') OR
                    (@Service = 'Elder Care Taker' AND r.Service LIKE '%Elder Caretaker%'))";

            string serviceFilter = hasServiceCategoryId
                ? @"(@Service = '' OR EXISTS
                    (SELECT 1
                     FROM [sqladmin].[ServiceCategories] SC
                     WHERE SC.ServiceName = @Service
                       AND SC.ServiceCategoryID = r.ServiceCategoryID)
                    OR (r.ServiceCategoryID IS NULL AND " + legacyServiceMatch + "))"
                : @"(@Service = '' OR " + legacyServiceMatch + ")";

            string fromSql = @"
                FROM [sqladmin].[PostRequirements] r
                LEFT JOIN [sqladmin].[LocalPlaces] lp
                    ON TRY_CONVERT(INT, r.Area) = lp.PlaceID
                WHERE " + serviceFilter + @"
                  AND (@City = ''
                       OR COALESCE(NULLIF(r.City, ''), lp.City) = @City)
                  AND (@Area = ''
                       OR TRY_CONVERT(INT, r.Area) = TRY_CONVERT(INT, @Area))";

            string pageSql = @"
                SELECT RequirementID, Service, City, Area, DutyTime, Budget, CreatedDate
                FROM
                (
                    SELECT
                        r.RequirementID,
                        " + (hasServiceCategoryId
                            ? "COALESCE(sc.ServiceName, NULLIF(r.Service, ''))"
                            : "NULLIF(r.Service, '')") + @" AS Service,
                        COALESCE(NULLIF(r.City, ''), lp.City, 'Not specified') AS City,
                        COALESCE(lp.PlaceName, NULLIF(r.Area, ''), 'Not specified') AS Area,
                        r.DutyTime,
                        r.Budget,
                        r.CreatedDate,
                        ROW_NUMBER() OVER (
                            ORDER BY r.CreatedDate DESC, r.RequirementID DESC
                        ) AS RowNum
                    FROM [sqladmin].[PostRequirements] r
                    LEFT JOIN [sqladmin].[LocalPlaces] lp
                        ON TRY_CONVERT(INT, r.Area) = lp.PlaceID
                    " + (hasServiceCategoryId
                            ? "LEFT JOIN [sqladmin].[ServiceCategories] sc ON sc.ServiceCategoryID = r.ServiceCategoryID "
                            : "") + @"
                    WHERE " + serviceFilter + @"
                      AND (@City = ''
                           OR COALESCE(NULLIF(r.City, ''), lp.City) = @City)
                      AND (@Area = ''
                           OR TRY_CONVERT(INT, r.Area) = TRY_CONVERT(INT, @Area))
                ) AS RequirementResults
                WHERE RowNum BETWEEN @StartRow AND @EndRow
                ORDER BY RowNum;";

            int totalRecords;
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                using (SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) " + fromSql, con))
                {
                    AddFilterParameters(countCmd, service, city, area);
                    totalRecords = Convert.ToInt32(countCmd.ExecuteScalar());
                }

                int totalPages = (int)Math.Ceiling(totalRecords / (double)PageSize);
                if (CurrentPage >= totalPages)
                    CurrentPage = Math.Max(0, totalPages - 1);

                using (SqlCommand cmd = new SqlCommand(pageSql, con))
                {
                    AddFilterParameters(cmd, service, city, area);
                    cmd.Parameters.Add("@StartRow", SqlDbType.Int).Value = CurrentPage * PageSize + 1;
                    cmd.Parameters.Add("@EndRow", SqlDbType.Int).Value = (CurrentPage + 1) * PageSize;

                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);

                    rptRequirements.DataSource = dt;
                    rptRequirements.DataBind();
                    pnlEmpty.Visible = totalRecords == 0;
                    lblResults.Text = totalRecords +
                        (totalRecords == 1 ? " requirement found." : " requirements found.");
                    lblPage.Text = totalPages == 0
                        ? "Page 0 of 0"
                        : "Page " + (CurrentPage + 1) + " of " + totalPages;
                    btnPrevious.Enabled = CurrentPage > 0;
                    btnNext.Enabled = CurrentPage + 1 < totalPages;
                }
            }
        }

        private void AddFilterParameters(
            SqlCommand cmd,
            string service,
            string city,
            string area)
        {
            cmd.Parameters.Add(
                "@Service", SqlDbType.NVarChar, 150).Value =
                service ?? "";

            cmd.Parameters.Add(
                "@City", SqlDbType.NVarChar, 100).Value =
                city ?? "";

            cmd.Parameters.Add(
                "@Area", SqlDbType.NVarChar, 20).Value =
                area ?? "";
        }

        protected bool HasValue(object value)
        {
            return value != null &&
                   value != DBNull.Value &&
                   !string.IsNullOrWhiteSpace(value.ToString());
        }

        protected string DisplayValue(object value)
        {
            return HasValue(value)
                ? value.ToString()
                : "Not specified";
        }
    }
}