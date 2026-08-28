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
import ballerina/io;
import ballerina/lang.runtime;
import ballerina/test;

const TRIGGER_TEST_SECRET = "trigger-test-secret";
const TRIGGER_TEST_PORT = 9091;
const TRIGGER_PAYLOAD_DIR = "tests/resources/trigger_payloads";

isolated map<boolean> triggerFired = {};

listener Listener triggerTestListener = check new ({webhookSecret: TRIGGER_TEST_SECRET}, TRIGGER_TEST_PORT);

final http:Client triggerClient = check new (string `http://localhost:${TRIGGER_TEST_PORT}`);

service TaxAgencyService on triggerTestListener {
    isolated remote function onTaxAgencyUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TaxAgencyService.onTaxAgencyUpdated"] = true;
        }
    }

    isolated remote function onTaxAgencyCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TaxAgencyService.onTaxAgencyCreated"] = true;
        }
    }
}

service TimeActivityService on triggerTestListener {
    isolated remote function onTimeActivityCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TimeActivityService.onTimeActivityCreated"] = true;
        }
    }

    isolated remote function onTimeActivityUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TimeActivityService.onTimeActivityUpdated"] = true;
        }
    }

    isolated remote function onTimeActivityDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TimeActivityService.onTimeActivityDeleted"] = true;
        }
    }
}

service PurchaseService on triggerTestListener {
    isolated remote function onPurchaseVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseService.onPurchaseVoided"] = true;
        }
    }

    isolated remote function onPurchaseUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseService.onPurchaseUpdated"] = true;
        }
    }

    isolated remote function onPurchaseDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseService.onPurchaseDeleted"] = true;
        }
    }

    isolated remote function onPurchaseCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseService.onPurchaseCreated"] = true;
        }
    }
}

service RefundReceiptService on triggerTestListener {
    isolated remote function onRefundReceiptCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["RefundReceiptService.onRefundReceiptCreated"] = true;
        }
    }

    isolated remote function onRefundReceiptDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["RefundReceiptService.onRefundReceiptDeleted"] = true;
        }
    }

    isolated remote function onRefundReceiptEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["RefundReceiptService.onRefundReceiptEmailed"] = true;
        }
    }

    isolated remote function onRefundReceiptVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["RefundReceiptService.onRefundReceiptVoided"] = true;
        }
    }

    isolated remote function onRefundReceiptUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["RefundReceiptService.onRefundReceiptUpdated"] = true;
        }
    }
}

service ItemService on triggerTestListener {
    isolated remote function onItemCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ItemService.onItemCreated"] = true;
        }
    }

    isolated remote function onItemDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ItemService.onItemDeleted"] = true;
        }
    }

    isolated remote function onItemUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ItemService.onItemUpdated"] = true;
        }
    }

    isolated remote function onItemMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ItemService.onItemMerged"] = true;
        }
    }
}

service BudgetService on triggerTestListener {
    isolated remote function onBudgetUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BudgetService.onBudgetUpdated"] = true;
        }
    }

    isolated remote function onBudgetCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BudgetService.onBudgetCreated"] = true;
        }
    }
}

service BillPaymentService on triggerTestListener {
    isolated remote function onBillPaymentCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillPaymentService.onBillPaymentCreated"] = true;
        }
    }

    isolated remote function onBillPaymentDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillPaymentService.onBillPaymentDeleted"] = true;
        }
    }

    isolated remote function onBillPaymentVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillPaymentService.onBillPaymentVoided"] = true;
        }
    }

    isolated remote function onBillPaymentUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillPaymentService.onBillPaymentUpdated"] = true;
        }
    }
}

service JournalCodeService on triggerTestListener {
    isolated remote function onJournalCodeUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["JournalCodeService.onJournalCodeUpdated"] = true;
        }
    }

    isolated remote function onJournalCodeCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["JournalCodeService.onJournalCodeCreated"] = true;
        }
    }
}

service EmployeeService on triggerTestListener {
    isolated remote function onEmployeeUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EmployeeService.onEmployeeUpdated"] = true;
        }
    }

    isolated remote function onEmployeeMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EmployeeService.onEmployeeMerged"] = true;
        }
    }

    isolated remote function onEmployeeCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EmployeeService.onEmployeeCreated"] = true;
        }
    }

    isolated remote function onEmployeeDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EmployeeService.onEmployeeDeleted"] = true;
        }
    }
}

service BillService on triggerTestListener {
    isolated remote function onBillUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillService.onBillUpdated"] = true;
        }
    }

    isolated remote function onBillDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillService.onBillDeleted"] = true;
        }
    }

    isolated remote function onBillCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["BillService.onBillCreated"] = true;
        }
    }
}

service ChangeOrderService on triggerTestListener {
    isolated remote function onChangeOrderCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ChangeOrderService.onChangeOrderCreated"] = true;
        }
    }

    isolated remote function onChangeOrderUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ChangeOrderService.onChangeOrderUpdated"] = true;
        }
    }

    isolated remote function onChangeOrderDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ChangeOrderService.onChangeOrderDeleted"] = true;
        }
    }
}

service VendorService on triggerTestListener {
    isolated remote function onVendorUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorService.onVendorUpdated"] = true;
        }
    }

    isolated remote function onVendorDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorService.onVendorDeleted"] = true;
        }
    }

    isolated remote function onVendorMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorService.onVendorMerged"] = true;
        }
    }

    isolated remote function onVendorCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorService.onVendorCreated"] = true;
        }
    }
}

service TransferService on triggerTestListener {
    isolated remote function onTransferCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TransferService.onTransferCreated"] = true;
        }
    }

    isolated remote function onTransferDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TransferService.onTransferDeleted"] = true;
        }
    }

    isolated remote function onTransferVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TransferService.onTransferVoided"] = true;
        }
    }

    isolated remote function onTransferUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TransferService.onTransferUpdated"] = true;
        }
    }
}

service SalesReceiptService on triggerTestListener {
    isolated remote function onSalesReceiptCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["SalesReceiptService.onSalesReceiptCreated"] = true;
        }
    }

    isolated remote function onSalesReceiptDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["SalesReceiptService.onSalesReceiptDeleted"] = true;
        }
    }

    isolated remote function onSalesReceiptVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["SalesReceiptService.onSalesReceiptVoided"] = true;
        }
    }

    isolated remote function onSalesReceiptUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["SalesReceiptService.onSalesReceiptUpdated"] = true;
        }
    }

    isolated remote function onSalesReceiptEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["SalesReceiptService.onSalesReceiptEmailed"] = true;
        }
    }
}

service CreditMemoService on triggerTestListener {
    isolated remote function onCreditMemoUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CreditMemoService.onCreditMemoUpdated"] = true;
        }
    }

    isolated remote function onCreditMemoVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CreditMemoService.onCreditMemoVoided"] = true;
        }
    }

    isolated remote function onCreditMemoEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CreditMemoService.onCreditMemoEmailed"] = true;
        }
    }

    isolated remote function onCreditMemoCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CreditMemoService.onCreditMemoCreated"] = true;
        }
    }

    isolated remote function onCreditMemoDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CreditMemoService.onCreditMemoDeleted"] = true;
        }
    }
}

service PaymentService on triggerTestListener {
    isolated remote function onPaymentUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentService.onPaymentUpdated"] = true;
        }
    }

    isolated remote function onPaymentEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentService.onPaymentEmailed"] = true;
        }
    }

    isolated remote function onPaymentVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentService.onPaymentVoided"] = true;
        }
    }

    isolated remote function onPaymentCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentService.onPaymentCreated"] = true;
        }
    }

    isolated remote function onPaymentDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentService.onPaymentDeleted"] = true;
        }
    }
}

service PaymentMethodService on triggerTestListener {
    isolated remote function onPaymentMethodUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentMethodService.onPaymentMethodUpdated"] = true;
        }
    }

    isolated remote function onPaymentMethodCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentMethodService.onPaymentMethodCreated"] = true;
        }
    }

    isolated remote function onPaymentMethodMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PaymentMethodService.onPaymentMethodMerged"] = true;
        }
    }
}

service CustomerService on triggerTestListener {
    isolated remote function onCustomerDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CustomerService.onCustomerDeleted"] = true;
        }
    }

    isolated remote function onCustomerCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CustomerService.onCustomerCreated"] = true;
        }
    }

    isolated remote function onCustomerUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CustomerService.onCustomerUpdated"] = true;
        }
    }

    isolated remote function onCustomerMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CustomerService.onCustomerMerged"] = true;
        }
    }
}

service PurchaseOrderService on triggerTestListener {
    isolated remote function onPurchaseOrderDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseOrderService.onPurchaseOrderDeleted"] = true;
        }
    }

    isolated remote function onPurchaseOrderCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseOrderService.onPurchaseOrderCreated"] = true;
        }
    }

    isolated remote function onPurchaseOrderUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseOrderService.onPurchaseOrderUpdated"] = true;
        }
    }

    isolated remote function onPurchaseOrderEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PurchaseOrderService.onPurchaseOrderEmailed"] = true;
        }
    }
}

service CompanyCurrencyService on triggerTestListener {
    isolated remote function onCompanyCurrencyUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CompanyCurrencyService.onCompanyCurrencyUpdated"] = true;
        }
    }

    isolated remote function onCompanyCurrencyDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CompanyCurrencyService.onCompanyCurrencyDeleted"] = true;
        }
    }

    isolated remote function onCompanyCurrencyCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CompanyCurrencyService.onCompanyCurrencyCreated"] = true;
        }
    }
}

service EstimateService on triggerTestListener {
    isolated remote function onEstimateCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EstimateService.onEstimateCreated"] = true;
        }
    }

    isolated remote function onEstimateEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EstimateService.onEstimateEmailed"] = true;
        }
    }

    isolated remote function onEstimateDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EstimateService.onEstimateDeleted"] = true;
        }
    }

    isolated remote function onEstimateUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["EstimateService.onEstimateUpdated"] = true;
        }
    }
}

service PreferencesService on triggerTestListener {
    isolated remote function onPreferencesUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["PreferencesService.onPreferencesUpdated"] = true;
        }
    }
}

service ClassService on triggerTestListener {
    isolated remote function onClassUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ClassService.onClassUpdated"] = true;
        }
    }

    isolated remote function onClassDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ClassService.onClassDeleted"] = true;
        }
    }

    isolated remote function onClassCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ClassService.onClassCreated"] = true;
        }
    }

    isolated remote function onClassMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["ClassService.onClassMerged"] = true;
        }
    }
}

service DepositService on triggerTestListener {
    isolated remote function onDepositCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepositService.onDepositCreated"] = true;
        }
    }

    isolated remote function onDepositUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepositService.onDepositUpdated"] = true;
        }
    }

    isolated remote function onDepositDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepositService.onDepositDeleted"] = true;
        }
    }
}

service InvoiceService on triggerTestListener {
    isolated remote function onInvoiceCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["InvoiceService.onInvoiceCreated"] = true;
        }
    }

    isolated remote function onInvoiceUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["InvoiceService.onInvoiceUpdated"] = true;
        }
    }

    isolated remote function onInvoiceDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["InvoiceService.onInvoiceDeleted"] = true;
        }
    }

    isolated remote function onInvoiceEmailed(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["InvoiceService.onInvoiceEmailed"] = true;
        }
    }

    isolated remote function onInvoiceVoided(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["InvoiceService.onInvoiceVoided"] = true;
        }
    }
}

service TermService on triggerTestListener {
    isolated remote function onTermCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TermService.onTermCreated"] = true;
        }
    }

    isolated remote function onTermUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["TermService.onTermUpdated"] = true;
        }
    }
}

service CurrencyService on triggerTestListener {
    isolated remote function onCurrencyCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CurrencyService.onCurrencyCreated"] = true;
        }
    }

    isolated remote function onCurrencyDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CurrencyService.onCurrencyDeleted"] = true;
        }
    }

    isolated remote function onCurrencyUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["CurrencyService.onCurrencyUpdated"] = true;
        }
    }
}

service AccountService on triggerTestListener {
    isolated remote function onAccountMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["AccountService.onAccountMerged"] = true;
        }
    }

    isolated remote function onAccountUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["AccountService.onAccountUpdated"] = true;
        }
    }

    isolated remote function onAccountCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["AccountService.onAccountCreated"] = true;
        }
    }

    isolated remote function onAccountDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["AccountService.onAccountDeleted"] = true;
        }
    }
}

service JournalEntryService on triggerTestListener {
    isolated remote function onJournalEntryUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["JournalEntryService.onJournalEntryUpdated"] = true;
        }
    }

    isolated remote function onJournalEntryDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["JournalEntryService.onJournalEntryDeleted"] = true;
        }
    }

    isolated remote function onJournalEntryCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["JournalEntryService.onJournalEntryCreated"] = true;
        }
    }
}

service DepartmentService on triggerTestListener {
    isolated remote function onDepartmentCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepartmentService.onDepartmentCreated"] = true;
        }
    }

    isolated remote function onDepartmentMerged(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepartmentService.onDepartmentMerged"] = true;
        }
    }

    isolated remote function onDepartmentUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["DepartmentService.onDepartmentUpdated"] = true;
        }
    }
}

service VendorCreditService on triggerTestListener {
    isolated remote function onVendorCreditCreated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorCreditService.onVendorCreditCreated"] = true;
        }
    }

    isolated remote function onVendorCreditDeleted(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorCreditService.onVendorCreditDeleted"] = true;
        }
    }

    isolated remote function onVendorCreditUpdated(QuickBookEvent payload) returns error? {
        lock {
            triggerFired["VendorCreditService.onVendorCreditUpdated"] = true;
        }
    }
}

isolated function sendSignedTriggerWebhook(string headerValue, string eventIdentifier) returns http:Response|error {
    byte[] body = check io:fileReadBytes(string `${TRIGGER_PAYLOAD_DIR}/${eventIdentifier}.json`);
    string bodyText = check string:fromBytes(body);
    string payloadToHash = string `${bodyText}`;
    byte[] computedDigest = check crypto:hmacSha256(payloadToHash.toBytes(), TRIGGER_TEST_SECRET.toBytes());
    string computedSignature = computedDigest.toBase64();
    map<string> headers = {
        "Intuit-Signature": string `${computedSignature}`
    };
    return triggerClient->post("/", body, headers, "application/json");
}

function waitForDispatch(string trackerKey) returns boolean {
    foreach int i in 0 ..< 20 {
        lock {
            if triggerFired[trackerKey] ?: false {
                return true;
            }
        }
        runtime:sleep(0.05);
    }
    return false;
}

@test:Config {}
function testTaxAgencyUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.taxagency.updated.v1", "qbo.taxagency.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TaxAgencyService.onTaxAgencyUpdated"), "TaxAgencyService.onTaxAgencyUpdated should have fired");
}

@test:Config {}
function testTaxAgencyCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.taxagency.created.v1", "qbo.taxagency.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TaxAgencyService.onTaxAgencyCreated"), "TaxAgencyService.onTaxAgencyCreated should have fired");
}

@test:Config {}
function testTimeActivityCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.timeactivity.created.v1", "qbo.timeactivity.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TimeActivityService.onTimeActivityCreated"), "TimeActivityService.onTimeActivityCreated should have fired");
}

@test:Config {}
function testTimeActivityUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.timeactivity.updated.v1", "qbo.timeactivity.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TimeActivityService.onTimeActivityUpdated"), "TimeActivityService.onTimeActivityUpdated should have fired");
}

@test:Config {}
function testTimeActivityDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.timeactivity.deleted.v1", "qbo.timeactivity.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TimeActivityService.onTimeActivityDeleted"), "TimeActivityService.onTimeActivityDeleted should have fired");
}

@test:Config {}
function testPurchaseVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchase.void.v1", "qbo.purchase.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseService.onPurchaseVoided"), "PurchaseService.onPurchaseVoided should have fired");
}

@test:Config {}
function testPurchaseUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchase.updated.v1", "qbo.purchase.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseService.onPurchaseUpdated"), "PurchaseService.onPurchaseUpdated should have fired");
}

@test:Config {}
function testPurchaseDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchase.deleted.v1", "qbo.purchase.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseService.onPurchaseDeleted"), "PurchaseService.onPurchaseDeleted should have fired");
}

@test:Config {}
function testPurchaseCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchase.created.v1", "qbo.purchase.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseService.onPurchaseCreated"), "PurchaseService.onPurchaseCreated should have fired");
}

@test:Config {}
function testRefundReceiptCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.refundreceipt.created.v1", "qbo.refundreceipt.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RefundReceiptService.onRefundReceiptCreated"), "RefundReceiptService.onRefundReceiptCreated should have fired");
}

@test:Config {}
function testRefundReceiptDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.refundreceipt.deleted.v1", "qbo.refundreceipt.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RefundReceiptService.onRefundReceiptDeleted"), "RefundReceiptService.onRefundReceiptDeleted should have fired");
}

@test:Config {}
function testRefundReceiptEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.refundreceipt.emailed.v1", "qbo.refundreceipt.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RefundReceiptService.onRefundReceiptEmailed"), "RefundReceiptService.onRefundReceiptEmailed should have fired");
}

@test:Config {}
function testRefundReceiptVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.refundreceipt.void.v1", "qbo.refundreceipt.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RefundReceiptService.onRefundReceiptVoided"), "RefundReceiptService.onRefundReceiptVoided should have fired");
}

@test:Config {}
function testRefundReceiptUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.refundreceipt.updated.v1", "qbo.refundreceipt.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RefundReceiptService.onRefundReceiptUpdated"), "RefundReceiptService.onRefundReceiptUpdated should have fired");
}

@test:Config {}
function testItemCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.item.created.v1", "qbo.item.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ItemService.onItemCreated"), "ItemService.onItemCreated should have fired");
}

@test:Config {}
function testItemDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.item.deleted.v1", "qbo.item.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ItemService.onItemDeleted"), "ItemService.onItemDeleted should have fired");
}

@test:Config {}
function testItemUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.item.updated.v1", "qbo.item.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ItemService.onItemUpdated"), "ItemService.onItemUpdated should have fired");
}

@test:Config {}
function testItemMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.item.merged.v1", "qbo.item.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ItemService.onItemMerged"), "ItemService.onItemMerged should have fired");
}

@test:Config {}
function testBudgetUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.budget.updated.v1", "qbo.budget.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BudgetService.onBudgetUpdated"), "BudgetService.onBudgetUpdated should have fired");
}

@test:Config {}
function testBudgetCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.budget.created.v1", "qbo.budget.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BudgetService.onBudgetCreated"), "BudgetService.onBudgetCreated should have fired");
}

@test:Config {}
function testBillPaymentCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.billpayment.created.v1", "qbo.billpayment.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillPaymentService.onBillPaymentCreated"), "BillPaymentService.onBillPaymentCreated should have fired");
}

@test:Config {}
function testBillPaymentDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.billpayment.deleted.v1", "qbo.billpayment.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillPaymentService.onBillPaymentDeleted"), "BillPaymentService.onBillPaymentDeleted should have fired");
}

@test:Config {}
function testBillPaymentVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.billpayment.void.v1", "qbo.billpayment.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillPaymentService.onBillPaymentVoided"), "BillPaymentService.onBillPaymentVoided should have fired");
}

@test:Config {}
function testBillPaymentUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.billpayment.updated.v1", "qbo.billpayment.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillPaymentService.onBillPaymentUpdated"), "BillPaymentService.onBillPaymentUpdated should have fired");
}

@test:Config {}
function testJournalCodeUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.journalcode.updated.v1", "qbo.journalcode.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("JournalCodeService.onJournalCodeUpdated"), "JournalCodeService.onJournalCodeUpdated should have fired");
}

@test:Config {}
function testJournalCodeCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.journalcode.created.v1", "qbo.journalcode.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("JournalCodeService.onJournalCodeCreated"), "JournalCodeService.onJournalCodeCreated should have fired");
}

@test:Config {}
function testEmployeeUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.employee.updated.v1", "qbo.employee.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EmployeeService.onEmployeeUpdated"), "EmployeeService.onEmployeeUpdated should have fired");
}

@test:Config {}
function testEmployeeMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.employee.merged.v1", "qbo.employee.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EmployeeService.onEmployeeMerged"), "EmployeeService.onEmployeeMerged should have fired");
}

@test:Config {}
function testEmployeeCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.employee.created.v1", "qbo.employee.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EmployeeService.onEmployeeCreated"), "EmployeeService.onEmployeeCreated should have fired");
}

@test:Config {}
function testEmployeeDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.employee.deleted.v1", "qbo.employee.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EmployeeService.onEmployeeDeleted"), "EmployeeService.onEmployeeDeleted should have fired");
}

@test:Config {}
function testBillUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.bill.updated.v1", "qbo.bill.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillService.onBillUpdated"), "BillService.onBillUpdated should have fired");
}

@test:Config {}
function testBillDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.bill.deleted.v1", "qbo.bill.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillService.onBillDeleted"), "BillService.onBillDeleted should have fired");
}

@test:Config {}
function testBillCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.bill.created.v1", "qbo.bill.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("BillService.onBillCreated"), "BillService.onBillCreated should have fired");
}

@test:Config {}
function testChangeOrderCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.changeorder.created.v1", "qbo.changeorder.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ChangeOrderService.onChangeOrderCreated"), "ChangeOrderService.onChangeOrderCreated should have fired");
}

@test:Config {}
function testChangeOrderUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.changeorder.updated.v1", "qbo.changeorder.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ChangeOrderService.onChangeOrderUpdated"), "ChangeOrderService.onChangeOrderUpdated should have fired");
}

@test:Config {}
function testChangeOrderDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.changeorder.deleted.v1", "qbo.changeorder.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ChangeOrderService.onChangeOrderDeleted"), "ChangeOrderService.onChangeOrderDeleted should have fired");
}

@test:Config {}
function testVendorUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendor.updated.v1", "qbo.vendor.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorService.onVendorUpdated"), "VendorService.onVendorUpdated should have fired");
}

@test:Config {}
function testVendorDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendor.deleted.v1", "qbo.vendor.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorService.onVendorDeleted"), "VendorService.onVendorDeleted should have fired");
}

@test:Config {}
function testVendorMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendor.merged.v1", "qbo.vendor.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorService.onVendorMerged"), "VendorService.onVendorMerged should have fired");
}

@test:Config {}
function testVendorCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendor.created.v1", "qbo.vendor.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorService.onVendorCreated"), "VendorService.onVendorCreated should have fired");
}

@test:Config {}
function testTransferCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.transfer.created.v1", "qbo.transfer.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TransferService.onTransferCreated"), "TransferService.onTransferCreated should have fired");
}

@test:Config {}
function testTransferDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.transfer.deleted.v1", "qbo.transfer.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TransferService.onTransferDeleted"), "TransferService.onTransferDeleted should have fired");
}

@test:Config {}
function testTransferVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.transfer.void.v1", "qbo.transfer.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TransferService.onTransferVoided"), "TransferService.onTransferVoided should have fired");
}

@test:Config {}
function testTransferUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.transfer.updated.v1", "qbo.transfer.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TransferService.onTransferUpdated"), "TransferService.onTransferUpdated should have fired");
}

@test:Config {}
function testSalesReceiptCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.salesreceipt.created.v1", "qbo.salesreceipt.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SalesReceiptService.onSalesReceiptCreated"), "SalesReceiptService.onSalesReceiptCreated should have fired");
}

@test:Config {}
function testSalesReceiptDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.salesreceipt.deleted.v1", "qbo.salesreceipt.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SalesReceiptService.onSalesReceiptDeleted"), "SalesReceiptService.onSalesReceiptDeleted should have fired");
}

@test:Config {}
function testSalesReceiptVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.salesreceipt.void.v1", "qbo.salesreceipt.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SalesReceiptService.onSalesReceiptVoided"), "SalesReceiptService.onSalesReceiptVoided should have fired");
}

@test:Config {}
function testSalesReceiptUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.salesreceipt.updated.v1", "qbo.salesreceipt.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SalesReceiptService.onSalesReceiptUpdated"), "SalesReceiptService.onSalesReceiptUpdated should have fired");
}

@test:Config {}
function testSalesReceiptEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.salesreceipt.emailed.v1", "qbo.salesreceipt.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SalesReceiptService.onSalesReceiptEmailed"), "SalesReceiptService.onSalesReceiptEmailed should have fired");
}

@test:Config {}
function testCreditMemoUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.creditmemo.updated.v1", "qbo.creditmemo.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CreditMemoService.onCreditMemoUpdated"), "CreditMemoService.onCreditMemoUpdated should have fired");
}

@test:Config {}
function testCreditMemoVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.creditmemo.void.v1", "qbo.creditmemo.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CreditMemoService.onCreditMemoVoided"), "CreditMemoService.onCreditMemoVoided should have fired");
}

@test:Config {}
function testCreditMemoEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.creditmemo.emailed.v1", "qbo.creditmemo.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CreditMemoService.onCreditMemoEmailed"), "CreditMemoService.onCreditMemoEmailed should have fired");
}

@test:Config {}
function testCreditMemoCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.creditmemo.created.v1", "qbo.creditmemo.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CreditMemoService.onCreditMemoCreated"), "CreditMemoService.onCreditMemoCreated should have fired");
}

@test:Config {}
function testCreditMemoDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.creditmemo.deleted.v1", "qbo.creditmemo.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CreditMemoService.onCreditMemoDeleted"), "CreditMemoService.onCreditMemoDeleted should have fired");
}

@test:Config {}
function testPaymentUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.payment.updated.v1", "qbo.payment.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentService.onPaymentUpdated"), "PaymentService.onPaymentUpdated should have fired");
}

@test:Config {}
function testPaymentEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.payment.emailed.v1", "qbo.payment.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentService.onPaymentEmailed"), "PaymentService.onPaymentEmailed should have fired");
}

@test:Config {}
function testPaymentVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.payment.void.v1", "qbo.payment.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentService.onPaymentVoided"), "PaymentService.onPaymentVoided should have fired");
}

@test:Config {}
function testPaymentCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.payment.created.v1", "qbo.payment.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentService.onPaymentCreated"), "PaymentService.onPaymentCreated should have fired");
}

@test:Config {}
function testPaymentDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.payment.deleted.v1", "qbo.payment.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentService.onPaymentDeleted"), "PaymentService.onPaymentDeleted should have fired");
}

@test:Config {}
function testPaymentMethodUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.paymentmethod.updated.v1", "qbo.paymentmethod.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentMethodService.onPaymentMethodUpdated"), "PaymentMethodService.onPaymentMethodUpdated should have fired");
}

@test:Config {}
function testPaymentMethodCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.paymentmethod.created.v1", "qbo.paymentmethod.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentMethodService.onPaymentMethodCreated"), "PaymentMethodService.onPaymentMethodCreated should have fired");
}

@test:Config {}
function testPaymentMethodMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.paymentmethod.merged.v1", "qbo.paymentmethod.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PaymentMethodService.onPaymentMethodMerged"), "PaymentMethodService.onPaymentMethodMerged should have fired");
}

@test:Config {}
function testCustomerDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.customer.deleted.v1", "qbo.customer.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CustomerService.onCustomerDeleted"), "CustomerService.onCustomerDeleted should have fired");
}

@test:Config {}
function testCustomerCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.customer.created.v1", "qbo.customer.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CustomerService.onCustomerCreated"), "CustomerService.onCustomerCreated should have fired");
}

@test:Config {}
function testCustomerUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.customer.updated.v1", "qbo.customer.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CustomerService.onCustomerUpdated"), "CustomerService.onCustomerUpdated should have fired");
}

@test:Config {}
function testCustomerMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.customer.merged.v1", "qbo.customer.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CustomerService.onCustomerMerged"), "CustomerService.onCustomerMerged should have fired");
}

@test:Config {}
function testPurchaseOrderDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchaseorder.deleted.v1", "qbo.purchaseorder.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseOrderService.onPurchaseOrderDeleted"), "PurchaseOrderService.onPurchaseOrderDeleted should have fired");
}

@test:Config {}
function testPurchaseOrderCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchaseorder.created.v1", "qbo.purchaseorder.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseOrderService.onPurchaseOrderCreated"), "PurchaseOrderService.onPurchaseOrderCreated should have fired");
}

@test:Config {}
function testPurchaseOrderUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchaseorder.updated.v1", "qbo.purchaseorder.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseOrderService.onPurchaseOrderUpdated"), "PurchaseOrderService.onPurchaseOrderUpdated should have fired");
}

@test:Config {}
function testPurchaseOrderEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.purchaseorder.emailed.v1", "qbo.purchaseorder.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PurchaseOrderService.onPurchaseOrderEmailed"), "PurchaseOrderService.onPurchaseOrderEmailed should have fired");
}

@test:Config {}
function testCompanyCurrencyUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.companycurrency.updated.v1", "qbo.companycurrency.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CompanyCurrencyService.onCompanyCurrencyUpdated"), "CompanyCurrencyService.onCompanyCurrencyUpdated should have fired");
}

@test:Config {}
function testCompanyCurrencyDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.companycurrency.deleted.v1", "qbo.companycurrency.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CompanyCurrencyService.onCompanyCurrencyDeleted"), "CompanyCurrencyService.onCompanyCurrencyDeleted should have fired");
}

@test:Config {}
function testCompanyCurrencyCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.companycurrency.created.v1", "qbo.companycurrency.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CompanyCurrencyService.onCompanyCurrencyCreated"), "CompanyCurrencyService.onCompanyCurrencyCreated should have fired");
}

@test:Config {}
function testEstimateCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.estimate.created.v1", "qbo.estimate.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EstimateService.onEstimateCreated"), "EstimateService.onEstimateCreated should have fired");
}

@test:Config {}
function testEstimateEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.estimate.emailed.v1", "qbo.estimate.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EstimateService.onEstimateEmailed"), "EstimateService.onEstimateEmailed should have fired");
}

@test:Config {}
function testEstimateDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.estimate.deleted.v1", "qbo.estimate.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EstimateService.onEstimateDeleted"), "EstimateService.onEstimateDeleted should have fired");
}

@test:Config {}
function testEstimateUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.estimate.updated.v1", "qbo.estimate.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("EstimateService.onEstimateUpdated"), "EstimateService.onEstimateUpdated should have fired");
}

@test:Config {}
function testPreferencesUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.preferences.updated.v1", "qbo.preferences.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("PreferencesService.onPreferencesUpdated"), "PreferencesService.onPreferencesUpdated should have fired");
}

@test:Config {}
function testClassUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.class.updated.v1", "qbo.class.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ClassService.onClassUpdated"), "ClassService.onClassUpdated should have fired");
}

@test:Config {}
function testClassDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.class.deleted.v1", "qbo.class.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ClassService.onClassDeleted"), "ClassService.onClassDeleted should have fired");
}

@test:Config {}
function testClassCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.class.created.v1", "qbo.class.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ClassService.onClassCreated"), "ClassService.onClassCreated should have fired");
}

@test:Config {}
function testClassMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.class.merged.v1", "qbo.class.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ClassService.onClassMerged"), "ClassService.onClassMerged should have fired");
}

@test:Config {}
function testDepositCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.deposit.created.v1", "qbo.deposit.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepositService.onDepositCreated"), "DepositService.onDepositCreated should have fired");
}

@test:Config {}
function testDepositUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.deposit.updated.v1", "qbo.deposit.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepositService.onDepositUpdated"), "DepositService.onDepositUpdated should have fired");
}

@test:Config {}
function testDepositDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.deposit.deleted.v1", "qbo.deposit.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepositService.onDepositDeleted"), "DepositService.onDepositDeleted should have fired");
}

@test:Config {}
function testInvoiceCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.invoice.created.v1", "qbo.invoice.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("InvoiceService.onInvoiceCreated"), "InvoiceService.onInvoiceCreated should have fired");
}

@test:Config {}
function testInvoiceUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.invoice.updated.v1", "qbo.invoice.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("InvoiceService.onInvoiceUpdated"), "InvoiceService.onInvoiceUpdated should have fired");
}

@test:Config {}
function testInvoiceDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.invoice.deleted.v1", "qbo.invoice.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("InvoiceService.onInvoiceDeleted"), "InvoiceService.onInvoiceDeleted should have fired");
}

@test:Config {}
function testInvoiceEmailedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.invoice.emailed.v1", "qbo.invoice.emailed.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("InvoiceService.onInvoiceEmailed"), "InvoiceService.onInvoiceEmailed should have fired");
}

@test:Config {}
function testInvoiceVoidedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.invoice.void.v1", "qbo.invoice.void.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("InvoiceService.onInvoiceVoided"), "InvoiceService.onInvoiceVoided should have fired");
}

@test:Config {}
function testTermCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.term.created.v1", "qbo.term.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TermService.onTermCreated"), "TermService.onTermCreated should have fired");
}

@test:Config {}
function testTermUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.term.updated.v1", "qbo.term.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TermService.onTermUpdated"), "TermService.onTermUpdated should have fired");
}

@test:Config {}
function testCurrencyCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.currency.created.v1", "qbo.currency.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CurrencyService.onCurrencyCreated"), "CurrencyService.onCurrencyCreated should have fired");
}

@test:Config {}
function testCurrencyDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.currency.deleted.v1", "qbo.currency.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CurrencyService.onCurrencyDeleted"), "CurrencyService.onCurrencyDeleted should have fired");
}

@test:Config {}
function testCurrencyUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.currency.updated.v1", "qbo.currency.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CurrencyService.onCurrencyUpdated"), "CurrencyService.onCurrencyUpdated should have fired");
}

@test:Config {}
function testAccountMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.account.merged.v1", "qbo.account.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("AccountService.onAccountMerged"), "AccountService.onAccountMerged should have fired");
}

@test:Config {}
function testAccountUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.account.updated.v1", "qbo.account.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("AccountService.onAccountUpdated"), "AccountService.onAccountUpdated should have fired");
}

@test:Config {}
function testAccountCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.account.created.v1", "qbo.account.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("AccountService.onAccountCreated"), "AccountService.onAccountCreated should have fired");
}

@test:Config {}
function testAccountDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.account.deleted.v1", "qbo.account.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("AccountService.onAccountDeleted"), "AccountService.onAccountDeleted should have fired");
}

@test:Config {}
function testJournalEntryUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.journalentry.updated.v1", "qbo.journalentry.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("JournalEntryService.onJournalEntryUpdated"), "JournalEntryService.onJournalEntryUpdated should have fired");
}

@test:Config {}
function testJournalEntryDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.journalentry.deleted.v1", "qbo.journalentry.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("JournalEntryService.onJournalEntryDeleted"), "JournalEntryService.onJournalEntryDeleted should have fired");
}

@test:Config {}
function testJournalEntryCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.journalentry.created.v1", "qbo.journalentry.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("JournalEntryService.onJournalEntryCreated"), "JournalEntryService.onJournalEntryCreated should have fired");
}

@test:Config {}
function testDepartmentCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.department.created.v1", "qbo.department.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepartmentService.onDepartmentCreated"), "DepartmentService.onDepartmentCreated should have fired");
}

@test:Config {}
function testDepartmentMergedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.department.merged.v1", "qbo.department.merged.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepartmentService.onDepartmentMerged"), "DepartmentService.onDepartmentMerged should have fired");
}

@test:Config {}
function testDepartmentUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.department.updated.v1", "qbo.department.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("DepartmentService.onDepartmentUpdated"), "DepartmentService.onDepartmentUpdated should have fired");
}

@test:Config {}
function testVendorCreditCreatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendorcredit.created.v1", "qbo.vendorcredit.created.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorCreditService.onVendorCreditCreated"), "VendorCreditService.onVendorCreditCreated should have fired");
}

@test:Config {}
function testVendorCreditDeletedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendorcredit.deleted.v1", "qbo.vendorcredit.deleted.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorCreditService.onVendorCreditDeleted"), "VendorCreditService.onVendorCreditDeleted should have fired");
}

@test:Config {}
function testVendorCreditUpdatedDispatch() returns error? {
    http:Response response = check sendSignedTriggerWebhook("qbo.vendorcredit.updated.v1", "qbo.vendorcredit.updated.v1");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("VendorCreditService.onVendorCreditUpdated"), "VendorCreditService.onVendorCreditUpdated should have fired");
}

