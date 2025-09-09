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

import ballerina/crypto;
import ballerina/http;
import ballerina/lang.regexp;
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
            return error("Cannot detach the service of type " + serviceType +
            ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns http:Response|error? {
        string payload = check request.getTextPayload();
        byte[] binaryPay = payload.toBytes();
        string signature = check request.getHeader("x-wso2-event-signature");
        string trimmedSecret = signature.substring(7, signature.length());
        byte[] output = check crypto:hmacSha256(binaryPay, self.listenerConfig.webhookSecret.toBytes());
        string computedDigest = output.toBase16();
        if (trimmedSecret.length() != computedDigest.length() || trimmedSecret != computedDigest) {
            // Validate secret with x-wso2-event-signature header for intent verification.
            http:Response response = new;
            response.statusCode = http:STATUS_UNAUTHORIZED;
            return response;
        }

        json parsedPayload = check payload.fromJsonString();
        GenericPayloadType|error genericPayloadType = parsedPayload.cloneWithType();
        if genericPayloadType is error {
            http:Response response = new;
            response.statusCode = http:STATUS_BAD_REQUEST;
            return response;
        }
        check self.matchRemoteFunc(genericPayloadType);
        http:Response response = new;
        response.statusCode = http:STATUS_OK;
        return response;
    }

    private function matchRemoteFunc(GenericPayloadType genericPayloadType) returns error? {
        json events = genericPayloadType.events;
        map<json> eventMap = check events.ensureType();
        string eventKey = eventMap.keys()[0];
        regexp:RegExp eventPattern = re `/events/`;
        string[] eventSplit = regexp:split(eventPattern, eventKey);
        if eventSplit.length() < 2 {
            return error("Invalid event key format: missing main event with event type");
        }
        string mainEventWithEventType = eventSplit[1];
        regexp:RegExp eventTypePattern = re `/event-type/`;
        string[] eventDetails = regexp:split(eventTypePattern, mainEventWithEventType);
        if eventDetails.length() < 2 {
            return error("Invalid event key format: missing event type");
        }
        string mainEvent = eventDetails[0];
        string eventType = eventDetails[1];

        match mainEvent {
            "user" => {
                match eventType {
                    "userCreated" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userCreatedData = check eventData.cloneWithType();
                        GenericUserOperationEvent userCreatedEvent = {
                            eventData: userCreatedData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userCreatedEvent, "userCreated",
                            "UserOperationService", "onCreateUser");
                    }
                    "userProfileUpdated" => {
                        json eventData = eventMap[eventKey];
                        UserProfileUpdateData userUpdatedData = check eventData.cloneWithType();
                        UserProfileUpdateOperationEvent userUpdatedEvent = {
                            eventData: userUpdatedData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userUpdatedEvent, "userProfileUpdated",
                            "UserOperationService", "onUpdateUser");
                    }
                    "userEnabled" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userEnabledData = check eventData.cloneWithType();
                        GenericUserOperationEvent userEnabledEvent = {
                            eventData: userEnabledData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userEnabledEvent, "userEnabled",
                            "UserOperationService", "onEnableUser");
                    }
                    "userDisabled" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userDisabledData = check eventData.cloneWithType();
                        GenericUserOperationEvent userDisabledEvent = {
                            eventData: userDisabledData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userDisabledEvent, "userDisabled",
                            "UserOperationService", "onDisableUser");
                    }
                    "userAccountLocked" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userAccountLockedData = check eventData.cloneWithType();
                        GenericUserOperationEvent userAccountLockedEvent = {
                            eventData: userAccountLockedData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userAccountLockedEvent, "userAccountLocked",
                            "UserOperationService", "onUserAccountLock");
                    }
                    "userAccountUnlocked" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userAccountUnlockedData = check eventData.cloneWithType();
                        GenericUserOperationEvent userAccountUnlockedEvent = {
                            eventData: userAccountUnlockedData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userAccountUnlockedEvent, "userAccountUnlocked",
                            "UserOperationService", "onUserAccountUnlock");
                    }
                    "userDeleted" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userDeletedData = check eventData.cloneWithType();
                        GenericUserOperationEvent userDeletedEvent = {
                            eventData: userDeletedData,
                            securityData: self.getSecurityData(genericPayloadType)
                        };
                        check self.executeRemoteFunc(userDeletedEvent, "userDeleted",
                            "UserOperationService", "onDeleteUser");
                    }
                }
            }
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr,
            string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }

    private function getSecurityData(GenericPayloadType genericPayloadType) returns GenericSecurityData {
        return {
            iss: genericPayloadType.iss,
            jti: genericPayloadType.jti,
            iat: genericPayloadType.iat,
            rci: genericPayloadType.rci
        };
    }
}
