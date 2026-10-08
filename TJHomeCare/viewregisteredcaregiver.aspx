<%@ Page Title="Registered Caregivers"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="viewregisteredcaregiver.aspx.cs"
    Inherits="TJHomeCare.viewregisteredcaregiver" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="TitleContent"
    runat="server">
    Registered Caregivers
</asp:Content>


<asp:Content ID="Content2"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <style>

        .caregiver-page {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px 15px 40px;
        }

        .page-heading {
            margin-bottom: 20px;
        }

        .page-heading h2 {
            margin: 0;
            font-size: 26px;
            font-weight: 700;
        }

        .page-heading p {
            margin: 5px 0 0;
            color: #666;
            font-size: 14px;
        }


        /* ==========================
           FILTER SECTION
           ========================== */

        .filter-box {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }

        .filter-title {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .filter-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .filter-control {
            width: 100%;
            height: 40px;
            border: 1px solid #d7d7d7;
            border-radius: 7px;
            padding: 0 10px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-search {
            border: none;
            background: #0d6efd;
            color: #fff;
            padding: 9px 20px;
            border-radius: 7px;
            cursor: pointer;
        }

        .btn-clear {
            border: 1px solid #ccc;
            background: #fff;
            color: #333;
            padding: 9px 20px;
            border-radius: 7px;
            cursor: pointer;
        }


        /* ==========================
           CAREGIVER CARD
           ========================== */

        .caregiver-list {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .caregiver-card {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }

        .caregiver-top {
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }

        .aadhar-photo {
            width: 125px;
            height: 90px;
            object-fit: cover;
            border-radius: 7px;
            border: 1px solid #ddd;
            background: #f5f5f5;
            flex-shrink: 0;
        }

        .caregiver-basic {
            flex: 1;
            min-width: 0;
        }

        .caregiver-name {
            font-size: 19px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .caregiver-meta {
            color: #666;
            font-size: 13px;
            line-height: 1.7;
        }

        .caregiver-details {
            margin-top: 14px;
            padding-top: 12px;
            border-top: 1px solid #eee;
        }

        .detail-row {
            display: flex;
            margin-bottom: 7px;
            font-size: 13px;
        }

        .detail-label {
            width: 125px;
            font-weight: 600;
            color: #555;
            flex-shrink: 0;
        }

        .detail-value {
            color: #333;
            flex: 1;
        }

        .status {
            display: inline-block;
            padding: 4px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-verified {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-rejected {
            background: #f8d7da;
            color: #842029;
        }

        .view-button {
            display: inline-block;
            margin-top: 12px;
            padding: 8px 16px;
            background: #0d6efd;
            color: #fff !important;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
        }

        .no-records {
            padding: 35px 15px;
            text-align: center;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            color: #777;
        }


        /* ==========================
           PAGINATION
           ========================== */

        .pager {
            text-align: center;
            margin-top: 25px;
        }

        .pager a,
        .pager span {
            display: inline-block;
            padding: 7px 12px;
            margin: 2px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
        }

        .pager span {
            background: #0d6efd;
            color: #fff;
            border-color: #0d6efd;
        }


        /* ==========================
           MOBILE
           ========================== */

        @media (max-width: 768px) {

            .caregiver-page {
                padding: 15px 10px 30px;
            }

            .page-heading h2 {
                font-size: 22px;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .filter-buttons {
                display: grid;
                grid-template-columns: 1fr 1fr;
            }

            .caregiver-list {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .caregiver-card {
                padding: 12px;
            }

            .caregiver-top {
                gap: 10px;
            }

            .aadhar-photo {
                width: 105px;
                height: 75px;
            }

            .caregiver-name {
                font-size: 17px;
            }

            .detail-row {
                display: block;
            }

            .detail-label {
                width: auto;
                display: block;
                margin-bottom: 2px;
            }

            .detail-value {
                display: block;
            }
        }


        @media (max-width: 420px) {

            .caregiver-top {
                align-items: flex-start;
            }

            .aadhar-photo {
                width: 95px;
                height: 68px;
            }

            .caregiver-name {
                font-size: 16px;
            }

            .caregiver-meta {
                font-size: 12px;
            }

            .filter-buttons {
                grid-template-columns: 1fr;
            }
        }

    </style>

</asp:Content>


<asp:Content ID="Content3"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>


<asp:Content ID="Content4"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="caregiver-page">

        <!-- PAGE HEADING -->

        <div class="page-heading">

            <h2>Registered Caregivers</h2>

            <p>
                Search and view registered caregiver profiles.
            </p>

        </div>


        <!-- FILTERS -->

        <div class="filter-box">

            <div class="filter-title">
                Search Caregivers
            </div>


            <div class="filter-grid">

                <!-- SERVICE CATEGORY -->

                <div class="filter-group">

                    <label>
                        Service Category
                    </label>

                    <asp:DropDownList
                        ID="ddlServiceCategory"
                        runat="server"
                        CssClass="filter-control">

                        <asp:ListItem
                            Text="All Service Categories"
                            Value="">

                        </asp:ListItem>
                           <asp:ListItem
                            Text="Baby Caretaker"
                            Value="Baby Caretaker">

                        </asp:ListItem>
                           <asp:ListItem
                            Text="Patient Caretaker"
                            Value="Patient Caretaker">

                        </asp:ListItem>

                         <asp:ListItem
                            Text="Elder Caretaker"
                            Value="Elder Caretaker">

                        </asp:ListItem>
                         <asp:ListItem
                            Text="Home Nurseker"
                            Value="Home Nurse">

                        </asp:ListItem>


                    </asp:DropDownList>

                </div>


                <!-- CITY -->

                <div class="filter-group">

                    <label>
                        City
                    </label>

                    <asp:DropDownList
                        ID="ddlCity"
                        runat="server"
                        CssClass="filter-control">

                        <asp:ListItem
                            Text="All Cities"
                            Value="">
                        </asp:ListItem>

                    </asp:DropDownList>

                </div>


                <!-- RECRUITER -->

                <div class="filter-group">

                    <label>
                        Recruiter
                    </label>

                    <asp:DropDownList
                        ID="ddlRecruiter"
                        runat="server"
                        CssClass="filter-control">

                        <asp:ListItem
                            Text="All Recruiters"
                            Value="">
                        </asp:ListItem>

                    </asp:DropDownList>

                </div>


                <!-- FROM DATE -->

                <div class="filter-group">

                    <label>
                        From Date
                    </label>

                    <asp:TextBox
                        ID="txtFromDate"
                        runat="server"
                        CssClass="filter-control"
                        TextMode="Date">
                    </asp:TextBox>

                </div>


                <!-- TO DATE -->

                <div class="filter-group">

                    <label>
                        To Date
                    </label>

                    <asp:TextBox
                        ID="txtToDate"
                        runat="server"
                        CssClass="filter-control"
                        TextMode="Date">
                    </asp:TextBox>

                </div>

            </div>


            <div class="filter-buttons">

                <asp:Button
                    ID="btnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="btn-search"
                    OnClick="btnSearch_Click" />

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear"
                    CssClass="btn-clear"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

            </div>

        </div>


        <!-- CAREGIVER LIST -->

        <div class="caregiver-list">

            <asp:ListView
                ID="lvCaregivers"
                runat="server"
                OnPagePropertiesChanging="lvCaregivers_PagePropertiesChanging">

                <LayoutTemplate>

                    <asp:PlaceHolder
                        ID="itemPlaceholder"
                        runat="server">
                    </asp:PlaceHolder>

                </LayoutTemplate>


                <ItemTemplate>

                    <div class="caregiver-card">

                        <div class="caregiver-top">

                            <!-- AADHAR PHOTO -->

                            <asp:Image
                                ID="imgProfilePhoto"
                                runat="server"
                                CssClass="aadhar-photo"
                                ImageUrl='<%# GetAadharImage(Container.DataItem) %>'
                                AlternateText="Profile Photo" />


                            <div class="caregiver-basic">

                                <div class="caregiver-name">

                                    <%# Eval("FullName") %>

                                </div>


                                <div class="caregiver-meta">

                                    <%# Eval("Age") %> years
                                    &nbsp; | &nbsp;
                                    <%# Eval("Gender") %>

                                    <br />

                                    <%# Eval("City") %>

                                    <br />

                                    Experience:
                                    <%# Eval("Experience") %>

                                </div>

                            </div>

                        </div>


                        <div class="caregiver-details">

                            <div class="detail-row">

                                <div class="detail-label">
                                    Service Category
                                </div>

                                <div class="detail-value">
                                    <%# Eval("ServiceCategory") %>
                                </div>

                            </div>


                            <div class="detail-row">

                                <div class="detail-label">
                                    Duty Preference
                                </div>

                                <div class="detail-value">
                                    <%# Eval("DutyPreference") %>
                                </div>

                            </div>


                            <div class="detail-row">

                                <div class="detail-label">
                                    Recruiter
                                </div>

                                <div class="detail-value">
                                    <%# Eval("RecruiterName") %>
                                </div>

                            </div>


                            <div class="detail-row">

                                <div class="detail-label">
                                    Status
                                </div>

                                <div class="detail-value">

                                    <span class='<%# GetStatusClass(Eval("VerificationStatus")) %>'>
                                        <%# Eval("VerificationStatus") %>
                                    </span>

                                </div>

                            </div>


                            <div class="detail-row">

                                <div class="detail-label">
                                    Registered
                                </div>

                                <div class="detail-value">
                                    <%# Eval("CreatedDate", "{0:dd-MMM-yyyy}") %>
                                </div>

                            </div>


                            <a
                                class="view-button"
                                href='<%# "viewcaregiverdetails.aspx?id=" + Eval("CaregiverID") %>'>

                                View Details

                            </a>

                        </div>

                    </div>

                </ItemTemplate>


                <EmptyDataTemplate>

                    <div class="no-records">

                        No caregivers found.

                    </div>

                </EmptyDataTemplate>

            </asp:ListView>

        </div>


        <!-- PAGINATION -->

        <div class="pager">

            <asp:DataPager
                ID="dpCaregivers"
                runat="server"
                PagedControlID="lvCaregivers"
                PageSize="10">

                <Fields>

                    <asp:NumericPagerField
                        ButtonCount="5"
                        NextPageText="Next"
                        PreviousPageText="Previous" />

                </Fields>

            </asp:DataPager>

        </div>

    </div>

</asp:Content>


