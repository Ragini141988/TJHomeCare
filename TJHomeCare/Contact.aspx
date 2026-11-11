<%@ Page Title="Contact Us - TJ Homecare" Language="C#" MasterPageFile="~/Site.master" 
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TJHomeCare.Contact" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
     <style>
.contact-section {
    padding: 20px;
    background: #f8f9fa;
    border-radius: 10px;
}

.office-details {
    margin-top: 20px;
    padding: 18px;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
}

.office-details h4 {
    color: #0d6efd;
    font-size: 18px;
    margin-bottom: 15px;
}

.office-details p {
    font-size: 14px;
    line-height: 1.8;
    color: #444;
    margin-bottom: 12px;
}

.office-details a {
    color: #0d6efd;
    text-decoration: none;
}
</Style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<section class="inner-hero contact-hero"><div class="container"><span class="eyebrow">GET IN TOUCH</span><h1>Contact Us</h1><p>We're here to help you find the right caregiver for your loved ones.</p></div></section>

<section class="section contact-section">
<div class="container contact-grid">
  <div class="contact-info">
    <span class="eyebrow">TJ HOMECARE</span><h2>Get in Touch</h2>
    <p>TJ Homecare provides trusted home care services in Bangalore and online dietician counselling and psychologist counselling. Contact us for home care support in Bangalore or online wellness consultations.</p>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div><div><strong>Service Locations</strong><span>Bangalore &amp; Hyderabad (online counselling available)</span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div><div><strong>Bangalore Address</strong><span>#102, RV Residency Krishna Reddy Layout,<br />GS Palya Electronic City,<br />Bangalore – 560100</span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div><div><strong>Hyderabad Address</strong><span>A13/03, North East Business Center<br />Errum Manzil, Khairtabad<br />Hyderabad – 500004</span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-phone"></i></div><div><strong>Hyderabad Phone</strong><span><a href="tel:+919704797476">9704797476</a><br /><a href="tel:+917989788410">7989788410</a></span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-phone"></i></div><div><strong>Call Us</strong><span><a href="tel:+918074660555">+91 8074660555</a><br /><a href="tel:+917013107986">+91 7013107986</a></span></div></div>
  

    

  <div class="office-details">
    <h4>TJ HOME CARE</h4>
    <p><strong>Operated by Sunshine Enterprises</strong></p>

    <h5>Principal Place of Business</h5>
    <p>
        <strong>Sunshine Enterprises</strong><br />
        D.No. 32-1, Mahendra Plots,<br />
        Gayatri Nagar,<br />
        Kavali - 524201,<br />
        SPSR Nellore District,<br />
        Andhra Pradesh, India.
    </p>

    <h5>Additional Place of Business</h5>
    <p>
        <strong>TJ Corporation</strong><br />
        Room No. 7 &amp; 8, First Floor,<br />
        D.No. 10-1-12, Ward No. 11,<br />
        Railway Road,<br />
        Kavali - 524201,<br />
        SPSR Nellore District,<br />
        Andhra Pradesh, India.
    </p>

    <h5>Contact Information</h5>

    <p>
        <i class="fa-solid fa-phone"></i>
        <strong>Phone:</strong>
        <a href="tel:+919059724821">+91 9059724821</a>
    </p>

    <p>
        <i class="fa-solid fa-envelope"></i>
        <strong>Email:</strong>
        <a href="mailto:care@tjhomecare.com">care@tjhomecare.com</a>
    </p>

    <p>
        <i class="fa-solid fa-globe"></i>
        <strong>Website:</strong>
        <a href="https://www.tjhomecare.com" target="_blank">
            www.tjhomecare.com
        </a>
    </p>

    <p>
        <i class="fa-solid fa-file-invoice"></i>
        <strong>GSTIN:</strong> 37ARRPM1229P3Z0
    </p>

    <div class="contact-section">
    <a class="btn btn-primary contact-call" href="tel:+917013107986" style="color:white;">
        <i class="fa-solid fa-phone"></i> Call TJ Home Care
    </a>
</div></div>

  <div class="contact-form-card">
    <span class="eyebrow">SEND AN ENQUIRY</span><h2>How can we help?</h2><p class="form-intro">Share your requirements and our team can contact you about the appropriate home care service.</p>
    <div class="form-row">
      <div class="form-group"><label>Name <span>*</span></label><asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your name"></asp:TextBox></div>
      <div class="form-group"><label>Phone <span>*</span></label><asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number"></asp:TextBox></div>
    </div>
    <div class="form-group"><label>Email</label><asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address"></asp:TextBox></div>
    <div class="form-group"><label>Service Required</label><asp:DropDownList ID="ddlService" runat="server" CssClass="form-control">
      <asp:ListItem Text="Select a service" Value=""></asp:ListItem><asp:ListItem Text="Elderly Care" Value="Elderly Care"></asp:ListItem><asp:ListItem Text="Patient Care" Value="Patient Care"></asp:ListItem><asp:ListItem Text="Bedridden Patient Care" Value="Bedridden Patient Care"></asp:ListItem><asp:ListItem Text="Post-Hospitalization Care" Value="Post-Hospitalization Care"></asp:ListItem><asp:ListItem Text="Home Nursing Support" Value="Home Nursing Support"></asp:ListItem><asp:ListItem Text="Newborn and Baby Care" Value="Newborn and Baby Care"></asp:ListItem><asp:ListItem Text="Caregiver" Value="Caregiver"></asp:ListItem><asp:ListItem Text="Online Dietician Counselling" Value="Online Dietician Counselling"></asp:ListItem><asp:ListItem Text="Online Psychologist Counselling &amp; Stress Management" Value="Online Psychologist Counselling & Stress Management"></asp:ListItem><asp:ListItem Text="Other" Value="Other"></asp:ListItem>
    </asp:DropDownList></div>
    <div class="form-group"><label>Message</label><asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Tell us about your care requirement"></asp:TextBox></div>
    <asp:Button ID="btnSubmit" runat="server" Text="Send Enquiry" CssClass="btn btn-primary form-submit" OnClick="btnSubmit_Click" />
    <asp:Label ID="lblMessage" runat="server" CssClass="form-message"></asp:Label>
  </div>
</div>
</section>

<section class="contact-bottom"><div class="container"><div class="contact-bottom-card"><i class="fa-solid fa-heart-pulse"></i><div><h3>Need care assistance?</h3><p>Call us directly at <a href="tel:+917013107986">+91 7013107986</a> or <a href="tel:+918074660555">+91 8074660555</a>.</p></div></div></div></section>

</asp:Content>