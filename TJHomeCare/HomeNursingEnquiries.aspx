<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HomeNursingEnquiries.aspx.cs" Inherits="TJHomeCare.HomeNursingEnquiries" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home Nursing Enquiries
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

<style>
    .enquiry-page {
        background: #f4f7fb;
        padding: 30px 15px;
        min-height: 80vh;
        font-family: Arial, sans-serif;
        color: #26364a;
    }

    .enquiry-container {
        max-width: 1400px;
        margin: auto;
    }

    .enquiry-heading {
        margin-bottom: 22px;
    }

    .enquiry-heading h2 {
        color: #173b63;
        font-size: 28px;
        font-weight: 700;
        margin: 0 0 7px;
    }

    .enquiry-heading p {
        color: #718096;
        margin: 0;
    }

    /* Summary Cards */
    .summary-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
        margin-bottom: 22px;
    }

    .summary-card {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 15px rgba(0,0,0,.045);
        border-left: 4px solid #087f8c;
    }

    .summary-card.today {
        border-left-color: #2563eb;
    }

    .summary-card.pending {
        border-left-color: #e59b21;
    }

    .summary-label {
        color: #718096;
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 8px;
    }

    .summary-number {
        font-size: 29px;
        font-weight: 700;
        color: #173b63;
    }

    /* Filter Section */
    .enquiry-filter-card {
        background: #fff;
        border-radius: 12px;
        padding: 22px;
        box-shadow: 0 4px 18px rgba(0,0,0,.05);
        margin-bottom: 22px;
    }

    .filter-title {
        color: #173b63;
        font-size: 17px;
        font-weight: 700;
        margin-bottom: 16px;
    }

    .filter-row {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr auto auto;
        gap: 12px;
        align-items: end;
    }

    .filter-row label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #334155;
        margin-bottom: 7px;
    }

    .filter-control {
        width: 100%;
        height: 43px;
        border: 1px solid #d9e2ec;
        border-radius: 7px;
        padding: 8px 11px;
        box-sizing: border-box;
        background: #fff;
        outline: none;
        font-size: 14px;
    }

    .filter-control:focus {
        border-color: #087f8c;
        box-shadow: 0 0 0 2px rgba(8,127,140,.10);
    }

    .btn-search, .btn-clear {
        height: 43px;
        border: none;
        border-radius: 7px;
        padding: 0 22px;
        color: white;
        cursor: pointer;
        font-weight: 600;
        white-space: nowrap;
    }

    .btn-search {
        background: #087f8c;
    }

    .btn-search:hover {
        background: #066a75;
    }

    .btn-clear {
        background: #64748b;
    }

    .btn-clear:hover {
        background: #475569;
    }

    .message-label {
        display: block;
        color: #dc2626;
        margin-bottom: 12px;
        font-weight: 600;
    }

    .result-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 20px 0 15px;
        gap: 10px;
    }

    .result-heading h3 {
        color: #173b63;
        font-size: 19px;
        font-weight: 700;
        margin: 0;
    }

    .result-count {
        background: #e7f4f5;
        color: #087f8c;
        border-radius: 20px;
        padding: 7px 13px;
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
    }

    /* Enquiry Cards */
    .enquiry-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .customer-card {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 16px rgba(0,0,0,.05);
        border: 1px solid #edf1f5;
        min-width: 0;
    }

    .customer-card:hover {
        box-shadow: 0 7px 22px rgba(0,0,0,.09);
        transform: translateY(-2px);
        transition: .2s ease;
    }

    .customer-card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 10px;
        padding-bottom: 14px;
        border-bottom: 1px solid #edf1f5;
        margin-bottom: 15px;
    }

    .customer-name {
        font-size: 17px;
        color: #173b63;
        font-weight: 700;
        margin-bottom: 6px;
        overflow-wrap: anywhere;
    }

    .enquiry-id {
        color: #8795a6;
        font-size: 12px;
    }

    .enquiry-date {
        color: #64748b;
        font-size: 12px;
        margin-top: 5px;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 11px;
        border-radius: 20px;
        background: #fff4d6;
        color: #9a6700;
        font-size: 11px;
        font-weight: 700;
        white-space: nowrap;
        text-transform: uppercase;
    }

    .detail-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px 12px;
    }

    .detail-item {
        min-width: 0;
    }

    .detail-label {
        color: #94a3b8;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        margin-bottom: 5px;
    }

    .detail-value {
        color: #334155;
        font-size: 14px;
        font-weight: 600;
        overflow-wrap: anywhere;
    }

    .customer-contact {
        display: inline-block;
        color: #087f8c;
        text-decoration: none;
        font-weight: 700;
    }

    .customer-contact:hover {
        text-decoration: underline;
    }

    .requirements-box {
        background: #f7fafc;
        border-radius: 8px;
        padding: 13px;
        margin-top: 17px;
    }

    .requirements-box .detail-value {
        font-weight: 400;
        line-height: 1.6;
        white-space: pre-wrap;
    }

    .card-footer {
        border-top: 1px solid #edf1f5;
        margin-top: 16px;
        padding-top: 13px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }

    .privacy-yes {
        color: #15803d;
        font-size: 12px;
        font-weight: 700;
    }

    .privacy-no {
        color: #dc2626;
        font-size: 12px;
        font-weight: 700;
    }

    .empty-result {
        background: #fff;
        padding: 35px 15px;
        text-align: center;
        border-radius: 12px;
        color: #718096;
        box-shadow: 0 4px 15px rgba(0,0,0,.04);
    }

    /* Tablet */
    @media(max-width: 900px) {
        .filter-row {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .enquiry-grid {
            grid-template-columns: 1fr;
        }
    }

    /* Mobile */
    @media(max-width: 550px) {
        .enquiry-page {
            padding: 18px 10px;
        }

        .enquiry-heading h2 {
            font-size: 23px;
        }

        .summary-grid {
            grid-template-columns: 1fr;
            gap: 10px;
        }

        .summary-card {
            padding: 15px;
        }

        .summary-number {
            font-size: 25px;
        }

        .enquiry-filter-card {
            padding: 15px;
        }

        .filter-row {
            grid-template-columns: 1fr;
        }

        .btn-search, .btn-clear {
            width: 100%;
        }

        .customer-card {
            padding: 15px;
        }

        .customer-name {
            font-size: 16px;
        }

        .detail-grid {
            gap: 14px 9px;
        }

        .detail-value {
            font-size: 13px;
        }

        .result-heading h3 {
            font-size: 17px;
        }
    }
</style>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

<div class="enquiry-page">
    <div class="enquiry-container">

        <div class="enquiry-heading">
            <h2>Home Nursing Enquiries</h2>
            <p>Manage and track all customer home nursing enquiries.</p>
        </div>

        <!-- Summary Cards -->
        <div class="summary-grid">

            <div class="summary-card">
                <div class="summary-label">Total Enquiries</div>
                <div class="summary-number">
                    <asp:Label ID="lblTotal" runat="server" Text="0" />
                </div>
            </div>

            <div class="summary-card today">
                <div class="summary-label">Today's Enquiries</div>
                <div class="summary-number">
                    <asp:Label ID="lblToday" runat="server" Text="0" />
                </div>
            </div>

            <div class="summary-card pending">
                <div class="summary-label">Pending Enquiries</div>
                <div class="summary-number">
                    <asp:Label ID="lblPending" runat="server" Text="0" />
                </div>
            </div>

        </div>

        <!-- Search and Filters -->
        <div class="enquiry-filter-card">

            <div class="filter-title">Search & Filter Enquiries</div>

            <asp:Label ID="lblMessage" runat="server"
                CssClass="message-label" />

            <div class="filter-row">

                <div>
                    <label>Search Enquiry</label>
                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="filter-control"
                        placeholder="Name, mobile number or area..." />
                </div>

                <div>
                    <label>City</label>
                    <asp:DropDownList ID="ddlFilterCity" runat="server"
                        CssClass="filter-control">
                        <asp:ListItem Text="All Cities" Value="" />
                        <asp:ListItem Text="Hyderabad" Value="Hyderabad" />
                        <asp:ListItem Text="Bangalore" Value="Bangalore" />
                    </asp:DropDownList>
                </div>

                <div>
                    <label>Status</label>
                    <asp:DropDownList ID="ddlFilterStatus" runat="server"
                        CssClass="filter-control">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Contacted" Value="Contacted" />
                        <asp:ListItem Text="Completed" Value="Completed" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                    </asp:DropDownList>
                </div>

                <div>
                    <asp:Button ID="btnSearch" runat="server"
                        Text="Search"
                        CssClass="btn-search"
                        OnClick="btnSearch_Click" />
                </div>

                <div>
                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear"
                        CssClass="btn-clear"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />
                </div>

            </div>
        </div>

        <!-- Enquiry Results -->
        <div class="result-heading">
            <h3>Home Nursing Enquiries</h3>
            <span class="result-count">
                Showing:
                <asp:Label ID="lblShowing" runat="server" Text="0" />
            </span>
        </div>

        <asp:Repeater ID="rptEnquiries" runat="server">

            <HeaderTemplate>
                <div class="enquiry-grid">
            </HeaderTemplate>

            <ItemTemplate>

                <div class="customer-card">

                    <div class="customer-card-header">

                        <div>
                            <div class="customer-name">
                                <%#: Eval("CustomerName") %>
                            </div>

                            <div class="enquiry-id">
                                Enquiry #<%#: Eval("EnquiryID") %>
                            </div>

                            <div class="enquiry-date">
                                <%# Eval("EnquiryDate", "{0:dd-MMM-yyyy hh:mm tt}") %>
                            </div>
                        </div>

                        <span class="status-badge">
                            <%#: Eval("EnquiryStatus") %>
                        </span>

                    </div>

                    <div class="detail-grid">

                        <div class="detail-item">
                            <div class="detail-label">Mobile Number</div>
                            <div class="detail-value">
                                <a class="customer-contact"
                                   href='<%# "tel:" + Eval("MobileNumber") %>'>
                                    <%#: Eval("MobileNumber") %>
                                </a>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">City</div>
                            <div class="detail-value">
                                <%#: Eval("City") %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Area</div>
                            <div class="detail-value">
                                <%#: Eval("Area") %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Patient Age</div>
                            <div class="detail-value">
                                <%# Eval("PatientAge") == DBNull.Value
                                    ? "Not Provided"
                                    : Eval("PatientAge") + " Years" %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Preferred Start Date</div>
                            <div class="detail-value">
                                <%# Eval("PreferredStartDate") == DBNull.Value
                                    ? "Not Provided"
                                    : Eval("PreferredStartDate", "{0:dd-MMM-yyyy}") %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Nursing Care</div>
                            <div class="detail-value">
                                <%#: Eval("NursingCareType") %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Duty Hours</div>
                            <div class="detail-value">
                                <%#: Eval("DutyHours") %>
                            </div>
                        </div>

                    </div>

                    <div class="requirements-box">
                        <div class="detail-label">Additional Requirements</div>
                        <div class="detail-value">
                            <%# String.IsNullOrWhiteSpace(Convert.ToString(Eval("AdditionalRequirements")))
                                ? "No additional requirements provided."
                                : Server.HtmlEncode(Convert.ToString(Eval("AdditionalRequirements"))) %>
                        </div>
                    </div>

                    <div class="card-footer">

                        <span class='<%# Convert.ToBoolean(Eval("IsPrivacyAccepted"))
                            ? "privacy-yes" : "privacy-no" %>'>
                            <%# Convert.ToBoolean(Eval("IsPrivacyAccepted"))
                                ? "Privacy Accepted: Yes"
                                : "Privacy Accepted: No" %>
                        </span>

                        <span class="enquiry-id">
                            Enquiry #<%#: Eval("EnquiryID") %>
                        </span>

                    </div>

                </div>

            </ItemTemplate>

            <FooterTemplate>
                </div>
            </FooterTemplate>

        </asp:Repeater>

        <asp:Panel ID="pnlNoRecords" runat="server"
            CssClass="empty-result" Visible="false">
            <h3>No Enquiries Found</h3>
            <p>There are no enquiries matching your search or filter.</p>
        </asp:Panel>

    </div>
</div>

</asp:Content>