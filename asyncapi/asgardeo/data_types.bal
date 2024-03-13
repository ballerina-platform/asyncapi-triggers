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

# Listener related configurations
#
# + clientId - Client Id of user app  
# + clientSecret - Client Secret of user app 
# + organization - Organization of the user  
# + tokenEndpointHost - Token Endpoint   
# + callbackURL - Callback URL 
# + hubURL - Hub URL  
# + keyServiceURL - Crypto-key-service URL
public type ListenerConfig record {
    string clientId;
    string clientSecret;
    string organization;
    string tokenEndpointHost;
    string callbackURL;
    string hubURL;
    string keyServiceURL;
};

# Generic User Data
#
# + organizationId - Organization Id  
# + ref - Reference
# + organizationName - Organization Name  
# + userStoreName - Name of the User Store
# + userName - User Name
# + userId - User Id
# + claims - Claims
public type GenericUserData record {
    int organizationId?;
    string ref?;
    string organizationName?;
    string userStoreName?;
    string userName?;
    string userId?;
    map<string> claims?;
};

# Update User Credentials Data
#
# + organizationId - Organization Id  
# + ref - Reference
# + organizationName - Organization Name  
# + userStoreName - Name of the User Store
# + userName - User Name
# + userId - User Id
# + credentialUpdateMethod - Credential Updated Method
# + credentialUpdateChannel - Credential Updated Channel
# + claims - Claims
public type UpdateUserCredentialsData record {
    int organizationId;
    string ref;
    string organizationName;
    string userStoreName;
    string userName;
    string userId;
    string credentialUpdateMethod;
    string credentialUpdateChannel;
    map<string> claims;
};

# Generic Security Data
#
# + aud - Audience of the event.  
# + iss - Name of the issuer.  
# + iat - Issued timestamp of the event.  
# + jti - Event id.
public type GenericSecurityData record {
    string aud?;
    string iss?;
    int iat?;
    string jti?;
};

# Generic Event type
#
# + eventData - Event data  
# + securityData - Event related security data
public type GenericEvent record {
    GenericUserData eventData?;
    GenericSecurityData securityData?;
};

# Credential Update Event
#
# + eventData - Event data  
# + securityData - Event related security data
public type UpdateUserCredentialsEvent record {
    UpdateUserCredentialsData eventData;
    GenericSecurityData securityData;
};

# Update Event - User and Group
#
# + eventData - Event data  
# + securityData - Event related security data
public type UserGroupUpdateEvent record {
    UserGroupUpdateData eventData?;
    GenericSecurityData securityData?;
};

# Login Success event
#
# + eventData - Event data  
# + securityData - Event related security data
public type LoginSuccessEvent record {
    LoginSuccessData eventData?;
    GenericSecurityData securityData?;
};

# Represents login-failed event.
#
# + eventData - Event data  
# + securityData - Event related security data
public type LoginFailedEvent record {
    LoginFailedData eventData;
    GenericSecurityData securityData;
 };

# Add User event data
#
# + organizationId - Organization Id  
# + ref - Reference  
# + organizationName - Organization Name  
# + userStoreName - Name of the User Store  
# + userOnboardMethod - User onboard method 
# + userName - User Name  
# + roleList - List of roles  
# + userId - User Id  
# + claims - Claims
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

# Add User event
#
# + eventData - Event data  
# + securityData - Event related security data
public type AddUserEvent record {
    AddUserData eventData?;
    GenericSecurityData securityData?;
};

# Login Success Data
#
# + organizationId - Organization Id  
# + ref - Reference  
# + organizationName - Organization Name  
# + userStoreName - Name of the User Store  
# + serviceProvider - Service provider  
# + userName - User Name  
# + userId - User Id
# + authSteps - A list of Authentication Steps
public type LoginSuccessData record {
    int organizationId?;
    string ref?;
    string organizationName?;
    string userStoreName?;
    string serviceProvider?;
    string userName?;
    string userId?;
    AuthStep[] authSteps?;
};

# Represents login-failed event data.
#
# + organizationId - Organization Id  
# + ref - Reference  
# + organizationName - Organization Name  
# + serviceProvider - Service provider  
# + authenticatingUser - User Name  
# + userId - User Id
# + failedStep -  Authentication failed step
public type LoginFailedData record {
    int organizationId;
    string ref;
    string organizationName;
    string serviceProvider;
    string? authenticatingUser?;
    string? userId?;
    AuthStep failedStep;
};

# User data
#
# + userName - User name  
# + userId - User Id
public type User record {
    string userName?;
    string userId?;
};

# Represents auth-step data.
#
# + step - Step  
# + idp - IdentityProvider
# + authenticator - Authenticator
public type AuthStep record {
    int step;
    string idp;
    string authenticator;
};

# User Group Update event data
#
# + organizationId - Organization Id  
# + ref - Reference  
# + groupName - Group name  
# + organizationName - Organization Name  
# + groupId - Group Id  
# + userStoreName - Name of the User Store  
# + removedUsers - A list of removed users from the group.  
# + addedUsers - A list of added users to the group
public type UserGroupUpdateData record {
    int organizationId?;
    string ref?;
    string groupName?;
    string organizationName?;
    string groupId?;
    string userStoreName?;
    User[] removedUsers?;
    User[] addedUsers?;
};

# SMS OTP Notification
#
# + organizationId - Organization Id  
# + organizationName - Organization Name  
# + sendTo - Send To
# + messageBody - Message Body
public type SmsOtpNotificationData record {
    int organizationId?;
    string organizationName?;
    string sendTo?;
    string messageBody?;
};

# SMS OTP Notification Event
#
# + eventData - Event Data 
# + securityData - Security Data
public type SmsOtpNotificationEvent record {
    SmsOtpNotificationData eventData?;
    GenericSecurityData securityData?;
};

# Generic Data Type
public type GenericDataType GenericEvent|UpdateUserCredentialsEvent|UserGroupUpdateEvent|LoginSuccessEvent|AddUserEvent|SmsOtpNotificationEvent|LoginFailedEvent;

# Key format
#
# + key - Secret key  
# + type - Type of key (encryptionKey/decryptionKey)
# + status - Status of the key (active/expired/revoked)  
# + createdAt - Timestamp of creation  
# + expiry - Timestamp of expiration  
# + algo - Key algorithm (RSA/DSA/DiffieHellman)
# + size - Key size (1024, 2048)
# + reason - Reason if revoked
type KeyData record {|
    string key;
    string 'type;
    string status;
    string createdAt;
    string expiry;
    string algo;
    string size;
    string reason?;
|};

type AsgardeoPayload record {
    *GenericSecurityData;
    EventDetail event;
};

type DecryptedAsgardeoPayload record {
    *GenericSecurityData;
    json event;
};

# Event Detail
#
# + payload - Payload encrypted using symmetric key  
# + payloadCryptoKey - Symettric key encrypted using Asymmetric key  
# + ivParameterSpec - IV parameter
type EventDetail record {
    string payload;
    string payloadCryptoKey;
    string ivParameterSpec;
};
