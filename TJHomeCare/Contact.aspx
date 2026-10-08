<%@ Page Title="Contact Us - TJ Homecare" Language="C#" MasterPageFile="~/Site.master" 
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TJHomeCare.Contact" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<section class="inner-hero contact-hero"><div class="container"><span class="eyebrow">GET IN TOUCH</span><h1>Contact Us</h1><p>We're here to help you find the right caregiver for your loved ones.</p></div></section>

<section class="section contact-section">
<div class="container contact-grid">
  <div class="contact-info">
    <span class="eyebrow">TJ HOMECARE</span><h2>Get in Touch</h2>
    <p>TJ Homecare provides trusted, compassionate home care services in Bangalore, including caregivers, patient care, baby care, and home nursing support.</p>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div><div><strong>Service Location</strong><span>Bangalore</span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div><div><strong>Address</strong><span>#102, RV Residency Krishna Reddy Layout,<br />GS Palya Electronic City,<br />Bangalore – 560100</span></div></div>
    <div class="contact-detail"><div class="contact-icon"><i class="fa-solid fa-phone"></i></div><div><strong>Call Us</strong><span><a href="tel:+918074660555">+91 8074660555</a><br /><a href="tel:+917013107986">+91 7013107986</a></span></div></div>
    <a class="btn btn-primary contact-call" href="tel:+917013107986"><i class="fa-solid fa-phone"></i> Call TJ Homecare</a>
  </div>

  <div class="contact-form-card">
    <span class="eyebrow">SEND AN ENQUIRY</span><h2>How can we help?</h2><p class="form-intro">Share your requirements and our team can contact you about the appropriate home care service.</p>
    <div class="form-row">
      <div class="form-group"><label>Name <span>*</span></label><asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your name"></asp:TextBox></div>
      <div class="form-group"><label>Phone <span>*</span></label><asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number"></asp:TextBox></div>
    </div>
    <div class="form-group"><label>Email</label><asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address"></asp:TextBox></div>
    <div class="form-group"><label>Service Required</label><asp:DropDownList ID="ddlService" runat="server" CssClass="form-control">
      <asp:ListItem Text="Select a service" Value=""></asp:ListItem><asp:ListItem Text="Elderly Care" Value="Elderly Care"></asp:ListItem><asp:ListItem Text="Patient Care" Value="Patient Care"></asp:ListItem><asp:ListItem Text="Bedridden Patient Care" Value="Bedridden Patient Care"></asp:ListItem><asp:ListItem Text="Post-Hospitalization Care" Value="Post-Hospitalization Care"></asp:ListItem><asp:ListItem Text="Home Nursing Support" Value="Home Nursing Support"></asp:ListItem><asp:ListItem Text="Newborn and Baby Care" Value="Newborn and Baby Care"></asp:ListItem><asp:ListItem Text="Caregiver" Value="Caregiver"></asp:ListItem><asp:ListItem Text="Other" Value="Other"></asp:ListItem>
    </asp:DropDownList></div>
    <div class="form-group"><label>Message</label><asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Tell us about your care requirement"></asp:TextBox></div>
    <asp:Button ID="btnSubmit" runat="server" Text="Send Enquiry" CssClass="btn btn-primary form-submit" OnClick="btnSubmit_Click" />
    <asp:Label ID="lblMessage" runat="server" CssClass="form-message"></asp:Label>
  </div>
</div>
</section>

<section class="contact-bottom"><div class="container"><div class="contact-bottom-card"><i class="fa-solid fa-heart-pulse"></i><div><h3>Need care assistance?</h3><p>Call us directly at <a href="tel:+917013107986">+91 7013107986</a> or <a href="tel:+918074660555">+91 8074660555</a>.</p></div></div></div></section>

</asp:Content>