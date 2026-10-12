using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare.Staff
{
    public partial class Inquiries : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsStaff())
            //{
            //    Response.StatusCode = 403;
            //    lblMessage.Text = "Access denied. Please sign in with an authorized staff account.";
            //    gvInquiries.Visible = false;
            //    return;
            //}
            if (!IsPostBack) LoadInquiries();
        }

        // Adjust this check to match the authentication/session key used by the existing admin login.
        private bool IsStaff()
        {
            return Session["IsAdmin"] != null && Convert.ToString(Session["IsAdmin"]).Equals("true", StringComparison.OrdinalIgnoreCase)
                || Session["IsStaff"] != null && Convert.ToString(Session["IsStaff"]).Equals("true", StringComparison.OrdinalIgnoreCase);
        }

        private void LoadInquiries()
        {
            string sql = @"
                SELECT I.InquiryID,I.CreatedDate,I.FullName,I.ContactNumber,I.Email,I.City,
                       C.FullName AS SelectedCandidate,I.InquiryStatus
                FROM [sqladmin].[CaregiverInquiries] I
                LEFT JOIN [sqladmin].[CaregiverProfiles] C ON I.CaregiverID=C.CaregiverID
                ORDER BY CASE WHEN I.InquiryStatus='New' THEN 0 ELSE 1 END,
                         I.CreatedDate DESC,I.InquiryID DESC;";
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                lvInquiries.DataSource = dt;
                lvInquiries.DataBind();
            }
        }

        protected void lvInquiries_ItemCommand(
            object sender,
            ListViewCommandEventArgs e)
        {
            if (e.CommandName == "Matches")
            {
                int inquiryId;

                if (Int32.TryParse(
                    Convert.ToString(e.CommandArgument),
                    out inquiryId) && inquiryId > 0)
                {
                    Response.Redirect(
                        "InquiryMatches01.aspx?id=" + inquiryId);
                }
            }
        }

        
    }
}
