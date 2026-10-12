using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare.Staff
{
    public partial class PostedRequirements : Page
    {
        private readonly string connectionString = ConfigurationManager
            .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;

        private bool IsStaff()
        {
            return (Session["IsAdmin"] != null &&
                    Convert.ToString(Session["IsAdmin"]).Equals("true", StringComparison.OrdinalIgnoreCase))
                || (Session["IsStaff"] != null &&
                    Convert.ToString(Session["IsStaff"]).Equals("true", StringComparison.OrdinalIgnoreCase));
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsStaff())
            //{
            //    Response.StatusCode = 403;
            //    lblMessage.Text = "Access denied. Please sign in with an authorized admin or staff account.";
            //    lvRequirements.Visible = false;
            //    return;
            //}

            if (!IsPostBack)
                BindRequirements();
        }

        private void BindRequirements()
        {
            const string sql = @"
                SELECT R.RequirementID,
                       R.Service,
                       R.City,
                       COALESCE(NULLIF(L.PlaceName, ''), NULLIF(R.Area, ''), '') AS RequirementArea,
                       R.DutyTime,
                       R.PreferredLanguage,
                       R.Budget,
                       R.JoiningDate,
                       R.FullName,
                       R.MobileNumber,
                       R.WhatsAppNumber
                FROM [sqladmin].[PostRequirements] AS R
                LEFT JOIN [sqladmin].[LocalPlaces] AS L
                    ON R.PresentAreaID = L.PlaceID
                ORDER BY R.RequirementID DESC;";

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(dt);
            }

            lvRequirements.DataSource = dt;
            lvRequirements.DataBind();
            lblMessage.Text = dt.Rows.Count == 0 ? "There are currently no posted requirements." : "";
        }

        protected void lvRequirements_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            DataPager pager = lvRequirements.FindControl("dpRequirements") as DataPager;
            if (pager != null)
                pager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

            BindRequirements();
        }
    }
}
