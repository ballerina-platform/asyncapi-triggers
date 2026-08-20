// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
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
import ballerina/time;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string webhookSecret;
    private string callbackUrl;

    function init(string webhookSecret, string callbackUrl) {
        self.webhookSecret = webhookSecret;
        self.callbackUrl = callbackUrl;
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
        http:Response ackResponse = new;ackResponse.statusCode = http:STATUS_OK; check caller->respond(ackResponse);
        foreach json event in eventsArray {
            json|error eventTypeField = event.subscriptionType;
            if eventTypeField is error {
                log:printError("DISPATCH_FAILED", eventTypeField);
                continue;
            }
            string eventType = eventTypeField.toString();
            GenericDataType|error genericDataTypeResult = event.cloneWithType(GenericDataType);
            if genericDataTypeResult is error {
                log:printError("DISPATCH_FAILED", genericDataTypeResult);
                continue;
            }
            error? dispatchResult = self.matchRemoteFunc(genericDataTypeResult, eventType);
            if dispatchResult is error {
                log:printError("DISPATCH_FAILED", dispatchResult);
            }
        }
    }

    private function verifyWebhookSignature(http:Request request, string webhookSecret) returns error? {
        if !request.hasHeader("X-HubSpot-Request-Timestamp") {
            return error("Unauthorized: Missing Freshness Header");
        }
        string freshnessHeaderValue = let var headerValue = trap request.getHeader("X-HubSpot-Request-Timestamp") in (headerValue is string ? headerValue : "");
        decimal freshnessTimestamp = check decimal:fromString(freshnessHeaderValue);
        decimal freshnessNowMillis = <decimal>time:utcNow()[0] * 1000;
        decimal freshnessSkewMillis = freshnessNowMillis - freshnessTimestamp;
        if freshnessSkewMillis.abs() > <decimal>300000 {
            return error("Unauthorized: Request Timestamp Expired");
        }
        if !request.hasHeader("X-HubSpot-Signature-v3") {
            return error("Unauthorized: Missing Signature Header");
        }
        string receivedHeader = let var headerValue = trap request.getHeader("X-HubSpot-Signature-v3") in (headerValue is string ? headerValue : "");
        map<string> extractedHeaderValues = {};
        int headerCursor = 0;
        extractedHeaderValues["signature"] = receivedHeader.substring(headerCursor);
        headerCursor = receivedHeader.length();
        if !extractedHeaderValues.hasKey("signature") {
            return error("Unauthorized: Missing Header Component: signature");
        }
        string signature = extractedHeaderValues["signature"] ?: "";
        if !extractedHeaderValues.hasKey("signature") {
            return error("Unauthorized: Missing Signature Value");
        }
        string extractedSignature = extractedHeaderValues["signature"] ?: "";
        string payloadToHash = string `${request.method}${self.callbackUrl}${check request.getTextPayload()}${let var headerValue = trap request.getHeader("X-HubSpot-Request-Timestamp") in (headerValue is string ? headerValue : "")}`;
        byte[] computedDigest = check crypto:hmacSha256(payloadToHash.toBytes(), webhookSecret.toBytes());
        string computedSignature = computedDigest.toBase64();
        string expectedHeader = string `${computedSignature}`;
        if !crypto:equalConstantTime(receivedHeader.toBytes(), expectedHeader.toBytes()) {
            return error("Unauthorized: Signature Mismatch");
        }
        return;
    }

    private function matchRemoteFunc(GenericDataType genericDataType, string eventType) returns error? {
        check self.matchRemoteFuncForTicket(genericDataType);
        check self.matchRemoteFuncForCompany(genericDataType);
        check self.matchRemoteFuncForLineItem(genericDataType);
        check self.matchRemoteFuncForProduct(genericDataType);
        check self.matchRemoteFuncForConversation(genericDataType);
        check self.matchRemoteFuncForDeal(genericDataType);
        check self.matchRemoteFuncForContact(genericDataType);
    }

    private function matchRemoteFuncForTicket(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "ticket.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "ticket.propertyChange", "TicketService", "onTicketPropertyChange");
            }
            "ticket.deletion" => {
                check self.executeRemoteFunc(genericDataType, "ticket.deletion", "TicketService", "onTicketDeletion");
            }
            "ticket.creation" => {
                check self.executeRemoteFunc(genericDataType, "ticket.creation", "TicketService", "onTicketCreation");
            }
            "ticket.merge" => {
                check self.executeRemoteFunc(genericDataType, "ticket.merge", "TicketService", "onTicketMerge");
            }
            "ticket.restore" => {
                check self.executeRemoteFunc(genericDataType, "ticket.restore", "TicketService", "onTicketRestore");
            }
            "ticket.associationChange" => {
                check self.executeRemoteFunc(genericDataType, "ticket.associationChange", "TicketService", "onTicketAssociationChange");
            }
        }
    }

    private function matchRemoteFuncForCompany(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "company.deletion" => {
                check self.executeRemoteFunc(genericDataType, "company.deletion", "CompanyService", "onCompanyDeletion");
            }
            "company.restore" => {
                check self.executeRemoteFunc(genericDataType, "company.restore", "CompanyService", "onCompanyRestore");
            }
            "company.merge" => {
                check self.executeRemoteFunc(genericDataType, "company.merge", "CompanyService", "onCompanyMerge");
            }
            "company.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "company.propertyChange", "CompanyService", "onCompanyPropertyChange");
            }
            "company.creation" => {
                check self.executeRemoteFunc(genericDataType, "company.creation", "CompanyService", "onCompanyCreation");
            }
            "company.associationChange" => {
                check self.executeRemoteFunc(genericDataType, "company.associationChange", "CompanyService", "onCompanyAssociationChange");
            }
        }
    }

    private function matchRemoteFuncForLineItem(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "line_item.merge" => {
                check self.executeRemoteFunc(genericDataType, "line_item.merge", "LineItemService", "onLineItemMerge");
            }
            "line_item.deletion" => {
                check self.executeRemoteFunc(genericDataType, "line_item.deletion", "LineItemService", "onLineItemDeletion");
            }
            "line_item.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "line_item.propertyChange", "LineItemService", "onLineItemPropertyChange");
            }
            "line_item.restore" => {
                check self.executeRemoteFunc(genericDataType, "line_item.restore", "LineItemService", "onLineItemRestore");
            }
            "line_item.associationChange" => {
                check self.executeRemoteFunc(genericDataType, "line_item.associationChange", "LineItemService", "onLineItemAssociationChange");
            }
            "line_item.creation" => {
                check self.executeRemoteFunc(genericDataType, "line_item.creation", "LineItemService", "onLineItemCreation");
            }
        }
    }

    private function matchRemoteFuncForProduct(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "product.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "product.propertyChange", "ProductService", "onProductPropertyChange");
            }
            "product.deletion" => {
                check self.executeRemoteFunc(genericDataType, "product.deletion", "ProductService", "onProductDeletion");
            }
            "product.merge" => {
                check self.executeRemoteFunc(genericDataType, "product.merge", "ProductService", "onProductMerge");
            }
            "product.restore" => {
                check self.executeRemoteFunc(genericDataType, "product.restore", "ProductService", "onProductRestore");
            }
            "product.creation" => {
                check self.executeRemoteFunc(genericDataType, "product.creation", "ProductService", "onProductCreation");
            }
        }
    }

    private function matchRemoteFuncForConversation(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "conversation.creation" => {
                check self.executeRemoteFunc(genericDataType, "conversation.creation", "ConversationService", "onConversationCreation");
            }
            "conversation.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "conversation.propertyChange", "ConversationService", "onConversationPropertyChange");
            }
            "conversation.privacyDeletion" => {
                check self.executeRemoteFunc(genericDataType, "conversation.privacyDeletion", "ConversationService", "onConversationPrivacyDeletion");
            }
            "conversation.newMessage" => {
                check self.executeRemoteFunc(genericDataType, "conversation.newMessage", "ConversationService", "onConversationNewMessage");
            }
            "conversation.deletion" => {
                check self.executeRemoteFunc(genericDataType, "conversation.deletion", "ConversationService", "onConversationDeletion");
            }
        }
    }

    private function matchRemoteFuncForDeal(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "deal.deletion" => {
                check self.executeRemoteFunc(genericDataType, "deal.deletion", "DealService", "onDealDeletion");
            }
            "deal.creation" => {
                check self.executeRemoteFunc(genericDataType, "deal.creation", "DealService", "onDealCreation");
            }
            "deal.merge" => {
                check self.executeRemoteFunc(genericDataType, "deal.merge", "DealService", "onDealMerge");
            }
            "deal.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "deal.propertyChange", "DealService", "onDealPropertyChange");
            }
            "deal.restore" => {
                check self.executeRemoteFunc(genericDataType, "deal.restore", "DealService", "onDealRestore");
            }
            "deal.associationChange" => {
                check self.executeRemoteFunc(genericDataType, "deal.associationChange", "DealService", "onDealAssociationChange");
            }
        }
    }

    private function matchRemoteFuncForContact(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "contact.creation" => {
                check self.executeRemoteFunc(genericDataType, "contact.creation", "ContactService", "onContactCreation");
            }
            "contact.associationChange" => {
                check self.executeRemoteFunc(genericDataType, "contact.associationChange", "ContactService", "onContactAssociationChange");
            }
            "contact.deletion" => {
                check self.executeRemoteFunc(genericDataType, "contact.deletion", "ContactService", "onContactDeletion");
            }
            "contact.privacyDeletion" => {
                check self.executeRemoteFunc(genericDataType, "contact.privacyDeletion", "ContactService", "onContactPrivacyDeletion");
            }
            "contact.propertyChange" => {
                check self.executeRemoteFunc(genericDataType, "contact.propertyChange", "ContactService", "onContactPropertyChange");
            }
            "contact.merge" => {
                check self.executeRemoteFunc(genericDataType, "contact.merge", "ContactService", "onContactMerge");
            }
            "contact.restore" => {
                check self.executeRemoteFunc(genericDataType, "contact.restore", "ContactService", "onContactRestore");
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
