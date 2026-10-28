using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class EditRequirements : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindServices();

                string id = Request.QueryString["id"];

                int requirementId;
                if (int.TryParse(id, out requirementId) && requirementId > 0)
                {
                    LoadRequirement(requirementId);
                }
                else
                {
                    lblMessage.Text = "Invalid requirement ID.";
                }
            }
        }

        private void BindServices()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT ServiceCategoryID, ServiceName
                    FROM [sqladmin].[ServiceCategories]
                    WHERE IsActive = 1
                    ORDER BY DisplayOrder, ServiceName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlService.DataSource = cmd.ExecuteReader();
                    ddlService.DataTextField = "ServiceName";
                    ddlService.DataValueField = "ServiceCategoryID";
                    ddlService.DataBind();
                }
            }

            ddlService.Items.Insert(
                0, new ListItem("-- Select Service --", ""));
        }

        private void LoadRequirement(int requirementId)
        {
            string query = @"
                SELECT
                    R.RequirementID,
                    R.Service,
                    R.ServiceCategoryID,
                    R.City,
                    R.Area,
                    R.PresentAreaID,
                    R.DutyTime,
                    R.PreferredLanguage,
                    R.Budget,
                    R.JoiningDate,
                    R.FullName,
                    R.MobileNumber,
                    R.WhatsAppNumber,
                    L.PlaceName
                FROM [sqladmin].[PostRequirements] R
                LEFT JOIN [sqladmin].[LocalPlaces] L
                    ON R.PresentAreaID = L.PlaceID
                WHERE R.RequirementID = @RequirementID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@RequirementID", SqlDbType.Int)
                    .Value = requirementId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        lblMessage.Text = "Requirement not found.";
                        return;
                    }

                    // Service
                    string serviceId = "";

                    if (reader["ServiceCategoryID"] != DBNull.Value)
                    {
                        serviceId = reader["ServiceCategoryID"].ToString();
                    }

                    if (ddlService.Items.FindByValue(serviceId) != null)
                    {
                        ddlService.SelectedValue = serviceId;
                    }

                    // City
                    string city = reader["City"] == DBNull.Value
                        ? ""
                        : reader["City"].ToString();

                    if (!string.IsNullOrWhiteSpace(city) &&
                        ddlCity.Items.FindByValue(city) == null)
                    {
                        ddlCity.Items.Add(new ListItem(city, city));
                    }

                    if (ddlCity.Items.FindByValue(city) != null)
                    {
                        ddlCity.SelectedValue = city;
                    }

                    // Area name and PlaceID
                    hdnAreaID.Value =
                        reader["PresentAreaID"] == DBNull.Value
                        ? ""
                        : reader["PresentAreaID"].ToString();

                    txtArea.Text =
                        reader["PlaceName"] == DBNull.Value
                        ? ""
                        : reader["PlaceName"].ToString();

                    // Duty time
                    string dutyTime =
                        reader["DutyTime"] == DBNull.Value
                        ? ""
                        : reader["DutyTime"].ToString();

                    if (ddlDutyTime.Items.FindByValue(dutyTime) != null)
                    {
                        ddlDutyTime.SelectedValue = dutyTime;
                    }

                    // Preferred language
                    string language =
                        reader["PreferredLanguage"] == DBNull.Value
                        ? ""
                        : reader["PreferredLanguage"].ToString();

                    if (!string.IsNullOrWhiteSpace(language) &&
                        txtPreferredLanguage.Items.FindByValue(language) == null)
                    {
                        txtPreferredLanguage.Items.Add(
                            new ListItem(language, language));
                    }

                    if (txtPreferredLanguage.Items.FindByValue(language) != null)
                    {
                        txtPreferredLanguage.SelectedValue = language;
                    }

                    // Budget
                    txtBudget.Text =
                        reader["Budget"] == DBNull.Value
                        ? ""
                        : reader["Budget"].ToString();

                    // Joining date
                    if (reader["JoiningDate"] != DBNull.Value)
                    {
                        txtJoiningDate.Text =
                            Convert.ToDateTime(reader["JoiningDate"])
                            .ToString("yyyy-MM-dd");
                    }

                    // Contact details
                    txtFullName.Text =
                        reader["FullName"] == DBNull.Value
                        ? ""
                        : reader["FullName"].ToString();

                    txtMobile.Text =
                        reader["MobileNumber"] == DBNull.Value
                        ? ""
                        : reader["MobileNumber"].ToString();

                    txtWhatsApp.Text =
                        reader["WhatsAppNumber"] == DBNull.Value
                        ? ""
                        : reader["WhatsAppNumber"].ToString();
                }
            }
        }



        protected void btnEdit_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "Save button clicked. ID = "
                      + Request.QueryString["id"];
            int requirementId;
            int areaId;
            int serviceCategoryId;
            DateTime joiningDate;

            try
            {
                if (!int.TryParse(Request.QueryString["id"], out requirementId) ||
                    requirementId <= 0)
                {
                    lblMessage.Text = "Invalid Requirement ID.";
                    return;
                }

                if (!int.TryParse(hdnAreaID.Value, out areaId) || areaId <= 0)
                {
                    lblMessage.Text = "Please select an area from the suggestions.";
                    return;
                }

                if (!int.TryParse(ddlService.SelectedValue, out serviceCategoryId))
                {
                    lblMessage.Text = "Please select a service.";
                    return;
                }

                if (!DateTime.TryParse(txtJoiningDate.Text, out joiningDate))
                {
                    lblMessage.Text = "Please enter a valid joining date.";
                    return;
                }

                string query = @"
            UPDATE [sqladmin].[PostRequirements]
            SET Service = @Service,
                ServiceCategoryID = @ServiceCategoryID,
                City = @City,
                Area = @Area,
                PresentAreaID = @PresentAreaID,
                DutyTime = @DutyTime,
                PreferredLanguage = @PreferredLanguage,
                Budget = @Budget,
                JoiningDate = @JoiningDate,
                FullName = @FullName,
                MobileNumber = @MobileNumber,
                WhatsAppNumber = @WhatsAppNumber
            WHERE RequirementID = @RequirementID;

            SELECT @@ROWCOUNT;";

                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Service",
                        ddlService.SelectedValue);

                    cmd.Parameters.AddWithValue("@ServiceCategoryID",
                        serviceCategoryId);

                    cmd.Parameters.AddWithValue("@City",
                        ddlCity.SelectedValue);

                    cmd.Parameters.AddWithValue("@Area",
                        areaId.ToString());

                    cmd.Parameters.AddWithValue("@PresentAreaID", areaId);

                    cmd.Parameters.AddWithValue("@DutyTime",
                        ddlDutyTime.SelectedValue);

                    cmd.Parameters.AddWithValue("@PreferredLanguage",
                        txtPreferredLanguage.SelectedValue);

                    cmd.Parameters.AddWithValue("@Budget",
                        txtBudget.Text.Trim());

                    cmd.Parameters.Add("@JoiningDate", SqlDbType.DateTime).Value =
                        joiningDate;

                    cmd.Parameters.AddWithValue("@FullName",
                        txtFullName.Text.Trim());

                    cmd.Parameters.AddWithValue("@MobileNumber",
                        txtMobile.Text.Trim());

                    cmd.Parameters.AddWithValue("@WhatsAppNumber",
                        string.IsNullOrWhiteSpace(txtWhatsApp.Text)
                            ? (object)DBNull.Value
                            : txtWhatsApp.Text.Trim());

                    cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value =
                        requirementId;

                    con.Open();

                    int rows = Convert.ToInt32(cmd.ExecuteScalar());

                    if (rows > 0)
                    {
                        lblMessage.Text =
                            "Record updated successfully. Requirement ID: "
                            + requirementId;
                    }
                    else
                    {
                        lblMessage.Text =
                            "No record updated. Requirement ID: "
                            + requirementId;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Database Error: " + ex.Message;
            }

        }


    }
}



        



    

 