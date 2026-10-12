<%@ Page Title="Candidate Details | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="CandidateDetails.aspx.cs" Inherits="TJHomeCare.CandidateDetails" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server"><style>
.care-page{max-width:1180px;margin:0 auto;padding:34px 16px 55px;color:#16355f}
.care-page h1{color:#082f6f;margin:0 0 10px;font-size:clamp(28px,4vw,38px)}
.care-lead{color:#65748c;line-height:1.7;margin:0 0 24px}
.care-filters{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;margin:24px 0}
.care-filters select,.care-filters input,.care-form input,.care-form select,.care-form textarea{width:100%;box-sizing:border-box;padding:12px;border:1px solid #d9e2ef;border-radius:8px;background:#fff;font:inherit}
.care-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px}
.care-card{min-width:0;overflow:hidden;border:1px solid #e2eaf4;border-radius:14px;background:#fff;box-shadow:0 7px 22px rgba(20,60,110,.06)}
.care-photo{width:100%;height:210px;object-fit:cover;display:block;background:#eef5ff}
.care-photo-placeholder{height:210px;display:grid;place-items:center;background:#eef5ff;color:#0756c9;font-size:48px}
.care-card-body{padding:17px}
.care-card h2,.care-card h3{font-size:18px;color:#092f6d;margin:0 0 9px}
.care-meta{font-size:13px;line-height:1.8;color:#53647c;overflow-wrap:anywhere}
.care-actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:15px}
.care-btn{display:inline-flex;justify-content:center;align-items:center;gap:7px;padding:11px 14px;border-radius:8px;border:1px solid #0756c9;background:#0756c9;color:#fff;text-decoration:none;font-weight:800;font-size:13px;cursor:pointer}
.care-btn:hover{opacity:.9;color:#fff}
.care-btn-light{background:#fff;color:#0756c9}
.care-form{max-width:700px;display:grid;gap:14px}
.care-form label{display:grid;gap:6px;font-size:13px;font-weight:700;color:#16355f}
.care-message{display:block;margin:12px 0;color:#a11;font-weight:700}
.care-table-wrap{width:100%;overflow-x:auto}
.care-table{width:100%;border-collapse:collapse;background:#fff}
.care-table th,.care-table td{padding:11px;border-bottom:1px solid #e2eaf4;text-align:left;vertical-align:top;font-size:13px}
.care-table th{background:#f2f7ff;color:#092f6d}
.care-pagination{display:flex;gap:8px;flex-wrap:wrap;margin-top:20px}
.care-note{padding:14px;border-radius:10px;background:#f2f7ff;color:#28466d;line-height:1.6}
@media(max-width:850px){.care-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:600px){.care-grid,.care-filters{grid-template-columns:1fr}.care-actions .care-btn{flex:1 1 100%}.care-photo,.care-photo-placeholder{height:230px}.care-table{min-width:760px}}
</style></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<section class="care-page">
    <asp:Panel ID="pnlProfile" runat="server" Visible="false">
        <div class="care-card">
            <asp:Image ID="imgPhoto" runat="server" CssClass="care-photo" AlternateText="Caregiver profile photo" Visible="false" />
            <div class="care-card-body">
                <h1><asp:Literal ID="litName" runat="server" /></h1>
                <div class="care-meta">
                    <div><b>Service category:</b> <asp:Literal ID="litService" runat="server" /></div>
                    <div><b>Age:</b> <asp:Literal ID="litAge" runat="server" /></div>
                    <div><b>Gender:</b> <asp:Literal ID="litGender" runat="server" /></div>
                    <div><b>City:</b> <asp:Literal ID="litCity" runat="server" /></div>
                    <div><b>Area:</b> <asp:Literal ID="litArea" runat="server" /></div>
                    <div><b>Languages:</b> <asp:Literal ID="litLanguages" runat="server" /></div>
                    <div><b>Qualification:</b> <asp:Literal ID="litQualification" runat="server" /></div>
                    <div><b>Experience:</b> <asp:Literal ID="litExperience" runat="server" /></div>
                    <div><b>Duty preference:</b> <asp:Literal ID="litDuty" runat="server" /></div>
                    <div><b>Expected salary:</b> <asp:Literal ID="litSalary" runat="server" /></div>
                    <div><b>Preferred work areas:</b> <asp:Literal ID="litWorkAreas" runat="server" /></div>
                    <div><b>Joining availability:</b> <asp:Literal ID="litAvailability" runat="server" /></div>
                </div>
                <p class="care-note">For privacy, contact details and identity documents are not displayed publicly. Send an inquiry if you would like the team to assist.</p>
                <div class="care-actions">
                    <asp:HyperLink ID="lnkInquiry" runat="server" CssClass="care-btn" Text="Send Inquiry" />
                    <a class="care-btn care-btn-light" href="<%= ResolveUrl("~/Candidates.aspx") %>">Back to Candidates</a>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Label ID="lblMessage" runat="server" CssClass="care-message" />
</section>
</asp:Content>
