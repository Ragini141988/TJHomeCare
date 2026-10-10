<%@ Page Title="Caregiver Registration" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="CaregiverRegistration.aspx.cs" Inherits="TabletJobs.com.CaregiverRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
        .caregiver-wrapper {
            max-width: 1000px;
            margin: 25px auto;
            padding: 0 15px 40px;
        }

        .caregiver-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 3px 18px rgba(0,0,0,.08);
            padding: 25px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .page-subtitle {
            color: #666;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 19px;
            font-weight: 700;
            margin: 25px 0 15px;
            padding-bottom: 8px;
            border-bottom: 1px solid #ddd;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 7px;
        }

        .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            min-height: 42px;
            padding: 9px 12px;
            border: 1px solid #ced4da;
            border-radius: 7px;
            font-size: 15px;
            box-sizing: border-box;
        }

        textarea.form-control {
            min-height: 90px;
            resize: vertical;
        }

      .checkbox-list {
    display: flex;
    flex-wrap: wrap;
    gap: 12px 25px;
    padding: 10px 0;
}

.checkbox-list input[type="checkbox"] {
    margin-right: 6px;
    vertical-align: middle;
}

.checkbox-list label {
    font-weight: 400;
    margin-right: 20px;
    display: inline-block;
}

        .validation {
            display: block;
            color: #dc3545;
            font-size: 13px;
            margin-top: 4px;
        }

        .message {
            display: block;
            padding: 10px 14px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .success {
            background: #d1e7dd;
            color: #0f5132;
        }

        .error {
            background: #f8d7da;
            color: #842029;
        }

        .area-search {
            position: relative;
        }

        .area-results {
            position: absolute;
            z-index: 1000;
            left: 0;
            right: 0;
            background: #fff;
            border: 1px solid #ccc;
            border-top: none;
            max-height: 220px;
            overflow-y: auto;
            display: none;
            box-shadow: 0 5px 10px rgba(0,0,0,.1);
        }

        .area-item {
            padding: 10px 12px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }

        .area-item:hover {
            background: #f1f5f9;
        }

        .selected-area {
            margin-top: 6px;
            font-size: 13px;
            color: #198754;
        }

        .btn-submit {
            background: #198754;
            color: white;
            border: none;
            border-radius: 7px;
            padding: 12px 30px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: #157347;
        }

        .btn-clear {
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 7px;
            padding: 12px 25px;
            font-size: 16px;
            cursor: pointer;
            margin-left: 8px;
        }

        .photo-preview {
            margin-top: 10px;
            max-width: 150px;
            max-height: 150px;
            border-radius: 8px;
        }

        .preferred-area-search {
    position: relative;
}

.preferred-area-results {
    position: absolute;
    z-index: 2000;
    left: 0;
    right: 0;
    background: #fff;
    border: 1px solid #ccc;
    border-top: none;
    max-height: 220px;
    overflow-y: auto;
    display: none;
    box-shadow: 0 5px 10px rgba(0,0,0,.12);
}

.preferred-area-item {
    padding: 10px 12px;
    cursor: pointer;
    border-bottom: 1px solid #eee;
}

.preferred-area-item:hover {
    background: #f1f5f9;
}

.selected-preferred-areas {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 10px;
}

.preferred-area-tag {
    display: inline-flex;
    align-items: center;
    background: #e8f5e9;
    color: #146c43;
    border: 1px solid #badbcc;
    border-radius: 20px;
    padding: 6px 10px;
    font-size: 14px;
}

.preferred-area-remove {
    margin-left: 7px;
    cursor: pointer;
    font-weight: bold;
    color: #dc3545;
}

.preferred-area-remove:hover {
    color: #a71d2a;
}

       @media (max-width: 768px) {

    .caregiver-wrapper {
        margin: 10px auto;
        padding: 0 10px 30px;
    }

    .caregiver-card {
        padding: 17px;
        border-radius: 10px;
    }

    .page-title {
        font-size: 23px;
    }

    .form-row {
        grid-template-columns: 1fr;
        gap: 0;
    }

    .form-group.full {
        grid-column: auto;
    }

    .checkbox-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .checkbox-list label {
        margin-right: 0;
    }

    .btn-submit,
    .btn-clear {
        width: 100%;
        margin: 5px 0;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="caregiver-wrapper">

        <div class="caregiver-card">

            <h1 class="page-title">
                TJ HOME CARE – Caregiver Registration
            </h1>

            <div class="page-subtitle">
                Register your caregiver profile
            </div>

            <asp:Label ID="lblMessage"
                runat="server"
                Visible="false"
                CssClass="message">
            </asp:Label>

            <!-- RECRUITER -->

            <div class="section-title">
                Recruitment Details
            </div>

            <div class="form-row">

                <div class="form-group">

                    <label class="form-label">
                        Recruiter Name <span class="required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlRecruiter"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select Recruiter --"
                            Value="" />

                        <asp:ListItem Text="Sangeetha"
                            Value="Sangeetha" />
                        <asp:ListItem Text="Prasanna"
                            Value="Prasanna" />
                        <asp:ListItem Text="Divya"
                            Value="Divya" />
                        

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        ID="rfvRecruiter"
                        runat="server"
                        ControlToValidate="ddlRecruiter"
                        InitialValue=""
                        ErrorMessage="Please select recruiter name."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>

            </div>


            <!-- SERVICE -->

            <div class="section-title">
                Service Details
            </div>

            <div class="form-row">

                <div class="form-group full">

                    <label class="form-label">
                        Service Category <span class="required">*</span>
                    </label>

                    <asp:CheckBoxList ID="cblServiceCategory"
                        runat="server"
                        CssClass="checkbox-list">

                        <asp:ListItem>Baby Caretaker</asp:ListItem>
                        <asp:ListItem>Cook</asp:ListItem>
                        <asp:ListItem>Driver</asp:ListItem>
                        <asp:ListItem>Patient Caretaker</asp:ListItem>
                        <asp:ListItem>Elder Caretaker</asp:ListItem>
                        <asp:ListItem>Home Nurse</asp:ListItem>

                    </asp:CheckBoxList>

                    <asp:CustomValidator
                        ID="cvServiceCategory"
                        runat="server"
                        ErrorMessage="Please select at least one service category."
                        CssClass="validation"
                        OnServerValidate="cvServiceCategory_ServerValidate">
                    </asp:CustomValidator>

                </div>

            </div>


            <!-- PERSONAL -->

            <div class="section-title">
                Personal Information
            </div>

            <div class="form-row">

                <div class="form-group">

                    <label class="form-label">
                        Full Name <span class="required">*</span>
                    </label>

                    <asp:TextBox ID="txtFullName"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="200">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Age <span class="required">*</span>
                    </label>

                    <asp:TextBox ID="txtAge"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="txtAge"
                        ErrorMessage="Age is required."
                        CssClass="validation"
                        Display="Dynamic" />

                    <asp:RangeValidator
                        runat="server"
                        ControlToValidate="txtAge"
                        MinimumValue="18"
                        MaximumValue="70"
                        Type="Integer"
                        ErrorMessage="Age must be between 18 and 70."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Gender <span class="required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlGender"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select Gender --"
                            Value="" />

                        <asp:ListItem Text="Female"
                            Value="Female" />

                        <asp:ListItem Text="Male"
                            Value="Male" />

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="ddlGender"
                        InitialValue=""
                        ErrorMessage="Please select gender."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Contact Number <span class="required">*</span>
                    </label>

                    <asp:TextBox ID="txtContactNumber"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="10"
                        TextMode="Phone">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="txtContactNumber"
                        ErrorMessage="Contact number is required."
                        CssClass="validation"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator
                        runat="server"
                        ControlToValidate="txtContactNumber"
                        ValidationExpression="^[6-9][0-9]{9}$"
                        ErrorMessage="Enter valid 10 digit mobile number."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <div class="form-group">

                    <label class="form-label">
                        City <span class="required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlCity"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select City --"
                            Value="" />
                         <asp:ListItem>Bangalore</asp:ListItem>
                        <asp:ListItem>Hyderabad</asp:ListItem>
                        <asp:ListItem>Ranchi</asp:ListItem>
                        <asp:ListItem>Bokaro</asp:ListItem>
                        <asp:ListItem>Dhanbad</asp:ListItem>
                        <asp:ListItem>Asansol</asp:ListItem>
                        <asp:ListItem>Kolkata</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="ddlCity"
                        InitialValue=""
                        ErrorMessage="Please select city."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <!-- PRESENT AREA -->

                <div class="form-group">

                    <label class="form-label">
                        Present Area <span class="required">*</span>
                    </label>

                    <div class="area-search">

                        <asp:TextBox ID="txtPresentArea"
                            runat="server"
                            CssClass="form-control"
                            placeholder="Type area e.g. AR">
                        </asp:TextBox>

                        <asp:HiddenField
                            ID="hdnPresentAreaID"
                            runat="server" />
                        
                        <div id="areaResults"
                            class="area-results">
                        </div>

                    </div>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="txtPresentArea"
                        ErrorMessage="Please select present area."
                        CssClass="validation"
                        Display="Dynamic" />

                    <div id="selectedArea"
                        class="selected-area">
                    </div>

                </div>

            </div>


            <!-- LANGUAGE -->

            <div class="section-title">
                Qualification & Skills
            </div>

            <div class="form-row">

                <div class="form-group full">

                    <label class="form-label">
                        Languages Known <span class="required">*</span>
                    </label>

                <asp:CheckBoxList ID="cblLanguages"
    runat="server"
    CssClass="checkbox-list">

                        <asp:ListItem>Kannada</asp:ListItem>
                        <asp:ListItem>Telugu</asp:ListItem>
                        <asp:ListItem>Hindi</asp:ListItem>
                        <asp:ListItem>Tamil</asp:ListItem>
                        <asp:ListItem>Malayalam</asp:ListItem>
                        <asp:ListItem>English</asp:ListItem>
                        <asp:ListItem>Bengali</asp:ListItem>
                        <asp:ListItem>Others</asp:ListItem>

                    </asp:CheckBoxList>

                    <asp:CustomValidator
                        ID="cvLanguages"
                        runat="server"
                        ErrorMessage="Please select at least one language."
                        CssClass="validation"
                        OnServerValidate="cvLanguages_ServerValidate">
                    </asp:CustomValidator>

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Qualification
                    </label>

                    <asp:DropDownList ID="ddlQualification"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select Qualification --"
                            Value="" />

                        <asp:ListItem>Below 10th</asp:ListItem>
                        <asp:ListItem>10th</asp:ListItem>
                        <asp:ListItem>12th</asp:ListItem>
                        <asp:ListItem>Diploma</asp:ListItem>
                        <asp:ListItem>Graduate</asp:ListItem>
                        <asp:ListItem>ANM</asp:ListItem>
                        <asp:ListItem>GNM</asp:ListItem>
                        <asp:ListItem>B.Sc Nursing</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>

                    </asp:DropDownList>

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Experience <span class="required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlExperience"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select Experience --"
                            Value="" />

                        <asp:ListItem>Fresher</asp:ListItem>
                        <asp:ListItem>Below 1 Year</asp:ListItem>
                        <asp:ListItem>1–2 Years</asp:ListItem>
                        <asp:ListItem>2–5 Years</asp:ListItem>
                        <asp:ListItem>5+ Years</asp:ListItem>

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="ddlExperience"
                        InitialValue=""
                        ErrorMessage="Please select experience."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>

            </div>


            <!-- DUTY -->

            <div class="section-title">
                Work Preferences
            </div>

            <div class="form-row">

                <div class="form-group full">

                    <label class="form-label">
                        Duty Preference <span class="required">*</span>
                    </label>

                    <asp:CheckBoxList ID="cblDutyPreference"
                        runat="server"
                        CssClass="checkbox-list">

                        <asp:ListItem>8 Hours</asp:ListItem>
                        <asp:ListItem>10 Hours</asp:ListItem>
                        <asp:ListItem>12 Hours Day</asp:ListItem>
                        <asp:ListItem>12 Hours Night</asp:ListItem>
                        <asp:ListItem>24 Hours Live-in</asp:ListItem>

                    </asp:CheckBoxList>

                    <asp:CustomValidator
                        ID="cvDuty"
                        runat="server"
                        ErrorMessage="Please select duty preference."
                        CssClass="validation"
                        OnServerValidate="cvDuty_ServerValidate">
                    </asp:CustomValidator>

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Expected Salary ₹ / Month <span class="required">*</span>
                    </label>

                    <asp:TextBox ID="txtExpectedSalary"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="txtExpectedSalary"
                        ErrorMessage="Expected salary is required."
                        CssClass="validation"
                        Display="Dynamic" />

                    <asp:RangeValidator
                        runat="server"
                        ControlToValidate="txtExpectedSalary"
                        MinimumValue="1"
                        MaximumValue="999999"
                        Type="Double"
                        ErrorMessage="Enter a valid salary."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Joining Availability <span class="required">*</span>
                    </label>

                    <asp:DropDownList ID="ddlJoiningAvailability"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="-- Select --"
                            Value="" />

                        <asp:ListItem>Immediately</asp:ListItem>
                        <asp:ListItem>Within 3 Days</asp:ListItem>
                        <asp:ListItem>Within 7 Days</asp:ListItem>
                        <asp:ListItem>Later</asp:ListItem>

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        runat="server"
                        ControlToValidate="ddlJoiningAvailability"
                        InitialValue=""
                        ErrorMessage="Please select joining availability."
                        CssClass="validation"
                        Display="Dynamic" />

                </div>


              <div class="form-group full">

    <label class="form-label">
        Preferred Work Areas
    </label>

    <div class="preferred-area-search">

        <asp:TextBox
            ID="txtPreferredWorkAreas"
            runat="server"
            CssClass="form-control"
            placeholder="Type area e.g. AR"
            autocomplete="off">
        </asp:TextBox>

        <asp:HiddenField
            ID="hdnPreferredWorkAreaIDs"
            runat="server" />

        <div id="preferredAreaResults"
             class="preferred-area-results">
        </div>

    </div>

    <div id="selectedPreferredAreas"
         class="selected-preferred-areas">
    </div>

</div>

            </div>


            <!-- PHOTO -->

            <div class="section-title">
                Profile
            </div>

            <div class="form-row">

                <div class="form-group">

                    <label class="form-label">
                        Profile Photo <span class="required"></span>
                    </label>

                    <asp:FileUpload
                        ID="fuProfilePhoto"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png" />

                    <small>
                        JPG / JPEG / PNG. Maximum 2 MB.
                    </small>

                </div>


                <div class="form-group">

                    <label class="form-label">
                        Remarks
                    </label>

                    <asp:TextBox
                        ID="txtRemarks"
                        runat="server"
                        CssClass="form-control"
                        TextMode="MultiLine">
                    </asp:TextBox>

                </div>

            </div>

             <!-- PHOTO -->

            

            <div class="form-row">

                <div class="form-group">

                    <label class="form-label">
                        Aadhar Photo <span class="required"></span>
                    </label>

                    <asp:FileUpload
                        ID="fupaadhar"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png" />

                    <small>
                        JPG / JPEG / PNG. Maximum 2 MB.
                    </small>

                </div>


              

            </div>


            <div style="margin-top:25px;">

                <asp:Button
                    ID="btnSave"
                    runat="server"
                    Text="Register Caregiver"
                    CssClass="btn-submit"
                    OnClick="btnSave_Click" />

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear"
                    CssClass="btn-clear"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

            </div>

        </div>

    </div>


  <script type="text/javascript">

      // ======================================
// PREFERRED WORK AREAS - MULTI SELECT
// ======================================

var preferredAreaTextBox =
    document.getElementById(
        "<%= txtPreferredWorkAreas.ClientID %>"
    );

var preferredAreaHidden =
    document.getElementById(
        "<%= hdnPreferredWorkAreaIDs.ClientID %>"
    );

var preferredAreaResults =
    document.getElementById(
        "preferredAreaResults"
    );

var selectedPreferredAreas =
    document.getElementById(
        "selectedPreferredAreas"
    );

var preferredAreaTimer = null;


// Store selected areas
var selectedPreferredAreaList = [];


// ======================================
// LOAD EXISTING SELECTED VALUES
// ======================================

function loadPreferredAreas() {

    var value =
        preferredAreaHidden.value.trim();

    if (value === "") {
        return;
    }

    var ids = value.split(",");

    ids.forEach(function (id) {

        id = id.trim();

        if (id !== "") {

            selectedPreferredAreaList.push({
                PlaceID: parseInt(id),
                PlaceName: ""
            });

        }

    });

}


// ======================================
// SEARCH
// ======================================

preferredAreaTextBox.addEventListener(
    "input",
    function () {

        var searchText =
            preferredAreaTextBox.value.trim();

        clearTimeout(preferredAreaTimer);

        if (searchText.length < 2) {

            preferredAreaResults.innerHTML = "";

            preferredAreaResults.style.display =
                "none";

            return;
        }

        preferredAreaTimer =
            setTimeout(function () {

                var city =
                    $('#<%= ddlCity.ClientID %>').val() || '';

                console.log(
                    "Preferred Area searchText:",
                    searchText
                );

                console.log(
                    "Preferred Area city:",
                    city
                );

                fetch(
                    "<%= ResolveUrl("~/CaregiverRegistration.aspx/GetPlaces") %>",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/json; charset=utf-8"
                        },

                        body: JSON.stringify({
                            searchText: searchText,
                            city: city
                        })
                    }
                )

                .then(function (response) {

                    if (!response.ok) {

                        throw new Error(
                            "Server returned " +
                            response.status
                        );
                    }

                    return response.json();

                })

                .then(function (result) {

                    var places = result.d;

                    preferredAreaResults.innerHTML = "";


                    if (!places ||
                        places.length === 0) {

                        var noResult =
                            document.createElement("div");

                        noResult.className =
                            "preferred-area-item";

                        noResult.textContent =
                            "No area found";

                        preferredAreaResults.appendChild(
                            noResult
                        );

                        preferredAreaResults.style.display =
                            "block";

                        return;
                    }


                    places.forEach(function (place) {

                        // Don't show already selected areas
                        var alreadySelected =
                            selectedPreferredAreaList
                                .some(function (x) {

                                    return x.PlaceID ==
                                        place.PlaceID;

                                });


                        if (alreadySelected) {
                            return;
                        }


                        var item =
                            document.createElement("div");

                        item.className =
                            "preferred-area-item";

                        item.textContent =
                            place.PlaceName;


                        item.addEventListener(
                            "click",
                            function () {

                                addPreferredArea(
                                    place.PlaceID,
                                    place.PlaceName
                                );

                                preferredAreaTextBox.value =
                                    "";

                                preferredAreaResults.innerHTML =
                                    "";

                                preferredAreaResults.style.display =
                                    "none";

                                preferredAreaTextBox.focus();
                            }
                        );


                        preferredAreaResults.appendChild(
                            item
                        );

                    });


                    preferredAreaResults.style.display =
                        "block";

                })

                .catch(function (error) {

                    console.error(
                        "Preferred Area search error:",
                        error
                    );

                    preferredAreaResults.innerHTML =
                        "<div class='preferred-area-item'>" +
                        "Unable to load areas." +
                        "</div>";

                    preferredAreaResults.style.display =
                        "block";

                });

            }, 250);

    }
);

// ======================================
// ADD AREA
// ======================================

function addPreferredArea(
    placeID,
    placeName
) {

    var exists =
        selectedPreferredAreaList.some(
            function (x) {

                return x.PlaceID == placeID;

            }
        );


    if (exists) {
        return;
    }


    selectedPreferredAreaList.push({
        PlaceID: placeID,
        PlaceName: placeName
    });


    updatePreferredAreaHiddenField();

    renderPreferredAreaTags();
}


// ======================================
// REMOVE AREA
// ======================================

function removePreferredArea(placeID) {

    selectedPreferredAreaList =
        selectedPreferredAreaList.filter(
            function (x) {

                return x.PlaceID != placeID;

            }
        );


    updatePreferredAreaHiddenField();

    renderPreferredAreaTags();
}


// ======================================
// HIDDEN FIELD
// ======================================

function updatePreferredAreaHiddenField() {

    var ids =
        selectedPreferredAreaList.map(
            function (x) {

                return x.PlaceID;

            }
        );


    preferredAreaHidden.value =
        ids.join(",");
}


// ======================================
// DISPLAY SELECTED TAGS
// ======================================

function renderPreferredAreaTags() {

    selectedPreferredAreas.innerHTML = "";


    selectedPreferredAreaList.forEach(
        function (place) {

            var tag =
                document.createElement("span");

            tag.className =
                "preferred-area-tag";


            tag.textContent =
                place.PlaceName;


            var remove =
                document.createElement("span");

            remove.className =
                "preferred-area-remove";

            remove.textContent =
                " ×";


            remove.addEventListener(
                "click",
                function () {

                    removePreferredArea(
                        place.PlaceID
                    );

                }
            );


            tag.appendChild(remove);

            selectedPreferredAreas
                .appendChild(tag);

        }
    );
}


// ======================================
// CLOSE RESULT WHEN CLICKING OUTSIDE
// ======================================

document.addEventListener(
    "click",
    function (event) {

        if (!event.target.closest(
            ".preferred-area-search"
        )) {

            preferredAreaResults.style.display =
                "none";
        }

    }
);

    document.addEventListener("DOMContentLoaded", function () {

        var areaTextBox =
            document.getElementById("<%= txtPresentArea.ClientID %>");

        var areaHidden =
            document.getElementById("<%= hdnPresentAreaID.ClientID %>");

        var areaResults =
            document.getElementById("areaResults");

        var selectedArea =
            document.getElementById("selectedArea");

        var timer = null;


        areaTextBox.addEventListener("input", function () {

            var searchText = areaTextBox.value.trim();

            clearTimeout(timer);

            // Clear previously selected ID
            areaHidden.value = "";

            selectedArea.innerHTML = "";

            if (searchText.length < 2) {

                areaResults.innerHTML = "";
                areaResults.style.display = "none";

                return;
            }


            timer = setTimeout(function () {

              fetch(
    "CaregiverRegistration.aspx/GetPlaces",
    {
        method: "POST",

        headers: {
            "Content-Type":
                "application/json; charset=utf-8"
        },

        body: JSON.stringify({
            searchText: searchText,
            city: $('#<%= ddlCity.ClientID %>').val() || ''
        })
    }
)

                .then(function (response) {

                    if (!response.ok) {
                        throw new Error(
                            "Server returned " + response.status
                        );
                    }

                    return response.json();

                })

                .then(function (result) {

                    var places = result.d;

                    areaResults.innerHTML = "";

                    if (!places || places.length === 0) {

                        var noResult =
                            document.createElement("div");

                        noResult.className = "area-item";

                        noResult.textContent =
                            "No area found";

                        areaResults.appendChild(noResult);

                        areaResults.style.display = "block";

                        return;
                    }


                    places.forEach(function (place) {

                        var item =
                            document.createElement("div");

                        item.className = "area-item";

                        item.textContent =
                            place.PlaceName;

                        item.setAttribute(
                            "data-id",
                            place.PlaceID
                        );


                        item.addEventListener(
                            "click",
                            function () {

                                areaTextBox.value =
                                    place.PlaceName;

                                areaHidden.value =
                                    place.PlaceID;

                                selectedArea.innerHTML =
                                    "Selected Area: <strong>" +
                                    escapeHtml(place.PlaceName) +
                                    "</strong>";

                                areaResults.innerHTML = "";

                                areaResults.style.display =
                                    "none";
                            }
                        );


                        areaResults.appendChild(item);

                    });


                    areaResults.style.display = "block";

                })

                .catch(function (error) {

                    console.error(
                        "Present Area search error:",
                        error
                    );

                    areaResults.innerHTML =
                        "<div class='area-item'>" +
                        "Unable to load areas." +
                        "</div>";

                    areaResults.style.display =
                        "block";
                });


            }, 250);

        });


        document.addEventListener(
            "click",
            function (event) {

                if (!event.target.closest(".area-search")) {

                    areaResults.style.display =
                        "none";
                }

            }
        );


        function escapeHtml(value) {

            var div =
                document.createElement("div");

            div.textContent = value;

            return div.innerHTML;
        }

    });

</script>

</asp:Content>