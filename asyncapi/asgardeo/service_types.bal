public type RegistrationsService service object {
    remote function onAddUser(AddUserEvent event) returns error?;
    remote function onSelfSignupConfirm(GenericEvent event) returns error?;
    remote function onAskPasswordConfirm(GenericEvent event) returns error?;
};

public type UserOperationsService service object {
    remote function onLockUser(GenericEvent event) returns error?;
    remote function onUnlockUser(GenericEvent event) returns error?;
    remote function onUpdateUserCredentials(GenericEvent event) returns error?;
    remote function onDeleteUser(GenericEvent event) returns error?;
    remote function onUserGroupUpdate(UserGroupUpdateEvent event) returns error?;
};

public type LoginsService service object {
    remote function onLoginSuccess(LoginSuccessEvent event) returns error?;
};

public type GenericServiceType RegistrationsService|UserOperationsService|LoginsService;
