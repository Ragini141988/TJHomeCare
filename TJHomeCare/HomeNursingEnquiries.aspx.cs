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
    public partial class HomeNursingEnquiries : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "hospi2yp_tabletjobssConnectionString_V02"
            ].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSummary();
                LoadEnquiries();
            }
        }
        // Summary Cards
        private void LoadSummary()
        {
            try
            {
                string query = @"
                    SELECT
                        COUNT(*) AS TotalEnquiries,

                        ISNULL(SUM(CASE
                            WHEN CAST(EnquiryDate AS DATE) = CAST(GETDATE() AS DATE)
                            THEN 1 ELSE 0
                        END), 0) AS TodayEnquiries,

                        ISNULL(SUM(CASE
                            WHEN EnquiryStatus = 'Pending'
                            THEN 1 ELSE 0
                        END), 0) AS PendingEnquiries

                    FROM [sqladmin].[HomeNursingEnquiries]";

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                lblTotal.Text =
                                    dr["TotalEnquiries"].ToString();

                                lblToday.Text =
                                    dr["TodayEnquiries"].ToString();

                                lblPending.Text =
                                    dr["PendingEnquiries"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Summary Error: " +
                    Server.HtmlEncode(ex.Message);
            }
        }
        // Enquiry Cards
        private void LoadEnquiries()
        {
            try
            {
                lblMessage.Text = "";

                string query = @"
                    SELECT
                        EnquiryID,
                        CustomerName,
                        MobileNumber,
                        City,
                        Area,
                        PatientAge,
                        PreferredStartDate,
                        NursingCareType,
                        DutyHours,
                        AdditionalRequirements,
                        IsPrivacyAccepted,
                        EnquiryStatus,
                        EnquiryDate

                    FROM [sqladmin].[HomeNursingEnquiries]

                    WHERE
                    (
                        @Search = ''
                        OR CustomerName LIKE '%' + @Search + '%'
                        OR MobileNumber LIKE '%' + @Search + '%'
                        OR Area LIKE '%' + @Search + '%'
                    )

                    AND
                    (
                        @City = ''
                        OR City = @City
                    )

                    AND
                    (
                        @Status = ''
                        OR EnquiryStatus = @Status
                    )

                    ORDER BY
                        CAST(EnquiryDate AS DATE) DESC,
                        EnquiryDate DESC,
                        EnquiryID DESC";

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@Search", SqlDbType.NVarChar, 150)
                            .Value = txtSearch.Text.Trim();

                        cmd.Parameters.Add(
                            "@City", SqlDbType.NVarChar, 50)
                            .Value = ddlFilterCity.SelectedValue;

                        cmd.Parameters.Add(
                            "@Status", SqlDbType.NVarChar, 30)
                            .Value = ddlFilterStatus.SelectedValue;

                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();

                            da.Fill(dt);

                            rptEnquiries.DataSource = dt;
                            rptEnquiries.DataBind();

                            lblShowing.Text = dt.Rows.Count.ToString();

                            pnlNoRecords.Visible =
                                dt.Rows.Count == 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Enquiry Loading Error: " +
                    Server.HtmlEncode(ex.Message);

                rptEnquiries.DataSource = null;
                rptEnquiries.DataBind();

                lblShowing.Text = "0";
                pnlNoRecords.Visible = true;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadEnquiries();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";

            ddlFilterCity.SelectedIndex = 0;
            ddlFilterStatus.SelectedIndex = 0;

            lblMessage.Text = "";

            LoadEnquiries();
        }
    }
}