<%@ Page Title="Professional Home Care Services in Bangalore" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TJHomeCare._Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<section class="hero-section">
    <div class="container hero-grid">
        <div class="hero-copy">
            <span class="eyebrow"><i class="fa-solid fa-house-medical"></i> TRUSTED HOME CARE</span>
            <h1>Professional Home Care Services in <span>Bangalore</span></h1>
            <h2>Compassionate Care at the Comfort of Your Home</h2>
            <p>
                Welcome to TJ Homecare, your trusted partner for professional home care services in Bangalore.
                We provide trained and verified Caregivers, Patient Attendants, Home Nurses, and Baby Caregivers
                to support your loved ones with compassionate and reliable care.
            </p>
            <p>
                Whether you need elderly care, patient care after hospitalization, or newborn care, our experienced
                caregivers are here to provide personalized support tailored to your family's needs.
            </p>
            <div class="hero-actions">
                <a class="btn btn-primary" href="tel:+919999999999"><i class="fa-solid fa-phone"></i> Call Now</a>
                <a class="btn btn-outline" href="#services">View Services</a>
            </div>
        </div>

        <div class="hero-visual">
 <div class="hero-image-placeholder">
    <img src="<%= ResolveUrl("~/Images/baby-care-taker.png") %>"
         alt="TJ Homecare Baby Care"
         class="hero-image" />
</div>
            <div class="floating-card">
                <i class="fa-solid fa-circle-check"></i>
                <div><strong>Trusted Care</strong><span>Trained & Verified Caregivers</span></div>
            </div>
        </div>
    </div>
</section>

<section id="services" class="section services-section">
    <div class="container">
        <div class="section-heading">
            <span class="eyebrow">OUR SERVICES</span>
            <h2>Professional Home Care Services</h2>
            <p>Trusted and compassionate care services for your loved ones, provided in the comfort and safety of your home across Bangalore.</p>
        </div>

        <div class="service-grid">
            <article class="service-card">
                <div class="service-number">01</div><div class="service-icon"><i class="fa-solid fa-hands-helping"></i></div>
                <h3>Caretakers</h3>
                <p>Reliable and compassionate caretakers to assist individuals with their daily activities and personal care needs.</p>
                <ul><li>Personal assistance</li><li>Daily routine support</li><li>Hygiene assistance</li><li>Companionship</li></ul>
            </article>

            <article class="service-card">
                <div class="service-number">02</div><div class="service-icon"><i class="fa-solid fa-person-cane"></i></div>
                <h3>Elderly Care</h3>
                <p>Dedicated support for senior citizens to help them live comfortably and safely at home.</p>
                <ul><li>Daily activity assistance</li><li>Mobility support</li><li>Meal assistance</li><li>Companionship and supervision</li></ul>
            </article>

            <article class="service-card">
                <div class="service-number">03</div><div class="service-icon"><i class="fa-solid fa-baby"></i></div>
                <h3>Baby Care Services</h3>
                <p>Caring and experienced baby caregivers to provide professional support for newborns and babies.</p>
                <ul><li>Newborn care</li><li>Feeding assistance</li><li>Bathing and hygiene</li><li>Diaper changing</li></ul>
            </article>

            <article class="service-card">
                <div class="service-number">04</div><div class="service-icon"><i class="fa-solid fa-bed-pulse"></i></div>
                <h3>Patient Care</h3>
                <p>Compassionate assistance for patients who need additional support during their recovery and daily routines.</p>
                <ul><li>Bedridden patient care</li><li>Personal care assistance</li><li>Mobility support</li><li>Recovery assistance</li></ul>
            </article>

            <article class="service-card">
                <div class="service-number">05</div><div class="service-icon"><i class="fa-solid fa-user-nurse"></i></div>
                <h3>Home Nursing Support</h3>
                <p>Professional home nursing support for individuals who require care and assistance at home.</p>
                <ul><li>Basic nursing assistance</li><li>Health monitoring</li><li>Post-hospitalization support</li><li>Recovery care</li></ul>
            </article>

            <article class="service-card">
                <div class="service-number">06</div><div class="service-icon"><i class="fa-solid fa-clock"></i></div>
                <h3>12-Hour &amp; 24-Hour Care</h3>
                <p>Flexible care options designed around your family's requirements and preferred care schedule.</p>
                <ul><li>12-hour day or night care</li><li>24-hour continuous support</li><li>Live-in caregiver arrangements</li><li>Replacement support</li></ul>
            </article>
        </div>
    </div>
</section>

<section class="cta-section">
    <div class="container cta-inner">
        <div>
            <span class="eyebrow">NEED RELIABLE CARE AT HOME?</span>
            <h2>Talk to TJ Homecare and find the right care solution for your family.</h2>
        </div>
        <a class="btn btn-light" href="<%= ResolveUrl("~/Contact.aspx") %>">Contact TJ Homecare <i class="fa-solid fa-arrow-right"></i></a>
    </div>
</section>

<section class="section why-section">
    <div class="container why-grid">
        <div class="why-visual">
            <div class="why-placeholder"><i class="fa-solid fa-heart"></i><span>TJ HOMECARE</span></div>
        </div>
        <div>
            <span class="eyebrow">WHY CHOOSE TJ HOMECARE?</span>
            <h2>Care built around comfort, safety and trust.</h2>
            <p>We provide reliable, compassionate and professional home care services designed around the comfort, safety and individual needs of your loved ones.</p>
            <div class="benefit-list">
                <div><i class="fa-solid fa-check"></i> Trained &amp; Verified Caregivers</div>
                <div><i class="fa-solid fa-check"></i> Professional and Compassionate Service</div>
                <div><i class="fa-solid fa-check"></i> Flexible 10-Hour &amp; 24-Hour Care</div>
                <div><i class="fa-solid fa-check"></i> Female Caregivers Available</div>
                <div><i class="fa-solid fa-check"></i> Personalized Care Plans</div>
                <div><i class="fa-solid fa-check"></i> Quick Replacement Support</div>
                <div><i class="fa-solid fa-check"></i> Reliable Home Care Across Bangalore</div>
            </div>
        </div>
    </div>
</section>

<section class="final-call">
    <div class="container">
        <h2>Need Home Care Today?</h2>
        <p>Our team is ready to help you find the right caregiver for your family's needs.</p>
        <a class="btn btn-primary" href="tel:+919999999999"><i class="fa-solid fa-phone"></i> Call Now</a>
    </div>
</section>

</asp:Content>
