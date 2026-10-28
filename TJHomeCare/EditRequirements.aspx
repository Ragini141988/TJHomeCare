<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditRequirements.aspx.cs" Inherits="TJHomeCare.EditRequirements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Requirement
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .edit-req-wrapper {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 16px 40px;
            box-sizing: border-box;
        }

        .edit-req-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,.08);
            padding: 35px;
            border: 1px solid #eaeaea;
        }

        .edit-page-title {
            font-size: 26px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 6px;
        }

        .edit-page-subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .edit-section-title {
            font-size: 18px;
            font-weight: 700;
            color: #34495e;
            margin: 30px 0 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #f1f5f9;
        }

        .edit-form-row {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .edit-form-group {
            margin-bottom: 16px;
            min-width: 0;
        }

        .edit-form-group.full {
            grid-column: 1 / -1;
        }

        .edit-form-label {
            display: block;
            font-weight: 600;
            font-size: 13px;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .edit-required {
            color: #dc3545;
        }

        .edit-form-control {
            display: block;
            width: 100%;
            height: 46px;
            padding: 8px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #1e293b;
            background: #fff;
            box-sizing: border-box;
            outline: none;
        }

        .edit-form-control:focus {
            border-color: #198754;
            box-shadow: 0 0 0 3px rgba(25,135,84,.12);
        }

        .edit-duty-options {
            padding: 12px 16px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #f8fafc;
        }

        .edit-duty-options table {
            width: 100%;
            border-collapse: collapse;
        }

        .edit-duty-options tr {
            display: block;
            margin-bottom: 8px;
        }

        .edit-duty-options tr:last-child {
            margin-bottom: 0;
        }

        .edit-duty-options td {
            display: block;
            width: 100%;
            padding: 4px 0;
        }

        .edit-duty-options label {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: #334155;
            font-size: 14px;
            cursor: pointer;
        }

        .edit-duty-options input[type="radio"] {
            accent-color: #198754;
            margin: 0;
            width: 16px;
            height: 16px;
        }

        .edit-validation {
            display: block;
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
        }

        .edit-btn-save {
            background: #198754;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 28px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }

        .edit-btn-save:hover {
            background: #157347;
        }

        .edit-btn-cancel {
            display: block;
            text-align: center;
            margin-top: 12px;
            padding: 12px;
            background: #edf2f7;
            color: #334155;
            border-radius: 8px;
            text-decoration: none;
        }

        .edit-message {
            display: block;
            margin: 12px 0;
            color: #dc3545;
            font-weight: 600;
        }

        .edit-area-search {
            position: relative;
            width: 100%;
        }

        .edit-area-results {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            z-index: 1000;
            max-height: 220px;
            overflow-y: auto;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0,0,0,.12);
        }

        .edit-area-item {
            padding: 11px 14px;
            cursor: pointer;
            border-bottom: 1px solid #edf0f4;
            color: #334155;
            font-size: 14px;
        }

        .edit-area-item:hover {
            background: #f0fdf4;
            color: #198754;
        }

        .edit-selected-area {
            margin-top: 6px;
            color: #198754;
            font-size: 13px;
        }

        @media (max-width: 768px) {
            .edit-req-wrapper {
                margin: 10px auto;
                padding: 0 10px 25px;
            }

            .edit-req-card {
                padding: 20px;
                border-radius: 12px;
            }

            .edit-page-title {
                font-size: 22px;
            }

            .edit-form-row {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .edit-form-group.full {
                grid-column: auto;
            }

            .edit-form-control {
                font-size: 16px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <section class="edit-req-wrapper">
        <div class="edit-req-card">

            <h1 class="edit-page-title">Edit Your Requirement</h1>

            <div class="edit-page-subtitle">
                Update your home care requirement details below.
            </div>

            <%--<asp:Label ID="lblMessage" runat="server"
                CssClass="edit-message" />--%>
            <div style="display:block; background:#fff3cd; padding:10px; margin:15px 0;">
    <asp:Label ID="lblMessage" runat="server"
        Text=""
        ForeColor="Red"
        Font-Bold="true"
        EnableViewState="true" />
</div>
            <div class="edit-section-title">Service &amp; Location Details</div>

            <div class="edit-form-row">

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        Service Requirement <span class="edit-required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlService" runat="server"
                        CssClass="edit-form-control"
                        DataTextField="ServiceName"
                        DataValueField="ServiceCategoryID"
                        AppendDataBoundItems="true">
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvService"
                        runat="server"
                        ControlToValidate="ddlService"
                        InitialValue=""
                        ErrorMessage="Please select a service."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        City <span class="edit-required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlCity" runat="server"
                        CssClass="edit-form-control">
                        <asp:ListItem Value="">Select City</asp:ListItem>
                        <asp:ListItem Value="Bangalore">Bangalore</asp:ListItem>
                        <asp:ListItem Value="Hyderabad">Hyderabad</asp:ListItem>
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvCity"
                        runat="server"
                        ControlToValidate="ddlCity"
                        InitialValue=""
                        ErrorMessage="Please select a city."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group full">
                    <asp:HiddenField ID="hdnAreaID" runat="server" />

                    <label class="edit-form-label">
                        Area / Locality <span class="edit-required">*</span>
                    </label>

                    <div class="edit-area-search">
                        <asp:TextBox ID="txtArea" runat="server"
                            CssClass="edit-form-control"
                            placeholder="Type area name"
                            autocomplete="off" />

                        <div id="editAreaResults" class="edit-area-results"></div>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvArea"
                        runat="server"
                        ControlToValidate="txtArea"
                        ErrorMessage="Please select an area."
                        CssClass="edit-validation"
                        Display="Dynamic" />

                    <div id="editSelectedArea" class="edit-selected-area"></div>
                </div>

            </div>

            <div class="edit-section-title">Duty &amp; Preferences</div>

            <div class="edit-form-row">

                <div class="edit-form-group full">
                    <label class="edit-form-label">
                        Duty Time <span class="edit-required">*</span>
                    </label>

                    <div class="edit-duty-options">
                        <asp:RadioButtonList ID="ddlDutyTime" runat="server"
                            RepeatLayout="Table"
                            RepeatDirection="Vertical"
                            RepeatColumns="1">
                            <asp:ListItem Value="Part Time">Part Time</asp:ListItem>
                            <asp:ListItem Value="8 Hours">8 Hours</asp:ListItem>
                            <asp:ListItem Value="10 Hours">10 Hours</asp:ListItem>
                            <asp:ListItem Value="12 Hours">12 Hours</asp:ListItem>
                            <asp:ListItem Value="24 Hours / Live in">24 Hours / Live in</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvDutyTime"
                        runat="server"
                        ControlToValidate="ddlDutyTime"
                        ErrorMessage="Please select duty time."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        Preferred Language <span class="edit-required">*</span>
                    </label>

                    <asp:DropDownList ID="txtPreferredLanguage" runat="server"
                        CssClass="edit-form-control">
                        <asp:ListItem Value="">Select Language</asp:ListItem>
                        <asp:ListItem>Kannada</asp:ListItem>
                        <asp:ListItem>Telugu</asp:ListItem>
                        <asp:ListItem>Hindi</asp:ListItem>
                        <asp:ListItem>Tamil</asp:ListItem>
                        <asp:ListItem>Malayalam</asp:ListItem>
                        <asp:ListItem>English</asp:ListItem>
                        <asp:ListItem>Bengali</asp:ListItem>
                        <asp:ListItem>Urdu</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvLanguage"
                        runat="server"
                        ControlToValidate="txtPreferredLanguage"
                        InitialValue=""
                        ErrorMessage="Please select a language."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        Salary / Budget <span class="edit-required">*</span>
                    </label>

                    <asp:TextBox ID="txtBudget" runat="server"
                        CssClass="edit-form-control"
                        MaxLength="50"
                        placeholder="e.g. ₹12,000 per month" />

                    <asp:RequiredFieldValidator ID="rfvBudget"
                        runat="server"
                        ControlToValidate="txtBudget"
                        ErrorMessage="Please enter your budget."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group full">
                    <label class="edit-form-label">
                        Joining From <span class="edit-required">*</span>
                    </label>

                    <asp:TextBox ID="txtJoiningDate" runat="server"
                        CssClass="edit-form-control"
                        TextMode="Date"
                        style="max-width:50%;" />

                    <asp:RequiredFieldValidator ID="rfvJoiningDate"
                        runat="server"
                        ControlToValidate="txtJoiningDate"
                        ErrorMessage="Please select joining date."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

            </div>

            <div class="edit-section-title">Contact Information</div>

            <div class="edit-form-row">

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        Your Name <span class="edit-required">*</span>
                    </label>

                    <asp:TextBox ID="txtFullName" runat="server"
                        CssClass="edit-form-control"
                        MaxLength="100"
                        placeholder="Enter your full name" />

                    <asp:RequiredFieldValidator ID="rfvFullName"
                        runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Please enter your name."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group">
                    <label class="edit-form-label">
                        Mobile Number <span class="edit-required">*</span>
                    </label>

                    <asp:TextBox ID="txtMobile" runat="server"
                        CssClass="edit-form-control"
                        MaxLength="10"
                        placeholder="10-digit mobile number" />

                    <asp:RequiredFieldValidator ID="rfvMobile"
                        runat="server"
                        ControlToValidate="txtMobile"
                        ErrorMessage="Please enter mobile number."
                        CssClass="edit-validation"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revMobile"
                        runat="server"
                        ControlToValidate="txtMobile"
                        ValidationExpression="^[0-9]{10}$"
                        ErrorMessage="Enter a valid 10-digit mobile number."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group full">
                    <label class="edit-form-label">
                        WhatsApp Number <span class="edit-required">*</span>
                    </label>

                    <asp:TextBox ID="txtWhatsApp" runat="server"
                        CssClass="edit-form-control"
                        MaxLength="10"
                        placeholder="10-digit WhatsApp number" />

                    <asp:RequiredFieldValidator ID="rfvWhatsApp"
                        runat="server"
                        ControlToValidate="txtWhatsApp"
                        ErrorMessage="Please enter WhatsApp number."
                        CssClass="edit-validation"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revWhatsApp"
                        runat="server"
                        ControlToValidate="txtWhatsApp"
                        ValidationExpression="^[0-9]{10}$"
                        ErrorMessage="Enter a valid 10-digit WhatsApp number."
                        CssClass="edit-validation"
                        Display="Dynamic" />
                </div>

                <div class="edit-form-group full" style="margin-top:15px;">
                   <asp:Button ID="btnEdit" runat="server"
    Text="Edit"
    CssClass="edit-btn-save"
    OnClick="btnEdit_Click"
    CausesValidation="false" />

                    <asp:HyperLink ID="lnkCancel" runat="server"
                        NavigateUrl="~/HomePage.aspx"
                        CssClass="edit-btn-cancel"
                        Text="Back to Home" />
                </div>

            </div>
        </div>
    </section>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var areaTextBox = document.getElementById("<%= txtArea.ClientID %>");
            var areaHidden = document.getElementById("<%= hdnAreaID.ClientID %>");
            var areaResults = document.getElementById("editAreaResults");
            var selectedArea = document.getElementById("editSelectedArea");
            var cityDropdown = document.getElementById("<%= ddlCity.ClientID %>");
            var timer = null;

            if (!areaTextBox || !areaHidden || !areaResults || !cityDropdown)
                return;

            areaTextBox.addEventListener("input", function () {
                var searchText = areaTextBox.value.trim();

                areaHidden.value = "";
                selectedArea.textContent = "";
                clearTimeout(timer);

                if (searchText.length < 2) {
                    areaResults.innerHTML = "";
                    areaResults.style.display = "none";
                    return;
                }

                timer = setTimeout(function () {
                    var city = cityDropdown.value;

                    if (!city) {
                        areaResults.innerHTML = "";
                        var cityMessage = document.createElement("div");
                        cityMessage.className = "edit-area-item";
                        cityMessage.textContent = "Please select a city first.";
                        areaResults.appendChild(cityMessage);
                        areaResults.style.display = "block";
                        return;
                    }

                    fetch("<%= ResolveUrl("~/PostRequirement.aspx/GetPlaces") %>", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=utf-8"
                        },
                        body: JSON.stringify({
                            searchText: searchText,
                            city: city
                        })
                    })
                    .then(function (response) {
                        if (!response.ok)
                            throw new Error("Area search request failed.");
                        return response.json();
                    })
                    .then(function (result) {
                        var places = result.d || [];
                        areaResults.innerHTML = "";

                        if (places.length === 0) {
                            var noResult = document.createElement("div");
                            noResult.className = "edit-area-item";
                            noResult.textContent = "No area found";
                            areaResults.appendChild(noResult);
                            areaResults.style.display = "block";
                            return;
                        }

                        places.forEach(function (place) {
                            var item = document.createElement("div");
                            item.className = "edit-area-item";
                            item.textContent = place.PlaceName;

                            item.addEventListener("click", function () {
                                areaTextBox.value = place.PlaceName;
                                areaHidden.value = place.PlaceID;
                                selectedArea.textContent =
                                    "Selected Area: " + place.PlaceName;
                                areaResults.innerHTML = "";
                                areaResults.style.display = "none";
                            });

                            areaResults.appendChild(item);
                        });

                        areaResults.style.display = "block";
                    })
                    .catch(function (error) {
                        console.error("Area autocomplete error:", error);
                        areaResults.innerHTML = "";

                        var errorItem = document.createElement("div");
                        errorItem.className = "edit-area-item";
                        errorItem.textContent =
                            "Unable to load areas. Please try again.";
                        areaResults.appendChild(errorItem);
                        areaResults.style.display = "block";
                    });
                }, 250);
            });

            cityDropdown.addEventListener("change", function () {
                areaTextBox.value = "";
                areaHidden.value = "";
                selectedArea.textContent = "";
                areaResults.innerHTML = "";
                areaResults.style.display = "none";
            });

            document.addEventListener("click", function (event) {
                if (!event.target.closest(".edit-area-search"))
                    areaResults.style.display = "none";
            });
        });
    </script>

</asp:Content>

