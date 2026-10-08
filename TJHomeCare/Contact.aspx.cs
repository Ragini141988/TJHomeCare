using System;

namespace TJHomeCare
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text) || string.IsNullOrWhiteSpace(txtPhone.Text))
            {
                lblMessage.Text = "Please enter your name and phone number.";
                lblMessage.CssClass = "form-message error";
                return;
            }
            lblMessage.Text = "Thank you. Your enquiry has been received. We will contact you soon.";
            lblMessage.CssClass = "form-message success";
            txtName.Text = ""; txtPhone.Text = ""; txtEmail.Text = ""; txtMessage.Text = ""; ddlService.SelectedIndex = 0;
        }
    }
}
