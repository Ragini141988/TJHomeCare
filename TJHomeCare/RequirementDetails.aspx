<%@ Page Title="Requirement Details"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="RequirementDetails.aspx.cs"
    Inherits="TJHomeCare.RequirementDetails" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .requirement-details-page {
            max-width: 850px;
            margin: 40px auto;
            padding: 20px;
        }

        .requirement-details-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,.05);
        }

        .requirement-details-heading {
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 25px;
        }

        .requirement-details-heading h1 {
            font-size: 30px;
            margin: 12px 0 8px;
        }

        .requirement-details-badge {
            display: inline-block;
            background: #fff0f4;
            color: #ef2860;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .requirement-details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .requirement-detail {
            padding: 15px;
            background: #f9fafb;
            border-radius: 10px;
            min-width: 0;
        }

        .requirement-detail .detail-label {
            display: block;
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 7px;
        }

        .requirement-detail .detail-value {
            display: block;
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .requirement-detail i {
            color: #ef2860;
            margin-right: 7px;
        }

        .requirement-details-actions {
            margin-top: 28px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .requirement-home-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 13px 25px;
            background: #fff;
            color: #333;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
        }

        .requirement-home-btn:hover {
            background: #f3f4f6;
            color: #111;
        }

        .requirement-not-found {
            text-align: center;
            padding: 40px 20px;
        }

        @media (max-width: 600px) {
            .requirement-details-page {
                margin: 20px auto;
                padding: 12px;
            }

            .requirement-details-card {
                padding: 20px 15px;
            }

            .requirement-details-heading h1 {
                font-size: 25px;
            }

            .requirement-details-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .requirement-details-actions {
                display: flex;
                flex-direction: column;
            }

            .requirement-home-btn {
                width: 100%;
                box-sizing: border-box;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="requirement-details-page">

        <asp:Panel ID="pnlDetails" runat="server">

            <asp:FormView ID="fvRequirement"
                runat="server"
                Width="100%">

                <ItemTemplate>

                    <div class="requirement-details-card">

                        <div class="requirement-details-heading">

                            <span class="requirement-details-badge">
                                Home Care Requirement
                            </span>

                            <h1><%#: Eval("Service") %></h1>

                            <span>
                                <i class="fa-solid fa-location-dot"></i>
                                <%#: Eval("City") %>
                                <%# HasValue(Eval("Area"))
                                    ? " · " + Server.HtmlEncode(
                                        Convert.ToString(Eval("Area")))
                                    : "" %>
                            </span>

                        </div>

                        <div class="requirement-details-grid">

                            <div class="requirement-detail">
                                <span class="detail-label">
                                    <i class="fa-solid fa-clock"></i>
                                    Duty Time
                                </span>
                                <span class="detail-value">
                                    <%#: DisplayValue(Eval("DutyTime")) %>
                                </span>
                            </div>

                            <div class="requirement-detail">
                                <span class="detail-label">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    Budget
                                </span>
                                <span class="detail-value">
                                    <%#: DisplayValue(Eval("Budget")) %>
                                </span>
                            </div>

                            <div class="requirement-detail">
                                <span class="detail-label">
                                    <i class="fa-solid fa-language"></i>
                                    Preferred Language
                                </span>
                                <span class="detail-value">
                                    <%#: DisplayValue(Eval("PreferredLanguage")) %>
                                </span>
                            </div>

                            <div class="requirement-detail">
                                <span class="detail-label">
                                    <i class="fa-solid fa-calendar-check"></i>
                                    Joining Date
                                </span>
                                <span class="detail-value">
                                    <%#: DisplayDate(Eval("JoiningDate")) %>
                                </span>
                            </div>

                            <div class="requirement-detail">
                                <span class="detail-label">
                                    <i class="fa-solid fa-calendar"></i>
                                    Posted On
                                </span>
                                <span class="detail-value">
                                    <%#: DisplayDate(Eval("CreatedDate")) %>
                                </span>
                            </div>

                        </div>

                        <div class="requirement-details-actions">

                            <a href="<%= ResolveUrl("~/Homepage.aspx") %>"
                               class="requirement-home-btn">
                                <i class="fa-solid fa-house"
                                   style="margin-right:8px"></i>
                                Go to Home
                            </a>

                            <a href="<%= ResolveUrl("~/FindJobs.aspx") %>"
                               class="requirement-home-btn">
                                View All Requirements
                            </a>

                        </div>

                    </div>

                </ItemTemplate>

            </asp:FormView>

        </asp:Panel>

        <asp:Panel ID="pnlNotFound"
            runat="server"
            Visible="false"
            CssClass="requirement-details-card requirement-not-found">

            <h2>Requirement Not Found</h2>

            <p>
                This requirement may have been removed or the link may be invalid.
            </p>

            <a href="<%= ResolveUrl("~/FindJobs.aspx") %>"
               class="requirement-home-btn">
                Browse Requirements
            </a>

            <a href="<%= ResolveUrl("~/Homepage.aspx") %>"
               class="requirement-home-btn">
                Go to Home
            </a>

        </asp:Panel>

    </div>

</asp:Content>
