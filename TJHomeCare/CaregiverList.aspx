<%@ Page Title="Caregiver Profiles" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="CaregiverList.aspx.cs" Inherits="TabletJobs.com.CaregiverList" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .cg-list-wrap{max-width:1200px;margin:25px auto;padding:0 14px 35px}
    .cg-card{background:#fff;border-radius:12px;padding:22px;box-shadow:0 3px 18px rgba(0,0,0,.08)}
    .cg-title{font-size:27px;font-weight:700;margin:0 0 6px;color:#183153}
    .cg-subtitle{color:#6b7280;margin-bottom:18px}
    .cg-toolbar{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:16px}
    .cg-search{padding:10px 12px;border:1px solid #ced4da;border-radius:7px;min-width:240px}
    .cg-btn{display:inline-block;border:0;border-radius:6px;padding:8px 12px;text-decoration:none;cursor:pointer;font-size:14px;margin:2px}
    .cg-view{background:#0d6efd;color:white}.cg-edit{background:#ffc107;color:#212529}.cg-save{background:#198754;color:white}
    .cg-cancel{background:#6c757d;color:white}.cg-delete{background:#dc3545;color:white}
    .cg-new{background:#198754;color:white;padding:10px 14px}
    .cg-table-wrap{overflow-x:auto}
    .cg-table{width:100%;border-collapse:collapse}
    .cg-table th,.cg-table td{padding:11px 10px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
    .cg-table th{background:#f3f6fa;color:#24364b;white-space:nowrap}
    .cg-input{width:100%;min-width:100px;padding:8px;border:1px solid #ced4da;border-radius:5px;box-sizing:border-box}
    .cg-message{display:block;padding:10px 12px;margin:12px 0;border-radius:6px;background:#e8f5e9;color:#146c43}
    .cg-error{background:#f8d7da;color:#842029}
    .cg-details{margin:18px 0;padding:16px;border:1px solid #cfe2ff;background:#f5f9ff;border-radius:8px}
    .cg-details h3{margin-top:0}.cg-detail-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px 20px}
    .cg-detail-item{overflow-wrap:anywhere}.cg-detail-item b{display:block;color:#475569;font-size:13px;margin-bottom:3px}
    .cg-pager{display:flex;justify-content:center;align-items:center;gap:8px;padding-top:18px;flex-wrap:wrap}
    .cg-pager a,.cg-pager span{padding:7px 11px;border:1px solid #d1d5db;border-radius:5px;text-decoration:none}
    .cg-pager span{background:#0d6efd;color:white;border-color:#0d6efd}
    .cg-empty{padding:20px;text-align:center;color:#6b7280}
    @media(max-width:700px){
      .cg-card{padding:14px}.cg-title{font-size:22px}.cg-toolbar{align-items:stretch}
      .cg-search{width:100%;min-width:0;box-sizing:border-box}
      .cg-table-wrap{overflow:visible}.cg-table,.cg-table tbody,.cg-table tr,.cg-table td{display:block;width:100%;box-sizing:border-box}
      .cg-table thead{display:none}
      .cg-table tr{border:1px solid #e5e7eb;border-radius:9px;margin-bottom:13px;padding:10px;background:#fff}
      .cg-table td{border:0;padding:5px 2px;overflow-wrap:anywhere}
      .cg-table td[data-label]::before{content:attr(data-label);display:block;font-size:12px;font-weight:700;color:#64748b;margin-bottom:2px}
      .cg-table td.cg-actions{padding-top:10px}
      .cg-detail-grid{grid-template-columns:1fr}
    }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="cg-list-wrap">
  <div class="cg-card">
    <h1 class="cg-title">Caregiver Profiles</h1>
    <div class="cg-subtitle">View, edit, or delete registered caregiver records.</div>

    <div class="cg-toolbar">
      <asp:TextBox ID="txtSearch" runat="server" CssClass="cg-search"
          placeholder="Search name, contact, city or recruiter" />
      <div>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="cg-btn cg-view" OnClick="btnSearch_Click" />
        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="cg-btn cg-cancel" OnClick="btnReset_Click" />
        <a class="cg-btn cg-new" href="<%= ResolveUrl("~/CaregiverRegistration.aspx") %>">+ New Registration</a>
      </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <asp:Panel ID="pnlDetails" runat="server" CssClass="cg-details" Visible="false">
      <h3>Caregiver Details</h3>
      <div class="cg-detail-grid">
        <div class="cg-detail-item"><b>Caregiver ID</b><asp:Label ID="dID" runat="server" /></div>
        <div class="cg-detail-item"><b>Full Name</b><asp:Label ID="dName" runat="server" /></div>
        <div class="cg-detail-item"><b>Recruiter</b><asp:Label ID="dRecruiter" runat="server" /></div>
        <div class="cg-detail-item"><b>Age / Gender</b><asp:Label ID="dAgeGender" runat="server" /></div>
        <div class="cg-detail-item"><b>Contact</b><asp:Label ID="dContact" runat="server" /></div>
        <div class="cg-detail-item"><b>City</b><asp:Label ID="dCity" runat="server" /></div>
        <div class="cg-detail-item"><b>Present Area ID</b><asp:Label ID="dArea" runat="server" /></div>
        <div class="cg-detail-item"><b>Service Category</b><asp:Label ID="dServices" runat="server" /></div>
        <div class="cg-detail-item"><b>Languages</b><asp:Label ID="dLanguages" runat="server" /></div>
        <div class="cg-detail-item"><b>Qualification / Experience</b><asp:Label ID="dQualification" runat="server" /></div>
        <div class="cg-detail-item"><b>Duty Preference</b><asp:Label ID="dDuty" runat="server" /></div>
        <div class="cg-detail-item"><b>Expected Salary</b><asp:Label ID="dSalary" runat="server" /></div>
        <div class="cg-detail-item"><b>Preferred Work Area IDs</b><asp:Label ID="dPreferredAreas" runat="server" /></div>
        <div class="cg-detail-item"><b>Joining Availability</b><asp:Label ID="dJoining" runat="server" /></div>
        <div class="cg-detail-item"><b>Verification Status</b><asp:Label ID="dStatus" runat="server" /></div>
        <div class="cg-detail-item"><b>Created Date</b><asp:Label ID="dCreated" runat="server" /></div>
        <div class="cg-detail-item"><b>Remarks</b><asp:Label ID="dRemarks" runat="server" /></div>
      </div>
      <asp:Button ID="btnCloseDetails" runat="server" Text="Close Details" CssClass="cg-btn cg-cancel" OnClick="btnCloseDetails_Click" CausesValidation="false" />
    </asp:Panel>

    <div class="cg-table-wrap">
      <asp:ListView ID="lvCaregivers" runat="server" DataKeyNames="CaregiverID"
          OnItemCommand="lvCaregivers_ItemCommand"
          OnItemDeleting="lvCaregivers_ItemDeleting">
        <LayoutTemplate>
          <table class="cg-table">
            <thead><tr>
              <th>ID</th><th>Name</th><th>Contact</th><th>City</th><th>Recruiter</th><th>Verification</th><th>Actions</th>
            </tr></thead>
            <tbody id="itemPlaceholder" runat="server"></tbody>
          </table>
        </LayoutTemplate>
        <ItemTemplate>
          <tr>
            <td data-label="ID"><%# Eval("CaregiverID") %></td>
            <td data-label="Name"><strong><%#: Eval("FullName") %></strong><br /><small>Age: <%# Eval("Age") %> | <%#: Eval("Gender") %></small></td>
            <td data-label="Contact"><%#: Eval("ContactNumber") %></td>
            <td data-label="City"><%#: Eval("City") %></td>
            <td data-label="Recruiter"><%#: Eval("RecruiterName") %></td>
            <td data-label="Verification"><%#: Eval("VerificationStatus") %></td>
            <td data-label="Actions" class="cg-actions">
              <asp:LinkButton runat="server" Text="View" CommandName="ViewRecord" CommandArgument='<%# Eval("CaregiverID") %>' CssClass="cg-btn cg-view" CausesValidation="false" />
              <a class="cg-btn cg-edit" href="<%# ResolveUrl("~/CaregiverRegistration.aspx?CaregiverID=" + Eval("CaregiverID")) %>">Edit</a>
              <asp:LinkButton runat="server" Text="Delete" CommandName="Delete" CssClass="cg-btn cg-delete" CausesValidation="false"
                OnClientClick="return confirm('Delete this caregiver profile? This action cannot be undone.');" />
            </td>
          </tr>
        </ItemTemplate>

        <EmptyDataTemplate><div class="cg-empty">No caregiver profiles found.</div></EmptyDataTemplate>
      </asp:ListView>
    </div>
    <asp:DataPager ID="dpCaregivers" runat="server" PagedControlID="lvCaregivers" PageSize="10" CssClass="cg-pager">
      <Fields>
        <asp:NextPreviousPagerField ShowFirstPageButton="true" ShowPreviousPageButton="true" ShowNextPageButton="false" ShowLastPageButton="false" ButtonCssClass="cg-btn" />
        <asp:NumericPagerField ButtonCount="5" NumericButtonCssClass="cg-btn" CurrentPageLabelCssClass="cg-btn" />
        <asp:NextPreviousPagerField ShowFirstPageButton="false" ShowPreviousPageButton="false" ShowNextPageButton="true" ShowLastPageButton="true" ButtonCssClass="cg-btn" />
      </Fields>
    </asp:DataPager>
  </div>
</div>
</asp:Content>
