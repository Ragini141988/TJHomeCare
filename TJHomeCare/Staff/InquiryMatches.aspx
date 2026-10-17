<%@ Page Title="Inquiry Matches | TJ Home Care" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="InquiryMatches.aspx.cs" Inherits="TJHomeCare.Staff.InquiryMatches" %>
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

.im-match-list {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
    margin: 18px 0;
}

.im-caregiver-card {
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 18px;
    min-width: 0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.im-card-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 10px;
    flex-wrap: wrap;
}

.im-caregiver-name {
    font-size: 18px;
    font-weight: 700;
    color: #183153;
    overflow-wrap: anywhere;
}

.im-service {
    display: inline-block;
    margin-top: 8px;
    padding: 5px 10px;
    border-radius: 20px;
    background: #eef5ff;
    color: #2458a6;
    font-size: 13px;
}

.im-details {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 14px;
    margin-top: 18px;
}

.im-details > div {
    display: flex;
    flex-direction: column;
    gap: 4px;
    overflow-wrap: anywhere;
}

.im-label {
    font-size: 12px;
    color: #64748b;
}

.im-selected-badge {
    display: inline-block;
    padding: 5px 9px;
    border-radius: 6px;
    background: #fff0b3;
    color: #795500;
    font-size: 11px;
    font-weight: 700;
}

.im-caregiver-card.im-selected {
    background: #fffaf0;
    border: 2px solid #d99a00;
    box-shadow: 0 3px 12px rgba(217, 154, 0, 0.12);
}

.im-empty {
    padding: 24px;
    text-align: center;
    color: #64748b;
}

#dpMatches {
    display: block;
    margin: 20px 0;
    text-align: center;
}

@media (max-width: 600px) {
    .im-match-list {
        grid-template-columns: 1fr;
        gap: 12px;
    }

    .im-caregiver-card {
        padding: 14px;
    }

    .im-details {
        grid-template-columns: 1fr 1fr;
        gap: 12px;
    }

    .im-caregiver-name {
        font-size: 17px;
    }
}

.im-nearby-actions {
    margin: 18px 0;
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

.im-nearby-actions .care-btn {
    min-height: 44px;
}

@media (max-width: 600px) {
    .im-nearby-actions .care-btn {
        width: 100%;
        box-sizing: border-box;
    }
}
</style></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<section class="care-page">
    <h1>Relevant Caregiver Matches</h1>
    <p class="care-lead">Candidates are ranked using service-category and city/area matches.</p>
    <asp:Label ID="lblInquiry" runat="server" CssClass="care-note" />
    <asp:Label ID="lblMessage" runat="server" CssClass="care-message" />
  <%--  New Button--%>
    
<div class="im-nearby-actions">
    <asp:Button ID="btnNearbyAreas"
        runat="server"
        Text="Search Nearby Areas"
        CssClass="care-btn"
        Onclick="btnNearbyAreas_Click" CausesValidation="false" Visible="false" />
</div>

  <%--  Close Button--%>
    <div class="care-table-wrap">
       
<asp:ListView ID="lvMatches" runat="server"
    OnPagePropertiesChanging="lvMatches_PagePropertiesChanging"
    OnItemDataBound="lvMatches_ItemDataBound">

    <LayoutTemplate>
        <div class="im-match-list">
            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
        </div>
    </LayoutTemplate>

    <ItemTemplate>
        <article class="im-caregiver-card"
            runat="server" id="caregiverCard">

            <div class="im-card-header">
                <div class="im-caregiver-name">
                    <%#: Eval("FullName") %>
                </div>

                <asp:Label ID="lblSelected" runat="server"
                    CssClass="im-selected-badge"
                    Visible="false"
                    Text="★ Originally Selected" />
            </div>

            <div class="im-service">
                <%#: Eval("ServiceCategory") %>
            </div>

            <div class="im-details">
                <div>
                    <span class="im-label">City</span>
                    <span><%#: Eval("City") %></span>
                </div>

                <div>
                    <span class="im-label">Area</span>
                    <span><%#: Eval("PresentArea") %></span>
                </div>

                <div>
                    <span class="im-label">Location match</span>
                    <span><%#: Eval("LocationMatch") %></span>
                </div>

                <div>
                    <span class="im-label">Experience</span>
                    <span><%#: Eval("Experience") %></span>
                </div>

                <div>
                    <span class="im-label">Languages</span>
                    <span><%#: Eval("LanguagesKnown") %></span>
                </div>

                <div>
                    <span class="im-label">Availability</span>
                    <span><%#: Eval("JoiningAvailability") %></span>
                </div>
            </div>

        </article>
    </ItemTemplate>

    <EmptyDataTemplate>
        <div class="im-empty">
            No active caregivers found for this service.
        </div>
    </EmptyDataTemplate>

</asp:ListView>

<asp:DataPager ID="dpMatches" runat="server"
    PagedControlID="lvMatches" PageSize="10">

    <Fields>
        <asp:NextPreviousPagerField
            ShowFirstPageButton="true"
            ShowPreviousPageButton="true"
            ShowNextPageButton="false"
            ShowLastPageButton="false"
            ButtonType="Button"
            FirstPageText="First"
            PreviousPageText="Previous" />

        <asp:NumericPagerField ButtonCount="5" />

        <asp:NextPreviousPagerField
            ShowFirstPageButton="false"
            ShowPreviousPageButton="false"
            ShowNextPageButton="true"
            ShowLastPageButton="true"
            ButtonType="Button"
            NextPageText="Next"
            LastPageText="Last" />
    </Fields>

</asp:DataPager>

    </div>
    <p><asp:HyperLink ID="hlnkBack" runat="server" CssClass="care-btn care-btn-light" Text="Back to Inquiries" /></p>
</section>
</asp:Content>
