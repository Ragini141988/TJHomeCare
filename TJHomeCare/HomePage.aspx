<%@ Page Title="TJ Home Care | Find Trusted Home Care Services" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="TJHomeCare.HomePage" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
/* ============================================================
   TJ HOME CARE - NEW HOME PAGE
   Homepage-only styles. Existing Site.master is not changed.
   ============================================================ */
.tj-page{--blue:#075bd3;--navy:#082f6f;--red:#ef1747;--green:#0aa66b;--orange:#f58b19;--purple:#7654d8;--yellow:#ffd62d;--text:#16355f;--muted:#65748c;--light:#f5f9ff;--border:#e2ebf5;background:#fff;color:var(--text);overflow:hidden}
.tj-page *{box-sizing:border-box}.tj-page a{text-decoration:none}.tj-container{width:min(1180px,calc(100% - 32px));margin:auto}
.tj-hero{padding:28px 0 0;background:linear-gradient(135deg,#f7fbff 0%,#eef7ff 58%,#fffdf2 100%)}
.tj-hero-top{display:grid;grid-template-columns:1.02fr .98fr;gap:30px;align-items:center;padding:20px 0 30px}.tj-hero-copy{text-align:left}.tj-pill{display:inline-flex;gap:8px;align-items:center;padding:8px 15px;border-radius:99px;background:var(--navy);color:#fff;font-size:12px;font-weight:800;margin-bottom:13px}.tj-hero h1{font-size:clamp(39px,5vw,62px);line-height:1.01;letter-spacing:-1.7px;margin:0;color:var(--navy);font-weight:900}.tj-hero h1 .b{color:var(--blue)}.tj-hero h1 .r{color:var(--red)}.tj-hero h1 .g{color:var(--green)}.tj-hero h2{font-size:22px;line-height:1.25;margin:13px 0 10px;color:var(--navy)}.tj-hero p{font-size:14px;line-height:1.7;color:var(--muted);max-width:620px;margin:0}.tj-actions{display:flex;flex-wrap:wrap;gap:10px;margin-top:19px}.tj-btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;
                                                                                                                                                                                                                                                 padding:11px 18px;border-radius:10px;font-size:13px;font-weight:800;transition:.2s}.tj-btn:hover{transform:translateY(-2px)}.tj-primary{background:linear-gradient(135deg,#075bd3,#0878ed);color:#fff;box-shadow:0 9px 22px rgba(7,91,211,.2)}.tj-outline{border:1px solid #d5e3f3;background:#fff;color:var(--navy)}
.tj-hero-art img{display:block;width:100%;border-radius:24px;box-shadow:0 18px 42px rgba(10,53,100,.14)}
.tj-hero-bottom{display:grid;grid-template-columns:repeat(5,1fr);border-top:1px solid #e1eaf5;background:#fff}.tj-trust{min-height:69px;padding:10px 7px;display:flex;align-items:center;justify-content:center;gap:8px;text-align:center;border-right:1px solid #e7eef7;font-size:12px;font-weight:800;color:var(--navy)}.tj-trust:last-child{border:0}.tj-trust i{font-size:21px}.green{color:var(--green)}.blue{color:var(--blue)}.red{color:var(--red)}.purple{color:var(--purple)}.orange{color:var(--orange)}
.tj-section{padding:20px 0}.tj-soft{background:linear-gradient(180deg,#f7fbff,#fff)}.tj-heading{text-align:center;max-width:760px;margin:0 auto 30px}.tj-kicker{font-size:11px;letter-spacing:1.3px;text-transform:uppercase;color:var(--blue);font-weight:900}.tj-heading h2{font-size:34px;line-height:1.15;color:var(--navy);margin:7px 0 8px;font-weight:900}.tj-heading p{font-size:14px;line-height:1.65;color:var(--muted);margin:0}
/* service row */
.tj-services{display:grid;grid-template-columns:repeat(4,1fr);gap:15px}.tj-service{position:relative;background:#fff;border:1px solid var(--border);border-radius:18px;overflow:hidden;box-shadow:0 7px 23px rgba(18,57,101,.06);transition:.2s}.tj-service:hover{transform:translateY(-4px);box-shadow:0 15px 30px rgba(18,57,101,.11)}.tj-service-top{height:100px;display:grid;place-items:center;background:linear-gradient(135deg,#edf6ff,#fff)}
.tj-service-body{padding:16px 15px 17px}.tj-service h3{font-size:16px;color:var(--navy);margin:0 0 6px}.tj-service p{font-size:12px;line-height:1.55;color:var(--muted);min-height:56px;margin:0}.tj-service a{display:inline-flex;gap:6px;align-items:center;margin-top:10px;color:var(--blue);font-size:11px;font-weight:900}
.tj-service-icon {
    width: 110px;
    height: 110px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    overflow: hidden;
}

.tj-service-icon img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}
/* How it works */
.tj-how{display:grid;grid-template-columns:1fr 1fr;gap:34px;align-items:center}.tj-how-img img{width:100%;display:block;border-radius:22px;box-shadow:0 15px 38px rgba(15,55,100,.14)}.tj-how-copy h2{font-size:34px;line-height:1.15;color:var(--navy);margin:7px 0 10px}.tj-how-copy>p{font-size:14px;line-height:1.7;color:var(--muted);margin:0 0 18px}.tj-steps{display:grid;gap:10px}.tj-step{display:grid;grid-template-columns:40px 1fr;gap:11px;padding:11px;border-radius:13px;background:#fff;border:1px solid var(--border)}.tj-step-no{width:40px;height:40px;display:grid;place-items:center;border-radius:11px;background:var(--blue);color:#fff;font-weight:900}.tj-step:nth-child(2) .tj-step-no{background:var(--purple)}.tj-step:nth-child(3) .tj-step-no{background:var(--green)}.tj-step:nth-child(4) .tj-step-no{background:var(--orange)}.tj-step:nth-child(5) .tj-step-no{background:var(--red)}.tj-step strong{display:block;font-size:13px;color:var(--navy);margin-top:2px}.tj-step span{display:block;font-size:11px;line-height:1.5;color:var(--muted);margin-top:3px}
/* action panels */
.tj-action-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}.tj-action{position:relative;min-height:270px;border-radius:22px;overflow:hidden;box-shadow:0 15px 36px rgba(10,50,90,.12);color:#fff}.tj-action img{width:100%;height:100%;min-height:270px;object-fit:cover;display:block}.tj-action:after{content:"";position:absolute;inset:0;background:linear-gradient(90deg,rgba(3,29,70,.9),rgba(3,29,70,.18))}.tj-action-content{position:absolute;z-index:2;left:25px;bottom:23px;max-width:450px}.tj-action-content .tj-kicker{color:#fff}.tj-action-content h3{font-size:25px;line-height:1.15;margin:5px 0 7px}.tj-action-content p{font-size:12px;line-height:1.6;margin:0;opacity:.93}.tj-action-btn{display:inline-flex;align-items:center;gap:7px;margin-top:13px;padding:9px 14px;border-radius:9px;background:#fff;color:var(--navy);font-size:11px;font-weight:900}
/* why */
.tj-why{display:grid;grid-template-columns:.85fr 1.15fr;gap:35px;align-items:center}.tj-why-img img{width:100%;max-height:440px;object-fit:cover;border-radius:22px;display:block;box-shadow:0 15px 38px rgba(15,55,100,.14)}.tj-why h2{font-size:34px;line-height:1.15;color:var(--navy);margin:7px 0 9px}.tj-why>div:last-child>p{font-size:14px;line-height:1.7;color:var(--muted);margin:0 0 17px}.tj-benefits{display:grid;grid-template-columns:1fr 1fr;gap:10px}.tj-benefit{display:flex;align-items:center;gap:9px;padding:11px;border:1px solid var(--border);border-radius:11px;background:#fff;font-size:12px;font-weight:700;color:var(--navy)}.tj-benefit i{color:var(--green)}
/* cities */
.tj-city-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}.tj-city{display:grid;grid-template-columns:150px 1fr;min-height:145px;border-radius:19px;overflow:hidden;background:#fff;border:1px solid var(--border);box-shadow:0 8px 25px rgba(15,55,100,.06)}.tj-city-icon{display:grid;place-items:center;background:linear-gradient(135deg,#e8f3ff,#fff5e9);font-size:48px;color:var(--blue)}.tj-city:nth-child(2) .tj-city-icon{color:var(--red)}.tj-city-copy{padding:20px}.tj-city h3{margin:0 0 6px;font-size:21px;color:var(--navy)}.tj-city p{font-size:12px;line-height:1.55;color:var(--muted);margin:0}.tj-city a{display:inline-flex;margin-top:10px;align-items:center;gap:6px;color:var(--blue);font-size:11px;font-weight:900}
/* stats */
.tj-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:0;border:1px solid var(--border);border-radius:18px;overflow:hidden;background:#fff;box-shadow:0 8px 24px rgba(15,55,100,.05)}.tj-stat{text-align:center;padding:20px 10px;border-right:1px solid var(--border)}.tj-stat:last-child{border:0}.tj-stat strong{display:block;font-size:27px;color:var(--navy)}.tj-stat span{display:block;font-size:11px;color:var(--muted);font-weight:700;margin-top:3px}
/* reviews */
.tj-reviews{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.tj-review{background:#fff;border:1px solid var(--border);border-radius:18px;padding:20px;box-shadow:0 8px 24px rgba(15,55,100,.05);position:relative}.tj-review:before{content:'“';position:absolute;right:17px;top:3px;color:#e8f0fb;font:70px Georgia}.tj-stars{color:#ffae00;letter-spacing:2px;font-size:12px}.tj-review p{font-size:12px;line-height:1.7;color:var(--muted);margin:12px 0 16px}.tj-user{display:flex;align-items:center;gap:9px}.tj-avatar{width:38px;height:38px;border-radius:50%;display:grid;place-items:center;background:linear-gradient(135deg,var(--blue),var(--purple));color:#fff;font-weight:900}.tj-user strong{display:block;font-size:12px;color:var(--navy)}.tj-user span{display:block;font-size:10px;color:var(--muted);margin-top:2px}
/* faq */
.tj-faq{display:grid;grid-template-columns:1fr 1fr;gap:10px}.tj-faq details{border:1px solid var(--border);border-radius:11px;background:#fff;padding:12px 14px}.tj-faq summary{cursor:pointer;font-size:12px;font-weight:800;color:var(--navy);list-style:none}.tj-faq summary::-webkit-details-marker{display:none}.tj-faq summary:after{content:'+';float:right;color:var(--blue);font-size:17px}.tj-faq details[open] summary:after{content:'−'}.tj-faq p{font-size:11px;line-height:1.6;color:var(--muted);margin:9px 0 0}
/* final CTA */
.tj-final{background:linear-gradient(120deg,#063d8e,#0871df);color:#fff;padding:45px 0}.tj-final-inner{display:flex;align-items:center;justify-content:space-between;gap:20px}.tj-final h2{font-size:32px;margin:0 0 6px}.tj-final p{margin:0;font-size:13px;opacity:.9}.tj-final .tj-btn{background:#fff;color:var(--navy)}
@media(max-width:1000px){.tj-hero-top,.tj-how,.tj-why{grid-template-columns:1fr}.tj-hero-copy{text-align:center}.tj-hero p{margin:auto}.tj-actions{justify-content:center}.tj-services{grid-template-columns:repeat(2,1fr)}.tj-hero-bottom{grid-template-columns:repeat(3,1fr)}.tj-trust:nth-child(3){border-right:0}.tj-trust:nth-child(4),.tj-trust:nth-child(5){border-top:1px solid #e7eef7}.tj-how-img,.tj-why-img{max-width:760px;margin:auto}.tj-final-inner{flex-direction:column;align-items:flex-start}}
@media(max-width:700px){.tj-container{width:calc(100% - 22px)}.tj-section{padding:48px 0}.tj-hero{padding-top:15px}.tj-hero h1{font-size:40px}.tj-heading h2,.tj-how-copy h2,.tj-why h2{font-size:28px}.tj-services,.tj-action-grid,.tj-city-grid,.tj-reviews,.tj-faq,.tj-benefits{grid-template-columns:1fr}.tj-hero-bottom{grid-template-columns:1fr 1fr}.tj-trust:nth-child(3),.tj-trust:nth-child(5){border-right:0}.tj-city{grid-template-columns:105px 1fr}.tj-stats{grid-template-columns:1fr 1fr}.tj-stat:nth-child(2){border-right:0}.tj-stat:nth-child(3),.tj-stat:nth-child(4){border-top:1px solid var(--border)}.tj-action-content{left:18px;right:15px}.tj-action-content h3{font-size:22px}.tj-final .tj-btn{width:100%}}
@media(max-width:430px){.tj-hero h1{font-size:35px}.tj-actions{flex-direction:column}.tj-actions .tj-btn{width:100%}.tj-hero-art img{border-radius:17px}.tj-city{grid-template-columns:1fr}.tj-city-icon{height:100px}.tj-stats strong{font-size:22px}}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="tj-page">

<!-- ========================================================= HERO ========================================================= -->
<section class="tj-hero">
    <div class="tj-container tj-hero-top">
        <div class="tj-hero-copy">
            <span class="tj-pill"><i class="fa-solid fa-house-medical"></i> India's Home Workforce Hiring Marketplace</span>
            <h1><span class="b">Find.</span> <span class="r">Interview.</span> <span class="g">Hire.</span><br />Trusted People for Your Home.</h1>
            <h2>Simple, reliable home care hiring for families.</h2>
            <p>Find suitable maids, cooks, drivers, baby care takers, patient care takers and home nurses through TJ Home Care. Explore profiles, interview candidates and choose the right person for your family's needs.</p>
            <div class="tj-actions">
                <a class="tj-btn tj-primary" href="<%= ResolveUrl("~/PostRequirement.aspx") %>"><i class="fa-solid fa-file-circle-plus"></i> Post Your Requirement</a>
                <a class="tj-btn tj-outline" href="<%= ResolveUrl("~/FindJobs.aspx") %>"><i class="fa-solid fa-magnifying-glass"></i> Find Jobs / Caregivers</a>
            </div>
        </div>
        <div class="tj-hero-art">
            <img src="<%= ResolveUrl("~/Images/baby-care-taker.png") %>" alt="TJ Home Care family and caregiver" />
        </div>
    </div>
    <div class="tj-hero-bottom tj-container">
        <div class="tj-trust"><i class="fa-solid fa-shield-heart green"></i> Verified Candidates</div>
        <div class="tj-trust"><i class="fa-solid fa-video blue"></i> Online Interviews</div>
        <div class="tj-trust"><i class="fa-solid fa-location-dot red"></i> Location-Based Matching</div>
        <div class="tj-trust"><i class="fa-solid fa-users purple"></i> Multiple Candidate Options</div>
        <div class="tj-trust"><i class="fa-solid fa-handshake orange"></i> Joining Assistance</div>
    </div>
</section>

    <!-- ========================================================= HOW IT WORKS ========================================================= -->
<section class="tj-section tj-soft">
    <div class="tj-container tj-how">
        <div class="tj-how-img"><img src="<%= ResolveUrl("~/Images/how tjhomecareworks.jpeg") %>" alt="How TJ Home Care works" /></div>
        <div class="tj-how-copy">
            <span class="tj-kicker">HOW TJ HOME CARE WORKS</span>
            <h2>From your requirement to the right person at home.</h2>
            <p>We keep the process simple so families can focus on choosing the right caregiver instead of managing a complicated hiring process.</p>
            <div class="tj-steps">
                <div class="tj-step"><div class="tj-step-no">1</div><div><strong>Post Your Requirement</strong><span>Tell us your service, location, timings and preferences.</span></div></div>
                <div class="tj-step"><div class="tj-step-no">2</div><div><strong>Our Team Understands Your Need</strong><span>We discuss your requirement and shortlist suitable candidates.</span></div></div>
                <div class="tj-step"><div class="tj-step-no">3</div><div><strong>We Share Suitable Profiles</strong><span>Review relevant candidate details based on your requirement.</span></div></div>
                <div class="tj-step"><div class="tj-step-no">4</div><div><strong>You Take the Interview</strong><span>Speak with the candidate online or as arranged.</span></div></div>
                <div class="tj-step"><div class="tj-step-no">5</div><div><strong>Caregiver Joins Your Home</strong><span>After confirmation, we assist with the joining process.</span></div></div>
            </div>
        </div>
    </div>
</section>
<!-- ========================================================= SERVICES ========================================================= -->
<section id="services" class="tj-section">
    <div class="tj-container">
        <div class="tj-heading">
            <span class="tj-kicker">OUR HOME CARE SERVICES</span>
            <h2>Choose the right support for your home</h2>
            <p>From baby care and patient care to cooking, housekeeping and home nursing, explore the type of support your family needs.</p>
        </div>
        <div class="tj-services">
            <article class="tj-service" style="--c:#ef2860">
                <div class="tj-service-top">
                    <div class="tj-service-icon">
    <img src="<%= ResolveUrl("~/Images/babycaretaker02.jpeg") %>"
         alt="Baby Care Takers" />
</div>
                                            </div>
                
                <div class="tj-service-body">
                    <h3>Baby Care Takers</h3><p>Support for newborns, babies and children with dependable day-to-day care.</p>
                    <a href="<%= ResolveUrl("~/FindJobs.aspx?service=Baby%20Care") %>">Find Baby Care <i class="fa-solid fa-arrow-right">
                </i></a></div>

            </article>
            <article class="tj-service" style="--c:#1688df">
                <div class="tj-service-top"><div class="tj-service-icon"> <img src="<%= ResolveUrl("~/Images/patientcaretaker02.jpeg") %>"
         alt="Patients Care Taker" /></div></div><div class="tj-service-body">
                    <h3>Patient Care Takers</h3><p>Personal assistance, mobility support and companionship for patients at home.</p>
                    <a href="<%= ResolveUrl("~/FindJobs.aspx?service=Patient%20Care") %>">Find Patient Care <i class="fa-solid fa-arrow-right"></i></a></div></article>

            <article class="tj-service" style="--c:#e13d67"><div class="tj-service-top"><div class="tj-service-icon">
                <img src="<%= ResolveUrl("~/Images/homenure02.jpeg") %>"  alt="Home Nurses" /></div></div>
                <div class="tj-service-body"><h3>Home Nurses</h3><p>Home nursing support for families who need professional care and supervision.</p>
                    <a href="<%= ResolveUrl("~/FindJobs.aspx?service=Home%20Nurse") %>">Find Home Nurse <i class="fa-solid fa-arrow-right"></i></a></div>

            </article>
            <article class="tj-service" style="--c:#0ba76c"><div class="tj-service-top"><div class="tj-service-icon">
                 <img src="<%= ResolveUrl("~/Images/maidservvices02.jpeg") %>"
         alt="Maid Service" /></div></div><div class="tj-service-body">
                    <h3>Maid Services</h3><p>Reliable household help for cleaning, daily routines and general assistance.</p>
                    <a href="<%= ResolveUrl("~/FindJobs.aspx?service=Maid") %>">Find a Maid <i class="fa-solid fa-arrow-right"></i></a></div></article>


            <article class="tj-service" style="--c:#f38a17"><div class="tj-service-top"><div class="tj-service-icon">
                 <img src="<%= ResolveUrl("~/Images/cookingservices02.jpeg") %>"
         alt="Cooking Services" /></div></div><div class="tj-service-body"><h3>Cooking Services</h3><p>Find cooks based on your family's food preferences, schedule and requirements.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?service=Cook") %>">Find a Cook <i class="fa-solid fa-arrow-right"></i></a></div></article>
            
            
            <article class="tj-service" style="--c:#7752d8"><div class="tj-service-top"><div class="tj-service-icon">
<img src="<%= ResolveUrl("~/Images/housekeeping02.jpeg") %>"
         alt="Housekeeping" />
 </div></div><div class="tj-service-body"><h3>Housekeeping</h3><p>Practical home support for cleaning, organization and everyday household tasks.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?service=Housekeeping") %>">View Housekeeping <i class="fa-solid fa-arrow-right"></i></a></div></article>
            
            
            <article class="tj-service" style="--c:#10a36a"><div class="tj-service-top"><div class="tj-service-icon">
                <img src="<%= ResolveUrl("~/Images/eldercare02.jpeg") %>"
         alt="Elder Care" />

           </div></div><div class="tj-service-body"><h3>Elder Care</h3><p>Compassionate assistance and companionship for senior family members at home.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?service=Elder%20Care") %>">View Elder Care <i class="fa-solid fa-arrow-right"></i></a></div></article>
            
            
            <article class="tj-service" style="--c:#e8b800"><div class="tj-service-top"><div class="tj-service-icon">
                <img src="<%= ResolveUrl("~/Images/generalhomesupport02.jpeg") %>"
         alt="General Home Support" /></div></div><div class="tj-service-body"><h3>General Home Support</h3><p>Flexible assistance for families with specific day-to-day home requirements.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?service=Home%20Support") %>">Explore Support <i class="fa-solid fa-arrow-right"></i></a></div></article>
        </div>
    </div>
</section>



<!-- ========================================================= TWO LINK AREAS ========================================================= -->
<section class="tj-section">
    <div class="tj-container">
        <div class="tj-heading"><span class="tj-kicker">GET STARTED</span><h2>Choose what you want to do</h2><p>We have kept the homepage simple. Detailed forms and listings open on their respective pages.</p></div>
        <div class="tj-action-grid">
            <a class="tj-action" href="<%= ResolveUrl("~/PostRequirement.aspx") %>">
                <img src="<%= ResolveUrl("~/Images/tjhomecare.jpeg") %>" alt="Post your home care requirement" />
                <div class="tj-action-content"><span class="tj-kicker">FOR FAMILIES</span><h3>Need someone for your home?</h3><p>Tell us what support you need. Continue to the requirement page and share your details with our team.</p><span class="tj-action-btn">Post Your Requirement <i class="fa-solid fa-arrow-right"></i></span></div>
            </a>
            <a class="tj-action" href="<%= ResolveUrl("~/FindJobs.aspx") %>">
                <img src="<%= ResolveUrl("~/Images/tjhomecare02.jpeg") %>" alt="Find home care jobs" />
                <div class="tj-action-content"><span class="tj-kicker">FOR CANDIDATES</span><h3>Looking for a home care job?</h3><p>Explore available opportunities, find suitable work and connect with families looking for support.</p><span class="tj-action-btn">Find Jobs <i class="fa-solid fa-arrow-right"></i></span></div>
            </a>
        </div>
    </div>
</section>

<!-- ========================================================= WHY CHOOSE ========================================================= -->
<section class="tj-section tj-soft">
    <div class="tj-container tj-why">
        <div class="tj-why-img"><img src="<%= ResolveUrl("~/Images/tjhomecare02.jpeg") %>" alt="Family speaking with TJ Home Care" /></div>
        <div>
            <span class="tj-kicker">WHY CHOOSE TJ HOME CARE?</span>
            <h2>Built around trust, choice and family comfort.</h2>
            <p>Finding the right person to care for your loved ones is an important decision. TJ Home Care gives families a simpler way to discover suitable options, speak with candidates and make an informed choice.</p>
            <div class="tj-benefits">
                <div class="tj-benefit"><i class="fa-solid fa-circle-check"></i> Verified candidate options</div>
                <div class="tj-benefit"><i class="fa-solid fa-video"></i> Online interview support</div>
                <div class="tj-benefit"><i class="fa-solid fa-location-dot"></i> Location-based matching</div>
                <div class="tj-benefit"><i class="fa-solid fa-users"></i> Multiple candidate choices</div>
                <div class="tj-benefit"><i class="fa-solid fa-clock"></i> Flexible requirements</div>
                <div class="tj-benefit"><i class="fa-solid fa-handshake"></i> Joining assistance</div>
            </div>
        </div>
    </div>
</section>

<!-- ========================================================= CITIES ========================================================= -->
<section class="tj-section">
    <div class="tj-container">
        <div class="tj-heading"><span class="tj-kicker">CURRENTLY SERVING</span><h2>Home care support in Bangalore &amp; Hyderabad</h2><p>Choose your city to explore suitable requirements and available home care opportunities.</p></div>
        <div class="tj-city-grid">
            <div class="tj-city"><div class="tj-city-icon"><i class="fa-solid fa-city"></i></div><div class="tj-city-copy"><h3>Bangalore</h3><p>Find suitable caregivers, maids, cooks, drivers, baby care takers, patient care takers and home nurses across Bangalore.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?city=Bangalore") %>">Explore Bangalore <i class="fa-solid fa-arrow-right"></i></a></div></div>
            <div class="tj-city"><div class="tj-city-icon"><i class="fa-solid fa-mosque"></i></div><div class="tj-city-copy"><h3>Hyderabad</h3><p>Post your requirement or explore suitable home care jobs and caregiver opportunities across Hyderabad.</p><a href="<%= ResolveUrl("~/FindJobs.aspx?city=Hyderabad") %>">Explore Hyderabad <i class="fa-solid fa-arrow-right"></i></a></div></div>
        </div>
    </div>
</section>

<!-- ========================================================= STATS ========================================================= -->
<section class="tj-section tj-soft">
    <div class="tj-container">
        <div class="tj-stats">
            <div class="tj-stat"><strong>10,000+</strong><span>Verified Candidate Profiles</span></div>
            <div class="tj-stat"><strong>500+</strong><span>Requirements Every Month</span></div>
            <div class="tj-stat"><strong>50+</strong><span>Areas Covered</span></div>
            <div class="tj-stat"><strong>30 Days</strong><span>Replacement Assistance</span></div>
        </div>
    </div>
</section>

<!-- ========================================================= REVIEWS ========================================================= -->
<section class="tj-section">
    <div class="tj-container">
        <div class="tj-heading"><span class="tj-kicker">WHAT FAMILIES SAY</span><h2>Real families. Real experiences.</h2><p>Testimonials are hard-coded for now. Later this section can be connected directly to your review database.</p></div>
        <div class="tj-reviews">
            <article class="tj-review"><div class="tj-stars">★★★★★</div><p>“We found a suitable baby care taker through TJ Home Care. The online process was simple and the team helped us understand the options.”</p><div class="tj-user"><div class="tj-avatar">P</div><div><strong>Priya S.</strong><span>Electronic City, Bangalore</span></div></div></article>
            <article class="tj-review"><div class="tj-stars">★★★★★</div><p>“The team helped us shortlist multiple candidates for patient care and explained the interview process clearly. Good experience.”</p><div class="tj-user"><div class="tj-avatar">R</div><div><strong>Rajesh K.</strong><span>HSR Layout, Bangalore</span></div></div></article>
            <article class="tj-review"><div class="tj-stars">★★★★★</div><p>“We needed caring support for an elderly family member. Having different candidate options made the decision easier for us.”</p><div class="tj-user"><div class="tj-avatar">S</div><div><strong>Sunitha M.</strong><span>Miyapur, Hyderabad</span></div></div></article>
        </div>
    </div>
</section>

<!-- ========================================================= FAQ ========================================================= -->
<section class="tj-section tj-soft">
    <div class="tj-container">
        <div class="tj-heading"><span class="tj-kicker">FREQUENTLY ASKED QUESTIONS</span><h2>Questions families often ask</h2><p>We can later move these questions to a database or CMS if required.</p></div>
        <div class="tj-faq">
            <details><summary>How do I find a caregiver through TJ Home Care?</summary><p>Post your requirement with the service, city and preferences. Our team can help you identify suitable candidates and proceed with interviews.</p></details>
            <details><summary>Can I interview a candidate before hiring?</summary><p>Yes. The hiring process can include an online or arranged interview so you can speak with the candidate before making a decision.</p></details>
            <details><summary>Are candidates verified?</summary><p>TJ Home Care is designed around verified candidate options. The exact verification details can be displayed on the candidate profile and service pages.</p></details>
            <details><summary>Which cities are currently available?</summary><p>The current homepage highlights Bangalore and Hyderabad. More cities can be added later without changing the overall design.</p></details>
            <details><summary>Can I choose the working hours?</summary><p>Requirements can include your preferred schedule, such as day, night, 12-hour, 24-hour or live-in support, depending on availability.</p></details>
            <details><summary>Does TJ Home Care provide joining assistance?</summary><p>Yes. Joining assistance can be part of the service process after the family selects a suitable candidate.</p></details>
        </div>
    </div>
</section>

<!-- ========================================================= FINAL CTA ========================================================= -->
<section class="tj-final">
    <div class="tj-container tj-final-inner">
        <div><h2>Need someone for your home?</h2><p>Post your requirement today and take the first step toward finding suitable home care support.</p></div>
        <a class="tj-btn" href="<%= ResolveUrl("~/PostRequirement.aspx") %>">Post Your Requirement <i class="fa-solid fa-arrow-right"></i></a>
    </div>
</section>

</div>
</asp:Content>
