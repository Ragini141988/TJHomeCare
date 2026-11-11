using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TJHomeCare
{
    public partial class Homenursinglandingpage : System.Web.UI.Page
    {
        private readonly string connectionString =
           ConfigurationManager.ConnectionStrings[
               "hospi2yp_tabletjobssConnectionString_V02"
           ].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

       

        private void ClearForm()
        {
            txtCustomerName.Text = "";
            txtMobile.Text = "";
            ddlCity.SelectedIndex = 0;
            txtArea.Text = "";
            txtPatientAge.Text = "";
            txtStartDate.Text = "";
            ddlNursingCare.SelectedIndex = 0;
            ddlDutyHours.SelectedIndex = 0;
            txtRequirements.Text = "";
            chkPrivacy.Checked = false;
        }

        protected void btnSubmitEnquiry_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            lblMessage.Text = "";
            lblMessage.ForeColor = System.Drawing.Color.Red;

            // Privacy Policy validation
            if (!chkPrivacy.Checked)
            {
                lblMessage.Text = "Please accept the Privacy Policy.";
                return;
            }

            string name = txtCustomerName.Text.Trim();
            string mobile = txtMobile.Text.Trim();
            string city = ddlCity.SelectedValue;
            string area = txtArea.Text.Trim();
            string nursingCare = ddlNursingCare.SelectedValue;
            string dutyHours = ddlDutyHours.SelectedValue;
            string requirements = txtRequirements.Text.Trim();

            // Validate mobile number
            if (!Regex.IsMatch(mobile, @"^[6-9]\d{9}$"))
            {
                lblMessage.Text = "Please enter a valid mobile number.";
                return;
            }

            // Validate patient age
            object patientAge = DBNull.Value;

            if (!string.IsNullOrWhiteSpace(txtPatientAge.Text))
            {
                int age;

                if (!int.TryParse(txtPatientAge.Text.Trim(), out age)
                    || age < 0 || age > 120)
                {
                    lblMessage.Text = "Please enter a valid patient age.";
                    return;
                }

                patientAge = age;
            }

            // Validate start date
            object startDate = DBNull.Value;

            if (!string.IsNullOrWhiteSpace(txtStartDate.Text))
            {
                DateTime selectedDate;

                if (!DateTime.TryParseExact(
                    txtStartDate.Text,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out selectedDate))
                {
                    lblMessage.Text = "Please select a valid start date.";
                    return;
                }

                startDate = selectedDate;
            }


            string query = @"
                INSERT INTO [sqladmin].[HomeNursingEnquiries]
                (
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
                )
                VALUES
                (
                    @CustomerName,
                    @MobileNumber,
                    @City,
                    @Area,
                    @PatientAge,
                    @PreferredStartDate,
                    @NursingCareType,
                    @DutyHours,
                    @AdditionalRequirements,
                    @IsPrivacyAccepted,
                    'Pending',
                    GETDATE()
                )";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add("@CustomerName",
                            SqlDbType.NVarChar, 150).Value = name;

                        cmd.Parameters.Add("@MobileNumber",
                            SqlDbType.NVarChar, 15).Value = mobile;

                        cmd.Parameters.Add("@City",
                            SqlDbType.NVarChar, 50).Value = city;

                        cmd.Parameters.Add("@Area",
                            SqlDbType.NVarChar, 150).Value = area;

                        cmd.Parameters.Add("@PatientAge",
                            SqlDbType.Int).Value = patientAge;

                        cmd.Parameters.Add("@PreferredStartDate",
                            SqlDbType.Date).Value = startDate;

                        cmd.Parameters.Add("@NursingCareType",
                            SqlDbType.NVarChar, 150).Value = nursingCare;

                        cmd.Parameters.Add("@DutyHours",
                            SqlDbType.NVarChar, 50).Value = dutyHours;

                        cmd.Parameters.Add("@AdditionalRequirements",
                            SqlDbType.NVarChar, 2000).Value =
                            string.IsNullOrWhiteSpace(requirements)
                            ? (object)DBNull.Value : requirements;

                        cmd.Parameters.Add("@IsPrivacyAccepted",
                            SqlDbType.Bit).Value = true;

                        con.Open();

                        cmd.ExecuteNonQuery();
                    }
                }

                lblMessage.ForeColor =
                    System.Drawing.Color.Green;

                lblMessage.Text =
                    "Thank you! Your nursing enquiry has been submitted successfully. Our team will contact you soon.";

                ClearForm();
                //alert script
                string script = @"
Swal.fire({
    icon: 'success',
    title: 'Enquiry Submitted!',
    html: 'Thank you for choosing <b>TJ Home Care</b>.<br/>Our team will contact you soon.',
    confirmButtonText: 'OK',
    confirmButtonColor: '#0d9488',
    allowOutsideClick: false
});";

                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
                    "EnquirySuccess",
                    script,
                    true
                );
                //close alert script
            }
            catch (Exception ex)
            {

                //lblMessage.ForeColor = System.Drawing.Color.Red;

                //lblMessage.Text = "Database Error: " + ex.Message;

                //System.Diagnostics.Trace.TraceError(
                //    "Home Nursing Enquiry Error: " + ex.ToString());
                System.Diagnostics.Trace.TraceError(
       "Home Nursing Enquiry Error: " + ex.ToString());

                string script = @"
    Swal.fire({
        icon: 'error',
        title: 'Submission Failed!',
        text: 'Something went wrong. Please try again later.',
        confirmButtonText: 'OK',
        confirmButtonColor: '#dc2626'
    });";

                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
                    "EnquiryError",
                    script,
                    true
                );
            }
        }
    }
}
 