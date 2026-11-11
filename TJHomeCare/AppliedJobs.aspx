<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AppliedJobs.aspx.cs" Inherits="TJHomeCare.AppliedJobs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Applied Jobs Dashboard
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style>
    .dashboard {
        max-width: 1200px;
        margin: 35px auto;
        padding: 0 15px;
    }

    .dashboard-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 25px;
    }

    .dashboard-header h2 {
        color: #17365d;
        font-weight: 700;
        margin: 0;
    }

    .dashboard-header p {
        color: #718096;
        margin: 6px 0 0;
    }

    .summary-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 18px;
        margin-bottom: 25px;
    }

    .summary-card {
        background: #fff;
        border: 1px solid #e6edf5;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 3px 12px rgba(0,0,0,.04);
    }

    .summary-card span {
        color: #718096;
        font-size: 14px;
    }

    .summary-card h3 {
        font-size: 28px;
        font-weight: 700;
        color: #17365d;
        margin: 8px 0 0;
    }

    .filter-panel {
        background: #fff;
        padding: 22px;
        border: 1px solid #e6edf5;
        border-radius: 12px;
        margin-bottom: 25px;
        box-shadow: 0 3px 12px rgba(0,0,0,.04);
    }

    .filter-panel h4 {
        color: #17365d;
        font-weight: 700;
        margin-bottom: 18px;
    }

    .filter-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
        align-items: end;
    }

    .filter-grid label {
        font-size: 13px;
        font-weight: 600;
        color: #536174;
        margin-bottom: 7px;
    }

    .filter-buttons {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
    }

    .result-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 25px 0 15px;
    }

    .result-heading h4 {
        color: #17365d;
        font-weight: 700;
        margin: 0;
    }

    .job-card {
        background: #fff;
        border: 1px solid #e5ebf2;
        border-radius: 13px;
        margin-bottom: 18px;
        padding: 22px;
        box-shadow: 0 4px 14px rgba(0,0,0,.045);
        transition: .2s;
    }

    .job-card:hover {
        box-shadow: 0 7px 20px rgba(0,0,0,.09);
        transform: translateY(-2px);
    }

    .job-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 12px;
        flex-wrap: wrap;
        border-bottom: 1px solid #edf0f4;
        padding-bottom: 15px;
        margin-bottom: 17px;
    }

    .job-title {
        color: #17365d;
        font-size: 19px;
        font-weight: 700;
        margin: 0 0 6px;
    }

    .application-id {
        color: #8995a5;
        font-size: 12px;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 13px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 700;
        background: #fff3cd;
        color: #856404;
    }

    .job-details {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 18px;
    }

    .detail-item {
        color: #7a8797;
        font-size: 13px;
    }

    .detail-item strong {
        display: block;
        color: #344054;
        font-size: 14px;
        margin-top: 5px;
        font-weight: 600;
        overflow-wrap: anywhere;
    }

    .applicant-section {
        background: #f7f9fc;
        padding: 14px 16px;
        border-radius: 9px;
        margin-top: 18px;
    }

    .applicant-section h6 {
        color: #17365d;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .applicant-info {
        display: flex;
        flex-wrap: wrap;
        gap: 25px;
        color: #536174;
        font-size: 13px;
    }

    .no-records {
        background: #fff;
        text-align: center;
        padding: 45px 20px;
        border-radius: 12px;
        border: 1px solid #e6edf5;
        color: #718096;
    }

    .no-records h4 {
        color: #17365d;
        font-weight: 700;
    }

    @media(max-width: 900px) {
        .summary-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .filter-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media(max-width: 576px) {
        .summary-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }

        .summary-card {
            padding: 14px;
        }

        .summary-card h3 {
            font-size: 23px;
        }

        .filter-grid {
            grid-template-columns: 1fr;
        }

        .job-details {
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
        }

        .job-card {
            padding: 16px;
        }
    }
</style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<div class="dashboard">

    <!-- Dashboard Header -->

    <div class="dashboard-header">
        <div>
            <h2>Applied Jobs Dashboard</h2>
            <p>Manage and monitor all job applications</p>
        </div>
    </div>

    <!-- Summary Cards -->

    <div class="summary-grid">

        <div class="summary-card">
            <span>Total Applications</span>
            <h3>
                <asp:Label ID="lblTotal" runat="server" Text="0" />
            </h3>
        </div>

        <div class="summary-card">
            <span>Pending Applications</span>
            <h3>
                <asp:Label ID="lblPending" runat="server" Text="0" />
            </h3>
        </div>

        <div class="summary-card">
            <span>Approved Applications</span>
            <h3>
                <asp:Label ID="lblApproved" runat="server" Text="0" />
            </h3>
        </div>

        <div class="summary-card">
            <span>Rejected Applications</span>
            <h3>
                <asp:Label ID="lblRejected" runat="server" Text="0" />
            </h3>
        </div>

    </div>

    <!-- Filters -->

    <div class="filter-panel">

        <h4>Filter Applications</h4>

        <div class="filter-grid">

            <div>
                <label>Search</label>
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="form-control"
                    placeholder="Name, mobile, area..." />
            </div>

            <div>
                <label>Application Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="form-control">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                    <asp:ListItem Text="Approved" Value="Approved" />
                    <asp:ListItem Text="Rejected" Value="Rejected" />
                </asp:DropDownList>
            </div>

            <div>
                <label>Service Category</label>
                <asp:DropDownList ID="ddlService" runat="server"
                    CssClass="form-control">
                    <asp:ListItem Text="All Services" Value="" />
                </asp:DropDownList>
            </div>

            <div>
                <label>City</label>
                <asp:DropDownList ID="ddlCity" runat="server"
                    CssClass="form-control">
                    <asp:ListItem Text="All Cities" Value="" />
                </asp:DropDownList>
            </div>

        </div>

        <div class="filter-buttons" style="margin-top:18px;">

            <asp:Button ID="btnFilter" runat="server"
                Text="Apply Filters"
                CssClass="btn btn-primary" OnClick="btnFilter_Click" />

            <asp:Button ID="btnReset" runat="server"
                Text="Reset Filters"
                CssClass="btn btn-outline-secondary"
                Onclick="btnReset_Click" />

        </div>

    </div>

    <!-- Application List -->

    <div class="result-heading">

        <h4>All Applications</h4>

        <strong style="color:#536174;">
            Showing:
            <asp:Label ID="lblShowing" runat="server" Text="0" />
        </strong>

    </div>

    <asp:Repeater ID="rptAppliedJobs" runat="server">

        <ItemTemplate>

            <div class="job-card">

                <div class="job-top">

                    <div>
                        <h4 class="job-title">
                            <%#: Eval("Service") %>
                        </h4>

                        <span class="application-id">
                            Application #<%#: Eval("ApplicationID") %>
                            &nbsp; | &nbsp;
                            Requirement #<%#: Eval("RequirementID") %>
                        </span>
                    </div>

                    <span class="status-badge">
                        <%#: Eval("ApplicationStatus") %>
                    </span>

                </div>

                <div class="job-details">

                    <div class="detail-item">
                        Job Location
                        <strong>
                            <%#: Eval("Area") %>, <%#: Eval("City") %>
                        </strong>
                    </div>

                    <div class="detail-item">
                        Duty Time
                        <strong><%#: Eval("DutyTime") %></strong>
                    </div>

                    <div class="detail-item">
                        Budget
                        <strong>₹ <%#: Eval("Budget") %></strong>
                    </div>

                    <div class="detail-item">
                        Joining Date
                        <strong>
                            <%#: Eval("JoiningDate", "{0:dd MMM yyyy}") %>
                        </strong>
                    </div>

                    <div class="detail-item">
                        Applied Date
                        <strong>
                            <%#: Eval("AppliedOn", "{0:dd MMM yyyy}") %>
                        </strong>
                    </div>

                    <div class="detail-item">
                        Preferred Language
                        <strong><%#: Eval("PreferredLanguage") %></strong>
                    </div>

                </div>

                <div class="applicant-section">

                    <h6>Applicant Information</h6>

                    <div class="applicant-info">

                        <span>
                            <strong>Name:</strong>
                            <%#: Eval("ApplicantName") %>
                        </span>

                        <span>
                            <strong>Mobile:</strong>
                            <%#: Eval("ApplicantMobile") %>
                        </span>

                    </div>

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>

    <asp:Panel ID="pnlNoRecords" runat="server"
        Visible="false" CssClass="no-records">

        <h4>No Applications Found</h4>

        <p>No job applications match your selected filters.</p>

    </asp:Panel>

</div>
</asp:Content>
