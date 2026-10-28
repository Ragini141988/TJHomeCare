<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewPostedRequirement.aspx.cs" Inherits="TJHomeCare.ViewPostedRequirement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        * =========================================================
   RECENT REQUIREMENTS
   ========================================================= */

.tj-recent-requirements {
    padding: 10px 0;
    background: #f7faff;
}

.tj-recent-requirements .tj-container {
    width: min(1180px, calc(100% - 32px));
    margin: 0 auto;
}
.tj-recent-caregiver {
    padding: 10px 0;
    background: #f7faff;
}

.tj-recent-caregiver .tj-container {
    width: min(1180px, calc(100% - 32px));
    margin: 0 auto;
}

.tj-section-heading {
    text-align: center;
    max-width: 720px;
    margin: 0 auto 35px;
}

.tj-section-kicker {
    display: inline-block;
    margin-bottom: 8px;
    color: #0756c9;
    font-size: 12px;
    font-weight: 900;
    letter-spacing: 1.2px;
    text-transform: uppercase;
}

.tj-section-heading h2 {
    margin: 0;
    color: #092f6d;
    font-size: 36px;
    font-weight: 900;
}

.tj-section-heading p {
    margin: 10px auto 0;
    color: #65758e;
    font-size: 15px;
    line-height: 1.7;
}


/* GRID */

.tj-requirements-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}


/* CARD */

.tj-requirement-card {
    position: relative;
    padding: 20px;
    background: #ffffff;
    border: 1px solid #e2eaf4;
    border-radius: 18px;
    box-shadow: 0 8px 25px rgba(20, 60, 110, 0.06);
    transition: all .2s ease;
}

.tj-requirement-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 16px 35px rgba(20, 60, 110, 0.12);
}


/* caregiverGRID */

.tj-caregiver-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}


/* CARD */

.tj-caregiver-card {
    position: relative;
    padding: 20px;
    background: #ffffff;
    border: 1px solid #e2eaf4;
    border-radius: 18px;
    box-shadow: 0 8px 25px rgba(20, 60, 110, 0.06);
    transition: all .2s ease;
}

.tj-caregiver-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 16px 35px rgba(20, 60, 110, 0.12);
}


/* TOP */

.tj-requirement-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 18px;
}

.tj-requirement-badge {
    padding: 5px 9px;
    border-radius: 6px;
    font-size: 10px;
    font-weight: 900;
    letter-spacing: .4px;
}

.tj-new {
    color: #087a52;
    background: #dcf8ec;
}

.tj-urgent {
    color: #c82043;
    background: #ffe2e8;
}

.tj-posted-time {
    color: #8996a9;
    font-size: 11px;
}


/* SERVICE */

.tj-requirement-service {
    display: flex;
    align-items: center;
    gap: 13px;
    margin-bottom: 20px;
}

.tj-requirement-icon {
    width: 52px;
    height: 52px;
    flex-shrink: 0;
    display: grid;
    place-items: center;
    border-radius: 14px;
    color: #fff;
    font-size: 20px;
}

.tj-requirement-icon.baby {
    background: linear-gradient(135deg, #ef2860, #ff6b91);
}

.tj-requirement-icon.elder {
    background: linear-gradient(135deg, #7652d8, #9b7bed);
}

.tj-requirement-icon.patient {
    background: linear-gradient(135deg, #1687df, #49a9f4);
}

.tj-requirement-icon.maid {
    background: linear-gradient(135deg, #10a66c, #35c98e);
}

.tj-requirement-icon.cook {
    background: linear-gradient(135deg, #f28b17, #ffb33d);
}

.tj-requirement-icon.nurse {
    background: linear-gradient(135deg, #e53a64, #f36d8c);
}

.tj-requirement-service h3 {
    margin: 0 0 4px;
    color: #092f6d;
    font-size: 17px;
    font-weight: 800;
}

.tj-requirement-service span {
    color: #7b889b;
    font-size: 12px;
}


/* DETAILS */

.tj-requirement-details {
    display: grid;
    gap: 9px;
    padding: 15px 0;
    border-top: 1px solid #edf1f6;
    border-bottom: 1px solid #edf1f6;
}

.tj-requirement-details div {
    display: flex;
    align-items: center;
    gap: 9px;
    color: #53647c;
    font-size: 12px;
}

.tj-requirement-details i {
    width: 16px;
    color: #0756c9;
    text-align: center;
}


/* VIEW BUTTON */

.tj-view-requirement {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 15px;
    color: #0756c9;
    font-size: 13px;
    font-weight: 800;
}

.tj-view-requirement i {
    transition: transform .2s ease;
}

.tj-view-requirement:hover i {
    transform: translateX(4px);
}


/* VIEW ALL */

.tj-requirements-footer {
    margin-top: 30px;
    text-align: center;
}

.tj-view-all-requirements {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    padding: 12px 22px;
    border: 1px solid #0756c9;
    border-radius: 10px;
    color: #0756c9;
    background: #fff;
    font-size: 13px;
    font-weight: 800;
    transition: .2s ease;
}

.tj-view-all-requirements:hover {
    color: #fff;
    background: #0756c9;
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
     <section class="tj-recent-requirements">
    <div class="tj-container">

        <div class="tj-section-heading">
            <span class="tj-section-kicker">LATEST REQUIREMENTS</span>
            <h2>Recent Home Care Requirements</h2>
            <p>
                Explore the latest requirements posted by families looking
                for reliable home care professionals.
            </p>
        </div>

       <div class="tj-requirements-grid">

    <%--<asp:Repeater ID="rptRecentRequirements"
        runat="server">--%>
           <asp:Repeater ID="rptRecentRequirements"
    runat="server"
    OnItemCommand="rptRecentRequirements_ItemCommand">

        <ItemTemplate>
            <div class="tj-requirement-card">

                <div class="tj-requirement-top">
                    <span class="tj-requirement-badge tj-new"
                        runat="server"
                        visible='<%# IsNewRequirement(Eval("CreatedDate")) %>'>
                        NEW
                    </span>

                    <span class="tj-posted-time">
                        <%# GetPostedTime(Eval("CreatedDate")) %>
                    </span>
                </div>

                <div class="tj-requirement-service">

                    <div class='tj-requirement-icon <%# GetServiceClass(Eval("Service")) %>'>
                        <i class='<%# GetServiceIcon(Eval("Service")) %>'></i>
                    </div>

                    <div>
                        <h3><%#: Eval("Service") %></h3>
                        <span><%#: Eval("Service") %></span>
                    </div>

                </div>

                <div class="tj-requirement-details">

                    <div>
                        <i class="fa-solid fa-location-dot"></i>
                        <span>
                            <%#: Eval("City") %>
                            <%# HasValue(Eval("Area"))
                                ? " · " + Server.HtmlEncode(Convert.ToString(Eval("Area")))
                                : "" %>
                        </span>
                    </div>

                    <div>
                        <i class="fa-solid fa-clock"></i>
                        <span><%#: DisplayValue(Eval("DutyTime")) %></span>
                    </div>

                    <div>
                        <i class="fa-solid fa-indian-rupee-sign"></i>
                        <span><%#: DisplayValue(Eval("Budget")) %></span>
                    </div>

                </div>

             <%-- <a class="tj-view-requirement"
   href='<%# ResolveUrl("~/RequirementDetails.aspx?id=" +
       Eval("RequirementID")) %>'>
    View Requirement
    <i class="fa-solid fa-arrow-right"></i>
</a>--%>
        <div style="display:flex; align-items:center; gap:30px; flex-wrap:nowrap;">

    <a class="tj-view-requirement"
       href='<%# ResolveUrl("~/RequirementDetails.aspx?id=" + Eval("RequirementID")) %>'>
        View Requirement
        <i class="fa-solid fa-arrow-right"></i>
    </a>

    <a class="tj-view-requirement"
       href='<%# ResolveUrl("~/EditRequirements.aspx?id=" + Eval("RequirementID")) %>'>
        Edit
        <i class="fa-solid fa-pen-to-square"></i>
    </a>

    <asp:LinkButton ID="lnkDeleteRequirement"
    runat="server"
    CssClass="tj-view-requirement"
    CommandName="DeleteRequirement"
    CommandArgument='<%# Eval("RequirementID") %>'
    OnClientClick="return confirm('Are you sure you want to delete this requirement?');">
    Delete <i class="fa-solid fa-trash"></i>
</asp:LinkButton>

</div>       
            </div>
        </ItemTemplate>

    </asp:Repeater>

</div>
<div class="care-pagination">
        <asp:Button ID="btnPrevious" runat="server" Text="Previous" CssClass="care-btn care-btn-light" OnClick="PreviousPage" />
        <asp:Label ID="lblPage" runat="server" />
        <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="care-btn care-btn-light" OnClick="NextPage" />
    </div>

    

    </div>
</section>
</asp:Content>
