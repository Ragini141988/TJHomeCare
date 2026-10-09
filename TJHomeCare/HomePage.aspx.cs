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
    public partial class HomePage : System.Web.UI.Page
    {
        private readonly string connectionString =
          ConfigurationManager
              .ConnectionStrings[
                  "hospi2yp_tabletjobssConnectionString_V02"]
              .ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReviews();
            }
        }
        private void LoadReviews()
        {
            string query = @"
            SELECT TOP (6)
                   [ReviewId],
                   [Name],
                   [Rating],
                   [Remarks],
                   [ReviewDate],
                   [City]
            FROM [sqladmin].[Reviews]
            WHERE [IsActive] = 1
            ORDER BY [ReviewDate] DESC, [ReviewId] DESC;";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        da.Fill(dt);

                        rptReviews.DataSource = dt;
                        rptReviews.DataBind();
                    }
                }
            }
        }

        public string GetStars(object rating)
        {
            int stars = 0;

            if (rating != null && rating != DBNull.Value)
            {
                int.TryParse(rating.ToString(), out stars);
            }

            // Keep the rating between 0 and 5.
            stars = Math.Max(0, Math.Min(5, stars));

            return new string('★', stars)
                 + new string('☆', 5 - stars);
        }

        public string GetInitial(object name)
        {
            if (name == null || name == DBNull.Value)
            {
                return "?";
            }

            string reviewerName = name.ToString().Trim();

            if (string.IsNullOrEmpty(reviewerName))
            {
                return "?";
            }

            return Server.HtmlEncode(
                reviewerName.Substring(0, 1).ToUpperInvariant());
        }
    }
}
