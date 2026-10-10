using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class PostRequirement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        private void SaveRequirementToDatabase()
        {
            string cs = ConfigurationManager
      .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
      .ConnectionString;

            string query = "INSERT INTO PostRequirements (Service, City, Area, DutyTime, PreferredLanguage, Budget, JoiningDate, FullName, MobileNumber, WhatsAppNumber) " +
                           "VALUES (@Service, @City, @Area, @DutyTime, @PreferredLanguage, @Budget, @JoiningDate, @FullName, @MobileNumber, @WhatsAppNumber)";

            using (SqlConnection conn = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Service", ddlService.SelectedValue);
                    cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
                    cmd.Parameters.AddWithValue("@Area", txtArea.Text.Trim());
                    cmd.Parameters.AddWithValue("@DutyTime", rblDutyTime.SelectedValue);
                    cmd.Parameters.AddWithValue("@PreferredLanguage", ddlLanguage.SelectedValue);
                    cmd.Parameters.AddWithValue("@Budget", txtBudget.Text.Trim());
                    cmd.Parameters.AddWithValue("@JoiningDate", Convert.ToDateTime(txtJoiningDate.Text));
                    cmd.Parameters.AddWithValue("@FullName", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@MobileNumber", txtMobile.Text.Trim());

                    string whatsapp = txtWhatsApp.Text.Trim();
                    if (string.IsNullOrEmpty(whatsapp))
                    {
                        cmd.Parameters.AddWithValue("@WhatsAppNumber", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@WhatsAppNumber", whatsapp);
                    }

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        ClearForm();


                       // string script = "alert('Your requirement has been posted successfully!'); window.location='Default.aspx';";
                       // ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", script, true);

                    }
                    catch (Exception ex)
                    {

                    }
                }
            }
        }
        private void ClearForm()
        {
            ddlService.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            txtArea.Text = "";
            rblDutyTime.ClearSelection();
            ddlLanguage.SelectedIndex = 0;
            txtBudget.Text = "";
            txtJoiningDate.Text = "";
            txtName.Text = "";
            txtMobile.Text = "";
            txtWhatsApp.Text = "";
        }
        protected void btnPostRequirement_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Method call
                SaveRequirementToDatabase();
            }
        }
    }
    }