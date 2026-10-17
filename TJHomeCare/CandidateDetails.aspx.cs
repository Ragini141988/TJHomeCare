using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class CandidateDetails : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadProfile();
        }

        private void LoadProfile()
        {
            int id;
            if (!Int32.TryParse(Request.QueryString["id"], out id) || id <= 0)
            {
                lblMessage.Text = "Candidate profile was not found.";
                return;
            }

            string sql = @"
        SELECT
            C.CaregiverID,
            C.FullName,
            C.Age,
            C.Gender,

            -- Service names from the new service mapping tables
            COALESCE(
                NULLIF(
                    STUFF((
                        SELECT ', ' + SC.ServiceName
                        FROM [sqladmin].[CaregiverServices] CS
                        INNER JOIN [sqladmin].[ServiceCategories] SC
                            ON SC.ServiceCategoryID = CS.ServiceCategoryID
                        WHERE CS.CaregiverID = C.CaregiverID
                          AND SC.IsActive = 1
                        ORDER BY SC.DisplayOrder, SC.ServiceName
                        FOR XML PATH(''), TYPE
                    ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''),
                    ''
                ),
                C.ServiceCategory
            ) AS ServiceCategory,

            C.City,

            -- Present area name
            LP.PlaceName AS PresentArea,

            C.LanguagesKnown,
            C.Qualification,
            C.Experience,
            C.DutyPreference,
            C.ExpectedSalary,

            -- Preferred work area names instead of IDs
            COALESCE(
                NULLIF(
                    STUFF((
                        SELECT ', ' + P.PlaceName
                        FROM STRING_SPLIT(
                            ISNULL(C.PreferredWorkAreas, ''), ','
                        ) AS S
                        INNER JOIN [sqladmin].[LocalPlaces] P
                            ON P.PlaceID = TRY_CAST(LTRIM(RTRIM(S.value)) AS INT)
                        FOR XML PATH(''), TYPE
                    ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''),
                    ''
                ),
                C.PreferredWorkAreas
            ) AS PreferredWorkAreas,

            C.JoiningAvailability,
            C.ProfilePhoto

        FROM [sqladmin].[CaregiverProfiles] C

        LEFT JOIN [sqladmin].[LocalPlaces] LP
            ON C.PresentAreaID = LP.PlaceID

        WHERE C.CaregiverID = @ID
          AND C.IsActive = 1;";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;

                con.Open();

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        lblMessage.Text = "This candidate is not available.";
                        return;
                    }

                    litName.Text = Enc(r["FullName"]);
                    litService.Text = Enc(r["ServiceCategory"]);
                    litAge.Text = Enc(r["Age"]);
                    litGender.Text = Enc(r["Gender"]);
                    litCity.Text = Enc(r["City"]);
                    litArea.Text = Enc(r["PresentArea"]);
                    litLanguages.Text = Enc(r["LanguagesKnown"]);
                    litQualification.Text = Enc(r["Qualification"]);
                    litExperience.Text = Enc(r["Experience"]);
                    litDuty.Text = Enc(r["DutyPreference"]);
                    litSalary.Text = Enc(r["ExpectedSalary"]);
                    litWorkAreas.Text = Enc(r["PreferredWorkAreas"]);
                    litAvailability.Text = Enc(r["JoiningAvailability"]);

                    string photo = PhotoUrl(r["ProfilePhoto"]);

                    if (!String.IsNullOrEmpty(photo))
                    {
                        imgPhoto.ImageUrl = photo;
                        imgPhoto.Visible = true;
                    }

                    lnkInquiry.NavigateUrl =
                        ResolveUrl("~/SendInquiry.aspx?id=" + id);

                    pnlProfile.Visible = true;
                }
            }
        }

        private string Enc(object value)
        {
            return value == null || value == DBNull.Value ? "Not specified" : Server.HtmlEncode(Convert.ToString(value));
        }
        private string PhotoUrl(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            byte[] bytes = value as byte[];
            if (bytes == null || bytes.Length == 0) return "";
            string mime = "image/jpeg";
            if (bytes.Length >= 8 && bytes[0] == 137 && bytes[1] == 80 && bytes[2] == 78 && bytes[3] == 71) mime = "image/png";
            else if (bytes.Length >= 6 && System.Text.Encoding.ASCII.GetString(bytes, 0, 3) == "GIF") mime = "image/gif";
            return "data:" + mime + ";base64," + Convert.ToBase64String(bytes);
        }
       
    }
}
