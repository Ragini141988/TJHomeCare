<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewJobApplications.aspx.cs" Inherits="TJHomeCare.ViewJobApplications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
  Job Applications
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        
 
    /* Page Layout */
    .applications-page {
        padding: 30px 0 45px;
        color: #1e293b;
        font-family: Arial, Helvetica, sans-serif;
    }

    .applications-page,
    .applications-page * {
        box-sizing: border-box;
    }

    /* Page Heading */
    .applications-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 22px;
        flex-wrap: wrap;
        margin-bottom: 28px;
    }

    .applications-title {
        margin: 0 0 9px;
        font-size: 30px;
        line-height: 1.3;
        font-weight: 750;
        color: #14243a;
        letter-spacing: -.6px;
    }

    .applications-subtitle {
        margin: 0;
        color: #718096;
        font-size: 14px;
        line-height: 1.7;
    }

    /* Total Count */
    .applications-count {
        display: flex;
        align-items: center;
        gap: 15px;
        min-width: 215px;
        padding: 17px 21px;
        background: linear-gradient(135deg, #eef4ff, #f7f9ff);
        border: 1px solid #dce7fb;
        border-radius: 15px;
        box-shadow: 0 5px 16px rgba(37, 99, 235, .05);
    }

    .count-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 48px;
        height: 48px;
        flex-shrink: 0;
        border-radius: 13px;
        background: #dce8ff;
        color: #245bc5;
        font-size: 23px;
    }

    .count-label {
        display: block;
        margin-bottom: 6px;
        color: #64748b;
        font-size: 12px;
        font-weight: 600;
    }

    .count-number {
        display: block;
        color: #1d4ed8;
        font-size: 28px;
        font-weight: 750;
        line-height: 1;
    }

    /* Main Applications Panel */
    .applications-card {
        overflow: hidden;
        background: #f8fafc;
        border: 1px solid #e4eaf2;
        border-radius: 18px;
        box-shadow: 0 8px 30px rgba(15, 23, 42, .045);
    }

    .applications-card-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        padding: 23px 26px;
        background: #fff;
        border-bottom: 1px solid #e9eef5;
    }

    .applications-card-header h3 {
        margin: 0 0 6px;
        color: #1e293b;
        font-size: 18px;
        font-weight: 700;
    }

    .applications-card-header p {
        margin: 0;
        color: #8491a4;
        font-size: 13px;
        line-height: 1.6;
    }

    /* Information Message */
    .applications-message {
        display: block;
        padding: 12px 26px;
        color: #526780;
        background: #f0f6ff;
        border-bottom: 1px solid #e1ebfa;
        font-size: 12px;
        line-height: 1.6;
    }

    /* Cards Grid */
    .applications-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 20px;
        padding: 24px;
        align-items: stretch;
    }

    /* Individual Application */
    .application-card {
        position: relative;
        min-width: 0;
        padding: 23px;
        overflow: hidden;
        background: #fff;
        border: 1px solid #e3eaf3;
        border-radius: 15px;
        box-shadow: 0 3px 12px rgba(15, 23, 42, .035);
        transition: border-color .2s ease, box-shadow .2s ease,
                    transform .2s ease;
    }

    .application-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: #4779df;
        opacity: .9;
    }

    .application-card:hover {
        transform: translateY(-3px);
        border-color: #cbdaf4;
        box-shadow: 0 10px 25px rgba(15, 23, 42, .075);
    }

    /* Applicant Information */
    .application-card-top {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 14px;
        padding: 2px 0 20px;
        border-bottom: 1px solid #edf1f6;
    }

    .applicant-info {
        min-width: 0;
        flex: 1;
    }

    .application-id {
        display: inline-block;
        margin-bottom: 5px;
        color: #5475ad;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: .5px;
        text-transform: uppercase;
    }

    .application-card-top h3 {
        margin: 3px 0 9px;
        color: #172b4d;
        font-size: 19px;
        line-height: 1.45;
        font-weight: 700;
        overflow-wrap: anywhere;
    }

    .application-mobile {
        display: flex;
        align-items: center;
        gap: 7px;
        color: #53657d;
        font-size: 13px;
        line-height: 1.6;
        overflow-wrap: anywhere;
    }

    /* Status Badges */
    .status-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        padding: 7px 12px;
        border-radius: 7px;
        font-size: 10px;
        font-weight: 750;
        letter-spacing: .4px;
        text-transform: uppercase;
        white-space: nowrap;
    }

    .status-pending {
        background: #fff4d9;
        color: #946200;
        border: 1px solid #f5e5b8;
    }

    .status-approved {
        background: #e5f8ec;
        color: #187344;
        border: 1px solid #c8efd6;
    }

    .status-rejected {
        background: #ffebeb;
        color: #b42332;
        border: 1px solid #f6d0d4;
    }

    /* Detail Fields */
    .application-details {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 0;
        padding-top: 8px;
    }

    .detail-item {
        min-width: 0;
        padding: 14px 10px 13px 0;
        border-bottom: 1px solid #f0f3f7;
    }

    .detail-item:nth-last-child(1) {
        border-bottom: none;
    }

    .detail-item span {
        display: block;
        margin-bottom: 7px;
        color: #8a96a8;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: .2px;
        text-transform: uppercase;
    }

    .detail-item strong {
        display: block;
        color: #33445b;
        font-size: 13px;
        font-weight: 650;
        line-height: 1.65;
        overflow-wrap: anywhere;
    }

    /* Footer */
    .applications-footer-note {
        margin: 15px 2px 0;
        color: #8491a4;
        font-size: 12px;
        line-height: 1.7;
    }

    /* Tablet */
    @media (max-width: 900px) {
        .applications-grid {
            grid-template-columns: 1fr;
            gap: 17px;
            padding: 18px;
        }

        .applications-title {
            font-size: 26px;
        }
    }

    /* Mobile */
    @media (max-width: 767px) {
        .applications-page {
            padding: 20px 0 30px;
        }

        .applications-header {
            gap: 17px;
            margin-bottom: 20px;
        }

        .applications-title {
            font-size: 24px;
        }

        .applications-count {
            width: 100%;
            min-width: 0;
        }

        .applications-card-header {
            padding: 19px;
        }

        .applications-message {
            padding: 12px 19px;
        }

        .applications-grid {
            padding: 13px;
            gap: 14px;
        }
    }

    @media (max-width: 480px) {
        .application-card {
            padding: 18px;
        }

        .application-card-top {
            flex-wrap: wrap;
            gap: 12px;
        }

        .application-card-top h3 {
            font-size: 18px;
        }

        .application-details {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .detail-item {
            padding-right: 7px;
        }

        .status-badge {
            padding: 6px 10px;
        }
    }
</style>
   

</asp:Content>

 
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
 

    <div class="container applications-page">

        <!-- Page Header -->
        <div class="applications-header">

            <div>
                <h2 class="applications-title">Job Applications</h2>

                <p class="applications-subtitle">
                    Manage and review caregivers who have applied for jobs.
                </p>
            </div>

            <!-- Total Applications Card -->
            <div class="applications-count">

                <div class="count-icon">&#128101;</div>

                <div>
                    <span class="count-label">Total Applications</span>

                    <asp:Label ID="lblTotal" runat="server"
                        CssClass="count-number" Text="0" />
                </div>

            </div>

        </div>

        <!-- Applications Section -->
        <div class="applications-card">

            <div class="applications-card-header">

                <div>
                    <h3>All Applications</h3>

                    <p>
                        Review applicant details and application status.
                    </p>
                </div>

            </div>

            <!-- Message -->
            <asp:Label ID="lblMessage" runat="server"
                CssClass="applications-message" />

            <!-- Individual Application Cards -->
            <div class="applications-grid">

                <asp:Repeater ID="rptApplications" runat="server">

                    <ItemTemplate>

                        <div class="application-card">

                            <!-- Applicant Header -->
                            <div class="application-card-top">

                                <div class="applicant-info">

                                    <span class="application-id">
                                        Application #<%#: Eval("ApplicationID") %>
                                    </span>

                                    <h3>
                                        <%#: Eval("ApplicantName") %>
                                    </h3>

                                    <div class="application-mobile">
                                        <span>&#128222;</span>
                                        <%#: Eval("ApplicantMobile") %>
                                    </div>

                                </div>

                                <!-- Status Badge -->
                                <span class='<%# "status-badge " +
                                    (Convert.ToString(Eval("ApplicationStatus"))
                                    .Equals("Approved", StringComparison.OrdinalIgnoreCase)
                                    ? "status-approved"
                                    : Convert.ToString(Eval("ApplicationStatus"))
                                    .Equals("Rejected", StringComparison.OrdinalIgnoreCase)
                                    ? "status-rejected"
                                    : "status-pending") %>'>

                                    <%#: Eval("ApplicationStatus") %>

                                </span>

                            </div>

                            <!-- Job and Applicant Details -->
                            <div class="application-details">

                                <div class="detail-item">

                                    <span>Service</span>

                                    <strong>
                                        <%#: Eval("Service") == DBNull.Value
                                            ? "Not available"
                                            : Eval("Service") %>
                                    </strong>

                                </div>

                                <div class="detail-item">

                                    <span>Job Location</span>

                                    <strong>
                                        <%#: (Eval("City") == DBNull.Value
                                            ? "Not available"
                                            : Eval("City")) %>

                                        <%#: (Eval("Area") == DBNull.Value
                                            || Convert.ToString(Eval("Area")) == ""
                                            ? ""
                                            : " - " + Convert.ToString(Eval("Area"))) %>
                                    </strong>

                                </div>

                                <div class="detail-item">

                                    <span>Job ID</span>

                                    <strong>
                                        <%#: Eval("RequirementID") %>
                                    </strong>

                                </div>

                                <div class="detail-item">

                                    <span>Caregiver ID</span>

                                    <strong>
                                        <%#: Eval("CaregiverID") == DBNull.Value
                                            ? "Not linked"
                                            : Eval("CaregiverID") %>
                                    </strong>

                                </div>

                                <div class="detail-item detail-date">

                                    <span>Applied On</span>

                                    <strong>
                                        <%#: Eval("AppliedOn") == DBNull.Value
                                            ? "Not available"
                                            : Convert.ToDateTime(Eval("AppliedOn"))
                                                .ToString("dd MMM yyyy, hh:mm tt") %>
                                    </strong>

                                </div>

                            </div>

                        </div>

                    </ItemTemplate>

                </asp:Repeater>

            </div>

        </div>

        <!-- Footer Note -->
        <p class="applications-footer-note">
            Application information is loaded from the database.
        </p>

    </div>



</asp:Content>
