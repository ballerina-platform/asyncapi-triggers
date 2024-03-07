public type RegistrationService service object {
    remote function onAddUser(AddUserEvent event) returns error?;
    remote function onConfirmSelfSignup(GenericEvent event) returns error?;
    remote function onAcceptUserInvite(GenericEvent event) returns error?;
};

public type UserOperationService service object {
    remote function onLockUser(GenericEvent event) returns error?;
    remote function onUnlockUser(GenericEvent event) returns error?;
    remote function onUpdateUserCredentials(UpdateUserCredentialsEvent event) returns error?;
    remote function onDeleteUser(GenericEvent event) returns error?;
    remote function onUpdateUserGroup(UserGroupUpdateEvent event) returns error?;
};

# Triggers when a new event related to login is received.
# Available actions: onLoginSuccess and onLoginFailed
public type LoginService service object {
    remote function onLoginSuccess(LoginSuccessEvent event) returns error?;
    remote function onLoginFailed(LoginFailedEvent event) returns error?;
};

public type NotificationService service object {
    remote function onSmsOtp(SmsOtpNotificationEvent event) returns error?;
};

public type GenericServiceType RegistrationService|UserOperationService|LoginService|NotificationService;
