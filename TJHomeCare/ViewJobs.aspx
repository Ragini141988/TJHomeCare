<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewJobs.aspx.cs" Inherits="TJHomeCare.ViewJobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Available Jobs
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .jobs-page {
            background: #f5f8fc;
            padding: 35px 12px 50px;
            min-height: 600px;
        }

        .jobs-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 28px;
        }

        .jobs-header h2 {
            color: #17365d;
            font-size: 30px;
            font-weight: 700;
            margin: 0 0 7px;
        }

        .jobs-header p {
            color: #6b7280;
            margin: 0;
        }

        .jobs-count {
            background: #e6f0ff;
            color: #1769aa;
            padding: 12px 18px;
            border-radius: 10px;
            font-weight: 700;
        }

        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 22px;
        }

        .job-card {
            background: #fff;
            border: 1px solid #e3eaf2;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 5px 18px rgba(23,54,93,.07);
            display: flex;
            flex-direction: column;
            min-width: 0;
            transition: transform .2s, box-shadow .2s;
        }

        .job-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(23,54,93,.12);
        }

        .job-service {
            color: #17365d;
            font-size: 21px;
            font-weight: 700;
            margin-bottom: 8px;
            overflow-wrap: anywhere;
        }

        .job-location {
            color: #1769aa;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 18px;
        }

        .job-details {
            border-top: 1px solid #edf1f5;
            padding-top: 15px;
            margin-bottom: 16px;
        }

        .job-detail-row {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            margin-bottom: 12px;
            font-size: 14px;
            color: #536174;
            overflow-wrap: anywhere;
        }

        .job-detail-label {
            min-width: 95px;
            color: #17365d;
            font-weight: 700;
        }

        .job-budget {
            color: #16804a;
            font-size: 19px;
            font-weight: 700;
            margin: 5px 0 18px;
        }

        .job-apply-btn {
            display: block;
            margin-top: auto;
            padding: 12px 16px;
            text-align: center;
            background: #1769aa;
            color: #fff !important;
            border-radius: 9px;
            font-weight: 700;
            text-decoration: none !important;
            transition: background .2s;
        }

        .job-apply-btn:hover {
            background: #12558b;
        }

        .jobs-empty {
            background: #fff;
            border: 1px dashed #cbd5e1;
            padding: 40px 15px;
            border-radius: 12px;
            text-align: center;
            color: #6b7280;
        }

        .jobs-message {
            display: block;
            margin-bottom: 18px;
            font-weight: 600;
        }

        @media (max-width: 576px) {
            .jobs-page {
                padding: 22px 8px;
            }

            .jobs-header h2 {
                font-size: 25px;
            }

            .jobs-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container jobs-page">

        <div class="jobs-header">
            <div>
                <h2>Available Jobs</h2>
                <p>Explore caregiver opportunities and apply for a suitable job.</p>
            </div>

            <%--<div class="jobs-count">
                Total Jobs:
                <asp:Label ID="lblTotalJobs" runat="server" Text="0" />
            </div>--%>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">

   <div class="jobs-count">
    <asp:HyperLink
        ID="lnkTotalApplied"
        runat="server"
        NavigateUrl="~/ViewJobApplications.aspx"
        Style="color: #1769aa; text-decoration: none;">
        Total Applied:
        <asp:Label ID="lblTotalApplied" runat="server" Text="0" />
    </asp:HyperLink>
</div>

    <div class="jobs-count">
        Total Jobs:
        <asp:Label ID="lblTotalJobs" runat="server" Text="0" />
    </div>

</div>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            CssClass="jobs-message" EnableViewState="false" />

        <asp:Panel ID="pnlNoJobs" runat="server"
            CssClass="jobs-empty" Visible="false">
            <h4>No Jobs Available</h4>
            <p>There are currently no job requirements available.</p>
        </asp:Panel>

        <div class="jobs-grid">

            <asp:Repeater ID="rptJobs" runat="server">

                <ItemTemplate>

                    <div class="job-card">

                        <div class="job-service">
                            <%#: Eval("Service") %>
                        </div>

                        <div class="job-location">
                            &#128205;
                            <%#: Eval("Area") == DBNull.Value ||
                                string.IsNullOrWhiteSpace(Convert.ToString(Eval("Area")))
                                ? "Area not specified"
                                : Convert.ToString(Eval("Area")) %>,
                            <%#: Eval("City") == DBNull.Value ||
                                string.IsNullOrWhiteSpace(Convert.ToString(Eval("City")))
                                ? "City not specified"
                                : Convert.ToString(Eval("City")) %>
                        </div>

                        <div class="job-details">

                            <div class="job-detail-row">
                                <span class="job-detail-label">Duty Time</span>
                                <span>
                                    <%#: Eval("DutyTime") == DBNull.Value
                                        ? "Not specified"
                                        : Convert.ToString(Eval("DutyTime")) %>
                                </span>
                            </div>

                            <div class="job-detail-row">
                                <span class="job-detail-label">Language</span>
                                <span>
                                    <%#: Eval("PreferredLanguage") == DBNull.Value
                                        ? "Not specified"
                                        : Convert.ToString(Eval("PreferredLanguage")) %>
                                </span>
                            </div>

                            <div class="job-detail-row">
                                <span class="job-detail-label">Joining Date</span>
                                <span>
                                    <%# Eval("JoiningDate") == DBNull.Value
                                        ? "Not specified"
                                        : Convert.ToDateTime(Eval("JoiningDate")).ToString("dd MMM yyyy") %>
                                </span>
                            </div>

                        </div>

                        <div class="job-budget">
                            Budget:
                            <%#: Eval("Budget") == DBNull.Value ||
                                string.IsNullOrWhiteSpace(Convert.ToString(Eval("Budget")))
                                ? "Not specified"
                                : "₹" + Convert.ToString(Eval("Budget")) %>
                        </div>

                        <a class="job-apply-btn"
                           href='<%# ResolveUrl("~/ApplyJob.aspx?id=" + Eval("RequirementID")) %>'>
                            Apply Now
                        </a>

                    </div>

                </ItemTemplate>

            </asp:Repeater>

        </div>

    </div>

</asp:Content>

