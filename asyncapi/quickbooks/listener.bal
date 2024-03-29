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

import ballerina/cloud;
import ballerina/http;

@display {label: "QuickBooks", iconPath: "docs/icon.png"}
public class Listener {
    private http:Listener httpListener;
    private DispatcherService dispatcherService;

    public function init(ListenerConfig listenerConfig, @cloud:Expose int|http:Listener listenOn = 8090) returns error? {
        if listenOn is http:Listener {
            self.httpListener = listenOn;
        } else {
            self.httpListener = check new (listenOn);
        }
        self.dispatcherService = new DispatcherService(listenerConfig);
    }

    public isolated function attach(GenericServiceType serviceRef, () attachPoint) returns @tainted error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.addServiceRef(serviceTypeStr, serviceRef);
    }

    public isolated function detach(GenericServiceType serviceRef) returns error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.removeServiceRef(serviceTypeStr);
    }

    public isolated function 'start() returns error? {
        check self.httpListener.attach(self.dispatcherService, ());
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is AccountService {
            return "AccountService";
        } else if serviceRef is BillService {
            return "BillService";
        } else if serviceRef is BillPaymentService {
            return "BillPaymentService";
        } else if serviceRef is BudgetService {
            return "BudgetService";
        } else if serviceRef is ClassService {
            return "ClassService";
        } else if serviceRef is CreditMemoService {
            return "CreditMemoService";
        } else if serviceRef is CurrencyService {
            return "CurrencyService";
        } else if serviceRef is CustomerService {
            return "CustomerService";
        } else if serviceRef is DepartmentService {
            return "DepartmentService";
        } else if serviceRef is DepositService {
            return "DepositService";
        } else if serviceRef is EmployeeService {
            return "EmployeeService";
        } else if serviceRef is EstimateService {
            return "EstimateService";
        } else if serviceRef is InvoiceService {
            return "InvoiceService";
        } else if serviceRef is ItemService {
            return "ItemService";
        } else if serviceRef is JournalCodeService {
            return "JournalCodeService";
        } else if serviceRef is JournalEntryService {
            return "JournalEntryService";
        } else if serviceRef is PaymentService {
            return "PaymentService";
        } else if serviceRef is PaymentMethodService {
            return "PaymentMethodService";
        } else if serviceRef is PreferencesService {
            return "PreferencesService";
        } else if serviceRef is PurchaseService {
            return "PurchaseService";
        } else if serviceRef is PurchaseOrderService {
            return "PurchaseOrderService";
        } else if serviceRef is RefundReceiptService {
            return "RefundReceiptService";
        } else if serviceRef is SalesReceiptService {
            return "SalesReceiptService";
        } else if serviceRef is TaxAgencyService {
            return "TaxAgencyService";
        } else if serviceRef is TermService {
            return "TermService";
        } else if serviceRef is TimeActivityService {
            return "TimeActivityService";
        } else if serviceRef is TransferService {
            return "TransferService";
        } else if serviceRef is VendorService {
            return "VendorService";
        } else {
            return "VendorCreditService";
        }
    }
}
