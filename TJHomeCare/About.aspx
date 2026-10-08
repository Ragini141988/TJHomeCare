<%@ Page Title="About Us - TJ Homecare" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="TJHomeCare.About" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<section class="inner-hero about-hero">
  <div class="container">
    <span class="eyebrow">ABOUT US</span>
    <h1>About TJ Homecare</h1>
    <p>Trusted Home Care Services in Bangalore</p>
  </div>
</section>

<section class="section">
  <div class="container about-grid">
    <div class="about-image"><div class="about-image-placeholder"><i class="fa-solid fa-house-medical"></i><strong>TJ HOMECARE</strong><span>Compassionate care at home</span></div></div>
    <div>
      <span class="eyebrow">WHO WE ARE</span>
      <h2>Trusted Home Care Services in Bangalore</h2>
      <p>We understand that every person has different care requirements. Whether your loved one needs elderly care, patient care, bedridden patient care, post-hospitalization care, home nursing support, or newborn care, our team provides personalized care based on individual needs.</p>
    </div>
  </div>
</section>

<section class="section about-light">
  <div class="container">
    <div class="section-heading"><span class="eyebrow">OUR APPROACH</span><h2>Reliable Caregivers for Your Loved Ones</h2></div>
    <div class="content-card">
      <p>Finding a dependable caregiver for your family member can be challenging. At TJ Homecare, we focus on providing trained and verified caregivers in Bangalore who understand the importance of responsible and compassionate care.</p>
      <p>Our caregivers assist with day-to-day activities and provide the required support to seniors, patients, bedridden individuals, and families looking for professional home care assistance.</p>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-heading"><span class="eyebrow">FLEXIBLE SUPPORT</span><h2>Personalized Home Care Support</h2><p>Every family has different care needs. That's why TJ Homecare offers flexible home care solutions designed around the requirements of each client.</p></div>
    <div class="about-services-grid">
      <div class="about-service-item"><i class="fa-solid fa-person-cane"></i><span>Elderly Care at Home</span></div>
      <div class="about-service-item"><i class="fa-solid fa-bed-pulse"></i><span>Bedridden Patient Care</span></div>
      <div class="about-service-item"><i class="fa-solid fa-hospital"></i><span>Post-Hospitalization Care</span></div>
      <div class="about-service-item"><i class="fa-solid fa-user-nurse"></i><span>Patient Attendant Services</span></div>
      <div class="about-service-item"><i class="fa-solid fa-house-medical"></i><span>Home Nursing Support</span></div>
      <div class="about-service-item"><i class="fa-solid fa-baby"></i><span>Newborn and Baby Care</span></div>
      <div class="about-service-item"><i class="fa-solid fa-users"></i><span>Male and Female Caregivers</span></div>
      <div class="about-service-item"><i class="fa-solid fa-clock"></i><span>10-Hour and 24-Hour Care</span></div>
      <div class="about-service-item"><i class="fa-solid fa-user-check"></i><span>Caregiver Replacement Support</span></div>
    </div>
  </div>
</section>

<section class="mission-section">
  <div class="container mission-grid">
    <div class="mission-card"><div class="mission-icon"><i class="fa-solid fa-bullseye"></i></div><h3>Our Mission</h3><p>Our mission is to provide compassionate, professional, and dependable home care services in Bangalore that support the well-being and quality of life of individuals while giving families greater peace of mind.</p></div>
    <div class="mission-card"><div class="mission-icon"><i class="fa-solid fa-eye"></i></div><h3>Our Vision</h3><p>Our vision is to become a trusted home care service provider in Bangalore, recognized for quality care, trained caregivers, professionalism, reliability, and a compassionate approach to every family we serve.</p></div>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-heading"><span class="eyebrow">WHY CHOOSE US?</span><h2>Why Choose TJ Homecare?</h2><p>Choosing the right home care provider is an important decision. At TJ Homecare, we focus on dependable, personalized and compassionate support.</p></div>
    <div class="why-about-grid">
      <div class="why-point"><i class="fa-solid fa-user-shield"></i><div><h3>Trained &amp; Verified Caregivers</h3><p>Responsible and compassionate caregiver support.</p></div></div>
      <div class="why-point"><i class="fa-solid fa-heart"></i><div><h3>Compassionate Care</h3><p>Care based on comfort, dignity and individual needs.</p></div></div>
      <div class="why-point"><i class="fa-solid fa-sliders"></i><div><h3>Flexible Care Options</h3><p>Solutions designed around different family requirements.</p></div></div>
      <div class="why-point"><i class="fa-solid fa-arrows-rotate"></i><div><h3>Caregiver Replacement Support</h3><p>Support when a replacement caregiver arrangement is required.</p></div></div>
    </div>
  </div>
</section>

<section class="cta-section"><div class="container cta-inner"><div><span class="eyebrow">HOME CARE SERVICES YOU CAN DEPEND ON</span><h2>Talk to TJ Homecare about your family's care requirements.</h2></div><a class="btn btn-light" href="<%= ResolveUrl("~/Contact.aspx") %>">Contact Us <i class="fa-solid fa-arrow-right"></i></a></div></section>

</asp:Content>