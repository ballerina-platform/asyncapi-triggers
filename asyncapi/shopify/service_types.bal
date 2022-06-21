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

public type OrdersService service object {
    remote function onOrdersCreate(OrderEvent event) returns error?;
    remote function onOrdersCancelled(OrderEvent event) returns error?;
    remote function onOrdersFulfilled(OrderEvent event) returns error?;
    remote function onOrdersPaid(OrderEvent event) returns error?;
    remote function onOrdersPartiallyFulfilled(OrderEvent event) returns error?;
    remote function onOrdersUpdated(OrderEvent event) returns error?;
};

public type CustomersService service object {
    remote function onCustomersCreate(CustomerEvent event) returns error?;
    remote function onCustomersDisable(CustomerEvent event) returns error?;
    remote function onCustomersEnable(CustomerEvent event) returns error?;
    remote function onCustomersUpdate(CustomerEvent event) returns error?;
    remote function onCustomersMarketingConsentUpdate(CustomerEvent event) returns error?;
};

public type ProductsService service object {
    remote function onProductsCreate(ProductEvent event) returns error?;
    remote function onProductsUpdate(ProductEvent event) returns error?;
};

public type FulfillmentsService service object {
    remote function onFulfillmentsCreate(FulfillmentEvent event) returns error?;
    remote function onFulfillmentsUpdate(FulfillmentEvent event) returns error?;
};

public type GenericServiceType OrdersService|CustomersService|ProductsService|FulfillmentsService;
