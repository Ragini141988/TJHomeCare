<%@ Page Title="Home Care Enquiries"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="HomeCareEnquiryAdmin.aspx.cs"
    Inherits="TJHomeCare.HomeCareEnquiryAdmin"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

   

<style>
    /* =========================================
       MAIN PAGE
    ========================================= */

    .hca-page {
        padding: 24px 15px;
        background: #e9edf3;
        min-height: 80vh;
        color: #1f2937;
    }

    .hca-container {
        max-width: 1200px;
        margin: 0 auto;
    }

    .hca-title {
        font-size: 28px;
        font-weight: 700;
        color: #111827;
        margin: 0 0 6px;
    }

    .hca-subtitle {
        color: #374151;
        font-size: 15px;
        line-height: 1.5;
        margin: 0 0 20px;
    }

    /* =========================================
       FILTER SECTION
    ========================================= */

    .hca-filter {
        display: flex;
        align-items: flex-end;
        gap: 12px;
        flex-wrap: wrap;
        padding: 16px;
        background: #ffffff;
        border: 1px solid #b8c2cf;
        border-radius: 12px;
        margin-bottom: 16px;
        box-shadow: 0 2px 6px rgba(31, 41, 55, 0.07);
    }

    .hca-filter-field {
        flex: 1;
        min-width: 220px;
    }

    .hca-label {
        display: block;
        margin: 0 0 6px;
        font-size: 14px;
        font-weight: 600;
        color: #1f2937;
    }

    .hca-input {
        display: block;
        width: 100%;
        box-sizing: border-box;
        min-height: 42px;
        padding: 9px 11px;
        border: 1px solid #9ca8b7;
        border-radius: 7px;
        background: #ffffff;
        color: #111827;
        font-size: 14px;
        font-family: inherit;
    }

    .hca-input:focus {
        outline: none;
        border-color: #087f5b;
        box-shadow: 0 0 0 2px rgba(8, 127, 91, 0.15);
    }

    .hca-button {
        min-height: 42px;
        padding: 9px 18px;
        border: 1px solid #08704f;
        border-radius: 7px;
        background: #087f5b;
        color: #ffffff;
        font-size: 14px;
        font-weight: 700;
        font-family: inherit;
        cursor: pointer;
    }

    .hca-button:hover {
        background: #065f46;
    }

    /* =========================================
       TOTAL RECORDS
    ========================================= */

    .hca-count {
        display: block;
        margin: 12px 0;
        color: #1f2937;
        font-size: 15px;
        font-weight: 700;
    }

    /* =========================================
       ENQUIRY CARD
    ========================================= */

    .hca-card {
        box-sizing: border-box;
        width: 100%;
        background: #ffffff;
        border: 1px solid #b8c2cf;
        border-radius: 11px;
        padding: 16px 20px;
        margin: 0 0 12px;
        box-shadow: 0 2px 6px rgba(31, 41, 55, 0.07);
    }

    .hca-card-header {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 12px;
        border-bottom: 1px solid #cbd5e1;
        padding: 0 0 11px;
        margin: 0 0 14px;
    }

    .hca-customer {
        margin: 0 0 4px;
        color: #111827;
        font-size: 19px;
        font-weight: 700;
        line-height: 1.35;
        overflow-wrap: anywhere;
    }

    .hca-id {
        color: #4b5563;
        font-size: 12px;
        line-height: 1.5;
    }

    /* =========================================
       SERVICE CATEGORY BADGE
    ========================================= */

    .hca-service {
        display: inline-block;
        padding: 6px 10px;
        border: 1px solid #86c5a5;
        border-radius: 20px;
        background: #d9f3e5;
        color: #14532d;
        font-size: 12px;
        font-weight: 700;
        line-height: 1.4;
        overflow-wrap: anywhere;
    }

    /* =========================================
       CUSTOMER DETAILS
    ========================================= */

    .hca-details {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 13px 24px;
    }

    .hca-details > div {
        min-width: 0;
        margin: 0;
        padding: 0;
    }

    .hca-detail-label {
        display: block;
        margin: 0 0 3px;
        color: #4b5563;
        font-size: 11px;
        font-weight: 700;
        line-height: 1.4;
        text-transform: uppercase;
        letter-spacing: 0.2px;
    }

    .hca-detail-value {
        display: block;
        margin: 0;
        padding: 0;
        color: #111827;
        font-size: 14px;
        font-weight: 400;
        line-height: 1.4;
        overflow-wrap: anywhere;
        white-space: pre-wrap;
    }

    .hca-detail-value a {
        display: inline;
        margin: 0;
        padding: 0;
        color: #075eaa;
        font-size: inherit;
        font-weight: 600;
        line-height: inherit;
        text-decoration: underline;
    }

    /* =========================================
       ADDITIONAL REQUIREMENTS
    ========================================= */

    .hca-details > div[style*="grid-column"] {
        grid-column: 1 / -1;
    }

    /* =========================================
       CALLBACK STATUS AND REMARKS
    ========================================= */

    .hca-status-section {
        border-top: 1px solid #cbd5e1;
        padding-top: 13px;
        margin-top: 15px;
    }

    .hca-status-row {
        display: flex;
        align-items: flex-end;
        gap: 12px;
        flex-wrap: wrap;
    }

    .hca-status-field {
        flex: 1;
        min-width: 180px;
    }

    .hca-status-field .hca-label {
        margin-bottom: 5px;
    }

    .hca-status-field textarea.hca-input {
        min-height: 64px;
        resize: vertical;
    }

    /* =========================================
       PAGINATION
    ========================================= */

    .hca-pager {
        padding: 14px 5px;
        text-align: center;
        color: #065f46;
    }

    .hca-pager a,
    .hca-pager span {
        display: inline-block;
        box-sizing: border-box;
        min-width: 34px;
        padding: 7px 10px;
        margin: 2px;
        border: 1px solid #9ca8b7;
        border-radius: 6px;
        background: #ffffff;
        color: #1f2937;
        font-size: 13px;
        text-decoration: none;
    }

    .hca-pager a:hover {
        background: #d9f3e5;
        border-color: #087f5b;
    }

    .hca-pager span {
        background: #087f5b;
        border-color: #087f5b;
        color: #ffffff;
    }

    /* =========================================
       EMPTY RECORDS
    ========================================= */

    .hca-empty {
        padding: 25px 16px;
        background: #ffffff;
        border: 1px solid #b8c2cf;
        border-radius: 11px;
        text-align: center;
        color: #374151;
    }

    .hca-empty h3 {
        margin: 0 0 8px;
        color: #111827;
    }

    .hca-empty p {
        margin: 0;
        line-height: 1.5;
    }

    /* =========================================
       SUCCESS AND ERROR MESSAGES
    ========================================= */

    .hca-message {
        display: block;
        margin: 12px 0;
        padding: 10px 12px;
        border-radius: 7px;
        font-size: 14px;
        line-height: 1.5;
        font-weight: 600;
    }

    .hca-success {
        color: #14532d;
        background: #d9f3e5;
        border: 1px solid #86c5a5;
    }

    .hca-error {
        color: #991b1b;
        background: #fee2e2;
        border: 1px solid #fca5a5;
    }

    /* =========================================
       TABLET AND MOBILE
    ========================================= */

    @media (max-width: 768px) {

        .hca-page {
            padding: 15px 10px;
        }

        .hca-title {
            font-size: 24px;
        }

        .hca-filter {
            padding: 13px;
            gap: 10px;
        }

        .hca-filter-field {
            min-width: 100%;
        }

        .hca-filter .hca-button {
            flex: 1;
        }

        .hca-card {
            padding: 13px;
            margin-bottom: 10px;
        }

        .hca-card-header {
            gap: 8px;
            padding-bottom: 9px;
            margin-bottom: 12px;
        }

        .hca-customer {
            font-size: 18px;
        }

        .hca-service {
            max-width: 145px;
            font-size: 11px;
            padding: 5px 7px;
        }

        .hca-details {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px 14px;
        }

        .hca-detail-label {
            font-size: 10px;
            margin-bottom: 2px;
        }

        .hca-detail-value {
            font-size: 14px;
            line-height: 1.4;
        }

        .hca-status-section {
            margin-top: 12px;
            padding-top: 12px;
        }

        .hca-status-row {
            gap: 10px;
        }
    }
    
.im-match-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.im-caregiver-card {
    padding: 16px;
    background: #ffffff;
    border: 1px solid #d1d5db;
    border-radius: 10px;
    color: #1f2937;
}

.im-card-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 10px;
    margin-bottom: 8px;
}

.im-caregiver-name {
    font-size: 19px;
    font-weight: 700;
    color: #111827;
    overflow-wrap: anywhere;
}

.im-selected-badge {
    padding: 5px 9px;
    border-radius: 15px;
    background: #e0f2e9;
    color: #166534;
    font-size: 12px;
    font-weight: 600;
    overflow-wrap: anywhere;
}

.im-service {
    margin-bottom: 12px;
    padding-bottom: 10px;
    border-bottom: 1px solid #e5e7eb;
    color: #4b5563;
    font-size: 13px;
}

.im-details {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px 16px;
}

.im-details > div {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 3px;
    min-width: 0;
    margin: 0;
    padding: 0;
}

.im-label {
    display: block;
    margin: 0;
    color: #4b5563;
    font-size: 11px;
    font-weight: 700;
    line-height: 1.4;
}

.im-details > div > span:last-child {
    color: #111827;
    font-size: 14px;
    line-height: 1.4;
    overflow-wrap: anywhere;
    white-space: pre-wrap;
}

.im-details a {
    color: #075eaa;
    text-decoration: underline;
}

.im-status-section {
    display: flex;
    flex-direction: column;
    align-items: stretch;
    gap: 7px;
    margin-top: 16px;
    padding-top: 12px;
    border-top: 1px solid #d1d5db;
}

.im-input {
    width: 100%;
    box-sizing: border-box;
    padding: 9px 10px;
    border: 1px solid #9ca3af;
    border-radius: 6px;
    background: #ffffff;
    color: #111827;
    font-family: inherit;
    font-size: 14px;
}

.im-button {
    padding: 10px 15px;
    border: none;
    border-radius: 6px;
    background: #087f5b;
    color: #ffffff;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
}

.im-button:hover {
    background: #065f46;
}

.im-empty {
    padding: 20px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    background: #ffffff;
    color: #374151;
    text-align: center;
}

.im-page-link,
.im-page-current {
    display: inline-block;
    margin: 3px;
    padding: 7px 11px;
    border: 1px solid #d1d5db;
    border-radius: 5px;
    text-decoration: none;
}

.im-page-link {
    background: #ffffff;
    color: #1f2937;
}

.im-page-current {
    background: #087f5b;
    color: #ffffff;
}

@media (max-width: 480px) {
    .im-caregiver-card {
        padding: 12px;
    }

    .im-card-header {
        gap: 6px;
    }

    .im-caregiver-name {
        font-size: 17px;
    }

    .im-selected-badge {
        max-width: 120px;
        font-size: 10px;
    }

    .im-details {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 12px 10px;
    }

    .im-details > div {
        gap: 3px;
    }

    .im-label {
        font-size: 10px;
    }

    .im-details > div > span:last-child {
        font-size: 13px;
    }

    .im-status-section {
        margin-top: 12px;
    }

    .im-button {
        width: 100%;
    }
}

    /* =========================================
       SMALL MOBILE SCREENS
    ========================================= */

@media (max-width: 480px) {

    .hca-page {
        padding: 10px 7px;
    }

    .hca-container {
        width: 100%;
        max-width: 100%;
    }

    .hca-title {
        font-size: 22px;
        margin-bottom: 5px;
    }

    .hca-subtitle {
        font-size: 13px;
        margin-bottom: 12px;
    }

    .hca-card {
        padding: 12px;
        margin-bottom: 10px;
        border-radius: 9px;
    }

    .hca-card-header {
        display: flex;
        flex-direction: row;
        align-items: flex-start;
        justify-content: space-between;
        gap: 8px;
        padding-bottom: 9px;
        margin-bottom: 12px;
    }

    .hca-customer {
        font-size: 17px;
        margin-bottom: 3px;
    }

    .hca-id {
        font-size: 11px;
    }

    .hca-service {
        max-width: 120px;
        font-size: 10px;
        padding: 5px 7px;
    }

    /* Customer details: compact two-column layout */
    .hca-details {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        align-items: start;
        gap: 14px 12px;
    }

    .hca-details > div {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: flex-start;
        min-width: 0;
        margin: 0;
        padding: 0;
    }

    .hca-detail-label {
        display: block;
        margin: 0 0 5px;
        font-size: 10px;
        line-height: 1.4;
        font-weight: 700;
    }

    .hca-detail-value {
        display: block;
        width: 100%;
        margin: 0;
        padding: 0;
        font-size: 13px;
        line-height: 1.4;
        text-align: left;
        overflow-wrap: anywhere;
        white-space: pre-wrap;
    }

    .hca-detail-value a {
        display: inline;
        margin: 0;
        padding: 0;
        line-height: inherit;
    }

    /* Additional requirements and remarks span full width */
    .hca-details > div[style*="grid-column"] {
        grid-column: 1 / -1;
    }

    .hca-status-section {
        margin-top: 13px;
        padding-top: 12px;
    }

    .hca-status-row {
        display: flex;
        flex-direction: column;
        align-items: stretch;
        gap: 10px;
    }

    .hca-status-field {
        width: 100%;
        min-width: 0;
    }

    .hca-input {
        min-height: 42px;
        font-size: 14px;
    }

    .hca-status-field textarea.hca-input {
        min-height: 60px;
    }

    .hca-status-row .hca-button {
        width: 100%;
    }
}

</style>



    <div class="hca-page">

        <div class="hca-container">

            <h1 class="hca-title">
                Customer Enquiries
            </h1>

            <p class="hca-subtitle">
                View customer requirements, filter by service,
                and manage callback follow-ups.
            </p>

            <asp:Label ID="lblAdminMessage"
                runat="server"
                Visible="false"
                CssClass="hca-message" />

            <div class="hca-filter">

                <div class="hca-filter-field">

                    <label class="hca-label"
                        for="<%= ddlFilterService.ClientID %>">
                        Filter by Service Category
                    </label>

                    <asp:DropDownList
                        ID="ddlFilterService"
                        runat="server"
                        CssClass="hca-input"
                        AutoPostBack="false" />

                </div>

                <asp:Button ID="btnFilter"
                    runat="server"
                    Text="Apply Filter"
                    CssClass="hca-button"
                    OnClick="btnFilter_Click" />

                <asp:Button ID="btnReset"
                    runat="server"
                    Text="Show All"
                    CssClass="hca-button"
                    CausesValidation="false"
                    OnClick="btnReset_Click" />

            </div>

            <asp:Label ID="lblRecordCount"
                runat="server"
                CssClass="hca-count" />


<asp:ListView ID="lvEnquiries" runat="server"
    OnPagePropertiesChanging="lvEnquiries_PagePropertiesChanging"
    OnItemCommand="lvEnquiries_ItemCommand">

    <LayoutTemplate>
        <div class="im-match-list">
            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
        </div>
    </LayoutTemplate>

    <ItemTemplate>
        <article class="im-caregiver-card">

            <div class="im-card-header">
                <div class="im-caregiver-name">
                    <%#: Eval("FullName") %>
                </div>

                <span class="im-selected-badge">
                    <%#: Eval("ServiceName") %>
                </span>
            </div>

            <div class="im-service">
                Enquiry #<%#: Eval("EnquiryID") %>
                |
                <%#: Eval("CreatedDate", "{0:dd MMM yyyy, hh:mm tt}") %>
            </div>

            <div class="im-details">

                <div>
                    <span class="im-label">Mobile / WhatsApp</span>
                    <span> <a href='https://wa.me/91<%#: Eval("MobileNumber") %>'target="_blank"><%#: Eval("MobileNumber") %></a></span>
                </div>

                <div>
                    <span class="im-label">City</span>
                    <span><%#: Eval("City") %></span>
                </div>

                <div>
                    <span class="im-label">Area / Locality</span>
                    <span><%#: Eval("Area") %></span>
                </div>

                <div>
                    <span class="im-label">Duty Hours</span>
                    <span><%#: Eval("DutyHours") %></span>
                </div>

                <div>
                    <span class="im-label">Service Required</span>
                    <span><%#: Eval("ServiceName") %></span>
                </div>

                <div>
                    <span class="im-label">When Required</span>
                    <span><%#: Eval("RequiredWhen") %></span>
                </div>

                <div>
                    <span class="im-label">Current Callback Status</span>
                    <span><%#: Eval("CallbackStatus") %></span>
                </div>

                <div>
                    <span class="im-label">Additional Requirements</span>
                    <span><%#: Eval("AdditionalRequirements") %></span>
                </div>

                <div>
                    <span class="im-label">Admin Remarks</span>
                    <span><%#: Eval("AdminRemarks") %></span>
                </div>

            </div>

            <div class="im-status-section">

                <asp:Label ID="lblUpdateStatus" runat="server"
                    CssClass="im-label"
                    Text="Update Callback Status" />

                <asp:DropDownList ID="ddlCallbackStatus" runat="server"
                    CssClass="im-input">
                    <asp:ListItem Text="Pending" Value="Pending" />
                    <asp:ListItem Text="Contacted" Value="Contacted" />
                    <asp:ListItem Text="In Progress" Value="In Progress" />
                    <asp:ListItem Text="Completed" Value="Completed" />
                    <asp:ListItem Text="Cancelled" Value="Cancelled" />
                </asp:DropDownList>

                <asp:Label ID="lblAdminRemarks" runat="server"
                    CssClass="im-label"
                    Text="Admin Remarks" />

                <asp:TextBox ID="txtAdminRemarks" runat="server"
                    CssClass="im-input"
                    TextMode="MultiLine"
                    Rows="2" />

                <asp:Button ID="btnUpdateStatus" runat="server"
                    Text="Update Enquiry"
                    CssClass="im-button"
                    CommandName="UpdateEnquiry"
                    CommandArgument='<%# Eval("EnquiryID") %>' />

            </div>

        </article>
    </ItemTemplate>

    <EmptyDataTemplate>
        <div class="im-empty">
            No customer enquiries found.
        </div>
    </EmptyDataTemplate>

</asp:ListView>

<asp:DataPager ID="dpEnquiries" runat="server"
    PagedControlID="lvEnquiries"
    PageSize="10">

    <Fields>
        <asp:NumericPagerField
            ButtonCount="5"
            NumericButtonCssClass="im-page-link"
            CurrentPageLabelCssClass="im-page-current"
            NextPreviousButtonCssClass="im-page-link" />
    </Fields>

</asp:DataPager>


        </div>

    </div>

</asp:Content>