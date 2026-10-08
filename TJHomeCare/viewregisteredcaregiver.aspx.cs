using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class viewregisteredcaregiver : Page
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
                LoadFilters();
                BindCaregivers();
            }
        }


        // =========================================================
        // LOAD FILTERS
        // =========================================================

        private void LoadFilters()
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();


                // =====================================================
                // SERVICE CATEGORY
                // =====================================================

                //string serviceSql = @"
                //    SELECT DISTINCT ServiceCategory
                //    FROM [sqladmin].[CaregiverProfiles]
                //    WHERE ServiceCategory IS NOT NULL
                //      AND LTRIM(RTRIM(ServiceCategory)) <> ''
                //    ORDER BY ServiceCategory";


                //using (SqlCommand cmd =
                //    new SqlCommand(serviceSql, con))
                //{
                //    using (SqlDataReader reader =
                //        cmd.ExecuteReader())
                //    {
                //        while (reader.Read())
                //        {
                //            string value =
                //                reader["ServiceCategory"].ToString();

                //            ddlServiceCategory.Items.Add(
                //                new ListItem(value, value));
                //        }
                //    }
                //}


                // =====================================================
                // CITY
                // =====================================================

                string citySql = @"
                    SELECT DISTINCT City
                    FROM [sqladmin].[CaregiverProfiles]
                    WHERE City IS NOT NULL
                      AND LTRIM(RTRIM(City)) <> ''
                    ORDER BY City";


                using (SqlCommand cmd =
                    new SqlCommand(citySql, con))
                {
                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string value =
                                reader["City"].ToString();

                            ddlCity.Items.Add(
                                new ListItem(value, value));
                        }
                    }
                }


                // =====================================================
                // RECRUITER
                // =====================================================

                string recruiterSql = @"
                    SELECT DISTINCT RecruiterName
                    FROM [sqladmin].[CaregiverProfiles]
                    WHERE RecruiterName IS NOT NULL
                      AND LTRIM(RTRIM(RecruiterName)) <> ''
                    ORDER BY RecruiterName";


                using (SqlCommand cmd =
                    new SqlCommand(recruiterSql, con))
                {
                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string value =
                                reader["RecruiterName"].ToString();

                            ddlRecruiter.Items.Add(
                                new ListItem(value, value));
                        }
                    }
                }
            }
        }


        // =========================================================
        // BIND CAREGIVERS
        // =========================================================

        private void BindCaregivers()
        {
            StringBuilder sql =
                new StringBuilder();

            sql.Append(@"
                SELECT
                    CaregiverID,
                    RecruiterName,
                    ServiceCategory,
                    FullName,
                    Age,
                    Gender,
                    City,
                    Experience,
                    DutyPreference,
                    VerificationStatus,
                    CreatedDate,
                    ProfilePhoto
                FROM [sqladmin].[CaregiverProfiles]
                WHERE 1 = 1
            ");


            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                using (SqlCommand cmd =
                    new SqlCommand())
                {
                    cmd.Connection = con;


                    // =================================================
                    // SERVICE CATEGORY
                    // =================================================

                    if (!string.IsNullOrWhiteSpace(
                        ddlServiceCategory.SelectedValue))
                    {
                        sql.Append(@"
    AND (
        ',' + ServiceCategory + ',' LIKE
        '%' + @ServiceCategory + '%'
    )");

                        cmd.Parameters.Add(
                            "@ServiceCategory",
                            SqlDbType.NVarChar,
                            100)
                            .Value =
                            ddlServiceCategory.SelectedValue;
                    }


                    // =================================================
                    // CITY
                    // =================================================

                    if (!string.IsNullOrWhiteSpace(
                        ddlCity.SelectedValue))
                    {
                        sql.Append(@"
                            AND City =
                                @City");

                        cmd.Parameters.Add(
                            "@City",
                            SqlDbType.NVarChar,
                            100)
                            .Value =
                            ddlCity.SelectedValue;
                    }


                    // =================================================
                    // RECRUITER
                    // =================================================

                    if (!string.IsNullOrWhiteSpace(
                        ddlRecruiter.SelectedValue))
                    {
                        sql.Append(@"
                            AND RecruiterName =
                                @RecruiterName");

                        cmd.Parameters.Add(
                            "@RecruiterName",
                            SqlDbType.NVarChar,
                            100)
                            .Value =
                            ddlRecruiter.SelectedValue;
                    }


                    // =================================================
                    // FROM DATE
                    // =================================================

                    DateTime fromDate;

                    if (DateTime.TryParse(
                        txtFromDate.Text,
                        out fromDate))
                    {
                        sql.Append(@"
                            AND CreatedDate >= @FromDate");

                        cmd.Parameters.Add(
                            "@FromDate",
                            SqlDbType.DateTime)
                            .Value =
                            fromDate.Date;
                    }


                    // =================================================
                    // TO DATE
                    // =================================================

                    DateTime toDate;

                    if (DateTime.TryParse(
                        txtToDate.Text,
                        out toDate))
                    {
                        sql.Append(@"
                            AND CreatedDate <
                                DATEADD(DAY, 1, @ToDate)");

                        cmd.Parameters.Add(
                            "@ToDate",
                            SqlDbType.DateTime)
                            .Value =
                            toDate.Date;
                    }


                    // =================================================
                    // ORDER
                    // =================================================

                    sql.Append(@"
                        ORDER BY CreatedDate DESC,
                                 CaregiverID DESC");


                    cmd.CommandText =
                        sql.ToString();


                    DataTable dt =
                        new DataTable();


                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }


                    lvCaregivers.DataSource =
                        dt;

                    lvCaregivers.DataBind();
                }
            }
        }


        // =========================================================
        // SEARCH
        // =========================================================

        protected void btnSearch_Click(
            object sender,
            EventArgs e)
        {
            BindCaregivers();
        }


        // =========================================================
        // CLEAR FILTERS
        // =========================================================

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ddlServiceCategory.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            ddlRecruiter.SelectedIndex = 0;

            txtFromDate.Text = "";
            txtToDate.Text = "";

            BindCaregivers();
        }


        // =========================================================
        // PAGINATION
        // =========================================================

        protected void lvCaregivers_PagePropertiesChanging(
            object sender,
            PagePropertiesChangingEventArgs e)
        {
            dpCaregivers.SetPageProperties(
                e.StartRowIndex,
                e.MaximumRows,
                false);

            BindCaregivers();
        }


        // =========================================================
        // AADHAR IMAGE
        // =========================================================

        protected string GetAadharImage(
            object dataItem)
        {
            DataRowView row =
                dataItem as DataRowView;

            if (row == null)
                return "";


            if (row["ProfilePhoto"] == DBNull.Value)
                return "";


            byte[] imageBytes =
                (byte[])row["ProfilePhoto"];


            if (imageBytes == null ||
                imageBytes.Length == 0)
                return "";


            string base64 =
                Convert.ToBase64String(
                    imageBytes);


            return
                "data:image/jpeg;base64," +
                base64;
        }


        // =========================================================
        // STATUS CLASS
        // =========================================================

        protected string GetStatusClass(
            object statusObject)
        {
            string status =
                Convert.ToString(
                    statusObject);


            if (string.IsNullOrWhiteSpace(status))
                return "status";


            switch (status.Trim().ToLower())
            {
                case "verified":
                    return "status status-verified";

                case "rejected":
                    return "status status-rejected";

                case "pending":
                    return "status status-pending";

                default:
                    return "status";
            }
        }
    }
}