// Listener related configurations should be included here
public type ListenerConfig record {
    string clientId;
    string clientSecret;
    string hubSecret;
    string organization;
    string tokenEndpointHost;
    string callbackURL;
    string hubURL;
};

public type GenericUserData record {
    int organizationId?;
    string ref?;
    string organizationName?;
    string userStoreName?;
    string userName?;
    string userId?;
};

public type GenericSecurityData record {
    # Audience of the event.
    string aud?;
    # Name of the issuer.
    string iss?;
    # Issued timestamp of the event.
    int iat?;
    # Event id.
    string jti?;
};

public type GenericEvent record {
    GenericUserData eventData?;
    GenericSecurityData securityData?;
};

public type UserGroupUpdateEvent record {
    UserGroupUpdateData eventData?;
    GenericSecurityData securityData?;
};

public type LoginSuccessEvent record {
    LoginSuccessData eventData?;
    GenericSecurityData securityData?;
};

public type AddUserData record {
    int organizationId?;
    string ref?;
    string organizationName?;
    string userStoreName?;
    string userOnboardMethod?;
    string userName?;
    string[] roleList?;
    string userId?;
    map<string> claims?;
};

public type AddUserEvent record {
    AddUserData eventData?;
    GenericSecurityData securityData?;
};

public type LoginSuccessData record {
    int organizationId?;
    string ref?;
    string organizationName?;
    string userStoreName?;
    string serviceProvider?;
    string userName?;
    string userId?;
};

public type User record {
    string userName?;
    string userId?;
};

public type UserGroupUpdateData record {
    int organizationId?;
    string ref?;
    string groupName?;
    string organizationName?;
    string groupId?;
    string userStoreName?;
    # A list of removed users from the group.
    User[] removedUsers?;
    # A list of added users to the group.
    User[] addedUsers?;
};

public type GenericDataType GenericEvent|UserGroupUpdateEvent|LoginSuccessEvent|AddUserEvent;
