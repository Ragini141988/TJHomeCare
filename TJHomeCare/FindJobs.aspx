<%@ Page Title="Find Requirements"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="FindJobs.aspx.cs"
    Inherits="TJHomeCare.FindJobs" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .find-jobs-page {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 18px;
        }

        .find-jobs-heading {
            text-align: center;
            margin-bottom: 28px;
        }

        .find-jobs-heading h1 {
            font-size: clamp(26px, 4vw, 36px);
            margin-bottom: 8px;
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
        .find-jobs-filters {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            padding: 20px;
            margin-bottom: 28px;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            background: #fff;
        }

        .find-jobs-filters label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .find-jobs-filters select {
            width: 100%;
            min-width: 0;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            background: white;
        }

        .find-jobs-actions {
            grid-column: 1 / -1;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .find-jobs-actions .btn {
            padding: 11px 22px;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
        }

        .find-jobs-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
        }

        .find-jobs-card {
            min-width: 0;
            padding: 22px;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,.04);
        }

        .find-jobs-card h3 {
            overflow-wrap: anywhere;
            margin: 0 0 6px;
        }

        .find-jobs-card .job-meta {
            margin-top: 16px;
            display: grid;
            gap: 12px;
        }

        .find-jobs-card .job-meta div {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            overflow-wrap: anywhere;
        }

        .find-jobs-card .job-meta i {
            margin-top: 4px;
            color: #ef2860;
        }

        .find-jobs-pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 30px;
        }

        .find-jobs-pagination .btn {
            padding: 10px 18px;
        }

        .find-jobs-empty {
            grid-column: 1 / -1;
            padding: 35px 15px;
            text-align: center;
            border: 1px dashed #d1d5db;
            border-radius: 12px;
        }

        @media (max-width: 850px) {
            .find-jobs-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .find-jobs-filters {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 560px) {
            .find-jobs-page {
                padding: 26px 14px;
            }

            .find-jobs-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 16px;
            }

            .find-jobs-filters {
                grid-template-columns: minmax(0, 1fr);
                padding: 15px;
            }

            .find-jobs-actions {
                display: grid;
                grid-template-columns: 1fr 1fr;
            }

            .find-jobs-actions .btn {
                text-align: center;
                padding: 11px 8px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <main class="find-jobs-page">

        <div class="find-jobs-heading">
            <h1>Find Requirements</h1>
            <p>Explore the latest home care and household service requirements.</p>
        </div>

        <asp:Panel ID="pnlFilters"
            runat="server"
            DefaultButton="btnSearch">

            <div class="find-jobs-filters">

                <div>
                    <label for="<%= ddlService.ClientID %>">Service</label>
                    <asp:DropDownList ID="ddlService"
                        runat="server" />
                </div>

                <div>
                    <label for="<%= ddlCity.ClientID %>">City</label>
                    <asp:DropDownList ID="ddlCity"
                        runat="server" />
                </div>

                <div>
                    <label for="<%= ddlArea.ClientID %>">Area</label>
                    <asp:DropDownList ID="ddlArea"
                        runat="server" />
                </div>

                <div class="find-jobs-actions">
                    <asp:Button ID="btnSearch"
                        runat="server"
                        Text="Search"
                        CssClass="btn"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="btn"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />
                </div>

            </div>

        </asp:Panel>

        <p>
            <asp:Label ID="lblResults"
                runat="server" />
        </p>

        <div class="find-jobs-grid">

            <asp:Repeater ID="rptRequirements"
                runat="server">

                <ItemTemplate>
                    <article class="find-jobs-card">

                        <h3><%#: Eval("Service") %></h3>

                        <div class="job-meta">

                            <div>
                                <i class="fa-solid fa-location-dot"></i>
                                <span>
                                    <%#: Eval("City") %>
                                    <%# HasValue(Eval("Area"))
                                        ? " · " + Server.HtmlEncode(
                                            Convert.ToString(Eval("Area")))
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

                            <div>
                                <i class="fa-solid fa-calendar"></i>
                                <span>
                                    Posted:
                                    <%#: Convert.ToDateTime(
                                        Eval("CreatedDate")).ToString("dd MMM yyyy") %>
                                </span>
                            </div>

                              <a class="tj-view-requirement"
   href='<%# ResolveUrl("~/RequirementDetails.aspx?id=" +
       Eval("RequirementID")) %>'>
    View Full Details
    <i class="fa-solid fa-arrow-right"></i>
</a>
                        </div>

                    </article>
                </ItemTemplate>

            </asp:Repeater>

            <asp:Panel ID="pnlEmpty"
                runat="server"
                CssClass="find-jobs-empty"
                Visible="false">
                No requirements found. Try selecting another service or city.
            </asp:Panel>

        </div>

        <div class="find-jobs-pagination">

            <asp:Button ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label ID="lblPage"
                runat="server" />

            <asp:Button ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

    </main>

</asp:Content>