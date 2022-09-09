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

public type AppService service object {
    remote function onAccount(QuickBookEvent event) returns error?;
    remote function onBillPayment(QuickBookEvent event) returns error?;
    remote function onBill(QuickBookEvent event) returns error?;
    remote function onBudget(QuickBookEvent event) returns error?;
    remote function onClass(QuickBookEvent event) returns error?;
    remote function onCreditMemo(QuickBookEvent event) returns error?;
    remote function onCurrency(QuickBookEvent event) returns error?;
    remote function onCustomer(QuickBookEvent event) returns error?;
    remote function onDepartment(QuickBookEvent event) returns error?;
    remote function onDeposit(QuickBookEvent event) returns error?;
    remote function onEmployee(QuickBookEvent event) returns error?;
    remote function onEstimate(QuickBookEvent event) returns error?;
    remote function onInvoice(QuickBookEvent event) returns error?;
    remote function onItem(QuickBookEvent event) returns error?;
    remote function onJournalCode(QuickBookEvent event) returns error?;
    remote function onJournalEntry(QuickBookEvent event) returns error?;
    remote function onPayment(QuickBookEvent event) returns error?;
    remote function onPaymentMethod(QuickBookEvent event) returns error?;
    remote function onPreferences(QuickBookEvent event) returns error?;
    remote function onPurchase(QuickBookEvent event) returns error?;
    remote function onPurchaseOrder(QuickBookEvent event) returns error?;
    remote function onRefundReceipt(QuickBookEvent event) returns error?;
    remote function onSalesReceipt(QuickBookEvent event) returns error?;
    remote function onTaxAgency(QuickBookEvent event) returns error?;
    remote function onTerm(QuickBookEvent event) returns error?;
    remote function onTimeActivity(QuickBookEvent event) returns error?;
    remote function onTransfer(QuickBookEvent event) returns error?;
    remote function onVendor(QuickBookEvent event) returns error?;
    remote function onVendorCredit(QuickBookEvent event) returns error?;
};

public type GenericServiceType AppService;
