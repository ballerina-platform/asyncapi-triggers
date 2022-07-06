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
import ballerina/crypto;
import ballerina/log;
import ballerina/time;

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
        json[] eventsPayload = check payload.ensureType();
        http:Response response = new;

        error? validateRequestResult = self.validateRequest(request, payload);
        if validateRequestResult is error {
            string errorMessage = string `${eventValidationError} | ${validateRequestResult.message()}`;
            log:printError(errorMessage);
            response.statusCode = http:STATUS_NOT_ACCEPTABLE;
            response.setPayload(errorMessage);
            return response;
        }

        // Iterate event payload and emit each event
        foreach var event in eventsPayload {
            GenericDataType genericDataType = check event.cloneWithType(GenericDataType);
            error? matchRemoteFuncResult = self.matchRemoteFunc(genericDataType);
            if matchRemoteFuncResult is error {
                WebhookEvent failedEvent = check genericDataType.ensureType(WebhookEvent);
                log:printError(string `Error processing the event. EventID: ${<string>failedEvent.eventId}`);
                log:printError(matchRemoteFuncResult.toString());
            }
        }

        check caller->respond(http:STATUS_OK);
        return;
    }

    // Validate the request using request headers `X-HubSpot-Signature-v3` and `X-HubSpot-Request-Timestamp`
    // Documentation : https://developers.hubspot.com/docs/api/webhooks/validating-requests#validate-the-v3-request-signature
    private function validateRequest(http:Request request, json payload) returns error? {
        string signatureV3 = check request.getHeader("X-HubSpot-Signature-v3");
        decimal timestamp = check decimal:fromString(check request.getHeader("X-HubSpot-Request-Timestamp"));
        error? validateTimestampResult = self.validateTimestamp(timestamp);
        if validateTimestampResult is error {
            return validateTimestampResult;
        }
        error? validateSignatureResult = self.validateSignature(signatureV3, timestamp, payload);
        if validateSignatureResult is error {
            return validateSignatureResult;
        }
    }

    // Payload verification step 1
    // Reject the request if the timestamp is older than 5 minutes.
    // Documentation : https://developers.hubspot.com/docs/api/webhooks/validating-requests#validate-the-v3-request-signature
    private function validateTimestamp(decimal timestamp) returns error? {
        decimal timeDifference = <decimal>time:utcNow()[0] * 1000 - timestamp;
        if timeDifference > FIVE_MINUTES_IN_MILLISECONDS {
            return error(requestTimeoutFailure);
        }
    }

    // Payload verification step 2
    // Compare the generated Hash value to the `X-HubSpot-Signature-v3` header value. 
    // If they're equal then this request has been verified as originating from HubSpot.
    // Documentation: https://developers.hubspot.com/docs/api/webhooks/validating-requests#validate-the-v3-request-signature
    private function validateSignature(string signatureV3, decimal timestamp, json payload) returns error? {
        string generatedHash = string `POST${self.listenerConfig.callbackURL}${payload.toString()}${timestamp}`;
        byte[] digest = check crypto:hmacSha256(generatedHash.toBytes(), self.listenerConfig.clientSecret.toBytes());
        string computedHmac = digest.toBase64();
        if (signatureV3 != computedHmac) {
            return error(signatureVerificationFailure);
        }
    }

    private function matchRemoteFunc(GenericDataType genericDataType) returns error? {
        match genericDataType.subscriptionType {
            "company.creation" => {
                check self.executeRemoteFunc(genericDataType, "company.creation", "CompanyService", "onCompanyCreation");
            }
            "company.deletion" => {
                check self.executeRemoteFunc(genericDataType, "company.deletion", "CompanyService", "onCompanyDeletion");
            }
            "contact.creation" => {
                check self.executeRemoteFunc(genericDataType, "contact.creation", "ContactService", "onContactCreation");
            }
            "contact.deletion" => {
                check self.executeRemoteFunc(genericDataType, "contact.deletion", "ContactService", "onContactDeletion");
            }
            "conversation.creation" => {
                check self.executeRemoteFunc(genericDataType, "conversation.creation", "ConversationService", "onConversationCreation");
            }
            "conversation.deletion" => {
                check self.executeRemoteFunc(genericDataType, "conversation.deletion", "ConversationService", "onConversationDeletion");
            }
            "deal.creation" => {
                check self.executeRemoteFunc(genericDataType, "deal.creation", "DealService", "onDealCreation");
            }
            "deal.deletion" => {
                check self.executeRemoteFunc(genericDataType, "deal.deletion", "DealService", "onDealDeletion");
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
