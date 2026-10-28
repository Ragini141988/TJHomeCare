
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TJHomeCare
{
    public partial class RequirementDetails : System.Web.UI.Page
    {
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
        protected int RequirementId
        {
            get { return ViewState["RequirementId"] == null ? 0 : Convert.ToInt32(ViewState["RequirementId"]); }
            set { ViewState["RequirementId"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["Id"], out int Id))
            {
               
                return;
            }

            RequirementId = Id;
            if (!IsPostBack)
            {
                LoadRequirement();
            }
        }

        private void LoadRequirement()
        {
            int id;

            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                ShowNotFound();
                return;
            }

            bool hasServiceCategoryId;

            using (SqlConnection schemaCon = new SqlConnection(ConnectionString))
            using (SqlCommand schemaCmd = new SqlCommand(
                "SELECT CASE WHEN COL_LENGTH('sqladmin.PostRequirements', 'ServiceCategoryID') IS NULL THEN 0 ELSE 1 END",
                schemaCon))
            {
                schemaCon.Open();
                hasServiceCategoryId =
                    Convert.ToInt32(schemaCmd.ExecuteScalar()) == 1;
            }

            string serviceSelect = hasServiceCategoryId
                ? "COALESCE(sc.ServiceName, NULLIF(r.Service, ''), 'Not specified') AS Service,"
                : "COALESCE(NULLIF(r.Service, ''), 'Not specified') AS Service,";

            string serviceJoin = hasServiceCategoryId
                ? @"LEFT JOIN [sqladmin].[ServiceCategories] sc
                        ON sc.ServiceCategoryID = r.ServiceCategoryID"
                : "";

            string sql = @"
                SELECT
                    r.RequirementID,
                    " + serviceSelect + @"
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
                    r.PreferredLanguage,
                    r.Budget,
                    r.JoiningDate,
                    r.CreatedDate
                FROM [sqladmin].[PostRequirements] r
                LEFT JOIN [sqladmin].[LocalPlaces] lp
                    ON lp.PlaceID = TRY_CONVERT(INT, r.Area)
                " + serviceJoin + @"
                WHERE r.RequirementID = @RequirementID";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@RequirementID", SqlDbType.Int).Value = id;

                using (SqlDataAdapter da =
                    new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count == 0)
                    {
                        ShowNotFound();
                        return;
                    }

                    fvRequirement.DataSource = dt;
                    fvRequirement.DataBind();

                    pnlDetails.Visible = true;
                    pnlNotFound.Visible = false;
                }
            }
        }

        private void ShowNotFound()
        {
            pnlDetails.Visible = false;
            pnlNotFound.Visible = true;
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

        protected string DisplayDate(object value)
        {
            if (!HasValue(value))
                return "Not specified";

            DateTime date = Convert.ToDateTime(value);

            return date.ToString("dd MMM yyyy");
        }
        protected string GetShareApplyUrl(int RequirementId)
        {
            return "https://tjhomecare.com/RequirementDetails.aspx?id=" + RequirementId;
        }

        protected string GetFacebookShareUrl(int RequirementId)
        {
            return "https://www.facebook.com/sharer/sharer.php?u=" + Uri.EscapeDataString(GetShareApplyUrl(RequirementId));
        }

        protected string GetWhatsAppShareUrl(int RequirementId)
        {
            string text = "Check out TJHomecare job: " + GetShareApplyUrl(RequirementId);
            return "https://api.whatsapp.com/send?text=" + Uri.EscapeDataString(text);
        }

        protected string GetTelegramShareUrl(int RequirementId)
        {
            return "https://t.me/share/url?url=" + Uri.EscapeDataString(GetShareApplyUrl(RequirementId)) + "&text=" + Uri.EscapeDataString("Find hospital jobs faster on TabletJobs.com");
        }

        protected string GetTwitterShareUrl(int RequirementId)
        {
            return "https://twitter.com/intent/tweet?url=" + Uri.EscapeDataString(GetShareApplyUrl(RequirementId)) + "&text=" + Uri.EscapeDataString("Find Hospital Jobs Faster on TabletJobs");
        }

        protected string GetLinkedInShareUrl(int RequirementId)
        {
            return "https://www.linkedin.com/shareArticle?mini=true&url=" + Uri.EscapeDataString(GetShareApplyUrl(RequirementId)) + "&title=" + Uri.EscapeDataString("TabletJobs - Healthcare Job Portal");
        }
    }
}
