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
       
.requirement-contact-box {
    display: flex;
    align-items: center;
    gap: 18px;
    margin-top: 25px;
    padding: 22px;
    background: linear-gradient(135deg, #ecfdf5, #f0fdf4);
    border: 1px solid #bbf7d0;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(22, 101, 52, 0.07);
}

.requirement-contact-icon {
    width: 60px;
    height: 60px;
    min-width: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #25D366;
    color: #fff;
    border-radius: 50%;
    font-size: 32px;
}

.requirement-contact-content {
    flex: 1;
}

.requirement-contact-content h4 {
    margin: 0 0 6px;
    color: #14532d;
    font-size: 20px;
    font-weight: 700;
}

.requirement-contact-content p {
    margin: 0 0 14px;
    color: #4b5563;
    font-size: 14px;
}

.requirement-contact-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.requirement-call-btn,
.requirement-whatsapp-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 11px 20px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none !important;
    transition: all 0.25s ease;
}

.requirement-call-btn {
    background: #166534;
    color: #fff !important;
}

.requirement-call-btn:hover {
    background: #14532d;
    transform: translateY(-2px);
}

.requirement-whatsapp-btn {
    background: #25D366;
    color: #fff !important;
}

.requirement-whatsapp-btn:hover {
    background: #128C7E;
    transform: translateY(-2px);
}

/* Mobile responsive */
@media (max-width: 480px) {
    .requirement-contact-box {
        align-items: flex-start;
        gap: 12px;
        padding: 16px;
    }

    .requirement-contact-icon {
        width: 45px;
        height: 45px;
        min-width: 45px;
        font-size: 25px;
    }

    .requirement-contact-content h4 {
        font-size: 17px;
    }

    .requirement-contact-buttons {
        flex-direction: column;
        align-items: stretch;
    }

    .requirement-call-btn,
    .requirement-whatsapp-btn {
        width: 100%;
        box-sizing: border-box;
    }
}

/* Social sharing section */
.share-social {
    margin-top: 25px !important;
    padding: 20px 15px;
    background: linear-gradient(135deg, #eff6ff, #f0f9ff);
    border: 1px solid #bfdbfe;
    border-radius: 14px;
    box-shadow: 0 4px 15px rgba(19, 121, 190, 0.10);
    text-align: center;
}

/* Highlighted heading */
.share-social-title {
    color: #1379BE;
    font-size: 16px !important;
    font-weight: 700 !important;
    margin-bottom: 15px !important;
}

.share-social-title i {
    margin-right: 6px;
    font-size: 18px;
}

/* Social media icon container */
.share-social .d-flex {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap !important;
    gap: 10px;
}

/* Social media buttons */
.share-social .social-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    margin: 0;
    border-radius: 50%;
    background: #ffffff;
    border: 1px solid #dbeafe;
    color: #1379BE;
    font-size: 19px;
    text-decoration: none;
    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
    transition: all 0.25s ease;
}

/* Individual brand colors */
.share-social .social-icon[title="Share on Facebook"] {
    color: #1877F2;
}

.share-social .social-icon[title="Share on WhatsApp"] {
    color: #25D366;
}

.share-social .social-icon[title="Share on Telegram"] {
    color: #229ED9;
}

.share-social .social-icon[title="Share on Instagram"] {
    color: #E4405F;
}

.share-social .social-icon[title="Share on Twitter"] {
    color: #1DA1F2;
}

.share-social .social-icon[title="Share on LinkedIn"] {
    color: #0A66C2;
}

/* Hover effect */
.share-social .social-icon:hover {
    background: #1379BE;
    color: #ffffff !important;
    border-color: #1379BE;
    transform: translateY(-4px);
    box-shadow: 0 6px 14px rgba(19, 121, 190, 0.22);
}

/* Mobile responsive */

@media (max-width: 480px) {
    .share-social {
        padding: 15px 5px;
    }

    .share-social .d-flex {
        display: flex;
        flex-wrap: nowrap !important;
        justify-content: center;
        align-items: center;
        gap: 5px;
    }

    .share-social .social-icon {
        width: 36px;
        height: 36px;
        min-width: 0;
        flex: 0 1 36px;
        margin: 0;
        font-size: 16px;
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
                         <div class="share-social mt-2 border-top pt-1 mb-3">
                <div class="share-social-title text-center fw-semibold mb-1 small">Share With Your Friends</div>
                <div class="d-flex justify-content-center flex-wrap">
                    <a href='<%= GetFacebookShareUrl(RequirementId) %>' class="social-icon" target="_blank" title="Share on Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href='<%= GetWhatsAppShareUrl(RequirementId) %>' class="social-icon" target="_blank" title="Share on WhatsApp"><i class="fab fa-whatsapp"></i></a>
                    <a href='<%= GetTelegramShareUrl(RequirementId) %>' class="social-icon" target="_blank" title="Share on Telegram"><i class="fab fa-telegram-plane"></i></a>
                    <a href='https://www.instagram.com/' class="social-icon" target="_blank" title="Share on Instagram"><i class="fab fa-instagram"></i></a>
                    <a href='<%= GetTwitterShareUrl(RequirementId) %>' class="social-icon" target="_blank" title="Share on Twitter"><i class="fab fa-twitter"></i></a>
                    <a href='<%= GetLinkedInShareUrl(RequirementId) %>' class="social-icon" target="_blank" title="Share on LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
                        <div class="requirement-contact-box">

    

    <div class="requirement-contact-content">
        <h4>Interested in This Job?</h4>
        <p>Call or WhatsApp us to get started!</p>

        <div class="requirement-contact-buttons">

            <a href="tel:+919429693689"
               class="requirement-call-btn">
                <i class="fa-solid fa-phone"></i>
                Call Now
            </a>

            <a href="https://wa.me/919429693689"
               target="_blank"
               rel="noopener noreferrer"
               class="requirement-whatsapp-btn">
                <i class="fa-brands fa-whatsapp"></i>
                WhatsApp Us
            </a>

        </div>
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
