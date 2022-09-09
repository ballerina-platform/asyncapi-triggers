// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/http;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private ListenerConfigs listenerConfigs;

    public function init(ListenerConfigs listenerConfigs) {
        self.listenerConfigs = listenerConfigs;
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
    resource function post .(http:Caller caller, http:Request request) returns error? {
        json payload = check request.getJsonPayload();
        CommonResponseType genericDataType = check payload.cloneWithType(CommonResponseType);
        check self.matchRemoteFunc(genericDataType);
        check caller->respond(http:STATUS_OK);
    }

    private function matchRemoteFunc(CommonResponseType genericDataType) returns error? {
        string[] realmIds = self.listenerConfigs.realmIds;
        foreach EventNotification event in genericDataType.eventNotifications {
            if (self.isRequiredRealmId(realmIds, event.realmId)) {
                DataChangeEvent datachange = event.dataChangeEvent;
                foreach QuickBookEvent item in datachange.entities {
                    match item.name {
                        "Account" => {
                            check self.executeRemoteFunc(item, "Account", "AppService", "onAccount");
                        }
                        "Bill" => {
                            check self.executeRemoteFunc(item, "Bill", "AppService", "onBill");
                        }
                        "BillPayment" => {
                            check self.executeRemoteFunc(item, "BillPayment", "AppService", "onBillPayment");
                        }

                        "Budget" => {
                            check self.executeRemoteFunc(item, "Budget", "AppService", "onBudget");
                        }
                        "Class" => {
                            check self.executeRemoteFunc(item, "Class", "AppService", "onClass");
                        }
                        "CreditMemo" => {
                            check self.executeRemoteFunc(item, "CreditMemo", "AppService", "onCreditMemo");
                        }
                        "Currency" => {
                            check self.executeRemoteFunc(item, "Currency", "AppService", "onCurrency");
                        }
                        "Customer" => {
                            check self.executeRemoteFunc(item, "Customer", "AppService", "onCustomer");
                        }
                        "Department" => {
                            check self.executeRemoteFunc(item, "Department", "AppService", "onDepartment");
                        }
                        "Deposit" => {
                            check self.executeRemoteFunc(item, "Deposit", "AppService", "onDeposit");
                        }
                        "Employee" => {
                            check self.executeRemoteFunc(item, "Employee", "AppService", "onEmployee");
                        }
                        "Estimate" => {
                            check self.executeRemoteFunc(item, "Estimate", "AppService", "onEstimate");
                        }
                        "Invoice" => {
                            check self.executeRemoteFunc(item, "Invoice", "AppService", "onInvoice");
                        }
                        "Item" => {
                            check self.executeRemoteFunc(item, "Item", "AppService", "onItem");
                        }
                        "JournalCode" => {
                            check self.executeRemoteFunc(item, "JournalCode", "AppService", "onJournalCode");
                        }
                        "JournalEntry" => {
                            check self.executeRemoteFunc(item, "JournalEntry", "AppService", "onJournalEntry");
                        }
                        "Payment" => {
                            check self.executeRemoteFunc(item, "Payment", "AppService", "onPayment");
                        }
                        "PaymentMethod" => {
                            check self.executeRemoteFunc(item, "PaymentMethod", "AppService", "onPaymentMethod");
                        }
                        "Preferences" => {
                            check self.executeRemoteFunc(item, "Preferences", "AppService", "onPreferences");
                        }
                        "Purchase" => {
                            check self.executeRemoteFunc(item, "Purchase", "AppService", "onPurchase");
                        }
                        "PurchaseOrder" => {
                            check self.executeRemoteFunc(item, "PurchaseOrder", "AppService", "onPurchaseOrder");
                        }
                        "RefundReceipt" => {
                            check self.executeRemoteFunc(item, "RefundReceipt", "AppService", "onRefundReceipt");
                        }
                        "SalesReceipt" => {
                            check self.executeRemoteFunc(item, "SalesReceipt", "AppService", "onSalesReceipt");
                        }
                        "TaxAgency" => {
                            check self.executeRemoteFunc(item, "TaxAgency", "AppService", "onTaxAgency");
                        }
                        "Term" => {
                            check self.executeRemoteFunc(item, "Term", "AppService", "onTerm");
                        }
                        "TimeActivity" => {
                            check self.executeRemoteFunc(item, "TimeActivity", "AppService", "onTimeActivity");
                        }
                        "Transfer" => {
                            check self.executeRemoteFunc(item, "Transfer", "AppService", "onTransfer");
                        }
                        "Vendor" => {
                            check self.executeRemoteFunc(item, "Vendor", "AppService", "onVendor");
                        }
                        "VendorCredit" => {
                            check self.executeRemoteFunc(item, "VendorCredit", "AppService", "onVendorCredit");
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
