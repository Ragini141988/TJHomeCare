<%@ Page Title="Posted Requirements | TJ Home Care" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PostedRequirements.aspx.cs" Inherits="TJHomeCare.Staff.PostedRequirements" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .pr-page{max-width:1180px;margin:0 auto;padding:34px 16px 55px;color:#16355f}
        .pr-page h1{color:#082f6f;margin:0 0 10px;font-size:clamp(28px,4vw,38px)}
        .pr-lead{color:#65748c;line-height:1.7;margin:0 0 24px}
        .pr-message{display:block;margin:12px 0;color:#a11;font-weight:700}
        .pr-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
        .pr-card{border:1px solid #e2eaf4;border-radius:14px;background:#fff;padding:18px;box-shadow:0 7px 22px rgba(20,60,110,.06);min-width:0}
        .pr-card h2{font-size:19px;color:#092f6d;margin:0 0 8px;overflow-wrap:anywhere}
        .pr-service{display:inline-block;padding:5px 10px;border-radius:20px;background:#eef5ff;color:#2458a6;font-size:13px;margin-bottom:12px}
        .pr-details{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;margin-top:8px}
        .pr-detail{min-width:0;overflow-wrap:anywhere;font-size:14px;color:#334155;line-height:1.5}
        .pr-label{display:block;color:#64748b;font-size:12px;margin-bottom:3px}
        .pr-actions{margin-top:16px}
        .pr-btn{display:inline-flex;justify-content:center;align-items:center;padding:11px 15px;border-radius:8px;border:1px solid #0756c9;background:#0756c9;color:#fff;text-decoration:none;font-weight:800;font-size:13px}
        .pr-btn:hover{opacity:.9;color:#fff}
        .pr-empty{padding:24px;text-align:center;color:#64748b;background:#f8fafc;border-radius:10px}
        .pr-pager{display:flex;gap:7px;justify-content:center;align-items:center;flex-wrap:wrap;margin-top:22px}
        .pr-pager a,.pr-pager span{display:inline-block;padding:8px 12px;border:1px solid #d9e2ef;border-radius:7px;text-decoration:none;color:#0756c9;background:#fff}
        .pr-pager span{background:#0756c9;color:#fff;border-color:#0756c9}
        .pr-back{display:inline-block;margin-top:22px;color:#0756c9;text-decoration:none}
        @media(max-width:700px){.pr-grid{grid-template-columns:1fr}.pr-details{grid-template-columns:1fr 1fr}}
        @media(max-width:420px){.pr-details{grid-template-columns:1fr}.pr-btn{width:100%;box-sizing:border-box}}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="pr-page">
        <h1>Posted Home Care Requirements</h1>
        <p class="pr-lead">Review submitted requirements and find active caregivers who match each family's service and location needs.</p>

        <asp:Label ID="lblMessage" runat="server" CssClass="pr-message" EnableViewState="false" />

        <asp:ListView ID="lvRequirements" runat="server"
            OnPagePropertiesChanging="lvRequirements_PagePropertiesChanging">
            <LayoutTemplate>
                <div class="pr-grid">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                </div>
                <asp:DataPager ID="dpRequirements" runat="server" PageSize="10" CssClass="pr-pager">
                    <Fields>
                        <asp:NextPreviousPagerField ShowFirstPageButton="true" ShowPreviousPageButton="true"
                            ShowNextPageButton="false" ShowLastPageButton="false" ButtonType="Link"
                            FirstPageText="First" PreviousPageText="Previous" />
                        <asp:NumericPagerField ButtonCount="5" />
                        <asp:NextPreviousPagerField ShowFirstPageButton="false" ShowPreviousPageButton="false"
                            ShowNextPageButton="true" ShowLastPageButton="true" ButtonType="Link"
                            NextPageText="Next" LastPageText="Last" />
                    </Fields>
                </asp:DataPager>
            </LayoutTemplate>
            <ItemTemplate>
                <article class="pr-card">
                   <h2>Requirement #<%#: Eval("RequirementID") %> - <%#: Eval("FullName") %></h2>
                    <div class="pr-service"><%#: Eval("Service") %></div>
                    <div class="pr-details">
                        <div class="pr-detail"><span class="pr-label">City</span><%#: Eval("City") %></div>
                        <div class="pr-detail"><span class="pr-label">Area / Locality</span><%#: Eval("RequirementArea") %></div>
                        <div class="pr-detail"><span class="pr-label">Duty time</span><%#: Eval("DutyTime") %></div>
                        <div class="pr-detail"><span class="pr-label">Preferred language</span><%#: Eval("PreferredLanguage") %></div>
                        <div class="pr-detail"><span class="pr-label">Budget</span><%#: Eval("Budget") %></div>
                        <div class="pr-detail"><span class="pr-label">Joining date</span><%# Eval("JoiningDate", "{0:dd MMM yyyy}") %></div>
                        <div class="pr-detail"><span class="pr-label">Mobile</span><%#: Eval("MobileNumber") %></div>
                        <div class="pr-detail"><span class="pr-label">WhatsApp</span><%#: Eval("WhatsAppNumber") %></div>
                    </div>
                    <div class="pr-actions">
                        <asp:HyperLink ID="lnkFindMatch" runat="server" CssClass="pr-btn"
                            NavigateUrl='<%# "~/Staff/InquiryMatches.aspx?requirementId=" + Eval("RequirementID") %>'
                            Text="Find Match" />
                    </div>
                </article>
            </ItemTemplate>
            <EmptyDataTemplate>
                <div class="pr-empty">No posted requirements were found.</div>
            </EmptyDataTemplate>
        </asp:ListView>

        <a class="pr-back" href="<%= ResolveUrl("~/HomePage.aspx") %>">Back to Home</a>
    </section>
</asp:Content>
