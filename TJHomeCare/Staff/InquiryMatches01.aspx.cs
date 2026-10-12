using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare.Staff
{
    public partial class InquiryMatches01 : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;
        private bool IsStaff()
        {
            return Session["IsAdmin"] != null && Convert.ToString(Session["IsAdmin"]).Equals("true", StringComparison.OrdinalIgnoreCase)
                || Session["IsStaff"] != null && Convert.ToString(Session["IsStaff"]).Equals("true", StringComparison.OrdinalIgnoreCase);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsStaff())
            //{
            //    Response.StatusCode = 403;
            //    lblMessage.Text = "Access denied. Please sign in with an authorized staff account.";
            //    gvMatches.Visible = false;
            //    return;
            //}
            if (!IsPostBack) LoadMatches();
        }


        private void LoadMatches()
        {
            int inquiryId;

            if (!Int32.TryParse(Request.QueryString["id"], out inquiryId) || inquiryId <= 0)
            {
                lblMessage.Text = "Invalid inquiry ID.";
                return;
            }

            string sql = @"
        SELECT I.InquiryID,
               I.FullName AS FamilyName,
               I.City AS FamilyCity,
               I.CaregiverID AS OriginallySelectedCaregiverID,
               C0.ServiceCategory AS RequiredService,
               R.PresentAreaID AS RequirementAreaID,
               L0.PlaceName AS RequirementArea
        FROM [sqladmin].[CaregiverInquiries] I
        LEFT JOIN [sqladmin].[CaregiverProfiles] C0
            ON I.CaregiverID = C0.CaregiverID
        LEFT JOIN [sqladmin].[PostRequirements] R
            ON I.RequirementID = R.RequirementID
        LEFT JOIN [sqladmin].[LocalPlaces] L0
            ON R.PresentAreaID = L0.PlaceID
        WHERE I.InquiryID = @InquiryID;

        SELECT C.CaregiverID,
               C.FullName,
               C.ServiceCategory,
               C.City,
               L.PlaceName AS PresentArea,
               C.LanguagesKnown,
               C.Experience,
               C.JoiningAvailability,
               CASE
                   WHEN R.PresentAreaID IS NOT NULL
                        AND C.PresentAreaID = R.PresentAreaID
                       THEN 'Same area'
                   WHEN LOWER(ISNULL(C.City, '')) =
                        LOWER(ISNULL(I.City, ''))
                       THEN 'Same city'
                   ELSE 'Other city'
               END AS LocationMatch,
               CASE
                   WHEN R.PresentAreaID IS NOT NULL
                        AND C.PresentAreaID = R.PresentAreaID
                       THEN 0
                   WHEN LOWER(ISNULL(C.City, '')) =
                        LOWER(ISNULL(I.City, ''))
                       THEN 1
                   ELSE 2
               END AS MatchRank
        FROM [sqladmin].[CaregiverInquiries] I
        INNER JOIN [sqladmin].[CaregiverProfiles] C0
            ON I.CaregiverID = C0.CaregiverID
        INNER JOIN [sqladmin].[CaregiverProfiles] C
            ON C.ServiceCategory = C0.ServiceCategory
           AND C.IsActive = 1
        LEFT JOIN [sqladmin].[LocalPlaces] L
            ON C.PresentAreaID = L.PlaceID
        LEFT JOIN [sqladmin].[PostRequirements] R
            ON I.RequirementID = R.RequirementID
        WHERE I.InquiryID = @InquiryID
        ORDER BY MatchRank, C.CreatedDate DESC, C.CaregiverID DESC;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@InquiryID", SqlDbType.Int).Value = inquiryId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        lblMessage.Text = "Inquiry was not found.";
                        return;
                    }

                    // Save the originally selected caregiver ID
                    // BEFORE moving to the second SQL result.
                    OriginallySelectedCaregiverID =
                        reader["OriginallySelectedCaregiverID"] == DBNull.Value
                            ? (int?)null
                            : Convert.ToInt32(
                                reader["OriginallySelectedCaregiverID"]);

                    string family = Convert.ToString(reader["FamilyName"]);
                    string city = Convert.ToString(reader["FamilyCity"]);

                    string service =
                        reader["RequiredService"] == DBNull.Value
                            ? "Selected caregiver's service"
                            : Convert.ToString(reader["RequiredService"]);

                    lblInquiry.Text =
                        "Inquiry #" + inquiryId + " — " +
                        Server.HtmlEncode(family) + ", " +
                        Server.HtmlEncode(city) +
                        " — service: " + Server.HtmlEncode(service);

                    if (!reader.NextResult())
                        return;

                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    if (dt.Columns.Contains("MatchRank"))
                        dt.Columns.Remove("MatchRank");

                    lvMatches.DataSource = dt;
                    lvMatches.DataBind();

                    lblMessage.Text = dt.Rows.Count == 0
                        ? "No active caregivers found for this service."
                        : "";
                }
            }
        }

        protected void lvMatches_PagePropertiesChanging(
    object sender,
    PagePropertiesChangingEventArgs e)
        {
            dpMatches.SetPageProperties(
                e.StartRowIndex,
                e.MaximumRows,
                false);

            LoadMatches();
        }

        protected void lvMatches_ItemDataBound(
            object sender,
            ListViewItemEventArgs e)
        {
            if (e.Item.ItemType != ListViewItemType.DataItem)
                return;

            if (OriginallySelectedCaregiverID == null)
                return;

            ListViewDataItem item = (ListViewDataItem)e.Item;

            object value = DataBinder.Eval(
                item.DataItem, "CaregiverID");

            if (value == null || value == DBNull.Value)
                return;

            int caregiverId = Convert.ToInt32(value);

            if (caregiverId == OriginallySelectedCaregiverID.Value)
            {
                System.Web.UI.HtmlControls.HtmlGenericControl card =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                    item.FindControl("caregiverCard");

                Label badge =
                    (Label)item.FindControl("lblSelected");

                if (card != null)
                    card.Attributes["class"] += " im-selected";

                if (badge != null)
                    badge.Visible = true;
            }
        }
        private int? OriginallySelectedCaregiverID
        {
            get
            {
                return ViewState["OriginallySelectedCaregiverID"] == null
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
