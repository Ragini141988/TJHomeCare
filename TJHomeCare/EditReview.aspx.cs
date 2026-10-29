using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class EditReview : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int reviewId;

                if (!int.TryParse(Request.QueryString["id"], out reviewId)
                    || reviewId <= 0)
                {
                    ShowMessage("Invalid review ID.", true);
                    btnUpdate.Enabled = false;
                    return;
                }

                hdnReviewId.Value = reviewId.ToString();
                LoadReview(reviewId);
            }
        }

        private void LoadReview(int reviewId)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT ReviewId, Name, ContactNo, Rating,
                               Remarks, ReviewDate, Email, City
                        FROM [sqladmin].[Reviews]
                        WHERE ReviewId = @ReviewId;";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@ReviewId", SqlDbType.Int
                        ).Value = reviewId;

                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtName.Text =
                                    GetValue(reader, "Name");

                                txtContactNo.Text =
                                    GetValue(reader, "ContactNo");

                                txtEmail.Text =
                                    GetValue(reader, "Email");

                                txtCity.Text =
                                    GetValue(reader, "City");

                                txtRemarks.Text =
                                    GetValue(reader, "Remarks");

                                if (reader["Rating"] != DBNull.Value)
                                {
                                    string rating =
                                        Convert.ToString(reader["Rating"]);

                                    if (ddlRating.Items.FindByValue(rating) != null)
                                    {
                                        ddlRating.SelectedValue = rating;
                                    }
                                }

                                if (reader["ReviewDate"] != DBNull.Value)
                                {
                                    txtReviewDate.Text =
                                        Convert.ToDateTime(reader["ReviewDate"])
                                            .ToString("yyyy-MM-dd");
                                }
                            }
                            else
                            {
                                ShowMessage("Review not found.", true);
                                btnUpdate.Enabled = false;
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to load review. Please check the database connection and table name.",
                    true
                );

                btnUpdate.Enabled = false;
            }
        }

        private string GetValue(SqlDataReader reader, string columnName)
        {
            if (reader[columnName] == DBNull.Value)
            {
                return string.Empty;
            }

            return Convert.ToString(reader[columnName]);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Page.Validate("ReviewForm");

            if (!Page.IsValid)
            {
                return;
            }

            int reviewId;
            int rating;

            if (!int.TryParse(hdnReviewId.Value, out reviewId)
                || reviewId <= 0)
            {
                ShowMessage("Invalid review ID.", true);
                return;
            }

            if (!int.TryParse(ddlRating.SelectedValue, out rating)
                || rating < 1 || rating > 5)
            {
                ShowMessage("Please select a valid rating.", true);
                return;
            }

            object reviewDateValue = DBNull.Value;

            if (!string.IsNullOrWhiteSpace(txtReviewDate.Text))
            {
                DateTime reviewDate;

                if (!DateTime.TryParseExact(
                    txtReviewDate.Text.Trim(),
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out reviewDate))
                {
                    ShowMessage("Please enter a valid review date.", true);
                    return;
                }

                reviewDateValue = reviewDate;
            }

            try
            {
                int rowsAffected;

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE [sqladmin].[Reviews]
                        SET Name = @Name,
                            ContactNo = @ContactNo,
                            Rating = @Rating,
                            Remarks = @Remarks,
                            ReviewDate = @ReviewDate,
                            Email = @Email,
                            City = @City
                        WHERE ReviewId = @ReviewId;";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@Name", SqlDbType.NVarChar, 150
                        ).Value = txtName.Text.Trim();

                        cmd.Parameters.Add(
                            "@ContactNo", SqlDbType.NVarChar, 30
                        ).Value = string.IsNullOrWhiteSpace(txtContactNo.Text)
                            ? (object)DBNull.Value
                            : txtContactNo.Text.Trim();

                        cmd.Parameters.Add(
                            "@Rating", SqlDbType.Int
                        ).Value = rating;

                        cmd.Parameters.Add(
                            "@Remarks", SqlDbType.NVarChar, -1
                        ).Value = string.IsNullOrWhiteSpace(txtRemarks.Text)
                            ? (object)DBNull.Value
                            : txtRemarks.Text.Trim();

                        cmd.Parameters.Add(
                            "@ReviewDate", SqlDbType.DateTime
                        ).Value = reviewDateValue;

                        cmd.Parameters.Add(
                            "@Email", SqlDbType.NVarChar, 254
                        ).Value = string.IsNullOrWhiteSpace(txtEmail.Text)
                            ? (object)DBNull.Value
                            : txtEmail.Text.Trim();

                        cmd.Parameters.Add(
                            "@City", SqlDbType.NVarChar, 100
                        ).Value = string.IsNullOrWhiteSpace(txtCity.Text)
                            ? (object)DBNull.Value
                            : txtCity.Text.Trim();

                        cmd.Parameters.Add(
                            "@ReviewId", SqlDbType.Int
                        ).Value = reviewId;

                        con.Open();
                        rowsAffected = cmd.ExecuteNonQuery();
                    }
                }

                if (rowsAffected > 0)
                {
                    Response.Redirect(
                        ResolveUrl("~/ManageReviews.aspx?updated=1"),
                        false
                    );

                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    ShowMessage(
                        "Review not found. No changes were saved.",
                        true
                    );
                }
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to update review. Please check the database fields and data types.",
                    true
                );
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;

            lblMessage.ForeColor = isError
                ? System.Drawing.Color.Red
                : System.Drawing.Color.Green;
        }
    }
}
