using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class HomeCareEnquiryAdmin : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                    .ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // IMPORTANT:
            // Restrict this page to authorized administrators
            // before deploying it publicly.

            if (!IsPostBack)
            {
                LoadFilterCategories();
                BindEnquiries();
            }
        }

        // ==========================================
        // LOAD SERVICE CATEGORIES INTO FILTER
        // ==========================================

        private void LoadFilterCategories()
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT ServiceCategoryID, ServiceName
                FROM ServiceCategories
                WHERE IsActive = 1
                ORDER BY DisplayOrder, ServiceName;", con))
            {
                con.Open();

                ddlFilterService.DataSource = cmd.ExecuteReader();

                ddlFilterService.DataTextField = "ServiceName";

                ddlFilterService.DataValueField =
                    "ServiceCategoryID";

                ddlFilterService.DataBind();
            }

            ddlFilterService.Items.Insert(
                0,
                new ListItem("All Service Categories", ""));
        }

        // ==========================================
        // APPLY FILTER
        // ==========================================

        protected void btnFilter_Click(
            object sender, EventArgs e)
        {
            ResetPagination();
            BindEnquiries();
        }

        // ==========================================
        // RESET FILTER
        // ==========================================

        protected void btnReset_Click(
            object sender, EventArgs e)
        {
            ddlFilterService.SelectedIndex = 0;

            ResetPagination();
            BindEnquiries();
        }

        // ==========================================
        // RESET PAGINATION TO FIRST PAGE
        // ==========================================

        private void ResetPagination()
        {
            DataPager pager =
                lvEnquiries.FindControl("dpEnquiries")
                as DataPager;

            if (pager != null)
            {
                pager.SetPageProperties(0, 10, false);
            }
        }

        // ==========================================
        // LOAD ENQUIRIES
        // ==========================================

        private void BindEnquiries()
        {
            int serviceCategoryID = 0;

            if (!string.IsNullOrEmpty(
                ddlFilterService.SelectedValue))
            {
                int.TryParse(
                    ddlFilterService.SelectedValue,
                    out serviceCategoryID);
            }

            string query = @"
                SELECT
                    E.EnquiryID,
                    E.FullName,
                    E.MobileNumber,
                    E.City,
                    E.Area,
                    E.ServiceCategoryID,
                    S.ServiceName,
                    E.DutyHours,
                    E.RequiredWhen,
                    E.AdditionalRequirements,
                    E.CallbackStatus,
                    E.AdminRemarks,
                    E.CreatedDate,
                    E.UpdatedDate
                FROM HomeCareEnquiries E
                INNER JOIN ServiceCategories S
                    ON E.ServiceCategoryID =
                       S.ServiceCategoryID
                WHERE
                    (
                        @ServiceCategoryID = 0
                        OR E.ServiceCategoryID =
                           @ServiceCategoryID
                    )
                ORDER BY E.CreatedDate DESC,
                         E.EnquiryID DESC;";

            DataTable dt = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                cmd.Parameters.Add(
                    "@ServiceCategoryID",
                    SqlDbType.Int).Value = serviceCategoryID;

                using (SqlDataAdapter da =
                    new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            lvEnquiries.DataSource = dt;
            lvEnquiries.DataBind();

            lblRecordCount.Text =
                "Total enquiries: " + dt.Rows.Count;
        }

        // ==========================================
        // SET SAVED CALLBACK STATUS IN DROPDOWN
        // ==========================================

        protected void lvEnquiries_ItemDataBound(
            object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                DataRowView row =
                    e.Item.DataItem as DataRowView;

                if (row == null)
                {
                    return;
                }

                DropDownList ddlStatus =
                    e.Item.FindControl("ddlCallbackStatus")
                    as DropDownList;

                if (ddlStatus != null)
                {
                    string savedStatus =
                        Convert.ToString(
                            row["CallbackStatus"]);

                    ListItem item =
                        ddlStatus.Items.FindByValue(
                            savedStatus);

                    if (item != null)
                    {
                        ddlStatus.ClearSelection();
                        item.Selected = true;
                    }
                }
            }
        }

        // ==========================================
        // UPDATE CALLBACK STATUS AND ADMIN REMARKS
        // ==========================================

        protected void lvEnquiries_ItemCommand(
            object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName != "UpdateStatus")
            {
                return;
            }

            int enquiryID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out enquiryID))
            {
                ShowAdminMessage(
                    "Invalid enquiry ID.", false);

                return;
            }

            DropDownList ddlStatus =
                e.Item.FindControl("ddlCallbackStatus")
                as DropDownList;

            TextBox txtRemarks =
                e.Item.FindControl("txtAdminRemarks")
                as TextBox;

            if (ddlStatus == null || txtRemarks == null)
            {
                ShowAdminMessage(
                    "Unable to read the enquiry details.", false);

                return;
            }

            string status = ddlStatus.SelectedValue;

            string remarks = txtRemarks.Text.Trim();

            if (remarks.Length > 1000)
            {
                ShowAdminMessage(
                    "Admin remarks cannot exceed 1000 characters.",
                    false);

                return;
            }

            if (status != "Pending" &&
                status != "Contacted" &&
                status != "In Progress" &&
                status != "Completed" &&
                status != "Cancelled")
            {
                ShowAdminMessage(
                    "Invalid callback status.", false);

                return;
            }

            string query = @"
                UPDATE HomeCareEnquiries
                SET
                    CallbackStatus = @CallbackStatus,
                    AdminRemarks = @AdminRemarks,
                    UpdatedDate = GETDATE()
                WHERE EnquiryID = @EnquiryID;";

            int rowsAffected;

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                cmd.Parameters.Add(
                    "@CallbackStatus",
                    SqlDbType.NVarChar, 30).Value = status;

                cmd.Parameters.Add(
                    "@AdminRemarks",
                    SqlDbType.NVarChar, 1000).Value =
                    string.IsNullOrWhiteSpace(remarks)
                    ? (object)DBNull.Value
                    : remarks;

                cmd.Parameters.Add(
                    "@EnquiryID",
                    SqlDbType.Int).Value = enquiryID;

                con.Open();

                rowsAffected = cmd.ExecuteNonQuery();
            }

            if (rowsAffected > 0)
            {
                ShowAdminMessage(
                    "Enquiry #" + enquiryID +
                    " updated successfully.", true);
            }
            else
            {
                ShowAdminMessage(
                    "The enquiry was not found.", false);
            }

            // Preserve the selected category filter and page.
            BindEnquiries();
        }

        // ==========================================
        // DISPLAY ADMIN MESSAGE
        // ==========================================

        private void ShowAdminMessage(
            string message, bool success)
        {
            lblAdminMessage.Text =
                Server.HtmlEncode(message);

            lblAdminMessage.Visible = true;

            lblAdminMessage.CssClass = success
                ? "hca-message hca-success"
                : "hca-message hca-error";
        }
        
protected void lvEnquiries_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            dpEnquiries.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

            BindEnquiries();
        }

    }
}