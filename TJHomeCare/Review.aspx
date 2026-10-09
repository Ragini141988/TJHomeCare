<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Review.aspx.cs" Inherits="TJHomeCare.Review" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Customer Review
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">

<style>

    /* ==============================
   FONT & TYPOGRAPHY
   ============================== */

.review-page,
.review-page input,
.review-page textarea,
.review-page button {
    font-family: 'Open Sans', Arial, sans-serif;
}

.review-intro h1,
.form-heading h2,
.form-label,
.submit-btn {
    font-family: 'Montserrat', Arial, sans-serif;
}

.review-intro p {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 16px;
    font-weight: 400;
    line-height: 1.7;
}

.form-heading h2 {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 30px;
    font-weight: 700;
    letter-spacing: -0.3px;
}

.form-heading p {
    font-size: 15px;
    line-height: 1.6;
}

.form-label {
    font-size: 14px;
    font-weight: 600;
    letter-spacing: 0.1px;
}

.review-input {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 15px;
}

.rating-text {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 14px;
}

.submit-btn {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 16px;
    font-weight: 600;
}

.review-points li {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 15px;
}
    /* ==============================
       MAIN PAGE
       ============================== */

    .review-page {
        min-height: 85vh;
        padding: 60px 20px;
       background: linear-gradient(135deg, #f2fbfa, #ffffff);
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .review-container {
        width: 100%;
        max-width: 1050px;
        display: grid;
        grid-template-columns: 40% 60%;
        background: #ffffff;
        border-radius: 24px;
        overflow: hidden;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
    }


    /* ==============================
       LEFT SIDE
       ============================== */

    .review-intro {
 background: linear-gradient(145deg, #177b78, #105d5b);        color: white;
        padding: 55px 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        position: relative;
        overflow: hidden;
    }

    .review-intro:before {
        content: "";
        position: absolute;
        width: 220px;
        height: 220px;
        border-radius: 50%;
        background: rgba(255,255,255,0.08);
        top: -70px;
        right: -70px;
    }

    .review-intro:after {
        content: "";
        position: absolute;
        width: 160px;
        height: 160px;
        border-radius: 50%;
        background: rgba(255,255,255,0.06);
        bottom: -60px;
        left: -50px;
    }

    .review-icon {
        width: 65px;
        height: 65px;
        background: rgba(255,255,255,0.15);
        border-radius: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32px;
        margin-bottom: 25px;
    }

    .review-intro h1 {
        font-size: 34px;
        line-height: 1.2;
        margin: 0 0 18px;
        font-weight: 700;
    }

    .review-intro p {
        color: #ffffff !important;
        font-size: 16px;
        line-height: 1.7;
        opacity: 1 !important;
        margin-bottom: 30px;
    }

    .review-points {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .review-points li {
        margin-bottom: 16px;
        font-size: 15px;
    }

    .review-points span {
        display: inline-flex;
        width: 28px;
        height: 28px;
        align-items: center;
        justify-content: center;
        background: rgba(255,255,255,0.15);
        border-radius: 50%;
        margin-right: 10px;
    }


    /* ==============================
       RIGHT SIDE FORM
       ============================== */

    .review-form {
        padding: 50px;
    }

    .form-heading {
        margin-bottom: 30px;
    }

        .form-heading h2 {
            margin: 0 0 8px;
            color: #24343b;
        }

    .form-heading p {
       color: #64747b;
        margin: 0;
        font-size: 14px;
    }

    .form-group {
        margin-bottom: 22px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
       color: #24343b;
        margin-bottom: 8px;
    }

    .form-label .required {
        color: #e63946;
    }

    .review-input {
        width: 100%;
        padding: 14px 16px;
       border: 1px solid #dce9e7;
        border-radius: 10px;
        font-size: 15px;
        outline: none;
        transition: all 0.3s ease;
        box-sizing: border-box;
        background: #fff;
    }

    .review-input:focus {
    border-color: #177b78;
    box-shadow: 0 0 0 4px rgba(23, 123, 120, 0.10);
}

    textarea.review-input {
        resize: vertical;
        min-height: 110px;
    }


    /* ==============================
       STAR RATING
       ============================== */

    .rating-box {
          background: #f6faf9;
    border: 1px solid #dce9e7;
        border-radius: 12px;
        padding: 18px;
    }

    .rating-text {
        font-size: 13px;
        color: #64747b;
        margin-bottom: 12px;
    }

    .stars {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    /*
       ASP.NET RadioButton generates
       a wrapper around input + label.
    */

    .stars .star-radio {
        display: inline-block;
        margin: 0;
        padding: 0;
    }

    .stars .star-radio input[type="radio"] {
        position: absolute;
        opacity: 0;
        width: 1px;
        height: 1px;
    }

    .stars .star-radio label {
        display: block;
        font-size: 36px;
        line-height: 1;
        color: #d0d5dd;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .stars .star-radio label:hover {
        color: #ffc107;
        transform: scale(1.12);
    }

    .stars .star-radio label.selected {
        color: #ffc107;
    }


    /* ==============================
       SUBMIT BUTTON
       ============================== */

    .submit-btn {
    width: 100%;
    border: none;
    padding: 15px 20px;
    border-radius: 7px;
    background: linear-gradient(135deg, #177b78, #105d5b);
    color: #ffffff;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 8px 20px rgba(23, 123, 120, 0.22);
}

.submit-btn:hover {
    transform: translateY(-2px);
    background: #105d5b;
    box-shadow: 0 12px 25px rgba(23, 123, 120, 0.30);
}

    .optional {
        font-size: 12px;
        color: #64747b;
        font-weight: normal;
    }

    .privacy-note {
    text-align: center;
    font-size: 12px;
    color: #64747b;
    }


    /* ==============================
       RESPONSIVE
       ============================== */

    @media (max-width: 800px) {

        .review-container {
            grid-template-columns: 1fr;
        }

        .review-intro {
            padding: 40px 30px;
        }

        .review-intro h1 {
            font-size: 28px;
        }

        .review-form {
            padding: 35px 25px;
        }
    }

    @media (max-width: 480px) {

        .review-page {
            padding: 25px 12px;
        }

        .review-intro {
            padding: 30px 22px;
        }

        .review-form {
            padding: 28px 18px;
        }

        .stars .star-radio label {
            font-size: 27px;
        }
    }
    .validation-error {
    display: block;
    color: #c14444;
    font-family: 'Open Sans', Arial, sans-serif;
    font-size: 13px;
    margin-top: 6px;
}
</style>


<script type="text/javascript">

    document.addEventListener("DOMContentLoaded", function () {

        var starInputs = document.querySelectorAll(
            ".stars .star-radio input[type='radio']"
        );

        function updateStars() {

            var selectedIndex = -1;

            // Find selected star
            for (var i = 0; i < starInputs.length; i++) {

                if (starInputs[i].checked) {
                    selectedIndex = i;
                }
            }

            // Fill stars up to selected rating
            for (var i = 0; i < starInputs.length; i++) {

                var label =
                    starInputs[i].parentElement.querySelector("label");

                if (label) {

                    if (i <= selectedIndex) {
                        label.classList.add("selected");
                    }
                    else {
                        label.classList.remove("selected");
                    }
                }
            }
        }

        // When user clicks a star
        for (var i = 0; i < starInputs.length; i++) {

            starInputs[i].addEventListener("change", updateStars);

        }

        // Initial state
        updateStars();

    });

</script>

</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

<section class="review-page">

    <div class="review-container">


        <!-- ==============================
             LEFT SIDE
             ============================== -->

        <div class="review-intro">

            <div class="review-icon">
                ★
            </div>

            <h1>
                We Value Your Feedback
            </h1>

            <p>
                Your experience matters to us.
                Please take a moment to share your feedback
                and help us serve you better.
            </p>

            <ul class="review-points">

                <li>
                    <span>✓</span>
                    Quick and easy review
                </li>

                <li>
                    <span>★</span>
                    Rate your experience
                </li>

                <li>
                    <span>♥</span>
                    Help us improve our service
                </li>

            </ul>

        </div>


        <!-- ==============================
             RIGHT SIDE
             ============================== -->

        <div class="review-form">

            <div class="form-heading">

                <h2>
                    Share Your Review
                </h2>

                <p>
                    We would love to hear about your experience.
                </p>

            </div>


            <!-- NAME -->

            <div class="form-group">

                <label class="form-label">
                    Your Name
                    <span class="required">*</span>
                </label>

                <asp:TextBox
                    ID="txtName"
                    runat="server"
                    CssClass="review-input"
                    placeholder="Enter your name">
                </asp:TextBox>
                <asp:RequiredFieldValidator
    ID="rfvName"
    runat="server"
    ControlToValidate="txtName"
    ErrorMessage="Please enter your name."
    CssClass="validation-error"
    Display="Dynamic">
</asp:RequiredFieldValidator>

            </div>


            <!-- CONTACT -->

            <div class="form-group">

                <label class="form-label">
                    Your Contact No
                    <span class="required">*</span>
                </label>

               <asp:TextBox
    ID="txtContact"
    runat="server"
    CssClass="review-input"
    placeholder="Enter your contact number"
    MaxLength="10">
</asp:TextBox>

<asp:RequiredFieldValidator
    ID="rfvContact"
    runat="server"
    ControlToValidate="txtContact"
    ErrorMessage="Please enter your contact number."
    CssClass="validation-error"
    Display="Dynamic">
</asp:RequiredFieldValidator>

<asp:RegularExpressionValidator
    ID="revContact"
    runat="server"
    ControlToValidate="txtContact"
    ValidationExpression="^[0-9]{10}$"
    ErrorMessage="Please enter a valid 10-digit contact number."
    CssClass="validation-error"
    Display="Dynamic">
</asp:RegularExpressionValidator>

            </div>


            <!-- RATING -->

            <div class="form-group">

                <label class="form-label">
                    Your Rating
                    <span class="required">*</span>
                </label>

                <div class="rating-box">

                    <div class="rating-text">
                        How would you rate your experience?
                    </div>

                    <div class="stars">

    <asp:RadioButton
        ID="rb1"
        runat="server"
        GroupName="Rating"
        Text="★"
        CssClass="star-radio" />

    <asp:RadioButton
        ID="rb2"
        runat="server"
        GroupName="Rating"
        Text="★"
        CssClass="star-radio" />

    <asp:RadioButton
        ID="rb3"
        runat="server"
        GroupName="Rating"
        Text="★"
        CssClass="star-radio" />

    <asp:RadioButton
        ID="rb4"
        runat="server"
        GroupName="Rating"
        Text="★"
        CssClass="star-radio" />

    <asp:RadioButton
        ID="rb5"
        runat="server"
        GroupName="Rating"
        Text="★"
        CssClass="star-radio" />
<asp:CustomValidator
    ID="cvRating"
    runat="server"
    ErrorMessage="Please select a rating."
    CssClass="validation-error"
    Display="Dynamic"
    ClientValidationFunction="validateRating"
    ValidationGroup="ReviewValidation">
</asp:CustomValidator>


                    </div>

                </div>

            </div>


            <!-- REMARKS -->

            <div class="form-group">

                <label class="form-label">

                    Remarks

                    <span class="optional">
                        (Optional)
                    </span>

                </label>

                <asp:TextBox
                    ID="txtRemarks"
                    runat="server"
                    CssClass="review-input"
                    TextMode="MultiLine"
                    Rows="4"
                    placeholder="Tell us about your experience...">
                </asp:TextBox>

            </div>


            <!-- SUBMIT -->

            <asp:Button
                ID="btnSubmit"
                runat="server"
                Text="Submit Review"
                CssClass="submit-btn"
                OnClick="btnSubmit_Click" />


            <div class="privacy-note">
                Thank you for taking the time to share your feedback.
            </div>

        </div>

    </div>

</section>

</asp:Content>
