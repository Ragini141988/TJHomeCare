
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

        protected void Page_Load(object sender, EventArgs e)
        {
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

            string sql = @"
                SELECT
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
                    r.PreferredLanguage,
                    r.Budget,
                    r.JoiningDate,
                    r.CreatedDate
                FROM [sqladmin].[PostRequirements] r
                LEFT JOIN [sqladmin].[LocalPlaces] lp
                    ON CONVERT(NVARCHAR(20), lp.PlaceID) = r.Area
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
    }
}
