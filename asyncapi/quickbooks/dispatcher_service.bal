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

import ballerina/crypto;
import ballerina/http;
import ballerina/log;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private ListenerConfig listenerConfig;

    public function init(ListenerConfig listenerConfig) {
        self.listenerConfig = listenerConfig;
    }

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error("Service of type " + serviceType + " has already been attached");
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error("Cannot detach the service of type " + serviceType + ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns http:Response|error? {
        json payload = check request.getJsonPayload();

        byte[] binaryPayload = <@untainted>payload.toString().toBytes();
        if request.hasHeader("Intuit-Signature") {
            string hmacHeader = check request.getHeader("Intuit-Signature");
            byte[] digest = check crypto:hmacSha256(binaryPayload, self.listenerConfig.verificationToken.toBytes());
            string computedHmac = digest.toBase64();
            if computedHmac != hmacHeader {
                // Validate verifier token with Intuit-Signature header for intent verification
                log:printError("Signature verification failure!");
                http:Response response = new;
                response.statusCode = http:STATUS_UNAUTHORIZED;
                response.setPayload("Signature verification failure");
                return response;
            }
        }

        CommonResponseType genericDataType = check payload.cloneWithType(CommonResponseType);
        check self.matchRemoteFunc(genericDataType);
        return caller->respond(http:STATUS_OK);
    }

    private function matchRemoteFunc(CommonResponseType genericDataType) returns error? {
        string[] realmIds = self.listenerConfig.realmIds;
        foreach EventNotification event in genericDataType.eventNotifications {
            if (self.isRequiredRealmId(realmIds, event.realmId)) {
                DataChangeEvent datachange = event.dataChangeEvent;
                foreach QuickBookEvent item in datachange.entities {
                    string filter = item.name.toString() + "/" + item.operation.toString();
                    match filter {
                        "Account/Create" => {
                            check self.executeRemoteFunc(item, "Account/Create", "AccountService", "onAccountCreate");
                        }
                        "Account/Update" => {
                            check self.executeRemoteFunc(item, "Account/Update", "AccountService", "onAccountUpdate");
                        }
                        "Account/Delete" => {
                            check self.executeRemoteFunc(item, "Account/Delete", "AccountService", "onAccountDelete");
                        }
                        "Account/Merge" => {
                            check self.executeRemoteFunc(item, "Account/Merge", "AccountService", "onAccountMerge");
                        }
                        "Bill/Create" => {
                            check self.executeRemoteFunc(item, "Bill/Create", "BillService", "onBillCreate");
                        }
                        "Bill/Update" => {
                            check self.executeRemoteFunc(item, "Bill/Update", "BillService", "onBillUpdate");
                        }
                        "Bill/Delete" => {
                            check self.executeRemoteFunc(item, "Bill/Delete", "BillService", "onBillDelete");
                        }
                        "BillPayment/Create" => {
                            check self.executeRemoteFunc(item, "BillPayment/Create", "BillPaymentService", "onBillpaymentCreate");
                        }
                        "BillPayment/Update" => {
                            check self.executeRemoteFunc(item, "BillPayment/Update", "BillPaymentService", "onBillpaymentUpdate");
                        }
                        "BillPayment/Delete" => {
                            check self.executeRemoteFunc(item, "BillPayment/Delete", "BillPaymentService", "onBillpaymentDelete");
                        }
                        "BillPayment/Void" => {
                            check self.executeRemoteFunc(item, "BillPayment/Void", "BillPaymentService", "onBillpaymentVoid");
                        }
                        "Budget/Create" => {
                            check self.executeRemoteFunc(item, "Budget/Create", "BudgetService", "onBudgetCreate");
                        }
                        "Budget/Update" => {
                            check self.executeRemoteFunc(item, "Budget/Update", "BudgetService", "onBudgetUpdate");
                        }
                        "Class/Create" => {
                            check self.executeRemoteFunc(item, "Class/Create", "ClassService", "onClassCreate");
                        }
                        "Class/Update" => {
                            check self.executeRemoteFunc(item, "Class/Update", "ClassService", "onClassUpdate");
                        }
                        "Class/Delete" => {
                            check self.executeRemoteFunc(item, "Class/Delete", "ClassService", "onClassDelete");
                        }
                        "CreditMemo/Create" => {
                            check self.executeRemoteFunc(item, "CreditMemo/Create", "CreditMemoService", "onCreditmemoCreate");
                        }
                        "CreditMemo/Update" => {
                            check self.executeRemoteFunc(item, "CreditMemo/Update", "CreditMemoService", "onCreditmemoUpdate");
                        }
                        "CreditMemo/Delete" => {
                            check self.executeRemoteFunc(item, "CreditMemo/Delete", "CreditMemoService", "onCreditmemoDelete");
                        }
                        "CreditMemo/Void" => {
                            check self.executeRemoteFunc(item, "CreditMemo/Void", "CreditMemoService", "onCreditmemoVoid");
                        }
                        "Currency/Create" => {
                            check self.executeRemoteFunc(item, "Currency/Create", "CurrencyService", "onCurrencyCreate");
                        }
                        "Currency/Update" => {
                            check self.executeRemoteFunc(item, "Currency/Update", "CurrencyService", "onCurrencyUpdate");
                        }
                        "Customer/Create" => {
                            check self.executeRemoteFunc(item, "Customer/Create", "CustomerService", "onCustomerCreate");
                        }
                        "Customer/Update" => {
                            check self.executeRemoteFunc(item, "Customer/Update", "CustomerService", "onCustomerUpdate");
                        }
                        "Customer/Delete" => {
                            check self.executeRemoteFunc(item, "Customer/Delete", "CustomerService", "onCustomerDelete");
                        }
                        "Customer/Merge" => {
                            check self.executeRemoteFunc(item, "Customer/Merge", "CustomerService", "onCustomerMerge");
                        }
                        "Department/Create" => {
                            check self.executeRemoteFunc(item, "Department/Create", "DepartmentService", "onDepartmentCreate");
                        }
                        "Department/Update" => {
                            check self.executeRemoteFunc(item, "Department/Update", "DepartmentService", "onDepartmentUpdate");
                        }
                        "Department/Merge" => {
                            check self.executeRemoteFunc(item, "Department/Merge", "DepartmentService", "onDepartmentMerge");
                        }
                        "Deposit/Create" => {
                            check self.executeRemoteFunc(item, "Deposit/Create", "DepositService", "onDepositCreate");
                        }
                        "Deposit/Update" => {
                            check self.executeRemoteFunc(item, "Deposit/Update", "DepositService", "onDepositUpdate");
                        }
                        "Deposit/Delete" => {
                            check self.executeRemoteFunc(item, "Deposit/Delete", "DepositService", "onDepositDelete");
                        }
                        "Employee/Create" => {
                            check self.executeRemoteFunc(item, "Employee/Create", "EmployeeService", "onEmployeeCreate");
                        }
                        "Employee/Update" => {
                            check self.executeRemoteFunc(item, "Employee/Update", "EmployeeService", "onEmployeeUpdate");
                        }
                        "Employee/Delete" => {
                            check self.executeRemoteFunc(item, "Employee/Delete", "EmployeeService", "onEmployeeDelete");
                        }
                        "Employee/Merge" => {
                            check self.executeRemoteFunc(item, "Employee/Merge", "EmployeeService", "onEmployeeMerge");
                        }
                        "Estimate/Create" => {
                            check self.executeRemoteFunc(item, "Estimate/Create", "EstimateService", "onEstimateCreate");
                        }
                        "Estimate/Update" => {
                            check self.executeRemoteFunc(item, "Estimate/Update", "EstimateService", "onEstimateUpdate");
                        }
                        "Estimate/Delete" => {
                            check self.executeRemoteFunc(item, "Estimate/Delete", "EstimateService", "onEstimateDelete");
                        }
                        "Invoice/Create" => {
                            check self.executeRemoteFunc(item, "Invoice/Create", "InvoiceService", "onInvoiceCreate");
                        }
                        "Invoice/Update" => {
                            check self.executeRemoteFunc(item, "Invoice/Update", "InvoiceService", "onInvoiceUpdate");
                        }
                        "Invoice/Delete" => {
                            check self.executeRemoteFunc(item, "Invoice/Delete", "InvoiceService", "onInvoiceDelete");
                        }
                        "Invoice/Void" => {
                            check self.executeRemoteFunc(item, "Invoice/Void", "InvoiceService", "onInvoiceVoid");
                        }
                        "Item/Create" => {
                            check self.executeRemoteFunc(item, "Item/Create", "ItemService", "onItemCreate");
                        }
                        "Item/Update" => {
                            check self.executeRemoteFunc(item, "Item/Update", "ItemService", "onItemUpdate");
                        }
                        "Item/Delete" => {
                            check self.executeRemoteFunc(item, "Item/Delete", "ItemService", "onItemDelete");
                        }
                        "Item/Merge" => {
                            check self.executeRemoteFunc(item, "Item/Merge", "ItemService", "onItemMerge");
                        }
                        "JournalCode/Create" => {
                            check self.executeRemoteFunc(item, "JournalCode/Create", "JournalCodeService", "onJournalcodeCreate");
                        }
                        "JournalCode/Update" => {
                            check self.executeRemoteFunc(item, "JournalCode/Update", "JournalCodeService", "onJournalcodeUpdate");
                        }
                        "JournalEntry/Create" => {
                            check self.executeRemoteFunc(item, "JournalEntry/Create", "JournalEntryService", "onJournalentryCreate");
                        }
                        "JournalEntry/Update" => {
                            check self.executeRemoteFunc(item, "JournalEntry/Update", "JournalEntryService", "onJournalentryUpdate");
                        }
                        "JournalEntry/Delete" => {
                            check self.executeRemoteFunc(item, "JournalEntry/Delete", "JournalEntryService", "onJournalentryDelete");
                        }
                        "Payment/Create" => {
                            check self.executeRemoteFunc(item, "Payment/Create", "PaymentService", "onPaymentCreate");
                        }
                        "Payment/Update" => {
                            check self.executeRemoteFunc(item, "Payment/Update", "PaymentService", "onPaymentUpdate");
                        }
                        "Payment/Delete" => {
                            check self.executeRemoteFunc(item, "Payment/Delete", "PaymentService", "onPaymentDelete");
                        }
                        "Payment/Void" => {
                            check self.executeRemoteFunc(item, "Payment/Void", "PaymentService", "onPaymentVoid");
                        }
                        "PaymentMethod/Create" => {
                            check self.executeRemoteFunc(item, "PaymentMethod/Create", "PaymentMethodService", "onPaymentmethodCreate");
                        }
                        "PaymentMethod/Update" => {
                            check self.executeRemoteFunc(item, "PaymentMethod/Update", "PaymentMethodService", "onPaymentmethodUpdate");
                        }
                        "PaymentMethod/Merge" => {
                            check self.executeRemoteFunc(item, "PaymentMethod/Merge", "PaymentMethodService", "onPaymentmethodMerge");
                        }
                        "Preferences/Update" => {
                            check self.executeRemoteFunc(item, "Preferences/Update", "PreferencesService", "onPreferencesUpdate");
                        }
                        "Purchase/Create" => {
                            check self.executeRemoteFunc(item, "Purchase/Create", "PurchaseService", "onPurchaseCreate");
                        }
                        "Purchase/Update" => {
                            check self.executeRemoteFunc(item, "Purchase/Update", "PurchaseService", "onPurchaseUpdate");
                        }
                        "Purchase/Delete" => {
                            check self.executeRemoteFunc(item, "Purchase/Delete", "PurchaseService", "onPurchaseDelete");
                        }
                        "Purchase/Void" => {
                            check self.executeRemoteFunc(item, "Purchase/Void", "PurchaseService", "onPurchaseVoid");
                        }
                        "PurchaseOrder/Create" => {
                            check self.executeRemoteFunc(item, "PurchaseOrder/Create", "PurchaseOrderService", "onPurchaseorderCreate");
                        }
                        "PurchaseOrder/Update" => {
                            check self.executeRemoteFunc(item, "PurchaseOrder/Update", "PurchaseOrderService", "onPurchaseorderUpdate");
                        }
                        "PurchaseOrder/Delete" => {
                            check self.executeRemoteFunc(item, "PurchaseOrder/Delete", "PurchaseOrderService", "onPurchaseorderDelete");
                        }
                        "RefundReceipt/Create" => {
                            check self.executeRemoteFunc(item, "RefundReceipt/Create", "RefundReceiptService", "onRefundreceiptCreate");
                        }
                        "RefundReceipt/Update" => {
                            check self.executeRemoteFunc(item, "RefundReceipt/Update", "RefundReceiptService", "onRefundreceiptUpdate");
                        }
                        "RefundReceipt/Delete" => {
                            check self.executeRemoteFunc(item, "RefundReceipt/Delete", "RefundReceiptService", "onRefundreceiptDelete");
                        }
                        "RefundReceipt/Void" => {
                            check self.executeRemoteFunc(item, "RefundReceipt/Void", "RefundReceiptService", "onRefundreceiptVoid");
                        }
                        "SalesReceipt/Create" => {
                            check self.executeRemoteFunc(item, "SalesReceipt/Create", "SalesReceiptService", "onSalesreceiptCreate");
                        }
                        "SalesReceipt/Update" => {
                            check self.executeRemoteFunc(item, "SalesReceipt/Update", "SalesReceiptService", "onSalesreceiptUpdate");
                        }
                        "SalesReceipt/Delete" => {
                            check self.executeRemoteFunc(item, "SalesReceipt/Delete", "SalesReceiptService", "onSalesreceiptDelete");
                        }
                        "SalesReceipt/Void" => {
                            check self.executeRemoteFunc(item, "SalesReceipt/Void", "SalesReceiptService", "onSalesreceiptVoid");
                        }
                        "TaxAgency/Create" => {
                            check self.executeRemoteFunc(item, "TaxAgency/Create", "TaxAgencyService", "onTaxagencyCreate");
                        }
                        "TaxAgency/Update" => {
                            check self.executeRemoteFunc(item, "TaxAgency/Update", "TaxAgencyService", "onTaxagencyUpdate");
                        }
                        "Term/Create" => {
                            check self.executeRemoteFunc(item, "Term/Create", "TermService", "onTermCreate");
                        }
                        "Term/Update" => {
                            check self.executeRemoteFunc(item, "Term/Update", "TermService", "onTermUpdate");
                        }
                        "TimeActivity/Create" => {
                            check self.executeRemoteFunc(item, "TimeActivity/Create", "TimeActivityService", "onTimeactivityCreate");
                        }
                        "TimeActivity/Update" => {
                            check self.executeRemoteFunc(item, "TimeActivity/Update", "TimeActivityService", "onTimeactivityUpdate");
                        }
                        "TimeActivity/Delete" => {
                            check self.executeRemoteFunc(item, "TimeActivity/Delete", "TimeActivityService", "onTimeactivityDelete");
                        }
                        "Transfer/Create" => {
                            check self.executeRemoteFunc(item, "Transfer/Create", "TransferService", "onTransferCreate");
                        }
                        "Transfer/Update" => {
                            check self.executeRemoteFunc(item, "Transfer/Update", "TransferService", "onTransferUpdate");
                        }
                        "Transfer/Delete" => {
                            check self.executeRemoteFunc(item, "Transfer/Delete", "TransferService", "onTransferDelete");
                        }
                        "Transfer/Void" => {
                            check self.executeRemoteFunc(item, "Transfer/Void", "TransferService", "onTransferVoid");
                        }
                        "Vendor/Create" => {
                            check self.executeRemoteFunc(item, "Vendor/Create", "VendorService", "onVendorCreate");
                        }
                        "Vendor/Update" => {
                            check self.executeRemoteFunc(item, "Vendor/Update", "VendorService", "onVendorUpdate");
                        }
                        "Vendor/Delete" => {
                            check self.executeRemoteFunc(item, "Vendor/Delete", "VendorService", "onVendorDelete");
                        }
                        "Vendor/Merge" => {
                            check self.executeRemoteFunc(item, "Vendor/Merge", "VendorService", "onVendorMerge");
                        }
                        "VendorCredit/Create" => {
                            check self.executeRemoteFunc(item, "VendorCredit/Create", "VendorCreditService", "onVendorcreditCreate");
                        }
                        "VendorCredit/Update" => {
                            check self.executeRemoteFunc(item, "VendorCredit/Update", "VendorCreditService", "onVendorcreditUpdate");
                        }
                        "VendorCredit/Delete" => {
                            check self.executeRemoteFunc(item, "VendorCredit/Delete", "VendorCreditService", "onVendorcreditDelete");
                        }
                    }
                }
            }
        }
    }

    private function isRequiredRealmId(string[] realmIds, string realmId) returns boolean {
        foreach string realmIdReq in realmIds {
            if (realmIdReq == realmId) {
                return true;
            }
        }
        return false;
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
