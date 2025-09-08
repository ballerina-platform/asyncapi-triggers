// Copyright (c) 2025 WSO2 LLC. (http://www.wso2.com).
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

import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/asyncapi.native.handler;
import ballerina/crypto;

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
        json payload = check <@untainted> request.getJsonPayload();
        byte [] binaryPay = <@untainted> payload.toString().toBytes();
        string signature = check request.getHeader("x-wso2-event-signature");
        string trimmedSecret = signature.substring(7, signature.length());
        byte [] output = check crypto:hmacSha256(binaryPay, self.listenerConfig.webhookSecret.toBytes());
        string computedDigest = output.toBase16();
        if (trimmedSecret.length() != computedDigest.length() || trimmedSecret !== computedDigest) {
            // Validate secret with x-wso2-event-signature header for intent verification.
            log:printError("Signature verification failure");
            http:Response response = new;
            response.statusCode = http:STATUS_UNAUTHORIZED;
            response.setPayload("Signature verification failure");
            return response;
        }

        GenericPayloadType|error genericPayloadType = payload.cloneWithType(GenericPayloadType);
        if (genericPayloadType is error) {
            log:printError("Unsupported payload");
            return genericPayloadType;
        } else {
            check self.matchRemoteFunc(genericPayloadType);
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            response.setPayload("Event acknoledged successfully");
            return response;
        }
    }

    private function matchRemoteFunc(GenericPayloadType genericPayloadType) returns error? {
        json events = genericPayloadType.events;
        map<json> eventMap = <map<json>>events;
        string eventKey = eventMap.keys()[0];
        string[] mainEventParts = regex:split(eventKey, "/events/");
        string mainEvent = regex:split(mainEventParts[1], "/event-type/")[0];
        string[] eventTypeParts = regex:split(eventKey, "/event-type/");
        string eventType = eventTypeParts[1];
        log:printInfo("Received event: " + mainEvent + " of type: " + eventType);
        match mainEvent {
            "user" => {
                match eventType {
                    "userCreated" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userCreatedData = check eventData.cloneWithType(GenericUserOperationData);
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userCreatedEvent = {
                            eventData: userCreatedData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userCreatedEvent, "userCreated", "UserOperationService", "onCreateUser");
                    }
                }
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
