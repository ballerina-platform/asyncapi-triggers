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

import ballerina/crypto;
import ballerina/http;
import ballerina/log;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string webhookSecret;

    function init(string webhookSecret) {
        self.webhookSecret = webhookSecret;
    }

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error(string `Service of type ${serviceType} has already been attached`);
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error(string `Cannot detach the service of type ${serviceType}. Service has not been attached to the listener before`);
        }
        _ = self.services.remove(serviceType);
    }

    resource function post .(http:Caller caller, http:Request request) returns error? {
        error? verifyResult = self.verifyWebhookSignature(request, self.webhookSecret);
        if verifyResult is error {
            http:Response r = new;
            r.statusCode = http:STATUS_UNAUTHORIZED;
            check caller->respond(r);
            return;
        }
        json payload = check request.getJsonPayload();
        json[] eventsArray = check payload.ensureType();
        http:Response ackResponse = new;
        ackResponse.statusCode = http:STATUS_OK;
        check caller->respond(ackResponse);
        _ = start self.dispatchBatchedEvents(eventsArray, "");
    }

    isolated function dispatchBatchedEvents(json[] eventsArray, string eventType) returns error? {
        foreach json event in eventsArray {
            json|error eventTypeField = event.'type;
            if eventTypeField is error {
                log:printError("DISPATCH_FAILED", eventTypeField);
                continue;
            }
            string elementEventType = eventTypeField.toString();
            GenericDataType|error genericDataTypeResult = event.cloneWithType(GenericDataType);
            if genericDataTypeResult is error {
                log:printError("DISPATCH_FAILED", genericDataTypeResult);
                continue;
            }
            error? dispatchResult = self.matchRemoteFunc(genericDataTypeResult, elementEventType);
            if dispatchResult is error {
                log:printError("DISPATCH_FAILED", dispatchResult);
            }
        }
    }

    private isolated function verifyWebhookSignature(http:Request request, string webhookSecret) returns error? {
        if !request.hasHeader("Intuit-Signature") {
            return error("Unauthorized: Missing Signature Header");
        }
        string receivedHeader = check request.getHeader("Intuit-Signature");
        map<string> extractedHeaderValues = {};
        int headerCursor = 0;
        extractedHeaderValues["signature"] = receivedHeader.substring(headerCursor);
        headerCursor = receivedHeader.length();
        if !extractedHeaderValues.hasKey("signature") {
            return error("Unauthorized: Missing Header Component: signature");
        }
        string payloadToHash = string `${check request.getTextPayload()}`;
        byte[] computedDigest = check crypto:hmacSha256(payloadToHash.toBytes(), webhookSecret.toBytes());
        string computedSignature = computedDigest.toBase64();
        string expectedHeader = string `${computedSignature}`;
        if !crypto:equalConstantTime(receivedHeader.toBytes(), expectedHeader.toBytes()) {
            return error("Unauthorized: Signature Mismatch");
        }
    }

    private isolated function matchRemoteFunc(GenericDataType genericDataType, string eventType) returns error? {
        check self.matchRemoteFuncForCompanyCurrency(genericDataType);
        check self.matchRemoteFuncForAccount(genericDataType);
        check self.matchRemoteFuncForEstimate(genericDataType);
        check self.matchRemoteFuncForInvoice(genericDataType);
        check self.matchRemoteFuncForCustomer(genericDataType);
        check self.matchRemoteFuncForTaxAgency(genericDataType);
        check self.matchRemoteFuncForJournalEntry(genericDataType);
        check self.matchRemoteFuncForItem(genericDataType);
        check self.matchRemoteFuncForDepartment(genericDataType);
        check self.matchRemoteFuncForRefundReceipt(genericDataType);
        check self.matchRemoteFuncForCurrency(genericDataType);
        check self.matchRemoteFuncForBillPayment(genericDataType);
        check self.matchRemoteFuncForCreditMemo(genericDataType);
        check self.matchRemoteFuncForBudget(genericDataType);
        check self.matchRemoteFuncForPreferences(genericDataType);
        check self.matchRemoteFuncForTimeActivity(genericDataType);
        check self.matchRemoteFuncForDeposit(genericDataType);
        check self.matchRemoteFuncForJournalCode(genericDataType);
        check self.matchRemoteFuncForPurchase(genericDataType);
        check self.matchRemoteFuncForVendorCredit(genericDataType);
        check self.matchRemoteFuncForTerm(genericDataType);
        check self.matchRemoteFuncForVendor(genericDataType);
        check self.matchRemoteFuncForPayment(genericDataType);
        check self.matchRemoteFuncForSalesReceipt(genericDataType);
        check self.matchRemoteFuncForEmployee(genericDataType);
        check self.matchRemoteFuncForChangeOrder(genericDataType);
        check self.matchRemoteFuncForTransfer(genericDataType);
        check self.matchRemoteFuncForBill(genericDataType);
        check self.matchRemoteFuncForPurchaseOrder(genericDataType);
        check self.matchRemoteFuncForPaymentMethod(genericDataType);
        check self.matchRemoteFuncForClass(genericDataType);
    }

    private isolated function matchRemoteFuncForCompanyCurrency(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.companycurrency.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.companycurrency.updated.v1", "CompanyCurrencyService", "onCompanyCurrencyUpdated");
            }
            "qbo.companycurrency.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.companycurrency.deleted.v1", "CompanyCurrencyService", "onCompanyCurrencyDeleted");
            }
            "qbo.companycurrency.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.companycurrency.created.v1", "CompanyCurrencyService", "onCompanyCurrencyCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForAccount(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.account.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.account.merged.v1", "AccountService", "onAccountMerged");
            }
            "qbo.account.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.account.updated.v1", "AccountService", "onAccountUpdated");
            }
            "qbo.account.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.account.created.v1", "AccountService", "onAccountCreated");
            }
            "qbo.account.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.account.deleted.v1", "AccountService", "onAccountDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForEstimate(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.estimate.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.estimate.created.v1", "EstimateService", "onEstimateCreated");
            }
            "qbo.estimate.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.estimate.emailed.v1", "EstimateService", "onEstimateEmailed");
            }
            "qbo.estimate.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.estimate.deleted.v1", "EstimateService", "onEstimateDeleted");
            }
            "qbo.estimate.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.estimate.updated.v1", "EstimateService", "onEstimateUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForInvoice(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.invoice.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.invoice.created.v1", "InvoiceService", "onInvoiceCreated");
            }
            "qbo.invoice.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.invoice.updated.v1", "InvoiceService", "onInvoiceUpdated");
            }
            "qbo.invoice.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.invoice.deleted.v1", "InvoiceService", "onInvoiceDeleted");
            }
            "qbo.invoice.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.invoice.emailed.v1", "InvoiceService", "onInvoiceEmailed");
            }
            "qbo.invoice.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.invoice.void.v1", "InvoiceService", "onInvoiceVoided");
            }
        }
    }

    private isolated function matchRemoteFuncForCustomer(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.customer.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.customer.deleted.v1", "CustomerService", "onCustomerDeleted");
            }
            "qbo.customer.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.customer.created.v1", "CustomerService", "onCustomerCreated");
            }
            "qbo.customer.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.customer.updated.v1", "CustomerService", "onCustomerUpdated");
            }
            "qbo.customer.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.customer.merged.v1", "CustomerService", "onCustomerMerged");
            }
        }
    }

    private isolated function matchRemoteFuncForTaxAgency(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.taxagency.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.taxagency.updated.v1", "TaxAgencyService", "onTaxAgencyUpdated");
            }
            "qbo.taxagency.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.taxagency.created.v1", "TaxAgencyService", "onTaxAgencyCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForJournalEntry(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.journalentry.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.journalentry.updated.v1", "JournalEntryService", "onJournalEntryUpdated");
            }
            "qbo.journalentry.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.journalentry.deleted.v1", "JournalEntryService", "onJournalEntryDeleted");
            }
            "qbo.journalentry.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.journalentry.created.v1", "JournalEntryService", "onJournalEntryCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForItem(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.item.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.item.created.v1", "ItemService", "onItemCreated");
            }
            "qbo.item.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.item.deleted.v1", "ItemService", "onItemDeleted");
            }
            "qbo.item.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.item.updated.v1", "ItemService", "onItemUpdated");
            }
            "qbo.item.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.item.merged.v1", "ItemService", "onItemMerged");
            }
        }
    }

    private isolated function matchRemoteFuncForDepartment(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.department.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.department.created.v1", "DepartmentService", "onDepartmentCreated");
            }
            "qbo.department.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.department.merged.v1", "DepartmentService", "onDepartmentMerged");
            }
            "qbo.department.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.department.updated.v1", "DepartmentService", "onDepartmentUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForRefundReceipt(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.refundreceipt.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.refundreceipt.created.v1", "RefundReceiptService", "onRefundReceiptCreated");
            }
            "qbo.refundreceipt.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.refundreceipt.deleted.v1", "RefundReceiptService", "onRefundReceiptDeleted");
            }
            "qbo.refundreceipt.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.refundreceipt.emailed.v1", "RefundReceiptService", "onRefundReceiptEmailed");
            }
            "qbo.refundreceipt.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.refundreceipt.void.v1", "RefundReceiptService", "onRefundReceiptVoided");
            }
            "qbo.refundreceipt.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.refundreceipt.updated.v1", "RefundReceiptService", "onRefundReceiptUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForCurrency(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.currency.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.currency.created.v1", "CurrencyService", "onCurrencyCreated");
            }
            "qbo.currency.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.currency.deleted.v1", "CurrencyService", "onCurrencyDeleted");
            }
            "qbo.currency.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.currency.updated.v1", "CurrencyService", "onCurrencyUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForBillPayment(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.billpayment.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.billpayment.created.v1", "BillPaymentService", "onBillPaymentCreated");
            }
            "qbo.billpayment.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.billpayment.deleted.v1", "BillPaymentService", "onBillPaymentDeleted");
            }
            "qbo.billpayment.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.billpayment.void.v1", "BillPaymentService", "onBillPaymentVoided");
            }
            "qbo.billpayment.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.billpayment.updated.v1", "BillPaymentService", "onBillPaymentUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForCreditMemo(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.creditmemo.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.creditmemo.updated.v1", "CreditMemoService", "onCreditMemoUpdated");
            }
            "qbo.creditmemo.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.creditmemo.void.v1", "CreditMemoService", "onCreditMemoVoided");
            }
            "qbo.creditmemo.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.creditmemo.emailed.v1", "CreditMemoService", "onCreditMemoEmailed");
            }
            "qbo.creditmemo.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.creditmemo.created.v1", "CreditMemoService", "onCreditMemoCreated");
            }
            "qbo.creditmemo.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.creditmemo.deleted.v1", "CreditMemoService", "onCreditMemoDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForBudget(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.budget.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.budget.updated.v1", "BudgetService", "onBudgetUpdated");
            }
            "qbo.budget.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.budget.created.v1", "BudgetService", "onBudgetCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForPreferences(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.preferences.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.preferences.updated.v1", "PreferencesService", "onPreferencesUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForTimeActivity(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.timeactivity.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.timeactivity.created.v1", "TimeActivityService", "onTimeActivityCreated");
            }
            "qbo.timeactivity.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.timeactivity.updated.v1", "TimeActivityService", "onTimeActivityUpdated");
            }
            "qbo.timeactivity.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.timeactivity.deleted.v1", "TimeActivityService", "onTimeActivityDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForDeposit(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.deposit.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.deposit.created.v1", "DepositService", "onDepositCreated");
            }
            "qbo.deposit.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.deposit.updated.v1", "DepositService", "onDepositUpdated");
            }
            "qbo.deposit.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.deposit.deleted.v1", "DepositService", "onDepositDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForJournalCode(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.journalcode.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.journalcode.updated.v1", "JournalCodeService", "onJournalCodeUpdated");
            }
            "qbo.journalcode.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.journalcode.created.v1", "JournalCodeService", "onJournalCodeCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForPurchase(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.purchase.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchase.void.v1", "PurchaseService", "onPurchaseVoided");
            }
            "qbo.purchase.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchase.updated.v1", "PurchaseService", "onPurchaseUpdated");
            }
            "qbo.purchase.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchase.deleted.v1", "PurchaseService", "onPurchaseDeleted");
            }
            "qbo.purchase.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchase.created.v1", "PurchaseService", "onPurchaseCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForVendorCredit(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.vendorcredit.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendorcredit.created.v1", "VendorCreditService", "onVendorCreditCreated");
            }
            "qbo.vendorcredit.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendorcredit.deleted.v1", "VendorCreditService", "onVendorCreditDeleted");
            }
            "qbo.vendorcredit.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendorcredit.updated.v1", "VendorCreditService", "onVendorCreditUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForTerm(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.term.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.term.created.v1", "TermService", "onTermCreated");
            }
            "qbo.term.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.term.updated.v1", "TermService", "onTermUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForVendor(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.vendor.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendor.updated.v1", "VendorService", "onVendorUpdated");
            }
            "qbo.vendor.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendor.deleted.v1", "VendorService", "onVendorDeleted");
            }
            "qbo.vendor.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendor.merged.v1", "VendorService", "onVendorMerged");
            }
            "qbo.vendor.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.vendor.created.v1", "VendorService", "onVendorCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForPayment(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.payment.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.payment.updated.v1", "PaymentService", "onPaymentUpdated");
            }
            "qbo.payment.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.payment.emailed.v1", "PaymentService", "onPaymentEmailed");
            }
            "qbo.payment.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.payment.void.v1", "PaymentService", "onPaymentVoided");
            }
            "qbo.payment.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.payment.created.v1", "PaymentService", "onPaymentCreated");
            }
            "qbo.payment.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.payment.deleted.v1", "PaymentService", "onPaymentDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForSalesReceipt(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.salesreceipt.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.salesreceipt.created.v1", "SalesReceiptService", "onSalesReceiptCreated");
            }
            "qbo.salesreceipt.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.salesreceipt.deleted.v1", "SalesReceiptService", "onSalesReceiptDeleted");
            }
            "qbo.salesreceipt.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.salesreceipt.void.v1", "SalesReceiptService", "onSalesReceiptVoided");
            }
            "qbo.salesreceipt.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.salesreceipt.updated.v1", "SalesReceiptService", "onSalesReceiptUpdated");
            }
            "qbo.salesreceipt.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.salesreceipt.emailed.v1", "SalesReceiptService", "onSalesReceiptEmailed");
            }
        }
    }

    private isolated function matchRemoteFuncForEmployee(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.employee.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.employee.updated.v1", "EmployeeService", "onEmployeeUpdated");
            }
            "qbo.employee.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.employee.merged.v1", "EmployeeService", "onEmployeeMerged");
            }
            "qbo.employee.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.employee.created.v1", "EmployeeService", "onEmployeeCreated");
            }
            "qbo.employee.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.employee.deleted.v1", "EmployeeService", "onEmployeeDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForChangeOrder(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.changeorder.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.changeorder.created.v1", "ChangeOrderService", "onChangeOrderCreated");
            }
            "qbo.changeorder.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.changeorder.updated.v1", "ChangeOrderService", "onChangeOrderUpdated");
            }
            "qbo.changeorder.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.changeorder.deleted.v1", "ChangeOrderService", "onChangeOrderDeleted");
            }
        }
    }

    private isolated function matchRemoteFuncForTransfer(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.transfer.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.transfer.created.v1", "TransferService", "onTransferCreated");
            }
            "qbo.transfer.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.transfer.deleted.v1", "TransferService", "onTransferDeleted");
            }
            "qbo.transfer.void.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.transfer.void.v1", "TransferService", "onTransferVoided");
            }
            "qbo.transfer.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.transfer.updated.v1", "TransferService", "onTransferUpdated");
            }
        }
    }

    private isolated function matchRemoteFuncForBill(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.bill.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.bill.updated.v1", "BillService", "onBillUpdated");
            }
            "qbo.bill.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.bill.deleted.v1", "BillService", "onBillDeleted");
            }
            "qbo.bill.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.bill.created.v1", "BillService", "onBillCreated");
            }
        }
    }

    private isolated function matchRemoteFuncForPurchaseOrder(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.purchaseorder.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchaseorder.deleted.v1", "PurchaseOrderService", "onPurchaseOrderDeleted");
            }
            "qbo.purchaseorder.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchaseorder.created.v1", "PurchaseOrderService", "onPurchaseOrderCreated");
            }
            "qbo.purchaseorder.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchaseorder.updated.v1", "PurchaseOrderService", "onPurchaseOrderUpdated");
            }
            "qbo.purchaseorder.emailed.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.purchaseorder.emailed.v1", "PurchaseOrderService", "onPurchaseOrderEmailed");
            }
        }
    }

    private isolated function matchRemoteFuncForPaymentMethod(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.paymentmethod.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.paymentmethod.updated.v1", "PaymentMethodService", "onPaymentMethodUpdated");
            }
            "qbo.paymentmethod.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.paymentmethod.created.v1", "PaymentMethodService", "onPaymentMethodCreated");
            }
            "qbo.paymentmethod.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.paymentmethod.merged.v1", "PaymentMethodService", "onPaymentMethodMerged");
            }
        }
    }

    private isolated function matchRemoteFuncForClass(GenericDataType genericDataType) returns error? {
        match genericDataType.'type {
            "qbo.class.updated.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.class.updated.v1", "ClassService", "onClassUpdated");
            }
            "qbo.class.deleted.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.class.deleted.v1", "ClassService", "onClassDeleted");
            }
            "qbo.class.created.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.class.created.v1", "ClassService", "onClassCreated");
            }
            "qbo.class.merged.v1" => {
                check self.executeRemoteFunc(genericDataType, "qbo.class.merged.v1", "ClassService", "onClassMerged");
            }
        }
    }

    private isolated function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
