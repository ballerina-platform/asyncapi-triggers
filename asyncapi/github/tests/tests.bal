// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/test;
import ballerina/log;
import ballerina/lang.runtime;
import ballerina/http;
import ballerina/os;

configurable string token = os:getEnv("GH_TOKEN");
configurable string userName = os:getEnv("GH_USER_NAME");
configurable string repository = os:getEnv("GH_REPOSITORY");
configurable string callbackURL = os:getEnv("CALLBACK_URL");

boolean labelCreatedNotified = false;
string createdabelName = "";

ListenerConfig config = {
    topic: string `https://github.com/${userName}/${repository}/events/*.json`,
    callbackURL,
    token
};

listener Listener githubListener = new (config);

service LabelService on githubListener {

    remote function onCreated(LabelEvent payload) returns error? {
        log:printInfo("Label created");
        labelCreatedNotified = true;
        createdabelName = payload.label.name;
    }

    remote function onEdited(LabelEvent payload) returns error? {
        return;
    }

    remote function onDeleted(LabelEvent payload) returns error? {
        log:printInfo("Label Deleted");
    }
}

http:ClientConfiguration githubConfig = {
    auth: {
        token
    }
};

http:Client githubClient = check new (GITHUB_REST_API_BASE_URL, githubConfig);
string labelName = "bugTest";

@test:Config {
    enable: false
}
function testWebhookNotificationOnIssueCreation() returns error? {
    string labelName = "bugTest";
    json label = {"name": labelName, "description": "Something isn't working", "color": "f29513"};

    http:Response _ = check githubClient->post(string `/repos/${userName}/${repository}/labels`, label);
    int counter = 10;
    while (!labelCreatedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(labelCreatedNotified, msg = "Expected an label creation notification");
    test:assertEquals(labelName, createdabelName, msg = "invalid issue title");
}

@test:AfterSuite {}
function closeIssue() returns error? {
    http:Response _ = check githubClient->delete(string `/repos/${userName}/${repository}/labels/${labelName}`);
}
