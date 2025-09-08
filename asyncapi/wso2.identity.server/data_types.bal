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

public type ListenerConfig record {
    string webhookSecret;
};

public type GenericUserOperationEvent record {
    GenericUserOperationData eventData;
    GenericSecurityData securityData;
};

public type GenericUserOperationData record {
    string initiatorType?;
    GenericUserData user;
    GenericTenantData tenant;
    GenericOrganizationData organization;
    GenericUserStoreData userStore;
    string action?;
};

public type GenericUserData record {
    string id;
    GenericClaimData[] claims;
    GenericOrganizationData organization;
    string ref;
};

public type GenericTenantData record {
    string id;
    string name;
};

public type GenericOrganizationData record {
    string id;
    string name;
    string orgHandle;
    int depth;
};

public type GenericUserStoreData record {
    string id;
    string name;
};

public type GenericClaimData record {
    string uri;
    string value;
};

public type GenericSecurityData record {
    string iss;
    string jti;
    int iat;
    string rci;
};

public type GenericPayloadType record {
    string iss;
    string jti;
    int iat;
    string rci;
    json events;
};

public type GenericDataType GenericUserOperationEvent;
