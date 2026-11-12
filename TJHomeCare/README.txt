TJ Home Care - Zaakpay Check Status Envelope-Flag Fix

WHY THIS PATCH IS NEEDED
The stored Check Status API response for the user's live order contains:
- message code 100 (transaction completed successfully)
- txnStatus 0 (success)
- responseCode 228 (transaction captured)
- exact expected Merchant Order ID
- amount 118 paise
- a non-empty Zaakpay transaction ID
but the status-client stored ApiStatus=false and the reconciler rejected the response because it required ApiStatus=true.

WHAT CHANGED
1. ZaakpayStatusClient.ApiSuccess uses message.code=100 as the API response
   success indicator and does not reject order details solely because the
   envelope-level Boolean status is false. The user's live response has this
   inconsistency: status=false alongside message.code=100 and a captured order.
2. The reconciler still requires a matching merchant identifier, exact merchant
   order ID, exact amount against both booking and attempt, txnStatus=0, and a
   non-empty gateway transaction ID before marking a booking Paid.
3. The safe diagnostic summary includes both ApiStatus and DataSuccess for audit.
4. The standalone Check Status diagnostic page also displays data.success.
5. JSON field lookup is case-insensitive to avoid rejecting differently cased keys.

FILES TO REPLACE
- ZaakpayStatusClient.cs
- ZaakpayPaymentReconciler.cs

OPTIONAL DIAGNOSTIC PAGE UPDATE
- Replace ZaakpayCheckStatus.aspx.cs only if you still use the standalone
  ZaakpayCheckStatus.aspx page and want it to show the data.success value.
  No .aspx markup change is required.

INSTALL
1. Back up the website and database.
2. Replace the two core .cs files in the project (same namespace TJHomeCare).
3. Build in Visual Studio. Do not add duplicate copies of either class.
4. Publish/deploy the updated assembly/source and recycle the IIS application pool.
5. For Booking 21, open its existing payment page and click Check Payment Status.
   The code will query the same order TJHC261112122230E91151EB. It will not
   initiate a new payment.
6. If Zaakpay returns message.code=100 plus the same matching merchant ID,
   order ID, txnStatus=0, amount=118 and transaction ID, the reconciler should
   mark the payment Paid and booking Confirmed. The top-level status and
   data.success flags are retained for diagnostics but do not override this
   validated per-order transaction record.

IMPORTANT
- This patch does not initiate payments and requires no SQL migration.
- Do not run manual SQL updates for Booking 21 after installing this patch.
- If message.code is not 100, or the merchant ID, order ID, amount, txnStatus,
  or transaction ID fails validation, the code keeps the payment unresolved.
  The API's top-level status and data.success flags are recorded for diagnostics
  because the current live response has conflicting envelope/per-order fields.
- This code has not been compiled or tested against the live hosting account.
- Rotate any gateway secrets previously exposed in source files or chat.
