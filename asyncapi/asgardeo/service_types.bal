public type RegistrationService service object {
    remote function onAddUser(AddUserEvent event) returns error?;
    remote function onSelfSignupConfirm(GenericEvent event) returns error?;
    remote function onAskPasswordConfirm(GenericEvent event) returns error?;
};

public type UserOperationService service object {
    remote function onLockUser(GenericEvent event) returns error?;
    remote function onUnlockUser(GenericEvent event) returns error?;
    remote function onUpdateUserCredentials(GenericEvent event) returns error?;
    remote function onDeleteUser(GenericEvent event) returns error?;
    remote function onUpdateUserGroup(UserGroupUpdateEvent event) returns error?;
};

public type LoginService service object {
    remote function onLoginSuccess(LoginSuccessEvent event) returns error?;
};

public type GenericServiceType RegistrationService|UserOperationService|LoginService;
