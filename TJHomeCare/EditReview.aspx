<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditReview.aspx.cs" Inherits="TJHomeCare.EditReview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Customer Review
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .edit-review-page {
            background: #f5f8fc;
            padding: 35px 12px 50px;
            min-height: 600px;
        }

        .edit-review-card {
            max-width: 760px;
            margin: 0 auto;
            background: #fff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 5px 22px rgba(23, 54, 93, .09);
        }

        .edit-review-title {
            color: #17365d;
            font-size: 27px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .edit-review-subtitle {
            color: #6b7280;
            margin-bottom: 25px;
        }

        .review-form-group {
            margin-bottom: 18px;
        }

        .review-form-group label {
            display: block;
            color: #17365d;
            font-weight: 600;
            margin-bottom: 7px;
        }

        .review-input {
            width: 100%;
            padding: 11px 13px;
            border: 1px solid #d9e2ec;
            border-radius: 8px;
            box-sizing: border-box;
            outline: none;
        }

        .review-input:focus {
            border-color: #1769aa;
            box-shadow: 0 0 0 3px rgba(23, 105, 170, .10);
        }

        textarea.review-input {
            min-height: 120px;
            resize: vertical;
        }

        .review-form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .review-save-btn,
        .review-cancel-btn {
            display: inline-block;
            padding: 11px 22px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none !important;
            cursor: pointer;
            border: none;
        }

        .review-save-btn {
            color: #fff;
            background: #1769aa;
        }

        .review-save-btn:hover {
            background: #12558b;
            color: #fff;
        }

        .review-cancel-btn {
            color: #17365d;
            background: #e8edf3;
        }

        .review-cancel-btn:hover {
            background: #dbe3ec;
            color: #17365d;
        }

        .edit-review-message {
            display: block;
            margin-bottom: 18px;
            font-weight: 600;
        }

        .validation-error {
            color: #dc3545;
            font-size: 13px;
        }

        @media (max-width: 576px) {
            .edit-review-card {
                padding: 20px 16px;
            }

            .edit-review-title {
                font-size: 23px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container edit-review-page">

        <div class="edit-review-card">

            <h2 class="edit-review-title">Edit Customer Review</h2>
            <p class="edit-review-subtitle">
                Update the customer information and review details below.
            </p>

            <asp:Label ID="lblMessage" runat="server"
                CssClass="edit-review-message"
                EnableViewState="false" />

            <asp:HiddenField ID="hdnReviewId" runat="server" />

            <div class="review-form-group">
                <label for="<%= txtName.ClientID %>">Customer Name</label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="review-input"
                    MaxLength="150" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                    ControlToValidate="txtName"
                    ErrorMessage="Please enter customer name."
                    CssClass="validation-error"
                    Display="Dynamic"
                    ValidationGroup="ReviewForm" />
            </div>

            <div class="review-form-group">
                <label for="<%= txtContactNo.ClientID %>">Contact Number</label>
                <asp:TextBox ID="txtContactNo" runat="server"
                    CssClass="review-input"
                    MaxLength="30" />
            </div>

            <div class="review-form-group">
                <label for="<%= txtEmail.ClientID %>">Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="review-input"
                    TextMode="Email"
                    MaxLength="254" />
            </div>

            <div class="review-form-group">
                <label for="<%= txtCity.ClientID %>">City</label>
                <asp:TextBox ID="txtCity" runat="server"
                    CssClass="review-input"
                    MaxLength="100" />
            </div>

            <div class="review-form-group">
                <label for="<%= ddlRating.ClientID %>">Rating</label>
                <asp:DropDownList ID="ddlRating" runat="server"
                    CssClass="review-input">
                    <asp:ListItem Text="Select Rating" Value="" />
                    <asp:ListItem Text="5 - Excellent" Value="5" />
                    <asp:ListItem Text="4 - Very Good" Value="4" />
                    <asp:ListItem Text="3 - Good" Value="3" />
                    <asp:ListItem Text="2 - Fair" Value="2" />
                    <asp:ListItem Text="1 - Poor" Value="1" />
                </asp:DropDownList>

                <asp:RequiredFieldValidator ID="rfvRating" runat="server"
                    ControlToValidate="ddlRating"
                    InitialValue=""
                    ErrorMessage="Please select a rating."
                    CssClass="validation-error"
                    Display="Dynamic"
                    ValidationGroup="ReviewForm" />
            </div>

            <div class="review-form-group">
                <label for="<%= txtRemarks.ClientID %>">Review / Remarks</label>
                <asp:TextBox ID="txtRemarks" runat="server"
                    CssClass="review-input"
                    TextMode="MultiLine"
                    Rows="5" />
            </div>

            <div class="review-form-group">
                <label for="<%= txtReviewDate.ClientID %>">Review Date</label>
                <asp:TextBox ID="txtReviewDate" runat="server"
                    CssClass="review-input"
                    TextMode="Date" />
            </div>

            <div class="review-form-actions">

                <asp:Button ID="btnUpdate" runat="server"
                    Text="Update Review"
                    CssClass="review-save-btn"
                    ValidationGroup="ReviewForm"
                    OnClick="btnUpdate_Click" />

                <asp:HyperLink ID="lnkCancel" runat="server"
                    NavigateUrl="~/ManageReviews.aspx"
                    CssClass="review-cancel-btn">
                    Cancel
                </asp:HyperLink>

            </div>

        </div>

    </div>

</asp:Content>
