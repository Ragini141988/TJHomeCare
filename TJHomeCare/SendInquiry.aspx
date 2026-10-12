<%@ Page Title="Send Inquiry | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="SendInquiry.aspx.cs" Inherits="TJHomeCare.SendInquiry" %>
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
.btn-submit {
            background: #198754;
            color: white;
            border: none;
            border-radius: 7px;
            padding: 12px 30px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: #157347;
        }
</style></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<section class="care-page">
    <h1>Send a Caregiver Inquiry</h1>
    <p class="care-lead">Share your contact details. Our team can follow up about the selected caregiver.</p>
    <asp:Panel ID="pnlInquiry" runat="server">
        <div class="care-note"><b>Selected candidate:</b> <asp:Literal ID="litCandidate" runat="server" /></div>
        <asp:Label ID="lblMessage" runat="server" CssClass="care-message" />
        
              <div class="form-group">
                    <label class="form-label">Full Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required." CssClass="validation" Display="Dynamic" />
                </div>
            <div class="form-group">
                    <label class="form-label">Contact Number <span class="required">*</span></label>
                    <asp:TextBox ID="txtContactNumber" runat="server" CssClass="form-control" MaxLength="10" TextMode="Phone"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContactNumber"
                        ErrorMessage="Contact number is required." CssClass="validation" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtContactNumber"
                        ValidationExpression="^[6-9][0-9]{9}$" ErrorMessage="Enter valid 10 digit mobile number."
                        CssClass="validation" Display="Dynamic" />
                </div>
           <div class="form-group">
                    <label class="form-label">Email Address <span class="optional-text">(Optional)</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                </div>
            <div class="form-group">
                    <label class="form-label">City <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- Select City --" Value="" />
                        <asp:ListItem>Bangalore</asp:ListItem>
                        <asp:ListItem>Hyderabad</asp:ListItem>
                        <asp:ListItem>Ranchi</asp:ListItem>
                        <asp:ListItem>Bokaro</asp:ListItem>
                        <asp:ListItem>Dhanbad</asp:ListItem>
                        <asp:ListItem>Asansol</asp:ListItem>
                        <asp:ListItem>Kolkata</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCity"
                        InitialValue="" ErrorMessage="Please select city." CssClass="validation" Display="Dynamic" />
                </div>
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Inquiry"  CssClass="btn-submit"   OnClick="btnSubmit_Click" />
       
    </asp:Panel>
</section>
</asp:Content>
