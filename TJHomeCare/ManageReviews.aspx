<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageReviews.aspx.cs" Inherits="TJHomeCare.ManageReviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Reviews
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="head" runat="server">
    <style>
        .manage-reviews {
            padding: 30px 12px 45px;
            background: #f5f8fc;
            min-height: 500px;
        }

        .reviews-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        .reviews-header h2 {
            color: #17365d;
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 6px;
        }

        .reviews-header p {
            color: #6b7280;
            margin: 0;
        }

        .reviews-count {
            background: #e6f0ff;
            color: #1769aa;
            border-radius: 10px;
            padding: 12px 18px;
            font-weight: 700;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 22px;
        }

        .customer-review-card {
            background: #fff;
            border: 1px solid #e7edf4;
            border-radius: 15px;
            padding: 23px;
            box-shadow: 0 5px 18px rgba(23,54,93,.07);
            display: flex;
            flex-direction: column;
            min-width: 0;
            transition: transform .2s, box-shadow .2s;
        }

        .customer-review-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(23,54,93,.12);
        }

        .customer-review-top {
            display: flex;
            align-items: center;
            gap: 13px;
            margin-bottom: 18px;
        }

        .customer-avatar {
            width: 53px;
            height: 53px;
            flex-shrink: 0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #1769aa, #17365d);
            color: #fff;
            font-size: 22px;
            font-weight: 700;
        }

        .customer-name {
            font-size: 18px;
            font-weight: 700;
            color: #17365d;
            overflow-wrap: anywhere;
            margin-bottom: 4px;
        }

        .customer-city {
            font-size: 13px;
            color: #6b7280;
        }

        .rating-row {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 14px;
        }

        .rating-stars {
            color: #f5a623;
            font-size: 22px;
            letter-spacing: 1px;
        }

        .rating-label {
            color: #596579;
            font-size: 13px;
            font-weight: 600;
        }

        .review-quote {
            color: #1769aa;
            font-size: 32px;
            line-height: 1;
            font-weight: 700;
        }

        .review-remarks {
            color: #4b5563;
            line-height: 1.7;
            font-size: 14px;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            flex: 1;
            margin-bottom: 18px;
        }

        .customer-info {
            border-top: 1px solid #edf1f5;
            padding-top: 15px;
            margin-bottom: 17px;
        }

        .customer-info-row {
            display: flex;
            align-items: flex-start;
            gap: 9px;
            margin-bottom: 10px;
            color: #536174;
            font-size: 13px;
            overflow-wrap: anywhere;
        }

        .info-label {
            color: #17365d;
            font-weight: 700;
            min-width: 55px;
        }

        .review-date {
            color: #7b8492;
            font-size: 12px;
            margin-bottom: 18px;
        }

        .review-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }

        .review-edit-btn,
        .review-delete-btn {
            flex: 1;
            text-align: center;
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none !important;
            cursor: pointer;
            transition: .2s;
        }

        .review-edit-btn {
            color: #1769aa !important;
            background: #e8f2ff;
            border: 1px solid #d3e5ff;
        }

        .review-edit-btn:hover {
            background: #d7e8ff;
        }

        .review-delete-btn {
            color: #fff !important;
            background: #dc3545;
            border: 1px solid #dc3545;
        }

        .review-delete-btn:hover {
            background: #bb2d3b;
        }

        .reviews-empty {
            padding: 40px 15px;
            text-align: center;
            background: #fff;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            color: #6b7280;
            margin-bottom: 22px;
        }

        .reviews-message {
            display: block;
            margin-bottom: 15px;
            font-weight: 600;
        }

        @media (max-width: 576px) {
            .manage-reviews {
                padding: 20px 8px;
            }

            .reviews-header h2 {
                font-size: 24px;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container manage-reviews">

        <div class="reviews-header">
            <div>
                <h2>Customer Reviews</h2>
                <p>Manage and review customer feedback.</p>
            </div>

            <div class="reviews-count">
                Total Reviews:
                <asp:Label ID="lblTotalReviews" runat="server" Text="0" />
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            CssClass="reviews-message"
            EnableViewState="false" />

        <asp:Panel ID="pnlEmpty" runat="server"
            CssClass="reviews-empty" Visible="false">
            <h4>No Reviews Found</h4>
            <p>Customer reviews will appear here when available.</p>
        </asp:Panel>

        <div class="reviews-grid">

            <asp:Repeater ID="rptReviews" runat="server"
                OnItemCommand="rptReviews_ItemCommand">

                <ItemTemplate>

                    <div class="customer-review-card">

                        <div class="customer-review-top">

                            <div class="customer-avatar">
                                <%# GetInitial(Eval("Name")) %>
                            </div>

                            <div>
                                <div class="customer-name">
                                    <%#: Eval("Name") %>
                                </div>

                                <div class="customer-city">
                                    <%#: Eval("City") == DBNull.Value ||
                                        string.IsNullOrWhiteSpace(Convert.ToString(Eval("City")))
                                        ? "City not provided"
                                        : Convert.ToString(Eval("City")) %>
                                </div>
                            </div>

                        </div>

                        <div class="rating-row">
                            <span class="rating-stars">
                                <%# GetStars(Eval("Rating")) %>
                            </span>

                            <span class="rating-label">
                                <%#: Eval("Rating") == DBNull.Value
                                    ? "0"
                                    : Convert.ToString(Eval("Rating")) %>/5
                            </span>
                        </div>

                        <div class="review-quote">“</div>

                        <div class="review-remarks">
                            <%#: Eval("Remarks") == DBNull.Value ||
                                string.IsNullOrWhiteSpace(Convert.ToString(Eval("Remarks")))
                                ? "No remarks provided."
                                : Convert.ToString(Eval("Remarks")) %>
                        </div>

                        <div class="customer-info">

                            <div class="customer-info-row">
                                <span class="info-label">Phone</span>
                                <span>
                                    <%#: Eval("ContactNo") == DBNull.Value ||
                                        string.IsNullOrWhiteSpace(Convert.ToString(Eval("ContactNo")))
                                        ? "Not provided"
                                        : Convert.ToString(Eval("ContactNo")) %>
                                </span>
                            </div>

                            <div class="customer-info-row">
                                <span class="info-label">Email</span>
                                <span>
                                    <%#: Eval("Email") == DBNull.Value ||
                                        string.IsNullOrWhiteSpace(Convert.ToString(Eval("Email")))
                                        ? "Not provided"
                                        : Convert.ToString(Eval("Email")) %>
                                </span>
                            </div>

                        </div>

                        <div class="review-date">
                            Review Date:
                            <%# Eval("ReviewDate") == DBNull.Value
                                ? "Not available"
                                : Convert.ToDateTime(Eval("ReviewDate")).ToString("dd MMM yyyy") %>
                        </div>

                        <div class="review-actions">

                            <a class="review-edit-btn"
                               href='<%# ResolveUrl("~/EditReview.aspx?id=" + Eval("ReviewId")) %>'>
                                Edit
                            </a>

                            <asp:LinkButton ID="lnkDelete" runat="server"
                                Text="Delete"
                                CssClass="review-delete-btn"
                                CommandName="DeleteReview"
                                CommandArgument='<%# Eval("ReviewId") %>'
                                CausesValidation="false"
                                OnClientClick="return confirm('Are you sure you want to permanently delete this review?');" />

                        </div>

                    </div>

                </ItemTemplate>

            </asp:Repeater>

        </div>

    </div>

</asp:Content>
