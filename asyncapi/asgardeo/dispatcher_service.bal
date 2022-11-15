import ballerina/websub;
import ballerina/log;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *websub:SubscriberService;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();

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

    public function onEventNotification(websub:ContentDistributionMessage event) returns websub:Acknowledgement|error {
        check self.matchRemoteFunc(<json>event.content);
        return websub:ACKNOWLEDGEMENT;
    }

    public function onSubscriptionValidationDenied(websub:SubscriptionDeniedError msg) returns websub:Acknowledgement?|error {
        if (msg.message().includes("already registered")){
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
