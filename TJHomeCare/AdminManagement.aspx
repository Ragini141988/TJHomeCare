<%@ Page Title="Manage Records" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminManagement.aspx.cs" Inherits="TJHomeCare.AdminManagement" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-manage-wrap {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 15px 40px;
        }
        .admin-manage-header {
            margin-bottom: 24px;
        }
        .admin-manage-title {
            margin: 0 0 8px;
            color: #183153;
            font-size: 28px;
            font-weight: 700;
        }
        .admin-manage-subtitle {
            margin: 0;
            color: #64748b;
            line-height: 1.6;
        }
        .admin-manage-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }
        .admin-manage-card {
            display: flex;
            flex-direction: column;
            min-width: 0;
            padding: 24px;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, .07);
        }
        .admin-manage-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 52px;
            height: 52px;
            margin-bottom: 16px;
            border-radius: 12px;
            background: #eaf2ff;
            color: #0d6efd;
            font-size: 25px;
            font-weight: 700;
        }
        .admin-manage-card h2 {
            margin: 0 0 10px;
            color: #183153;
            font-size: 20px;
        }
        .admin-manage-card p {
            flex: 1;
            margin: 0 0 20px;
            color: #64748b;
            line-height: 1.6;
        }
        .admin-manage-link {
            display: inline-block;
            padding: 11px 15px;
            border-radius: 7px;
            background: #0d6efd;
            color: #fff !important;
            text-align: center;
            text-decoration: none !important;
            font-weight: 600;
        }
        .admin-manage-link:hover {
            background: #0b5ed7;
        }
        .admin-manage-card:nth-child(2) .admin-manage-icon {
            background: #e8f7ee;
            color: #198754;
        }
        .admin-manage-card:nth-child(2) .admin-manage-link {
            background: #198754;
        }
        .admin-manage-card:nth-child(2) .admin-manage-link:hover {
            background: #157347;
        }
        .admin-manage-card:nth-child(3) .admin-manage-icon {
            background: #fff3df;
            color: #b76e00;
        }
        .admin-manage-card:nth-child(3) .admin-manage-link {
            background: #b76e00;
        }
        .admin-manage-card:nth-child(3) .admin-manage-link:hover {
            background: #955a00;
        }
        @media (max-width: 800px) {
            .admin-manage-grid {
                grid-template-columns: 1fr;
            }
            .admin-manage-card {
                padding: 20px;
            }
            .admin-manage-title {
                font-size: 24px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="admin-manage-wrap">
        <header class="admin-manage-header">
            <h1 class="admin-manage-title">Manage Records</h1>
            <p class="admin-manage-subtitle">
                Choose an option below to add, review, edit, or delete records.
            </p>
        </header>

        <section class="admin-manage-grid">
            <article class="admin-manage-card">
                <div class="admin-manage-icon" aria-hidden="true">★</div>
                <h2>Reviews</h2>
                <p>Manage customer reviews, including editing and deleting existing reviews.</p>
                <a class="admin-manage-link" href="<%= ResolveUrl("~/ManageReviews.aspx") %>">
                    Manage Reviews
                </a>
            </article>

            <article class="admin-manage-card">
                <div class="admin-manage-icon" aria-hidden="true">＋</div>
                <h2>Candidates</h2>
                <p>Open the candidate list to add new candidates or manage and delete existing profiles.</p>
                <a class="admin-manage-link" href="<%= ResolveUrl("~/CaregiverList.aspx") %>">
                    Manage Candidates
                </a>
            </article>

            <article class="admin-manage-card">
                <div class="admin-manage-icon" aria-hidden="true">✓</div>
                <h2>Online Consultants</h2>
                <p>Open the caregiver list to manage consultant profiles, including adding and deleting records.</p>
                <a class="admin-manage-link" href="<%= ResolveUrl("~/CaregiverList.aspx") %>">
                    Manage Consultants
                </a>
            </article>
        </section>
    </main>
</asp:Content>
