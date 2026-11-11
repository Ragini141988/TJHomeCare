TJ HOME CARE - CONSULTATION BOOKING V2 + ZAAKPAY EXPRESS CHECKOUT
==================================================================

PACKAGE CONTENTS
----------------
ConsultationBookingV2.aspx (+ .cs + .designer.cs)
    Customer booking form matching the supplied booking screenshot.
    URL example: ConsultationBookingV2.aspx?caregiverId=12&serviceId=4

ConsultationPaymentV2.aspx (+ .cs + .designer.cs)
    Shows the saved appointment and database-calculated fee/GST/total.
    Creates a unique Zaakpay merchant order ID and payment attempt.

ZaakpayRedirectV2.aspx (+ .cs + .designer.cs)
    Builds the server-signed Zaakpay Express Checkout POST form and redirects
    the customer to Zaakpay's hosted checkout page.

ZaakpayReturnV2.aspx (+ .cs + .designer.cs)
    Receives the gateway POST response, verifies the response HMAC-SHA256,
    checks the order ID and amount against both the booking and payment attempt,
    and only then marks the booking Paid / Confirmed. Repeated callbacks do not
    downgrade an already-paid payment or booking.

ConsultationBookingSuccessV2.aspx (+ .cs + .designer.cs)
    Shows the booking confirmation and print-friendly receipt.

ConsultationBookingManageV2.aspx (+ .cs + .designer.cs)
    Accepts reschedule or cancellation requests for the care team to review.

ZaakpayGateway.cs
    HMAC-SHA256 and response checksum helper methods.

ConsultationBookingV2.sql
    Adds the required booking fields, pricing table, payment attempts table and
    unique indexes. Existing BookingID and customer/profile fields are retained.

INSTALLATION
------------
1. Back up tabletjobs-db.
2. Execute ConsultationBookingV2.sql against tabletjobs-db.
3. Review ConsultationServicePricing. Dermatologist Online Consultation is
   prefilled at Rs 999 + 18% GST because that price appears in the screenshot.
   Add/update all other approved rates before allowing those services to book.
4. Add every ASPX, code-behind, designer and helper .cs file to your existing
   TJHomeCare ASP.NET Web Application project. Ensure all .cs files are included
   in the project and have Build Action = Compile.
5. Keep the existing connection string name:
   hospi2yp_tabletjobssConnectionString_V02
6. Merge web.config-zaakpay-snippet.xml entries into your EXISTING appSettings
   section. Do not add another appSettings element. Insert your rotated staging
   merchant identifier and generated key on the server only. Do not put keys in
   client-side code or public GitHub/source control.
7. The supplied generated_key is the HMAC secret for Redirect Flow. The supplied
   PublicKey and Encryption Key ID are for Seamless Flow card encryption; they
   are not used by this Redirect Flow implementation. Do not collect or store
   card number, CVV, PIN or OTP on TJ Home Care pages.
8. Use a public HTTPS URL for ZaakpayReturnUrl and register the website URL and
   return/redirect URL in the Zaakpay dashboard (Developers / Integration URLs).
   A localhost URL cannot receive the gateway callback.
9. Set ConsultationPaymentMode=Zaakpay and ZaakpayEnvironment=Staging.
   Staging uses https://zaakstaging.zaakpay.com/api/paymentTransact/V13 and
   mode=0. The code uses the Live endpoint and mode=1 only when environment=Live.
10. Test on your registered public staging domain with the test card details
    supplied by Zaakpay: 4111 1111 1111 1111, CVV 123, expiry 07/29, OTP 1234.
    These values are only for the gateway's staging environment.
11. Test success, cancellation/failure, browser back, duplicate callback,
    amount mismatch, invalid checksum, repeat payment attempt and lost callback.
12. Before live: generate/obtain LIVE credentials, use a separate live config,
    set ZaakpayEnvironment=Live, register the production website and return URL,
    and confirm limits and test completion with Zaakpay. Never use staging test
    card details or staging credentials in production.

ZAAKPAY REDIRECT FLOW DETAILS
-----------------------------
- Request type: POST
- Endpoint: /api/paymentTransact/V13
- Amount is sent in paisa (Rs 1 = 100 paisa).
- Request checksum: HMAC-SHA256 over non-empty parameters in alphabetical
  parameter-name order, formatted as name=value&.
- Response checksum: HMAC-SHA256 over the documented response field order.
- Success responseCode is 100. This implementation additionally requires a
  non-empty pgTransId and exact order/amount matching before marking Paid.
- Staging and Live endpoint base URLs are taken from Zaakpay's current Redirect
  Flow documentation.

Zaakpay also publishes a separate Check Status API at:
https://developer.zaakpay.com/docs/check-status-api
This can be used for server-to-server reconciliation and to investigate delayed
or uncertain callbacks. Confirm staging availability and enablement for this
merchant account with Zaakpay before relying on it in production.

IMPORTANT LIMITATIONS
--------------------
- This package uses the Redirect Flow. The PublicKey and Encryption Key ID you
  shared are for Seamless Flow; do not mix the two integration methods.
- The callback is accepted only after its HMAC checksum, order ID, amount and
  transaction ID checks succeed. Do not change this to trust a browser query
  string or a success page redirect alone.
- The appointment date/time is a customer-requested time, not a real-time slot
  lock. The care team must confirm professional availability.
- Reschedule and cancellation are review requests. They do not automatically
  change the appointment or issue a refund.
- No actual gateway request has been made from this development environment.
  The package has not been compiled against your Visual Studio solution or run
  against your SQL Server. Build and test it on your project before deployment.
- If the staging credentials pasted into chat are active, rotate/regenerate them
  and use the new values in your server-side web.config before testing.

POLICY LINKS
------------
Check the policy-page URLs in ConsultationBookingV2.aspx and update them if the
actual policy page names on your website differ.
