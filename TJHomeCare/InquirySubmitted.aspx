<%@ Page Title="Inquiry Submitted | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="InquirySubmitted.aspx.cs" Inherits="TJHomeCare.InquirySubmitted" %>
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
    <div class="care-note">
        <h1>Thank you for your inquiry</h1>
        <p>Your inquiry has been submitted. The TJ Home Care team can review your request and follow up.</p>
        <a class="care-btn" href="<%= ResolveUrl("~/Candidates.aspx") %>">Browse Candidates</a>
        <a class="care-btn care-btn-light" href="<%= ResolveUrl("~/Default.aspx") %>">Go to Home</a>
    </div>
</section>
</asp:Content>
