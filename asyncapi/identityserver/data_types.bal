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

# Listener configuration.
#
# + webhookSecret - Webhook secret configured in IS.
@display {label: "Listener Config"}
public type ListenerConfig record {|
    @display {label: "Webhook Secret", "description": "Secret specified when adding the Identity Server webhook"}
    string webhookSecret;
|};

# Represent generic user operation event.
#
# + eventData - User operation data
# + securityData - Security data
public type GenericUserOperationEvent record {
    GenericUserOperationData eventData;
    GenericSecurityData securityData;
};

# Represent user profile update operation event.
#
# + eventData - User profile update data
# + securityData - Security data
public type UserProfileUpdateOperationEvent record {
    UserProfileUpdateData eventData;
    GenericSecurityData securityData;
};

# Represent generic user operation data.
#
# + initiatorType - Type of the initiator
# + user - User data
# + tenant - Tenant data
# + organization - Organization data
# + userStore - User store data
# + action - Action performed
public type GenericUserOperationData record {
    string initiatorType?;
    GenericUserData user;
    GenericTenantData tenant;
    GenericOrganizationData organization;
    GenericUserStoreData userStore;
    string action?;
};

# Represent user profile update data.
#
# + initiatorType - Type of the initiator
# + user - User profile update data
# + tenant - Tenant data
# + organization - Organization data
# + userStore - User store data
# + action - Action performed
public type UserProfileUpdateData record {
    string initiatorType?;
    UserProfileUpdateUserData user;
    GenericTenantData tenant;
    GenericOrganizationData organization;
    GenericUserStoreData userStore;
    string action?;
};

# Represent generic user data.
#
# + id - User ID
# + claims - User claims
# + organization - User organization
# + ref - User reference
public type GenericUserData record {
    string id;
    GenericClaimData[] claims;
    GenericOrganizationData organization;
    string ref;
};

# Represent user profile update data.
#
# + id - User ID
# + organization - User organization
# + ref - User reference
# + addedClaims - Claims added in the user profile update
# + updatedClaims - Claims updated in the user profile update
# + removedClaims - Claims removed in the user profile update
public type UserProfileUpdateUserData record {
    string id;
    GenericOrganizationData organization;
    string ref;
    GenericClaimData[] addedClaims?;
    GenericClaimData[] updatedClaims?;
    GenericClaimData[] removedClaims?;
};

# Represent generic tenant data.
#
# + id - Tenant ID
# + name - Tenant name
public type GenericTenantData record {
    string id;
    string name;
};

# Represent generic organization data.
#
# + id - Organization ID
# + name - Organization name
# + orgHandle - Organization handle
# + depth - Organization depth
public type GenericOrganizationData record {
    string id;
    string name;
    string orgHandle;
    int depth;
};

# Represent generic user store data.
#
# + id - User store ID
# + name - User store name
public type GenericUserStoreData record {
    string id;
    string name;
};

# Represent generic claim data.
#
# + uri - Claim URI
# + value - Claim value
public type GenericClaimData record {
    string uri;
    string value;
};

# Represent generic security data.
#
# + iss - Issuer
# + jti - JWT ID
# + iat - Issued at
# + rci - RCI value
public type GenericSecurityData record {
    string iss;
    string jti;
    int iat;
    string rci;
};

# Represent generic payload data.
#
# + iss - Issuer
# + jti - JWT ID
# + iat - Issued at
# + rci - RCI value
# + events - Event data
public type GenericPayloadType record {
    string iss;
    string jti;
    int iat;
    string rci;
    json events;
};

# Represent generic data type.
public type GenericDataType GenericUserOperationEvent|UserProfileUpdateOperationEvent;
