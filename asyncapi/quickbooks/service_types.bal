// Copyright (c) 2022, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
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

# Triggers when a new event related to Quickbooks Account is received.
# Available actions: onAccountCreate, onAccountUpdate, onAccountDelete, and onAccountMerge.
public type AccountService service object {
    remote function onAccountCreate(QuickBookEvent event) returns error?;
    remote function onAccountUpdate(QuickBookEvent event) returns error?;
    remote function onAccountDelete(QuickBookEvent event) returns error?;
    remote function onAccountMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Bill is received.
# Available actions: onBillCreate, onBillUpdate, and onBillDelete.
public type BillService service object {
    remote function onBillCreate(QuickBookEvent event) returns error?;
    remote function onBillUpdate(QuickBookEvent event) returns error?;
    remote function onBillDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks BillPayment is received.
# Available actions: onBillpaymentCreate, onBillpaymentUpdate, onBillpaymentDelete, and onBillpaymentVoid.
public type BillPaymentService service object {
    remote function onBillpaymentCreate(QuickBookEvent event) returns error?;
    remote function onBillpaymentUpdate(QuickBookEvent event) returns error?;
    remote function onBillpaymentDelete(QuickBookEvent event) returns error?;
    remote function onBillpaymentVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Budget is received.
# Available actions: onBudgetCreate and onBudgetUpdate.
public type BudgetService service object {
    remote function onBudgetCreate(QuickBookEvent event) returns error?;
    remote function onBudgetUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Class is received.
# Available actions: onClassCreate, onClassUpdate, and onClassDelete.
public type ClassService service object {
    remote function onClassCreate(QuickBookEvent event) returns error?;
    remote function onClassUpdate(QuickBookEvent event) returns error?;
    remote function onClassDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks CreditMemo is received.
# Available actions: onCreditmemoCreate, onCreditmemoUpdate, onCreditmemoDelete, and onCreditmemoVoid.
public type CreditMemoService service object {
    remote function onCreditmemoCreate(QuickBookEvent event) returns error?;
    remote function onCreditmemoUpdate(QuickBookEvent event) returns error?;
    remote function onCreditmemoDelete(QuickBookEvent event) returns error?;
    remote function onCreditmemoVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Currency is received.
# Available actions: onCurrencyCreate and onCurrencyUpdate.
public type CurrencyService service object {
    remote function onCurrencyCreate(QuickBookEvent event) returns error?;
    remote function onCurrencyUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Customer is received.
# Available actions: onCustomerCreate, onCustomerUpdate, onCustomerDelete, and onCustomerMerge.
public type CustomerService service object {
    remote function onCustomerCreate(QuickBookEvent event) returns error?;
    remote function onCustomerUpdate(QuickBookEvent event) returns error?;
    remote function onCustomerDelete(QuickBookEvent event) returns error?;
    remote function onCustomerMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Department is received.
# Available actions: onDepartmentCreate, onDepartmentUpdate, and onDepartmentMerge.
public type DepartmentService service object {
    remote function onDepartmentCreate(QuickBookEvent event) returns error?;
    remote function onDepartmentUpdate(QuickBookEvent event) returns error?;
    remote function onDepartmentMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Deposit is received.
# Available actions: onDepositCreate, onDepositUpdate, and onDepositDelete.
public type DepositService service object {
    remote function onDepositCreate(QuickBookEvent event) returns error?;
    remote function onDepositUpdate(QuickBookEvent event) returns error?;
    remote function onDepositDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Employee is received.
# Available actions: onEmployeeCreate, onEmployeeUpdate, onEmployeeDelete, and onEmployeeMerge.
public type EmployeeService service object {
    remote function onEmployeeCreate(QuickBookEvent event) returns error?;
    remote function onEmployeeUpdate(QuickBookEvent event) returns error?;
    remote function onEmployeeDelete(QuickBookEvent event) returns error?;
    remote function onEmployeeMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Estimate is received.
# Available actions: onEstimateCreate, onEstimateUpdate, and onEstimateDelete.
public type EstimateService service object {
    remote function onEstimateCreate(QuickBookEvent event) returns error?;
    remote function onEstimateUpdate(QuickBookEvent event) returns error?;
    remote function onEstimateDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Invoice is received.
# Available actions: onInvoiceCreate, onInvoiceUpdate, onInvoiceDelete, and onInvoiceVoid.
public type InvoiceService service object {
    remote function onInvoiceCreate(QuickBookEvent event) returns error?;
    remote function onInvoiceUpdate(QuickBookEvent event) returns error?;
    remote function onInvoiceDelete(QuickBookEvent event) returns error?;
    remote function onInvoiceVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Item is received.
# Available actions: onItemCreate, onItemUpdate, onItemDelete, and onItemMerge.
public type ItemService service object {
    remote function onItemCreate(QuickBookEvent event) returns error?;
    remote function onItemUpdate(QuickBookEvent event) returns error?;
    remote function onItemDelete(QuickBookEvent event) returns error?;
    remote function onItemMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks JournalCode is received.
# Available actions: onJournalcodeCreate and onJournalcodeUpdate.
public type JournalCodeService service object {
    remote function onJournalcodeCreate(QuickBookEvent event) returns error?;
    remote function onJournalcodeUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks JournalEntry is received.
# Available actions: onJournalentryCreate, onJournalentryUpdate, and onJournalentryDelete.
public type JournalEntryService service object {
    remote function onJournalentryCreate(QuickBookEvent event) returns error?;
    remote function onJournalentryUpdate(QuickBookEvent event) returns error?;
    remote function onJournalentryDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Payment is received.
# Available actions: onPaymentCreate, onPaymentUpdate, onPaymentDelete, and onPaymentVoid.
public type PaymentService service object {
    remote function onPaymentCreate(QuickBookEvent event) returns error?;
    remote function onPaymentUpdate(QuickBookEvent event) returns error?;
    remote function onPaymentDelete(QuickBookEvent event) returns error?;
    remote function onPaymentVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks PaymentMethod is received.
# Available actions: onPaymentmethodCreate, onPaymentmethodUpdate, and onPaymentmethodMerge.
public type PaymentMethodService service object {
    remote function onPaymentmethodCreate(QuickBookEvent event) returns error?;
    remote function onPaymentmethodUpdate(QuickBookEvent event) returns error?;
    remote function onPaymentmethodMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Preferences is received.
# Available action: onPreferencesUpdate.
public type PreferencesService service object {
    remote function onPreferencesUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Purchase is received.
# Available actions: onPurchaseCreate, onPurchaseUpdate, onPurchaseDelete, and onPurchaseVoid.
public type PurchaseService service object {
    remote function onPurchaseCreate(QuickBookEvent event) returns error?;
    remote function onPurchaseUpdate(QuickBookEvent event) returns error?;
    remote function onPurchaseDelete(QuickBookEvent event) returns error?;
    remote function onPurchaseVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks PurchaseOrder is received.
# Available actions: onPurchaseorderCreate, onPurchaseorderUpdate, and onPurchaseorderDelete.
public type PurchaseOrderService service object {
    remote function onPurchaseorderCreate(QuickBookEvent event) returns error?;
    remote function onPurchaseorderUpdate(QuickBookEvent event) returns error?;
    remote function onPurchaseorderDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks RefundReceipt is received.
# Available actions: onRefundreceiptCreate, onRefundreceiptUpdate, onRefundreceiptDelete, and onRefundreceiptVoid.
public type RefundReceiptService service object {
    remote function onRefundreceiptCreate(QuickBookEvent event) returns error?;
    remote function onRefundreceiptUpdate(QuickBookEvent event) returns error?;
    remote function onRefundreceiptDelete(QuickBookEvent event) returns error?;
    remote function onRefundreceiptVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks SalesReceipt is received.
# Available actions: onRefundreceiptCreate, onRefundreceiptUpdate, onRefundreceiptDelete, and onRefundreceiptVoid.
public type SalesReceiptService service object {
    remote function onRefundreceiptCreate(QuickBookEvent event) returns error?;
    remote function onRefundreceiptUpdate(QuickBookEvent event) returns error?;
    remote function onRefundreceiptDelete(QuickBookEvent event) returns error?;
    remote function onRefundreceiptVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks TaxAgency is received.
# Available actions: onTaxagencyCreate and onTaxagencyUpdate.
public type TaxAgencyService service object {
    remote function onTaxagencyCreate(QuickBookEvent event) returns error?;
    remote function onTaxagencyUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Term is received.
# Available actions: onTermCreate and onTermUpdate.
public type TermService service object {
    remote function onTermCreate(QuickBookEvent event) returns error?;
    remote function onTermUpdate(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks TimeActivity is received.
# Available actions: onTimeactivityCreate, onTimeactivityUpdate and onTimeactivityDelete.
public type TimeActivityService service object {
    remote function onTimeactivityCreate(QuickBookEvent event) returns error?;
    remote function onTimeactivityUpdate(QuickBookEvent event) returns error?;
    remote function onTimeactivityDelete(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Transfer is received.
# Available actions: onTransferCreate, onTransferUpdate, onTransferDelete and onTransferVoid.
public type TransferService service object {
    remote function onTransferCreate(QuickBookEvent event) returns error?;
    remote function onTransferUpdate(QuickBookEvent event) returns error?;
    remote function onTransferDelete(QuickBookEvent event) returns error?;
    remote function onTransferVoid(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks Vendor is received.
# Available actions: onVendorCreate, onVendorUpdate, onVendorDelete and onVendorMerge.
public type VendorService service object {
    remote function onVendorCreate(QuickBookEvent event) returns error?;
    remote function onVendorUpdate(QuickBookEvent event) returns error?;
    remote function onVendorDelete(QuickBookEvent event) returns error?;
    remote function onVendorMerge(QuickBookEvent event) returns error?;
};

# Triggers when a new event related to Quickbooks VendorCredit is received.
# Available actions: onVendorcreditCreate, onVendorcreditUpdate, and onVendorcreditDelete.
public type VendorCreditService service object {
    remote function onVendorcreditCreate(QuickBookEvent event) returns error?;
    remote function onVendorcreditUpdate(QuickBookEvent event) returns error?;
    remote function onVendorcreditDelete(QuickBookEvent event) returns error?;
};

public type GenericServiceType AccountService|BillService|BillPaymentService|BudgetService|ClassService|CreditMemoService|CurrencyService|CustomerService|DepartmentService|DepositService|EmployeeService|EstimateService|InvoiceService|ItemService|JournalCodeService|JournalEntryService|PaymentService|PaymentMethodService|PreferencesService|PurchaseService|PurchaseOrderService|RefundReceiptService|SalesReceiptService|TaxAgencyService|TermService|TimeActivityService|TransferService|VendorService|VendorCreditService;
