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

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if self.services.hasKey(serviceType) {
            return error("Service of type " + serviceType + " has already been attached");
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if !self.services.hasKey(serviceType) {
            return error("Cannot detach the service of type " + serviceType + 
                ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns error? {
        json payload = check request.getJsonPayload();
        string eventName = check request.getHeader("x-shopify-topic");
        // GenericDataType genericDataType = check payload.cloneWithType(GenericDataType);
        check self.matchRemoteFunc(payload, eventName);
        check caller->respond(http:STATUS_OK);
    }

    private function matchRemoteFunc(json payload, string eventName) returns error? {
        match eventName {
            "orders/create" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/create", "OrdersService", "onOrdersCreate");
            }
            "orders/cancelled" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/cancelled", "OrdersService", "onOrdersCancelled");
            }
            "orders/fulfilled" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/fulfilled", "OrdersService", "onOrdersFulfilled");
            }
            "orders/paid" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/paid", "OrdersService", "onOrdersPaid");
            }
            "orders/partially_fulfilled" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/partially_fulfilled", "OrdersService", "onOrdersPartiallyFulfilled");
            }
            "orders/updated" => {
                OrderEvent genericDataType = check payload.cloneWithType(OrderEvent);
                check self.executeRemoteFunc(genericDataType, "orders/updated", "OrdersService", "onOrdersUpdated");
            }
            "customers/create" => {
                CustomerEvent genericDataType = check payload.cloneWithType(CustomerEvent);
                check self.executeRemoteFunc(genericDataType, "customers/create", "CustomersService", "onCustomersCreate");
            }
            "customers/disable" => {
                CustomerEvent genericDataType = check payload.cloneWithType(CustomerEvent);
                check self.executeRemoteFunc(genericDataType, "customers/disable", "CustomersService", "onCustomersDisable");
            }
            "customers/enable" => {
                CustomerEvent genericDataType = check payload.cloneWithType(CustomerEvent);
                check self.executeRemoteFunc(genericDataType, "customers/enable", "CustomersService", "onCustomersEnable");
            }
            "customers/update" => {
                CustomerEvent genericDataType = check payload.cloneWithType(CustomerEvent);
                check self.executeRemoteFunc(genericDataType, "customers/update", "CustomersService", "onCustomersUpdate");
            }
            "customers_marketing_consent/update" => {
                CustomerEvent genericDataType = check payload.cloneWithType(CustomerEvent);
                check self.executeRemoteFunc(genericDataType, "customers_marketing_consent/update", "CustomersService", "onCustomersMarketingConsentUpdate");
            }
            "products/create" => {
                ProductEvent genericDataType = check payload.cloneWithType(ProductEvent);
                check self.executeRemoteFunc(genericDataType, "products/create", "ProductsService", "onProductsCreate");
            }
            "products/update" => {
                ProductEvent genericDataType = check payload.cloneWithType(ProductEvent);
                check self.executeRemoteFunc(genericDataType, "products/update", "ProductsService", "onProductsUpdate");
            }
            "fulfillments/create" => {
                FulfillmentEvent genericDataType = check payload.cloneWithType(FulfillmentEvent);
                check self.executeRemoteFunc(genericDataType, "fulfillments/create", "FulfillmentsService", "onFulfillmentsCreate");
            }
            "fulfillments/update" => {
                FulfillmentEvent genericDataType = check payload.cloneWithType(FulfillmentEvent);
                check self.executeRemoteFunc(genericDataType, "fulfillments/update", "FulfillmentsService", "onFulfillmentsUpdate");
            }
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
