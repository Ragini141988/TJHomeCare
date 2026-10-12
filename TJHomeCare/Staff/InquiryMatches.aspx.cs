
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare.Staff
{
    public partial class InquiryMatches : Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;

        private bool IsStaff()
        {
            bool isAdmin =
                Session["IsAdmin"] != null &&
                Convert.ToString(Session["IsAdmin"]).Equals(
                    "true", StringComparison.OrdinalIgnoreCase);

            bool isStaff =
                Session["IsStaff"] != null &&
                Convert.ToString(Session["IsStaff"]).Equals(
                    "true", StringComparison.OrdinalIgnoreCase);

            return isAdmin || isStaff;
        }

        private bool IsRequirementMatchRequest()
        {
            return !string.IsNullOrWhiteSpace(
                Request.QueryString["requirementId"]);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Restrict the new requirement-matching route to staff/admin.
            // Preserve the existing access behavior of the ?id= route.
            //if (IsRequirementMatchRequest() && !IsStaff())
            //{
            //    Response.StatusCode = 403;
            //    lblMessage.Text =
            //        "Access denied. Please sign in with an authorized admin or staff account.";

            //    lvMatches.Visible = false;
            //    hlnkBack.Visible = false;
            //    return;
            //}

            lvMatches.Visible = true;
            hlnkBack.Visible = true;

            // Preserve route-specific Back navigation.
            if (IsRequirementMatchRequest())
            {
                hlnkBack.NavigateUrl =
                    ResolveUrl("~/Staff/PostedRequirements.aspx");

                hlnkBack.Text = "Back to Posted Requirements";
            }
            else
            {
                hlnkBack.NavigateUrl =
                    ResolveUrl("~/Staff/Inquiries.aspx");

                hlnkBack.Text = "Back to Inquiries";
            }

            if (!IsPostBack)
            {
                if (IsRequirementMatchRequest())
                    LoadRequirementMatches();
                else
                    LoadMatches();
            }
        }

        // ============================================================
        // NEW ROUTE:
        // InquiryMatches.aspx?requirementId=16
        // ============================================================

        private void LoadRequirementMatches()
        {
            int requirementId;

            if (!Int32.TryParse(
                Request.QueryString["requirementId"],
                out requirementId) ||
                requirementId <= 0)
            {
                lblInquiry.Text = "";
                lblMessage.Text = "Invalid requirement ID.";
                lvMatches.DataSource = null;
                lvMatches.DataBind();
                return;
            }

            const string sql = @"
SELECT
    R.RequirementID,
    R.FullName AS FamilyName,
    R.City AS FamilyCity,
    R.Service AS RequiredService,
    R.PresentAreaID AS RequirementAreaID,
    COALESCE(
        NULLIF(L0.PlaceName, ''),
        NULLIF(R.Area, ''),
        ''
    ) AS RequirementArea
FROM [sqladmin].[PostRequirements] R
LEFT JOIN [sqladmin].[LocalPlaces] L0
    ON R.PresentAreaID = L0.PlaceID
WHERE R.RequirementID = @RequirementID;";

            string family;
            string city;
            string service;
            string area;
            int? areaId;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@RequirementID",
                    SqlDbType.Int).Value = requirementId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        lblInquiry.Text = "";
                        lblMessage.Text = "Requirement was not found.";
                        lvMatches.DataSource = null;
                        lvMatches.DataBind();
                        return;
                    }

                    family = Convert.ToString(reader["FamilyName"]);
                    city = Convert.ToString(reader["FamilyCity"]);
                    service = Convert.ToString(reader["RequiredService"]);
                    area = Convert.ToString(reader["RequirementArea"]);

                    areaId =
                        reader["RequirementAreaID"] == DBNull.Value
                            ? (int?)null
                            : Convert.ToInt32(
                                reader["RequirementAreaID"]);
                }
            }

            OriginallySelectedCaregiverID = null;

            lblInquiry.Text =
                "Requirement #" + requirementId + " — " +
                Server.HtmlEncode(family) + ", " +
                Server.HtmlEncode(city) +
                (String.IsNullOrWhiteSpace(area)
                    ? ""
                    : " — area: " + Server.HtmlEncode(area)) +
                " — service: " + Server.HtmlEncode(service);

            BindCaregiverMatches(service, city, areaId);
        }

        // ============================================================
        // EXISTING ROUTE:
        // InquiryMatches.aspx?id=123
        // ============================================================

        private void LoadMatches()
        {
            int inquiryId;

            if (!Int32.TryParse(
                Request.QueryString["id"],
                out inquiryId) ||
                inquiryId <= 0)
            {
                lblInquiry.Text = "";
                lblMessage.Text = "Invalid inquiry ID.";
                lvMatches.DataSource = null;
                lvMatches.DataBind();
                return;
            }

            const string sql = @"
SELECT
    I.InquiryID,
    I.FullName AS FamilyName,
    I.City AS FamilyCity,
    I.CaregiverID AS OriginallySelectedCaregiverID,
    COALESCE(
        NULLIF(R.Service, ''),
        C0.ServiceCategory
    ) AS RequiredService,
    R.PresentAreaID AS RequirementAreaID,
    COALESCE(
        NULLIF(L0.PlaceName, ''),
        NULLIF(R.Area, ''),
        ''
    ) AS RequirementArea
FROM [sqladmin].[CaregiverInquiries] I
LEFT JOIN [sqladmin].[CaregiverProfiles] C0
    ON I.CaregiverID = C0.CaregiverID
LEFT JOIN [sqladmin].[PostRequirements] R
    ON I.RequirementID = R.RequirementID
LEFT JOIN [sqladmin].[LocalPlaces] L0
    ON R.PresentAreaID = L0.PlaceID
WHERE I.InquiryID = @InquiryID;";

            string family;
            string city;
            string service;
            string area;
            int? areaId;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@InquiryID",
                    SqlDbType.Int).Value = inquiryId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        lblInquiry.Text = "";
                        lblMessage.Text = "Inquiry was not found.";
                        lvMatches.DataSource = null;
                        lvMatches.DataBind();
                        return;
                    }

                    OriginallySelectedCaregiverID =
                        reader["OriginallySelectedCaregiverID"]
                            == DBNull.Value
                        ? (int?)null
                        : Convert.ToInt32(
                            reader["OriginallySelectedCaregiverID"]);

                    family = Convert.ToString(reader["FamilyName"]);
                    city = Convert.ToString(reader["FamilyCity"]);

                    service =
                        reader["RequiredService"] == DBNull.Value
                            ? ""
                            : Convert.ToString(
                                reader["RequiredService"]);

                    area = Convert.ToString(reader["RequirementArea"]);

                    areaId =
                        reader["RequirementAreaID"] == DBNull.Value
                            ? (int?)null
                            : Convert.ToInt32(
                                reader["RequirementAreaID"]);
                }
            }

            lblInquiry.Text =
                "Inquiry #" + inquiryId + " — " +
                Server.HtmlEncode(family) + ", " +
                Server.HtmlEncode(city) +
                (String.IsNullOrWhiteSpace(area)
                    ? ""
                    : " — area: " + Server.HtmlEncode(area)) +
                " — service: " + Server.HtmlEncode(service);

            BindCaregiverMatches(service, city, areaId);
        }

        // ============================================================
        // SHARED MATCHING LOGIC
        //
        // 1. Exact area: PresentAreaID matches.
        // 2. Preferred area: PreferredWorkAreas contains the exact ID.
        // 3. Same city: fallback if neither area match exists.
        //
        // Example PreferredWorkAreas: "9,19"
        // PreferredWorkAreaIDs is NOT used.
        // ============================================================

        private void BindCaregiverMatches(
            string service,
            string city,
            int? areaId)
        {
            if (String.IsNullOrWhiteSpace(service))
            {
                lblMessage.Text =
                    "The required service could not be determined.";

                lvMatches.DataSource = null;
                lvMatches.DataBind();
                return;
            }

            const string sql = @"
;WITH ServiceMatched AS
(
    SELECT C.*
    FROM [sqladmin].[CaregiverProfiles] C
    WHERE C.IsActive = 1

      -- Match individual services from comma-separated values.
      AND EXISTS
      (
          SELECT 1
          FROM STRING_SPLIT(
              ISNULL(C.ServiceCategory, ''),
              ','
          ) CS
          INNER JOIN STRING_SPLIT(
              @Service,
              ','
          ) RS
              ON LOWER(LTRIM(RTRIM(CS.value))) =
                 LOWER(LTRIM(RTRIM(RS.value)))
      )
),
MatchPriority AS
(
    SELECT
        CASE
            -- Priority 1: exact present area.
            WHEN @AreaID IS NOT NULL
             AND EXISTS
             (
                 SELECT 1
                 FROM ServiceMatched C
                 WHERE C.PresentAreaID = @AreaID
             )
            THEN 0

            -- Priority 2: exact ID in PreferredWorkAreas.
            WHEN @AreaID IS NOT NULL
             AND EXISTS
             (
                 SELECT 1
                 FROM ServiceMatched C
                 WHERE EXISTS
                 (
                     SELECT 1
                     FROM STRING_SPLIT(
                         ISNULL(C.PreferredWorkAreas, ''),
                         ','
                     ) P
                     WHERE TRY_CONVERT(
                         INT,
                         LTRIM(RTRIM(P.value))
                     ) = @AreaID
                 )
             )
            THEN 1

            -- Priority 3: same-city fallback.
            ELSE 2
        END AS MatchRank
)
SELECT
    C.CaregiverID,
    C.FullName,
    C.ServiceCategory,
    C.City,
    L.PlaceName AS PresentArea,
    C.LanguagesKnown,
    C.Experience,
    C.JoiningAvailability,

    CASE
        WHEN M.MatchRank = 0
            THEN 'Same area'
        WHEN M.MatchRank = 1
            THEN 'Preferred area'
        ELSE 'Same city'
    END AS LocationMatch,

    M.MatchRank

FROM ServiceMatched C
CROSS JOIN MatchPriority M

LEFT JOIN [sqladmin].[LocalPlaces] L
    ON C.PresentAreaID = L.PlaceID

WHERE
    (
        -- Show exact-area caregivers when any exist.
        M.MatchRank = 0
        AND C.PresentAreaID = @AreaID
    )
    OR
    (
        -- Otherwise show caregivers whose PreferredWorkAreas
        -- contains the exact requirement area ID.
        M.MatchRank = 1
        AND EXISTS
        (
            SELECT 1
            FROM STRING_SPLIT(
                ISNULL(C.PreferredWorkAreas, ''),
                ','
            ) P
            WHERE TRY_CONVERT(
                INT,
                LTRIM(RTRIM(P.value))
            ) = @AreaID
        )
    )
    OR
    (
        -- Otherwise show active same-city caregivers.
        M.MatchRank = 2
        AND LOWER(LTRIM(RTRIM(ISNULL(C.City, '')))) =
            LOWER(LTRIM(RTRIM(ISNULL(@City, ''))))
    )

ORDER BY
    M.MatchRank,
    C.CreatedDate DESC,
    C.CaregiverID DESC;";

            DataTable dt = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@Service",
                    SqlDbType.NVarChar,
                    1000).Value = service.Trim();

                cmd.Parameters.Add(
                    "@City",
                    SqlDbType.NVarChar,
                    100).Value =
                    String.IsNullOrWhiteSpace(city)
                        ? (object)DBNull.Value
                        : city.Trim();

                cmd.Parameters.Add(
                    "@AreaID",
                    SqlDbType.Int).Value =
                    areaId.HasValue
                        ? (object)areaId.Value
                        : DBNull.Value;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }

            string message;

            if (dt.Rows.Count == 0)
            {
                message =
                    "No active caregivers offering this service " +
                    "were found in the same city.";
            }
            else
            {
                int matchRank =
                    Convert.ToInt32(dt.Rows[0]["MatchRank"]);

                if (matchRank == 0)
                {
                    message =
                        "Caregivers matching the exact area are shown below.";
                }
                else if (matchRank == 1)
                {
                    message =
                        "No exact-area caregiver was found. " +
                        "These caregivers have selected this area " +
                        "in their preferred work areas.";
                }
                else
                {
                    message =
                        "No exact-area or preferred-area caregiver " +
                        "was found. You can explore these options " +
                        "in other areas of your city.";
                }
            }

            // Keep MatchRank for the message calculation only.
            if (dt.Columns.Contains("MatchRank"))
                dt.Columns.Remove("MatchRank");

            lvMatches.DataSource = dt;
            lvMatches.DataBind();

            lblMessage.Text = message;
        }

        // ============================================================
        // LISTVIEW PAGINATION
        // ============================================================

        protected void lvMatches_PagePropertiesChanging(
            object sender,
            PagePropertiesChangingEventArgs e)
        {
            if (IsRequirementMatchRequest() && !IsStaff())
                return;

            dpMatches.SetPageProperties(
                e.StartRowIndex,
                e.MaximumRows,
                false);

            if (IsRequirementMatchRequest())
                LoadRequirementMatches();
            else
                LoadMatches();
        }

        // ============================================================
        // HIGHLIGHT THE ORIGINALLY SELECTED CAREGIVER
        // Used by the existing ?id= route.
        // ============================================================

        protected void lvMatches_ItemDataBound(
            object sender,
            ListViewItemEventArgs e)
        {
            if (e.Item.ItemType != ListViewItemType.DataItem)
                return;

            if (!OriginallySelectedCaregiverID.HasValue)
                return;

            ListViewDataItem item = (ListViewDataItem)e.Item;

            object value = DataBinder.Eval(
                item.DataItem,
                "CaregiverID");

            if (value == null || value == DBNull.Value)
                return;

            int caregiverId = Convert.ToInt32(value);

            if (caregiverId != OriginallySelectedCaregiverID.Value)
                return;

            System.Web.UI.HtmlControls.HtmlGenericControl card =
                item.FindControl("caregiverCard")
                as System.Web.UI.HtmlControls.HtmlGenericControl;

            Label badge =
                item.FindControl("lblSelected") as Label;

            if (card != null)
            {
                string cssClass = card.Attributes["class"] ?? "";

                if (!cssClass.Contains("im-selected"))
                    card.Attributes["class"] =
                        cssClass + " im-selected";
            }

            if (badge != null)
                badge.Visible = true;
        }

        private int? OriginallySelectedCaregiverID
        {
            get
            {
                return ViewState[
                    "OriginallySelectedCaregiverID"] == null
                    ? (int?)null
                    : Convert.ToInt32(
                        ViewState["OriginallySelectedCaregiverID"]);
            }
            set
            {
                ViewState["OriginallySelectedCaregiverID"] = value;
            }
        }
    }
}
