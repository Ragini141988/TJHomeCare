using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

namespace TJHomeCare
{
    public partial class PostRequirement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static List<PlaceResult> GetPlaces(string searchText, string city)
        {
            List<PlaceResult> result = new List<PlaceResult>();

            if (string.IsNullOrWhiteSpace(searchText))
                return result;

            string connString = ConfigurationManager
                .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(connString))
            {
                string sql = @"
            SELECT TOP 30
                PlaceID,
                PlaceName
            FROM [sqladmin].[LocalPlaces]
            WHERE PlaceName LIKE @SearchText
              AND (
                    @City = ''
                    OR UPPER(City) = @City
                  )
            ORDER BY
                OrderColumn ASC,
                PlaceName ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@SearchText", SqlDbType.NVarChar, 200)
                        .Value = "%" + searchText.Trim() + "%";

                    cmd.Parameters.Add("@City", SqlDbType.NVarChar, 300)
                        .Value = string.IsNullOrWhiteSpace(city)
                            ? ""
                            : city.Trim().ToUpper();

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new PlaceResult
                            {
                                PlaceID = Convert.ToInt32(reader["PlaceID"]),
                                PlaceName = reader["PlaceName"].ToString()
                            });
                        }
                    }
                }
            }

            return result;
        }

        public class PlaceResult
        {
            public int PlaceID { get; set; }
            public string PlaceName { get; set; }
        }
        private void SaveRequirementToDatabase()
        {
            string cs = ConfigurationManager
      .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
      .ConnectionString;

            string query = "INSERT INTO PostRequirements (Service, City, Area,  PresentAreaID, DutyTime, PreferredLanguage, Budget, JoiningDate, FullName, MobileNumber, WhatsAppNumber) " +
                           "VALUES (@Service, @City, @Area, @PresentAreaID, @DutyTime, @PreferredLanguage, @Budget, @JoiningDate, @FullName, @MobileNumber, @WhatsAppNumber)";

            using (SqlConnection conn = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Service", ddlService.SelectedValue);
                    cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
                  

                    int areaID;

                    if (!int.TryParse(hdnAreaID.Value, out areaID))
                    {
                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "areaError",
                            "alert('Please select an Area from the suggestions.');", true);
                        return;
                    }

                    cmd.Parameters.Add("@PresentAreaID", SqlDbType.Int).Value = areaID;
                    cmd.Parameters.AddWithValue("@Area", Convert.ToString(areaID).Trim());
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
                        //string script = "alert('Your requirement has been posted successfully!'); window.location='Default.aspx';";
                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", script, true);

                        string script = @"
Swal.fire({
    icon: 'success',
    title: 'Requirement Posted Successfully!',
    text: 'Thank you! Your home care requirement has been submitted.',
    confirmButtonText: 'Go to Home',
    confirmButtonColor: '#198754',
    allowOutsideClick: false
}).then(function (result) {
    if (result.isConfirmed) {
        window.location.href = 'HomePage.aspx';
    }
});";

                        ScriptManager.RegisterStartupScript(
                            this,
                            this.GetType(),
                            "successAlert",
                            script,
                            true
                        );
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError(ex.ToString());

                        ScriptManager.RegisterStartupScript(
                            this,
                            GetType(),
                            "saveError",
                            "alert('Unable to save your requirement. Please check the details and try again.');",
                            true
                        );
                    }
                }
            }
        }
        private void ClearForm()
        {
            ddlService.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            txtArea.Text = "";
            hdnAreaID.Value = "";
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