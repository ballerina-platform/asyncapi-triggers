// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/io;
import ballerina/lang.runtime;
import ballerina/log;
import ballerina/os;
import ballerina/test;
import ballerinax/sfdc;

configurable string & readonly username = os:getEnv("SF_USERNAME");
configurable string & readonly password = os:getEnv("SF_PASSWORD");

ListenerConfig listenerConfig = {
    username: username,
    password: password,
    channelName: "/data/ChangeEvents"
};
listener Listener eventListener = new (listenerConfig);
isolated boolean isUpdated = false;

service StreamingEventService on eventListener {
    remote isolated function onUpdate(EventData payload) {
        json accountName = payload.changedData.get("Name");
        if (accountName.toString() == "WSO2 Inc") {
            lock {
                isUpdated = true;
            }
            io:println(payload.toString());
        } else {
            io:println(payload.toString());
        }
    }

    remote function onCreate(EventData payload) {

    }
        
    remote function onDelete(EventData payload) {

    }

    remote function onRestore(EventData payload) {

    }
}

// Create Salesforce client configuration by reading from environemnt.
configurable string & readonly clientId = os:getEnv("CLIENT_ID");
configurable string & readonly clientSecret = os:getEnv("CLIENT_SECRET");
configurable string & readonly refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string & readonly refreshUrl = os:getEnv("REFRESH_URL");
configurable string & readonly baseUrl = os:getEnv("EP_URL");

// Using direct-token config for client configuration
sfdc:ConnectionConfig sfConfig = {
    baseUrl: baseUrl,
    clientConfig: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl
    }
};

sfdc:Client baseClient = check new (sfConfig);
string testRecordId = "";

@test:Config { 
    enable: true
}
function testCreateRecord() {
    log:printInfo("baseClient -> createRecord()");
    json accountRecord = {
        Name: "John Keells Holdings",
        BillingCity: "Colombo 3"
    };
    string|error stringResponse = baseClient->createRecord("Account", accountRecord);

    if (stringResponse is string) {
        test:assertNotEquals(stringResponse, "", msg = "Found empty response!");
        testRecordId = <@untainted>stringResponse;
    } else {
        test:assertFail(msg = stringResponse.message());
    }
}

@test:Config {
    enable: true,
    dependsOn: [testCreateRecord]
}
function testUpdateRecord() {
    log:printInfo("baseClient -> updateRecord()");
    json account = {
        Name: "WSO2 Inc",
        BillingCity: "Jaffna",
        Phone: "+94110000000"
    };
    error? response = baseClient->updateRecord("Account", testRecordId, account);

    if (response is error) {
        test:assertFail(msg = response.message());
    } 
}

@test:Config {
    enable: true,
    dependsOn: [testUpdateRecord]
}
function testUpdatedEventTrigger() {
    runtime:sleep(5.0);
    lock {
        test:assertTrue(isUpdated, "Error in retrieving account update!");

    }
}

@test:Config {
    enable: true,
    dependsOn: [testUpdatedEventTrigger]
}
function testDeleteRecord() {
    log:printInfo("baseClient -> deleteRecord()");

    error? response = baseClient->deleteRecord("Account", testRecordId);

    if (response is error) {
        test:assertFail(msg = response.message());
    } 
}
