<%@ Page Title="Staff Inquiries | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Inquiries.aspx.cs" Inherits="TJHomeCare.Staff.Inquiries" %>
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

.care-inquiry-list {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
    margin: 16px 0;
}

.care-inquiry-card {
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 18px;
    min-width: 0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.care-inquiry-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 16px;
}

.care-inquiry-id {
    font-size: 17px;
    font-weight: 700;
    color: #183153;
}

.care-inquiry-status {
    background: #eef5ff;
    color: #2458a6;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.care-inquiry-details {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 14px;
}

.care-inquiry-field {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 0;
    overflow-wrap: anywhere;
}

.care-inquiry-label {
    color: #64748b;
    font-size: 12px;
}

.care-inquiry-email {
    overflow-wrap: anywhere;
}

.care-inquiry-actions {
    margin-top: 18px;
    padding-top: 14px;
    border-top: 1px solid #edf0f4;
}

.care-find-matches {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    color: #2458a6;
    border: 1px solid #2458a6;
    border-radius: 7px;
    padding: 10px 16px;
    text-decoration: none;
    font-weight: 600;
}

.care-find-matches:hover {
    background: #2458a6;
    color: #fff;
}

.care-inquiry-empty {
    padding: 24px;
    text-align: center;
    color: #64748b;
}

@media (max-width: 650px) {
    .care-inquiry-list {
        grid-template-columns: 1fr;
        gap: 12px;
    }

    .care-inquiry-card {
        padding: 15px;
    }

    .care-inquiry-details {
        grid-template-columns: 1fr 1fr;
        gap: 12px;
    }

    .care-find-matches {
        width: 100%;
        box-sizing: border-box;
    }
}

</style></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<section class="care-page">
    <h1>Caregiver Inquiries</h1>
    <p class="care-lead">Staff view of incoming inquiries. This page requires an authenticated staff session.</p>
    <asp:Label ID="lblMessage" runat="server" CssClass="care-message" />
    <div class="care-table-wrap">
       
<asp:ListView ID="lvInquiries" runat="server"
    DataKeyNames="InquiryID"
    OnItemCommand="lvInquiries_ItemCommand">

    <LayoutTemplate>
        <div class="care-inquiry-list">
            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
        </div>
    </LayoutTemplate>

    <ItemTemplate>
        <article class="care-inquiry-card">

            <div class="care-inquiry-header">
                <span class="care-inquiry-id">
                    Inquiry #<%#: Eval("InquiryID") %>
                </span>

                <span class="care-inquiry-status">
                    <%#: Eval("InquiryStatus") %>
                </span>
            </div>

            <div class="care-inquiry-details">

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Received</span>
                    <span>
                        <%#: Eval("CreatedDate", "{0:dd MMM yyyy HH:mm}") %>
                    </span>
                </div>

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Family name</span>
                    <span><%#: Eval("FullName") %></span>
                </div>

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Contact</span>
                    <span><%#: Eval("ContactNumber") %></span>
                </div>

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Email</span>
                    <span class="care-inquiry-email"><%#: Eval("Email") %></span>
                </div>

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Family city</span>
                    <span><%#: Eval("City") %></span>
                </div>

                <div class="care-inquiry-field">
                    <span class="care-inquiry-label">Selected caregiver</span>
                    <span><%#: Eval("SelectedCandidate") %></span>
                </div>

            </div>

            <div class="care-inquiry-actions">
                <asp:LinkButton ID="lnkFindMatches" runat="server"
                    CssClass="care-find-matches"
                    CommandName="Matches"
                    CommandArgument='<%# Eval("InquiryID") %>'
                    CausesValidation="false">
                    Find Matches
                </asp:LinkButton>
            </div>

        </article>
    </ItemTemplate>

    <EmptyDataTemplate>
        <div class="care-inquiry-empty">
            No inquiries found.
        </div>
    </EmptyDataTemplate>

</asp:ListView>

    </div>
</section>
</asp:Content>
