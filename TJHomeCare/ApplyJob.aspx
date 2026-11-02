<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplyJob.aspx.cs" Inherits="TJHomeCare.ApplyJob" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Apply for Job
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style>
        .apply-container {
            max-width: 650px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border: 1px solid #e3eaf2;
            border-radius: 14px;
            box-shadow: 0 5px 18px rgba(23,54,93,.08);
        }

        .apply-container h2 {
            color: #17365d;
            margin-bottom: 20px;
        }

        .apply-container .form-control {
            margin-top: 7px;
        }

        .apply-detail {
            margin: 12px 0;
            color: #536174;
        }

        .apply-message {
            display: block;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .apply-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 22px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<div class="container">

        <div class="apply-container">

            <h2>Apply for Job</h2>

            <asp:Label ID="lblMessage" runat="server"
                CssClass="apply-message"
                EnableViewState="false" />

            <div class="apply-detail">
                <strong>Service:</strong>
                <asp:Label ID="lblService" runat="server" />
            </div>

            <div class="apply-detail">
                <strong>Location:</strong>
                <asp:Label ID="lblLocation" runat="server" />
            </div>

            <div class="apply-detail">
                <strong>Duty Time:</strong>
                <asp:Label ID="lblDutyTime" runat="server" />
            </div>

            <div class="apply-detail">
                <strong>Budget:</strong>
                ₹<asp:Label ID="lblBudget" runat="server" />
            </div>

            <hr />

            <div class="form-group">
                <asp:Label ID="lblApplicantName" runat="server"
                    AssociatedControlID="txtApplicantName"
                    Text="Your Name" />

                <asp:TextBox ID="txtApplicantName" runat="server"
                    CssClass="form-control"
                    MaxLength="100" />
            </div>

            <br />

            <div class="form-group">
                <asp:Label ID="lblApplicantMobile" runat="server"
                    AssociatedControlID="txtApplicantMobile"
                    Text="Mobile Number" />

                <asp:TextBox ID="txtApplicantMobile" runat="server"
                    CssClass="form-control"
                    MaxLength="10"
                    TextMode="SingleLine" />
            </div>
            

<!-- Gender -->
<div class="form-group">
    <asp:Label ID="lblGender" runat="server"
        AssociatedControlID="ddlGender"
        Text="Gender" />

    <asp:DropDownList ID="ddlGender" runat="server"
        CssClass="form-control">
        <asp:ListItem Text="-- Select Gender --" Value="" />
        <asp:ListItem Text="Male" Value="Male" />
        <asp:ListItem Text="Female" Value="Female" />
        <asp:ListItem Text="Other" Value="Other" />
    </asp:DropDownList>
</div>

<!-- Age -->
<div class="form-group">
    <asp:Label ID="lblApplicantAge" runat="server"
        AssociatedControlID="ddlApplicantAge"
        Text="Your Age" />

    <asp:DropDownList ID="ddlApplicantAge" runat="server"
        CssClass="form-control">
        <asp:ListItem Text="-- Select Your Age --" Value="" />
        <asp:ListItem Text="18 Years - 20 Years" Value="18-20" />
        <asp:ListItem Text="21 Years - 25 Years" Value="21-25" />
        <asp:ListItem Text="26 Years - 30 Years" Value="26-30" />
        <asp:ListItem Text="31 Years - 35 Years" Value="31-35" />
        <asp:ListItem Text="36 Years - 40 Years" Value="36-40" />
        <asp:ListItem Text="41 Years - 45 Years" Value="41-45" />
        <asp:ListItem Text="46 Years - 50 Years" Value="46-50" />
        <asp:ListItem Text="50+ Years" Value="50+" />
    </asp:DropDownList>
</div>
            <div class="apply-buttons">

                <asp:Button ID="btnApply" runat="server"
                    Text="Submit Application"
                    CssClass="btn btn-primary"
                    OnClick="btnApply_Click" />

                <asp:HyperLink ID="lnkBack" runat="server"
                    NavigateUrl="~/ViewJobs.aspx"
                    CssClass="btn btn-secondary">
                    Back to Jobs
                </asp:HyperLink>

            </div>

        </div>

    </div>
</asp:Content>
