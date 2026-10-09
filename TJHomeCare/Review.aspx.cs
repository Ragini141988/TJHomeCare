using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace TJHomeCare
{
    public partial class Review : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveReview();

            Response.Redirect("ThankYou.aspx");

        }
        private void SaveReview()
        {
            string name = txtName.Text.Trim();
            string contact = txtContact.Text.Trim();
            string remarks = txtRemarks.Text.Trim();

            int rating = 0;

            if (rb1.Checked)
                rating = 1;
            else if (rb2.Checked)
                rating = 2;
            else if (rb3.Checked)
                rating = 3;
            else if (rb4.Checked)
                rating = 4;
            else if (rb5.Checked)
                rating = 5;

            string cs = ConfigurationManager
       .ConnectionStrings["hospi2yp_tabletjobssConnectionString_V02"]
       .ConnectionString;

            string query = @"INSERT INTO Reviews
                             (Name, ContactNo, Rating, Remarks)
                             VALUES
                             (@Name, @ContactNo, @Rating, @Remarks)";

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@ContactNo", contact);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Remarks",
                        string.IsNullOrEmpty(remarks)
                        ? (object)DBNull.Value
                        : remarks);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
