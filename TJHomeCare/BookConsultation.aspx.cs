
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace TJHomeCare
{
    public partial class BookConsultation : Page
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
            if (!IsPostBack)
            {
                LoadProfessionals();
            }
        }


        private void LoadProfessionals()
        {
            int serviceId;

            if (!Int32.TryParse(
                Request.QueryString["serviceId"], out serviceId)
                || serviceId <= 0)
            {
                litHeading.Text = "Online Consultation";
                ShowMessage("Please select a valid consultation category.");
                return;
            }

            DataTable dt = new DataTable();

            string query = @"
        SELECT
            C.CaregiverID,
            C.FullName,
            SC.ServiceName,
            COALESCE(
                NULLIF(ServiceList.ServiceCategory, ''),
                C.ServiceCategory
            ) AS ServiceCategory,
            C.City,
            L.PlaceName AS PresentArea,
            C.Experience,
            C.LanguagesKnown,
            C.ProfilePhoto,C.ProfilePhotoName,Qualification,DutyPreference
        FROM [sqladmin].[CaregiverProfiles] C

        INNER JOIN [sqladmin].[ServiceCategories] SC
            ON SC.ServiceCategoryID = @ServiceCategoryID
           AND SC.IsActive = 1

        OUTER APPLY
        (
            SELECT STUFF
            (
                (
                    SELECT ', ' + SC2.ServiceName
                    FROM [sqladmin].[CaregiverServices] CS2
                    INNER JOIN [sqladmin].[ServiceCategories] SC2
                        ON SC2.ServiceCategoryID = CS2.ServiceCategoryID
                    WHERE CS2.CaregiverID = C.CaregiverID
                      AND SC2.IsActive = 1
                      AND CS2.ServiceCategoryID = @ServiceCategoryID
                    ORDER BY SC2.DisplayOrder, SC2.ServiceName
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'),
                1, 2, ''
            ) AS ServiceCategory
        ) AS ServiceList

        LEFT JOIN [sqladmin].[LocalPlaces] L
            ON C.PresentAreaID = L.PlaceID

        WHERE C.IsActive = 1
        
          AND EXISTS
          (
              SELECT 1
              FROM [sqladmin].[CaregiverServices] CS
              WHERE CS.CaregiverID = C.CaregiverID
                AND CS.ServiceCategoryID = @ServiceCategoryID
          )

        ORDER BY C.CreatedDate DESC, C.CaregiverID DESC;";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.Add(
                    "@ServiceCategoryID",
                    SqlDbType.Int).Value = serviceId;

                da.Fill(dt);
            }

            if (dt.Rows.Count > 0)
            {
                litHeading.Text = HttpUtility.HtmlEncode(
                    Convert.ToString(dt.Rows[0]["ServiceName"]));

                rptProfessionals.DataSource = dt;
                rptProfessionals.DataBind();

                lblMessage.Visible = false;
            }
            else
            {
                litHeading.Text = "Online Consultation";

                rptProfessionals.DataSource = null;
                rptProfessionals.DataBind();

                ShowMessage(
                    "No active, verified professionals are registered " +
                    "for this consultation category. Please check again later.");
            }
        }


        protected string DisplayValue(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not provided";

            string result = Convert.ToString(value).Trim();

            return String.IsNullOrEmpty(result)
                ? "Not provided"
                : result;
        }

        protected string FormatExperience(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not provided";

            string result = Convert.ToString(value).Trim();

            if (String.IsNullOrEmpty(result))
                return "Not provided";

            decimal years;

            if (Decimal.TryParse(
                result,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out years))
            {
                return years.ToString("0.##") +
                    (years == 1 ? " year" : " years");
            }

            // Supports text values such as "6 years".
            return result;
        }

        protected bool HasProfilePhoto(
            object photo, object photoName)
        {
            if (photo != null && photo != DBNull.Value)
            {
                byte[] bytes = photo as byte[];

                if (bytes != null && bytes.Length > 0)
                    return true;

                string path = photo as string;

                if (!String.IsNullOrWhiteSpace(path))
                    return true;
            }

            return photoName != null &&
                photoName != DBNull.Value &&
                !String.IsNullOrWhiteSpace(
                    Convert.ToString(photoName));
        }

        protected string ResolveProfilePhoto(
            object photo, object photoName)
        {
            byte[] bytes = photo as byte[];

            if (bytes != null && bytes.Length > 0)
            {
                // Change image/jpeg if your stored files use
                // a different image format.
                return "data:image/jpeg;base64," +
                    Convert.ToBase64String(bytes);
            }

            string path = photo as string;

            if (String.IsNullOrWhiteSpace(path) &&
                photoName != null &&
                photoName != DBNull.Value)
            {
                path = Convert.ToString(photoName);
            }

            if (String.IsNullOrWhiteSpace(path))
                return String.Empty;

            path = path.Trim();

            if (path.StartsWith("~/"))
                return ResolveUrl(path);

            if (path.StartsWith("/") ||
                path.StartsWith("https://",
                    StringComparison.OrdinalIgnoreCase) ||
                path.StartsWith("http://",
                    StringComparison.OrdinalIgnoreCase))
            {
                return path;
            }

            // Treat a plain filename as a file in Images.
            return ResolveUrl("~/Images/" + path);
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}
