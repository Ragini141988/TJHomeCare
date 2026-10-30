<%@ Page Title="Online Consultation Professionals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ConsultationBookingsView.aspx.cs" Inherits="TJHomeCare.ConsultationBookingsView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Online Consultation Professionals | TJ Home Care
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
   

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
            color: #263238;
        }

        .page-container {
            max-width: 1450px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .page-header {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px rgba(0,0,0,.05);
        }

        .page-header h2 {
            color: #087f8c;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .booking-card {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,.05);
        }

        .summary-box {
            background: #e7f6f7;
            border-left: 4px solid #087f8c;
            padding: 14px 18px;
            border-radius: 7px;
            margin-bottom: 20px;
        }

        .summary-count {
            font-size: 25px;
            font-weight: bold;
            color: #087f8c;
        }

        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .booking-table {
            width: 100%;
            min-width: 1000px;
            border-collapse: collapse;
        }

        .booking-table th {
            background: #087f8c;
            color: white;
            padding: 13px;
            white-space: nowrap;
        }

        .booking-table td {
            padding: 13px;
            border: 1px solid #e5e9ec;
            vertical-align: middle;
        }

        .booking-table tbody tr:hover {
            background: #f4fbfb;
        }

        .professional-name {
            color: #087f8c;
            font-weight: 600;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #fff3cd;
            color: #856404;
        }

        .btn-view {
            background: #087f8c;
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            white-space: nowrap;
        }

        .btn-view:hover {
            background: #066570;
            color: white;
        }

        .btn-search {
            background: #087f8c;
            color: white;
            border: none;
        }

        .btn-search:hover {
            background: #066570;
            color: white;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        .pagination-container a,
        .pagination-container span {
            display: inline-block;
            padding: 7px 12px;
            margin: 3px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            text-decoration: none;
        }

        .pagination-container a {
            color: #087f8c;
            background: white;
        }

        .pagination-container span {
            color: white;
            background: #087f8c;
        }

        .empty-message {
            text-align: center;
            padding: 35px;
            color: #777;
        }

        @media (max-width: 767px) {
            .page-container {
                margin: 15px auto;
                padding: 0 10px;
            }

            .page-header {
                padding: 17px;
            }

            .page-header h2 {
                font-size: 22px;
            }

            .booking-card {
                padding: 13px;
            }
        }
        /* Consultation booking filter layout */
.booking-card .row.g-3.mb-4 {
    display: grid;
    grid-template-columns: 1.2fr 0.8fr 1.5fr;
    gap: 18px;
    margin: 0 0 24px 0;
}

.booking-card .row.g-3.mb-4 > div {
    width: 100%;
    min-width: 0;
    padding: 0;
}

.booking-card .row.g-3.mb-4 > div:last-child {
    grid-column: 1 / -1;
}

/* Filter labels */
.booking-card .form-label {
    display: block;
    font-weight: 600;
    color: #263238;
    margin-bottom: 8px;
}

/* Dropdowns and search textbox */
.booking-card select.form-select,
.booking-card input.form-control {
    display: block;
    width: 100%;
    min-height: 44px;
    padding: 10px 12px;
    font-family: Arial, sans-serif;
    font-size: 15px;
    color: #263238;
    background-color: #fff;
    border: 1px solid #d5e0e5;
    border-radius: 7px;
    box-sizing: border-box;
}

/* Focus effect */
.booking-card select.form-select:focus,
.booking-card input.form-control:focus {
    border-color: #087f8c;
    outline: 0;
    box-shadow: 0 0 0 3px rgba(8, 127, 140, 0.12);
}

/* Buttons */
.booking-card .btn-search,
.booking-card .btn-outline-secondary {
    min-height: 42px;
    padding: 10px 22px;
    border-radius: 7px;
    font-weight: 600;
}

/* Mobile layout */
@media (max-width: 767px) {
    .booking-card .row.g-3.mb-4 {
        grid-template-columns: 1fr;
        gap: 14px;
    }

    .booking-card .row.g-3.mb-4 > div:last-child {
        grid-column: auto;
    }

    .booking-card .btn-search,
    .booking-card .btn-outline-secondary {
        padding: 9px 15px;
    }
}
/* Desktop table */
.booking-table {
    width: 100%;
    border-collapse: collapse;
}

.booking-table th,
.booking-table td {
    padding: 12px;
    vertical-align: middle;
}

/* Mobile: display each booking vertically as a card */
@media (max-width: 767px) {

    .table-responsive {
        overflow-x: visible;
    }

    .booking-table,
    .booking-table tbody,
    .booking-table tr,
    .booking-table td {
        display: block;
        width: 100%;
    }

    .booking-table {
        min-width: 0 !important;
        border: none;
    }

    .booking-table thead {
        display: none;
    }

    .booking-table tbody tr {
        background: #ffffff;
        border: 1px solid #dce5e9;
        border-radius: 12px;
        padding: 12px 15px;
        margin-bottom: 16px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
    }

    .booking-table tbody td {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 12px;
        width: 100%;
        padding: 10px 0;
        border: none;
        border-bottom: 1px solid #edf0f2;
        text-align: right;
        overflow-wrap: anywhere;
    }

    /* Add labels before each value */
    .booking-table tbody td:nth-child(1)::before {
        content: "Booking ID";
    }

    .booking-table tbody td:nth-child(2)::before {
        content: "Customer";
    }

    .booking-table tbody td:nth-child(3)::before {
        content: "Service";
    }

    .booking-table tbody td:nth-child(4)::before {
        content: "Professional";
    }

    .booking-table tbody td:nth-child(5)::before {
        content: "Contact";
    }

    .booking-table tbody td:nth-child(6)::before {
        content: "City";
    }

    .booking-table tbody td:nth-child(7)::before {
        content: "Booking Date";
    }

    .booking-table tbody td:nth-child(8)::before {
        content: "Status";
    }

    .booking-table tbody td:nth-child(9)::before {
        content: "Action";
    }

    .booking-table tbody td::before {
        flex: 0 0 105px;
        font-weight: 600;
        color: #52636b;
        text-align: left;
        overflow-wrap: normal;
    }

    .booking-table tbody td:last-child {
        border-bottom: none;
        padding-top: 14px;
    }

    .booking-table .professional-name {
        overflow-wrap: anywhere;
    }

    .btn-view {
        display: inline-block;
        white-space: normal;
        text-align: center;
    }

    .pagination-container {
        flex-wrap: wrap;
        gap: 4px;
    }
}
    </style></asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-container">

        <div class="page-header">
            <h2>Consultation Bookings</h2>

            <p class="text-muted mb-0">
                View customer bookings and the professionals selected
                for online consultations.
            </p>
        </div>

        <div class="booking-card">

            <!-- Filters -->

            <div class="row g-3 mb-4">

                <div class="col-12 col-md-4">
                    <label class="form-label fw-semibold">
                        Consultation Service
                    </label>

                    <asp:DropDownList ID="ddlService"
                        runat="server"
                        CssClass="form-select"
                        AppendDataBoundItems="true">

                        <asp:ListItem
                            Text="All Services"
                            Value="">
                        </asp:ListItem>

                    </asp:DropDownList>
                </div>

                <div class="col-12 col-md-3">
                    <label class="form-label fw-semibold">
                        Booking Status
                    </label>

                    <asp:DropDownList ID="ddlStatus"
                        runat="server"
                        CssClass="form-select">

                        <asp:ListItem Text="All Statuses"
                            Value="">
                        </asp:ListItem>

                        <asp:ListItem Text="Pending"
                            Value="Pending">
                        </asp:ListItem>

                        <asp:ListItem Text="Confirmed"
                            Value="Confirmed">
                        </asp:ListItem>

                        <asp:ListItem Text="Completed"
                            Value="Completed">
                        </asp:ListItem>

                        <asp:ListItem Text="Cancelled"
                            Value="Cancelled">
                        </asp:ListItem>

                    </asp:DropDownList>
                </div>

                <div class="col-12 col-md-5">
                    <label class="form-label fw-semibold">
                        Search Customer or Professional
                    </label>

                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="254"
                        placeholder="Name, email or contact number">
                    </asp:TextBox>
                </div>

                <div class="col-12">

                    <asp:Button ID="btnSearch"
                        runat="server"
                        Text="Search"
                        CssClass="btn btn-search me-2"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="btn btn-outline-secondary"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                </div>

            </div>

            <!-- Booking count -->

            <div class="summary-box">

                <div class="small text-muted">
                    Matching consultation bookings
                </div>

                <div class="summary-count">
                    <asp:Label ID="lblBookingCount"
                        runat="server"
                        Text="0">
                    </asp:Label>
                </div>

            </div>

            <asp:Label ID="lblMessage"
                runat="server"
                CssClass="d-block mb-3 text-danger">
            </asp:Label>

            <!-- Booking list -->

            <div class="table-responsive">

                <asp:ListView ID="lvBookings"
                    runat="server"
                    OnPagePropertiesChanging="lvBookings_PagePropertiesChanging">

                    <LayoutTemplate>

                        <table class="booking-table">

                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Customer Name</th>
                                    <th>Service</th>
                                    <th>Selected Professional</th>
                                    <th>Customer Contact</th>
                                    <th>City</th>
                                    <th>Booking Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr id="itemPlaceholder"
                                    runat="server">
                                </tr>
                            </tbody>

                        </table>

                    </LayoutTemplate>

                    <ItemTemplate>

                        <tr>

                            <td>
                                <%#: Eval("BookingID") %>
                            </td>

                            <td>
                                <strong>
                                    <%#: Eval("CustomerName") %>
                                </strong>
                            </td>

                            <td>
                                <%#: Eval("ServiceName") %>
                            </td>

                            <td>
                                <span class="professional-name">
                                    <%#: Eval("ProfessionalName") %>
                                </span>

                                <br />

                                <small class="text-muted">
                                    Caregiver ID:
                                    <%#: Eval("CaregiverID") %>
                                </small>
                            </td>

                            <td>
                                <%#: Eval("ContactNumber") %>
                            </td>

                            <td>
                                <%#: Eval("City") %>
                            </td>

                            <td>
                                <%# Eval(
                                    "CreatedDate",
                                    "{0:dd-MMM-yyyy}") %>
                            </td>

                            <td>
                                <span class="status-badge">
                                    <%#: Eval("BookingStatus") %>
                                </span>
                            </td>

                            <td>

                                <asp:HyperLink ID="lnkView"
                                    runat="server"
                                    CssClass="btn-view"
                                    Text="View Details"
                                    NavigateUrl='<%# "ConsultationBookingDetails.aspx?id=" + Eval("BookingID") %>'>
                                </asp:HyperLink>

                            </td>

                        </tr>

                    </ItemTemplate>

                    <EmptyDataTemplate>

                        <div class="empty-message">
                            <h5>No consultation bookings found.</h5>

                            <p class="mb-0">
                                Try changing the selected service
                                or search filters.
                            </p>
                        </div>

                    </EmptyDataTemplate>

                </asp:ListView>

            </div>

            <!-- Pagination -->

            <div class="pagination-container">

                <asp:DataPager ID="dpBookings"
                    runat="server"
                    PagedControlID="lvBookings"
                    PageSize="10">

                    <Fields>

                        <asp:NextPreviousPagerField
                            ShowFirstPageButton="true"
                            ShowPreviousPageButton="true"
                            ShowNextPageButton="false"
                            ShowLastPageButton="false"
                            ButtonType="Link" />

                        <asp:NumericPagerField
                            ButtonCount="5"
                            ButtonType="Link" />

                        <asp:NextPreviousPagerField
                            ShowFirstPageButton="false"
                            ShowPreviousPageButton="false"
                            ShowNextPageButton="true"
                            ShowLastPageButton="true"
                            ButtonType="Link" />

                    </Fields>

                </asp:DataPager>

            </div>

        </div>

    </div>

</asp:Content>