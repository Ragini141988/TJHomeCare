using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class SendInquiry : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;
        private int CaregiverID
        {
            get { int id; return Int32.TryParse(Request.QueryString["id"], out id) ? id : 0; }
        }
        private int RequirementID
        {
            get { int id; return Int32.TryParse(Request.QueryString["requirementId"], out id) ? id : 0; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadCandidate();
        }

        private void LoadCandidate()
        {
            if (CaregiverID <= 0)
            {
                pnlInquiry.Visible = false;
                lblMessage.Text = "Please select a valid caregiver profile before sending an inquiry.";
                return;
            }
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"SELECT FullName,ServiceCategory,City FROM [sqladmin].[CaregiverProfiles] WHERE CaregiverID=@ID AND IsActive=1", con))
            {
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = CaregiverID;
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        pnlInquiry.Visible = false;
                        lblMessage.Text = "This caregiver is not currently available.";
                        return;
                    }
                    litCandidate.Text = Server.HtmlEncode(Convert.ToString(r["FullName"])) + " — " +
                        Server.HtmlEncode(Convert.ToString(r["ServiceCategory"])) + ", " +
                        Server.HtmlEncode(Convert.ToString(r["City"]));
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string name = txtFullName.Text.Trim();
            string contact = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string city = ddlCity.SelectedValue.ToString().Trim();

            if (CaregiverID <= 0 || name.Length == 0 || contact.Length == 0 || city.Length == 0)
            {
                lblMessage.Text = "Please enter your name, contact number and city.";
                return;
            }
            if (email.Length > 150 || name.Length > 150 || contact.Length > 20 || city.Length > 100)
            {
                lblMessage.Text = "One or more fields exceed the allowed length.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                INSERT INTO [sqladmin].[CaregiverInquiries]
                    (RequirementID,CaregiverID,FullName,ContactNumber,Email,City)
                SELECT @RequirementID,C.CaregiverID,@FullName,@ContactNumber,@Email,@City
                FROM [sqladmin].[CaregiverProfiles] C
                WHERE C.CaregiverID=@CaregiverID AND C.IsActive=1;
                SELECT CAST(@@ROWCOUNT AS INT);", con))
            {
                cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = RequirementID > 0 ? (object)RequirementID : DBNull.Value;
                cmd.Parameters.Add("@CaregiverID", SqlDbType.Int).Value = CaregiverID;
                cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 150).Value = name;
                cmd.Parameters.Add("@ContactNumber", SqlDbType.NVarChar, 20).Value = contact;
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = email.Length == 0 ? (object)DBNull.Value : email;
                cmd.Parameters.Add("@City", SqlDbType.NVarChar, 100).Value = city;
                con.Open();
                int inserted = Convert.ToInt32(cmd.ExecuteScalar());
                if (inserted == 1)
                    Response.Redirect("~/InquirySubmitted.aspx", false);
                else
                    lblMessage.Text = "The selected caregiver is no longer available. Please choose another profile.";
            }
        }
    }
}
