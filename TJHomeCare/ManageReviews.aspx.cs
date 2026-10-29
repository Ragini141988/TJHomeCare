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
    public partial class ManageReviews : System.Web.UI.Page
    {
        private readonly string connectionString =
             ConfigurationManager.ConnectionStrings[
                 "hospi2yp_tabletjobssConnectionString_V02"
             ].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReviews();
            }
        }

        private void LoadReviews()
        {
            DataTable dt = new DataTable();

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT ReviewId, Name, ContactNo, Rating,
                               Remarks, ReviewDate, Email, City
                        FROM [sqladmin].[Reviews]
                        ORDER BY ReviewDate DESC, ReviewId DESC;";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }

                rptReviews.DataSource = dt;
                rptReviews.DataBind();

                lblTotalReviews.Text = dt.Rows.Count.ToString();
                pnlEmpty.Visible = dt.Rows.Count == 0;
            }
            catch (Exception)
            {
                rptReviews.DataSource = null;
                rptReviews.DataBind();

                lblTotalReviews.Text = "0";
                pnlEmpty.Visible = false;

                lblMessage.Text =
                    "Unable to load reviews. Please check the database connection and table name.";

                lblMessage.ForeColor =
                    System.Drawing.Color.Red;
            }
        }

        protected string GetInitial(object name)
        {
            string reviewerName = Convert.ToString(name);

            if (string.IsNullOrWhiteSpace(reviewerName))
            {
                return "?";
            }

            return HttpUtility.HtmlEncode(
                reviewerName.Trim().Substring(0, 1).ToUpper()
            );
        }

        protected string GetStars(object rating)
        {
            int stars = 0;

            if (rating != null && rating != DBNull.Value)
            {
                int.TryParse(Convert.ToString(rating), out stars);
            }

            if (stars < 0)
            {
                stars = 0;
            }

            if (stars > 5)
            {
                stars = 5;
            }

            return new string('★', stars) +
                   new string('☆', 5 - stars);
        }

        protected void rptReviews_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteReview")
            {
                int reviewId;

                if (!int.TryParse(
                    Convert.ToString(e.CommandArgument),
                    out reviewId))
                {
                    lblMessage.Text = "Invalid review ID.";
                    lblMessage.ForeColor =
                        System.Drawing.Color.Red;
                    return;
                }

                try
                {
                    int rowsAffected;

                    using (SqlConnection con =
                        new SqlConnection(connectionString))
                    {
                        string query = @"
                            DELETE FROM [sqladmin].[Reviews]
                            WHERE ReviewId = @ReviewId;";

                        using (SqlCommand cmd =
                            new SqlCommand(query, con))
                        {
                            cmd.Parameters.Add(
                                "@ReviewId",
                                SqlDbType.Int
                            ).Value = reviewId;

                            con.Open();
                            rowsAffected = cmd.ExecuteNonQuery();
                        }
                    }

                    if (rowsAffected > 0)
                    {
                        lblMessage.Text =
                            "Review deleted successfully.";

                        lblMessage.ForeColor =
                            System.Drawing.Color.Green;
                    }
                    else
                    {
                        lblMessage.Text =
                            "Review not found or already deleted.";

                        lblMessage.ForeColor =
                            System.Drawing.Color.Red;
                    }

                    LoadReviews();
                }
                catch (Exception)
                {
                    lblMessage.Text =
                        "Unable to delete review. Please check the database.";

                    lblMessage.ForeColor =
                        System.Drawing.Color.Red;
                }
            }
        }
    }
}