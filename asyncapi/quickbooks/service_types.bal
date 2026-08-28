// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Attachable service type exposing the CompanyCurrencyService family of webhook events.
public type CompanyCurrencyService service object {
    # Triggered on Company currency updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCompanyCurrencyUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Company currency deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCompanyCurrencyDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Company currency created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCompanyCurrencyCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the AccountService family of webhook events.
public type AccountService service object {
    # Triggered on Account merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccountMerged(QuickBookEvent payload) returns error?;
    # Triggered on Account updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccountUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Account created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccountCreated(QuickBookEvent payload) returns error?;
    # Triggered on Account deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccountDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the EstimateService family of webhook events.
public type EstimateService service object {
    # Triggered on Estimate created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEstimateCreated(QuickBookEvent payload) returns error?;
    # Triggered on Estimate emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEstimateEmailed(QuickBookEvent payload) returns error?;
    # Triggered on Estimate deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEstimateDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Estimate updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEstimateUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the InvoiceService family of webhook events.
public type InvoiceService service object {
    # Triggered on Invoice created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onInvoiceCreated(QuickBookEvent payload) returns error?;
    # Triggered on Invoice updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onInvoiceUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Invoice deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onInvoiceDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Invoice emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onInvoiceEmailed(QuickBookEvent payload) returns error?;
    # Triggered on Invoice voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onInvoiceVoided(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the CustomerService family of webhook events.
public type CustomerService service object {
    # Triggered on Customer deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCustomerDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Customer created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCustomerCreated(QuickBookEvent payload) returns error?;
    # Triggered on Customer updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCustomerUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Customer merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCustomerMerged(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the TaxAgencyService family of webhook events.
public type TaxAgencyService service object {
    # Triggered on Tax agency updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTaxAgencyUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Tax agency created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTaxAgencyCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the JournalEntryService family of webhook events.
public type JournalEntryService service object {
    # Triggered on Journal entry updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onJournalEntryUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Journal entry deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onJournalEntryDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Journal entry created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onJournalEntryCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the ItemService family of webhook events.
public type ItemService service object {
    # Triggered on Item created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onItemCreated(QuickBookEvent payload) returns error?;
    # Triggered on Item deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onItemDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Item updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onItemUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Item merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onItemMerged(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the DepartmentService family of webhook events.
public type DepartmentService service object {
    # Triggered on Department created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepartmentCreated(QuickBookEvent payload) returns error?;
    # Triggered on Department merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepartmentMerged(QuickBookEvent payload) returns error?;
    # Triggered on Department updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepartmentUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the RefundReceiptService family of webhook events.
public type RefundReceiptService service object {
    # Triggered on Refund receipt created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRefundReceiptCreated(QuickBookEvent payload) returns error?;
    # Triggered on Refund receipt deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRefundReceiptDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Refund receipt emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRefundReceiptEmailed(QuickBookEvent payload) returns error?;
    # Triggered on Refund receipt voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRefundReceiptVoided(QuickBookEvent payload) returns error?;
    # Triggered on Refund receipt updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRefundReceiptUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the CurrencyService family of webhook events.
public type CurrencyService service object {
    # Triggered on Currency created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCurrencyCreated(QuickBookEvent payload) returns error?;
    # Triggered on Currency deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCurrencyDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Currency updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCurrencyUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the BillPaymentService family of webhook events.
public type BillPaymentService service object {
    # Triggered on Bill payment created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillPaymentCreated(QuickBookEvent payload) returns error?;
    # Triggered on Bill payment deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillPaymentDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Bill payment voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillPaymentVoided(QuickBookEvent payload) returns error?;
    # Triggered on Bill payment updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillPaymentUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the CreditMemoService family of webhook events.
public type CreditMemoService service object {
    # Triggered on Credit memo updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCreditMemoUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Credit memo voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCreditMemoVoided(QuickBookEvent payload) returns error?;
    # Triggered on Credit memo emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCreditMemoEmailed(QuickBookEvent payload) returns error?;
    # Triggered on Credit memo created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCreditMemoCreated(QuickBookEvent payload) returns error?;
    # Triggered on Credit memo deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCreditMemoDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the BudgetService family of webhook events.
public type BudgetService service object {
    # Triggered on Budget updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBudgetUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Budget created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBudgetCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the PreferencesService family of webhook events.
public type PreferencesService service object {
    # Triggered on Preferences updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPreferencesUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the TimeActivityService family of webhook events.
public type TimeActivityService service object {
    # Triggered on Time activity created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTimeActivityCreated(QuickBookEvent payload) returns error?;
    # Triggered on Time activity updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTimeActivityUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Time activity deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTimeActivityDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the DepositService family of webhook events.
public type DepositService service object {
    # Triggered on Deposit created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepositCreated(QuickBookEvent payload) returns error?;
    # Triggered on Deposit updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepositUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Deposit deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onDepositDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the JournalCodeService family of webhook events.
public type JournalCodeService service object {
    # Triggered on Journal code updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onJournalCodeUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Journal code created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onJournalCodeCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the PurchaseService family of webhook events.
public type PurchaseService service object {
    # Triggered on Purchase voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseVoided(QuickBookEvent payload) returns error?;
    # Triggered on Purchase updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Purchase deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Purchase created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the VendorCreditService family of webhook events.
public type VendorCreditService service object {
    # Triggered on Vendor credit created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorCreditCreated(QuickBookEvent payload) returns error?;
    # Triggered on Vendor credit deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorCreditDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Vendor credit updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorCreditUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the TermService family of webhook events.
public type TermService service object {
    # Triggered on Term created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTermCreated(QuickBookEvent payload) returns error?;
    # Triggered on Term updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTermUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the VendorService family of webhook events.
public type VendorService service object {
    # Triggered on Vendor updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Vendor deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Vendor merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorMerged(QuickBookEvent payload) returns error?;
    # Triggered on Vendor created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onVendorCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the PaymentService family of webhook events.
public type PaymentService service object {
    # Triggered on Payment updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Payment emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentEmailed(QuickBookEvent payload) returns error?;
    # Triggered on Payment voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentVoided(QuickBookEvent payload) returns error?;
    # Triggered on Payment created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentCreated(QuickBookEvent payload) returns error?;
    # Triggered on Payment deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the SalesReceiptService family of webhook events.
public type SalesReceiptService service object {
    # Triggered on Sales receipt created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSalesReceiptCreated(QuickBookEvent payload) returns error?;
    # Triggered on Sales receipt deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSalesReceiptDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Sales receipt voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSalesReceiptVoided(QuickBookEvent payload) returns error?;
    # Triggered on Sales receipt updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSalesReceiptUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Sales receipt emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSalesReceiptEmailed(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the EmployeeService family of webhook events.
public type EmployeeService service object {
    # Triggered on Employee updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEmployeeUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Employee merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEmployeeMerged(QuickBookEvent payload) returns error?;
    # Triggered on Employee created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEmployeeCreated(QuickBookEvent payload) returns error?;
    # Triggered on Employee deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onEmployeeDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the ChangeOrderService family of webhook events.
public type ChangeOrderService service object {
    # Triggered on Change order created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onChangeOrderCreated(QuickBookEvent payload) returns error?;
    # Triggered on Change order updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onChangeOrderUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Change order deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onChangeOrderDeleted(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the TransferService family of webhook events.
public type TransferService service object {
    # Triggered on Transfer created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTransferCreated(QuickBookEvent payload) returns error?;
    # Triggered on Transfer deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTransferDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Transfer voided.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTransferVoided(QuickBookEvent payload) returns error?;
    # Triggered on Transfer updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onTransferUpdated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the BillService family of webhook events.
public type BillService service object {
    # Triggered on Bill updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Bill deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Bill created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onBillCreated(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the PurchaseOrderService family of webhook events.
public type PurchaseOrderService service object {
    # Triggered on Purchase order deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseOrderDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Purchase order created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseOrderCreated(QuickBookEvent payload) returns error?;
    # Triggered on Purchase order updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseOrderUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Purchase order emailed.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurchaseOrderEmailed(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the PaymentMethodService family of webhook events.
public type PaymentMethodService service object {
    # Triggered on Payment method updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentMethodUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Payment method created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentMethodCreated(QuickBookEvent payload) returns error?;
    # Triggered on Payment method merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPaymentMethodMerged(QuickBookEvent payload) returns error?;
};

# Attachable service type exposing the ClassService family of webhook events.
public type ClassService service object {
    # Triggered on Class updated.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onClassUpdated(QuickBookEvent payload) returns error?;
    # Triggered on Class deleted.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onClassDeleted(QuickBookEvent payload) returns error?;
    # Triggered on Class created.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onClassCreated(QuickBookEvent payload) returns error?;
    # Triggered on Class merged.
    # + payload - the QuickBookEvent webhook payload
    # + return - an error if handling the event fails
    remote function onClassMerged(QuickBookEvent payload) returns error?;
};

# The union of every service type that can be attached to this listener.
public type GenericServiceType CompanyCurrencyService|AccountService|EstimateService|InvoiceService|CustomerService|TaxAgencyService|JournalEntryService|ItemService|DepartmentService|RefundReceiptService|CurrencyService|BillPaymentService|CreditMemoService|BudgetService|PreferencesService|TimeActivityService|DepositService|JournalCodeService|PurchaseService|VendorCreditService|TermService|VendorService|PaymentService|SalesReceiptService|EmployeeService|ChangeOrderService|TransferService|BillService|PurchaseOrderService|PaymentMethodService|ClassService;

