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

import ballerina/http;
import ballerina/jballerina.java;

# Fetch a DCR token calling token endpoint
#
# + tokenEndpoint - URL of token endpoint
# + clientId - Client Id
# + clientSecret - Client Secret
# + return - Token if success, error if fails
public isolated function fetchToken(string tokenEndpoint, string clientId, string clientSecret) returns string|error {
    final http:Client clientEndpoint = check new (tokenEndpoint);
    string authHeader = string `${clientId}:${clientSecret}`;
    http:Request tokenRequest = new;
    tokenRequest.setHeader("Authorization", "Basic " + authHeader.toBytes().toBase64());
    tokenRequest.setHeader("Content-Type", "application/json");
    tokenRequest.setPayload({
        "grant_type": "client_credentials"
    });
    json resp = check clientEndpoint->post("/oauth2/token", tokenRequest);
    string accessToken = check resp.access_token;
    return accessToken;
}

# Fetch decryption key calling crypto key service
#
# + keyServiceURL - Crypto key service URL 
# + token - Valid Token
# + orgHandle - Organization Handle
# + attempt - 0 for current key, 1 for previous key
# + return - KeyData if success, error if fails
public isolated function fetchDecryptionKey(string keyServiceURL, string token, string orgHandle, int attempt) returns KeyData|error {
    http:Client httpClient = check new (keyServiceURL);
    KeyData kd = check httpClient->get(string `/crypto/${orgHandle}/keys/dec/${attempt}`, {"Authorization": string `Bearer ${token}`});
    return kd;
}

isolated function decryptSymmetricKey(handle encryptedText, handle decryptionKey) returns string|error = @java:Method {
    'class: "io.crypto.Decryption",
    paramTypes: ["java.lang.String", "java.lang.String"]
} external;

isolated function decryptPayload(handle encryptedText, handle decryptionKey, handle iv) returns string|error = @java:Method {
    'class: "io.crypto.Decryption",
    paramTypes: ["java.lang.String", "java.lang.String", "java.lang.String"]
} external;

