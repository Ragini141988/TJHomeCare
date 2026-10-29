using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class CaregiverList : Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;

        private string SearchText
        {
            get { return (ViewState["SearchText"] ?? "").ToString(); }
            set { ViewState["SearchText"] = value ?? ""; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindServiceCategories();
                BindCaregivers();
            }
        }

        private void BindServiceCategories()
        {
            const string sql = @"
SELECT ServiceCategoryID, ServiceName
FROM [sqladmin].[ServiceCategories]
WHERE IsActive = 1
ORDER BY DisplayOrder, ServiceName;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlServiceCategory.Items.Clear();
                ddlServiceCategory.Items.Add(new ListItem("All Service Categories", "0"));

                foreach (DataRow row in dt.Rows)
                {
                    ddlServiceCategory.Items.Add(new ListItem(
                        Convert.ToString(row["ServiceName"]),
                        Convert.ToString(row["ServiceCategoryID"])));
                }
            }
        }

        private void BindCaregivers()
        {
            const string sql = @"
SELECT cp.CaregiverID, cp.FullName, cp.Age, cp.Gender, cp.ContactNumber,
       cp.City, cp.RecruiterName, cp.VerificationStatus
FROM [sqladmin].[CaregiverProfiles] cp
WHERE (@Search = ''
       OR ISNULL(cp.FullName,'') LIKE @LikeSearch
       OR ISNULL(cp.ContactNumber,'') LIKE @LikeSearch
       OR ISNULL(cp.City,'') LIKE @LikeSearch
       OR ISNULL(cp.RecruiterName,'') LIKE @LikeSearch)
  AND (@ServiceCategoryID = 0
       OR EXISTS
          (SELECT 1
           FROM [sqladmin].[CaregiverServices] cs
           WHERE cs.CaregiverID = cp.CaregiverID
             AND cs.ServiceCategoryID = @ServiceCategoryID))
ORDER BY cp.CaregiverID DESC;";

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 200).Value = SearchText;
                cmd.Parameters.Add("@LikeSearch", SqlDbType.NVarChar, 202).Value = "%" + SearchText + "%";

                int serviceCategoryId = 0;
                int.TryParse(ddlServiceCategory.SelectedValue, out serviceCategoryId);
                cmd.Parameters.Add("@ServiceCategoryID", SqlDbType.Int).Value = serviceCategoryId;

                da.Fill(dt);
            }

            lvCaregivers.DataSource = dt;
            lvCaregivers.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            SearchText = txtSearch.Text.Trim();
            dpCaregivers.SetPageProperties(0, dpCaregivers.PageSize, false);
            BindCaregivers();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            SearchText = "";
            ddlServiceCategory.SelectedIndex = 0;
            dpCaregivers.SetPageProperties(0, dpCaregivers.PageSize, false);
            pnlDetails.Visible = false;
            BindCaregivers();
        }

        protected void lvCaregivers_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewRecord")
            {
                int id;
                if (int.TryParse(Convert.ToString(e.CommandArgument), out id))
                    LoadDetails(id);
            }
        }

        private void LoadDetails(int id)
        {
            const string sql = @"
SELECT cp.CaregiverID, cp.RecruiterName,
       STUFF((
           SELECT ', ' + sc.ServiceName
           FROM [sqladmin].[CaregiverServices] cs
           INNER JOIN [sqladmin].[ServiceCategories] sc
               ON sc.ServiceCategoryID = cs.ServiceCategoryID
           WHERE cs.CaregiverID = cp.CaregiverID
           ORDER BY sc.DisplayOrder, sc.ServiceName
           FOR XML PATH(''), TYPE
       ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ServiceCategory,
       cp.FullName, cp.Age, cp.Gender, cp.ContactNumber, cp.City,
       cp.PresentAreaID, cp.LanguagesKnown, cp.Qualification,
       cp.Experience, cp.DutyPreference, cp.ExpectedSalary, cp.PreferredWorkAreas,
       cp.JoiningAvailability, cp.VerificationStatus, cp.CreatedDate, cp.Remarks
FROM [sqladmin].[CaregiverProfiles] cp
WHERE cp.CaregiverID = @ID;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowMessage("Caregiver record was not found.", true);
                        pnlDetails.Visible = false;
                        return;
                    }

                    dID.Text = Safe(r["CaregiverID"]);
                    dName.Text = Safe(r["FullName"]);
                    dRecruiter.Text = Safe(r["RecruiterName"]);
                    dAgeGender.Text = Safe(r["Age"]) + " / " + Safe(r["Gender"]);
                    dContact.Text = Safe(r["ContactNumber"]);
                    dCity.Text = Safe(r["City"]);
                    dArea.Text = Safe(r["PresentAreaID"]);
                    dServices.Text = Safe(r["ServiceCategory"]);
                    dLanguages.Text = Safe(r["LanguagesKnown"]);
                    dQualification.Text = Safe(r["Qualification"]) + " / " + Safe(r["Experience"]);
                    dDuty.Text = Safe(r["DutyPreference"]);
                    dSalary.Text = Safe(r["ExpectedSalary"]);
                    dPreferredAreas.Text = Safe(r["PreferredWorkAreas"]);
                    dJoining.Text = Safe(r["JoiningAvailability"]);
                    dStatus.Text = Safe(r["VerificationStatus"]);
                    dCreated.Text = r["CreatedDate"] == DBNull.Value ? "" : Convert.ToDateTime(r["CreatedDate"]).ToString("dd-MMM-yyyy");
                    dRemarks.Text = Safe(r["Remarks"]);
                    pnlDetails.Visible = true;
                }
            }
        }

        private string Safe(object value)
        {
            return value == null || value == DBNull.Value ? "—" : Server.HtmlEncode(Convert.ToString(value));
        }

        protected void btnCloseDetails_Click(object sender, EventArgs e)
        {
            pnlDetails.Visible = false;
        }

        protected void lvCaregivers_ItemDeleting(object sender, ListViewDeleteEventArgs e)
        {
            // Deletion is handled manually below; prevent automatic data-source deletion.
            e.Cancel = true;
            int id = Convert.ToInt32(lvCaregivers.DataKeys[e.ItemIndex].Value);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        // Remove the service mappings first to avoid a foreign-key conflict.
                        using (SqlCommand map = new SqlCommand(
                            "DELETE FROM [sqladmin].[CaregiverServices] WHERE CaregiverID = @ID;", con, tran))
                        {
                            map.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                            map.ExecuteNonQuery();
                        }

                        using (SqlCommand cmd = new SqlCommand(
                            "DELETE FROM [sqladmin].[CaregiverProfiles] WHERE CaregiverID = @ID;", con, tran))
                        {
                            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                            int rows = cmd.ExecuteNonQuery();
                            if (rows == 0)
                                throw new Exception("Caregiver record was not found.");
                        }

                        tran.Commit();
                    }
                    catch
                    {
                        tran.Rollback();
                        throw;
                    }
                }
            }

            lvCaregivers.EditIndex = -1;
            pnlDetails.Visible = false;
            ShowMessage("Caregiver profile deleted successfully.", true);
            BindCaregivers();
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Visible = true;
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = success ? "cg-message" : "cg-message cg-error";
        }
       
    }
}
