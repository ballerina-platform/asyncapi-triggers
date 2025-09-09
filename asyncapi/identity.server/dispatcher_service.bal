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
import ballerina/lang.regexp;
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
            return error("Cannot detach the service of type " + serviceType +
            ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns http:Response|error? {
        json payload = check request.getJsonPayload();
        byte[] binaryPay = payload.toString().toBytes();
        string signature = check request.getHeader("x-wso2-event-signature");
        string trimmedSecret = signature.substring(7, signature.length());
        byte[] output = check crypto:hmacSha256(binaryPay, self.listenerConfig.webhookSecret.toBytes());
        string computedDigest = output.toBase16();
        if (trimmedSecret.length() != computedDigest.length() || trimmedSecret !== computedDigest) {
            // Validate secret with x-wso2-event-signature header for intent verification.
            log:printError("Signature verification failure");
            http:Response response = new;
            response.statusCode = http:STATUS_UNAUTHORIZED;
            response.setPayload("Signature verification failure");
            return response;
        }

        GenericPayloadType|error genericPayloadType = payload.cloneWithType();
        if (genericPayloadType is error) {
            log:printError("Unsupported payload");
            return genericPayloadType;
        } else {
            check self.matchRemoteFunc(genericPayloadType);
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            response.setPayload("Event acknowledged successfully");
            return response;
        }
    }

    private function matchRemoteFunc(GenericPayloadType genericPayloadType) returns error? {
        json events = genericPayloadType.events;
        map<json> eventMap = <map<json>>events;
        string eventKey = eventMap.keys()[0];
        regexp:RegExp eventPattern = check regexp:fromString("/events/");
        string mainEventWithEventType = regexp:split(eventPattern, eventKey)[1];
        regexp:RegExp eventTypePattern = check regexp:fromString("/event-type/");
        string[] eventDetails = regexp:split(eventTypePattern, mainEventWithEventType);
        string mainEvent = eventDetails[0];
        string eventType = eventDetails[1];

        match mainEvent {
            "user" => {
                match eventType {
                    "userCreated" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userCreatedData = check eventData.cloneWithType();
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
                        check self.executeRemoteFunc(userCreatedEvent, "userCreated",
                        "UserOperationService", "onCreateUser");
                    }
                    "userProfileUpdated" => {
                        json eventData = eventMap[eventKey];
                        UserProfileUpdateData userUpdatedData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        UserProfileUpdateOperationEvent userUpdatedEvent = {
                            eventData: userUpdatedData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userUpdatedEvent, "userProfileUpdated",
                        "UserOperationService", "onUpdateUser");
                    }
                    "userEnabled" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userEnabledData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userEnabledEvent = {
                            eventData: userEnabledData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userEnabledEvent, "userEnabled",
                        "UserOperationService", "onEnableUser");
                    }
                    "userDisabled" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userDisabledData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userDisabledEvent = {
                            eventData: userDisabledData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userDisabledEvent, "userDisabled",
                        "UserOperationService", "onDisableUser");
                    }
                    "userAccountLocked" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userAccountLockedData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userAccountLockedEvent = {
                            eventData: userAccountLockedData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userAccountLockedEvent, "userAccountLocked",
                        "UserOperationService", "onUserAccountLock");
                    }
                    "userAccountUnlocked" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userAccountUnlockedData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userAccountUnlockedEvent = {
                            eventData: userAccountUnlockedData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(userAccountUnlockedEvent, "userAccountUnlocked",
                        "UserOperationService", "onUserAccountUnlock");
                    }
                    "userDeleted" => {
                        json eventData = eventMap[eventKey];
                        GenericUserOperationData userDeletedData = check eventData.cloneWithType();
                        GenericSecurityData securityData = {
                            iss: genericPayloadType.iss,
                            jti: genericPayloadType.jti,
                            iat: genericPayloadType.iat,
                            rci: genericPayloadType.rci
                        };
                        GenericUserOperationEvent userDeletedEvent = {
                            eventData: userDeletedData,
                            securityData: securityData
                        };
                        check self.executeRemoteFunc(
                            userDeletedEvent, "userDeleted", "UserOperationService", "onDeleteUser");
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
}
