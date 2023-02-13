// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/jballerina.java as java;
import ballerina/log;
import ballerina/websub;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *websub:SubscriberService;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string decryptionKey = "";
    private string keyAlgorithm = "";
    private string token = "";
    private string orgHandle = "";
    private string tokenEndpoint = "";
    private string keyServiceURL = "";
    private string clientId = "";
    private string clientSecret = "";

    isolated function setOrgInfo(string key, string algo, string token, ListenerConfig config) {
        self.decryptionKey = key;
        self.keyAlgorithm = algo;
        self.token = token;
        self.orgHandle = config.organization;
        self.tokenEndpoint = config.tokenEndpointHost;
        self.keyServiceURL = config.keyServiceURL;
        self.clientId = config.clientId;
        self.clientSecret = config.clientSecret;
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

    # On-Event-Notification
    # Receive the event, decrypt the payload and send acknowledgement. 
    # Note: 
    # If this function couldnt ACK due to errors, Hub send the payload again (upto 3 attempts)
    #
    # + event - websub event
    # + return - websub acknowledgement
    public function onEventNotification(websub:ContentDistributionMessage event) returns websub:Acknowledgement|error {
        AsgardeoPayload|error payload = event.content.cloneWithType();
        if payload is error {
            log:printDebug("Un-encrypted payload received.");
            check self.matchRemoteFunc(<json> event.content);
            return websub:ACKNOWLEDGEMENT;
        }
        string decryptedEvent = check self.decryptEvent(payload.event);
        log:printDebug("Successfully decrypted the payload.");
        DecryptedAsgardeoPayload dePayload = {
            iss: payload.iss,
            jti: payload.jti,
            iat: payload.iat,
            aud: payload.aud,
            event: check decryptedEvent.fromJsonString()
        };
        check self.matchRemoteFunc(dePayload.toJson());
        return websub:ACKNOWLEDGEMENT;
    }

    public function onSubscriptionValidationDenied(websub:SubscriptionDeniedError msg) returns websub:Acknowledgement?|error {
        if (msg.message().includes("already registered")) {
            log:printInfo("Successfully subscribed to the event source");
        } else {
            log:printError("Subscription failed: " + msg.message());
        }
        return websub:ACKNOWLEDGEMENT;
    }

    public function onSubscriptionVerification(websub:SubscriptionVerification msg)
                        returns websub:SubscriptionVerificationSuccess|websub:SubscriptionVerificationError {
        log:printInfo("Successfully subscribed to the event source");
        return websub:SUBSCRIPTION_VERIFICATION_SUCCESS;
    }

    public function onUnsubscriptionVerification(websub:UnsubscriptionVerification msg)
                        returns websub:UnsubscriptionVerificationSuccess|websub:UnsubscriptionVerificationError {
        log:printInfo("Successfully unsubscribed from the event source");
        return websub:UNSUBSCRIPTION_VERIFICATION_SUCCESS;
    }

    private function matchRemoteFunc(json payload) returns error? {
        map<json> eventMap = <map<json>>(check payload.event);
        foreach string event in eventMap.keys() {
            GenericSecurityData securityData = check payload.cloneWithType(GenericSecurityData);
            match event {
                "urn:ietf:params:registrations:addUser" => {
                    AddUserData eventData = check eventMap.get(event).cloneWithType(AddUserData);
                    AddUserEvent addUserEvent = {securityData, eventData};
                    check self.executeRemoteFunc(addUserEvent, "urn:ietf:params:registrations:addUser", "RegistrationService", "onAddUser");
                }
                "urn:ietf:params:registrations:confirmSelfSignUp" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:registrations:confirmSelfSignUp", "RegistrationService", "onConfirmSelfSignup");
                }
                "urn:ietf:params:registrations:acceptUserInvite" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:registrations:acceptUserInvite", "RegistrationService", "onAcceptUserInvite");
                }
                "urn:ietf:params:user-operations:lockUser" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:user-operations:lockUser", "UserOperationService", "onLockUser");
                }
                "urn:ietf:params:user-operations:unlockUser" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:user-operations:unlockUser", "UserOperationService", "onUnlockUser");
                }
                "urn:ietf:params:user-operations:updateUserCredentials" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:user-operations:updateUserCredentials", "UserOperationService", "onUpdateUserCredentials");
                }
                "urn:ietf:params:user-operations:deleteUser" => {
                    GenericUserData eventData = check eventMap.get(event).cloneWithType(GenericUserData);
                    GenericEvent genericEvent = {securityData, eventData};
                    check self.executeRemoteFunc(genericEvent, "urn:ietf:params:user-operations:deleteUser", "UserOperationService", "onDeleteUser");
                }
                "urn:ietf:params:user-operations:updateUserGroup" => {
                    UserGroupUpdateData eventData = check eventMap.get(event).cloneWithType(UserGroupUpdateData);
                    UserGroupUpdateEvent userGroupUpdateEvent = {securityData, eventData};
                    check self.executeRemoteFunc(userGroupUpdateEvent, "urn:ietf:params:user-operations:updateUserGroup", "UserOperationService", "onUpdateUserGroup");
                }
                "urn:ietf:params:logins:loginSuccess" => {
                    LoginSuccessData eventData = check eventMap.get(event).cloneWithType(LoginSuccessData);
                    LoginSuccessEvent loginSuccessEvent = {securityData, eventData};
                    check self.executeRemoteFunc(loginSuccessEvent, "urn:ietf:params:logins:loginSuccess", "LoginService", "onLoginSuccess");
                }
                "urn:ietf:params:notifications:smsOtp" => {
                    SmsOtpNotificationData eventData = check eventMap.get(event).cloneWithType(SmsOtpNotificationData);
                    SmsOtpNotificationEvent smsOtpNotificationEvent = {securityData, eventData};
                    check self.executeRemoteFunc(smsOtpNotificationEvent, "urn:ietf:params:notifications:smsOtp", "NotificationService", "onSmsOtp");
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

    # Decrypting event payload
    #
    # Steps: 
    # 1. Obtain the symmetric key by decrypting the `payloadCryptoKey` inside `event`
    # 2. Obtain the event by decrypting the `payload` inside the `event` using symmetric key (and IV).
    #
    # Note: This function has retry attempts using previous decryption key and new DCR token.
    #
    # + event - Event metadata
    # + return - Decrypted string
    public function decryptEvent(EventDetail event) returns string|error {
        string|error symmetricKey = decryptSymmetricKey(java:fromString(event.payloadCryptoKey), java:fromString(self.decryptionKey));
        if symmetricKey is string {
            return check decryptPayload(java:fromString(event.payload), java:fromString(symmetricKey), java:fromString(event.iv));
        } else {
            log:printDebug("Error in decrypting the payload.\nFetching the previous decryption key.");
            KeyData previousKey = check fetchDecryptionKey(self.keyServiceURL, self.token, self.orgHandle, 1);
            string|error symmetricKeyRetry = decryptSymmetricKey(java:fromString(event.payloadCryptoKey), java:fromString(previousKey.key));
            if symmetricKeyRetry is string {
                return check decryptPayload(java:fromString(event.payload), java:fromString(symmetricKeyRetry), java:fromString(event.iv));
            } else {
                log:printDebug("Error in decrypting the payload.\nFetching a new token.");
                self.token = check fetchToken(self.tokenEndpoint, self.clientId, self.clientSecret);
                record {string key;} newDecryptionKey = check fetchDecryptionKey(self.keyServiceURL, self.token, self.orgHandle, 0);
                self.decryptionKey = newDecryptionKey.key;
                string newSymmetricKey = check decryptSymmetricKey(java:fromString(event.payloadCryptoKey), java:fromString(self.decryptionKey));
                return check decryptPayload(java:fromString(event.payload), java:fromString(newSymmetricKey), java:fromString(event.iv));
            }
        }
    }
}
