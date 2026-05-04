// Copyright (c) 2026, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.runtime;
import ballerina/http;
import ballerina/crypto;

json baseLabel = {
    "id": 112233445,
    "node_id": "LA_kwDOFfuAD87654321",
    "url": "https://api.github.com/repos/ABCUser/samplestest/labels/bug",
    "name": "bug",
    "color": "d73a4a",
    "default": true,
    "description": "Something isn't working"
};

function sendLabelWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "label");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnLabelCreated() {
    json eventPayload = {
        "action": "created",
        "label": baseLabel,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendLabelWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Label created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!labelCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(labelCreatedNotified, msg = "expected a label created notification");
    test:assertEquals(labelCreatedName, "bug", msg = "expected label name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnLabelCreated],
    enable: true
}
function testWebhookNotificationOnLabelEdited() {
    json editedLabel = {
        "id": 112233445,
        "node_id": "LA_kwDOFfuAD87654321",
        "url": "https://api.github.com/repos/ABCUser/samplestest/labels/bug",
        "name": "bug",
        "color": "ee0701",
        "default": true,
        "description": "Something isn't working — updated description"
    };
    json eventPayload = {
        "action": "edited",
        "label": editedLabel,
        "changes": {
            "color": {
                "from": "d73a4a"
            },
            "description": {
                "from": "Something isn't working"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendLabelWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Label edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!labelEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(labelEditedNotified, msg = "expected a label edited notification");
    test:assertTrue(labelChanges != (), msg = "expected label changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnLabelEdited],
    enable: true
}
function testWebhookNotificationOnLabelDeleted() {
    json eventPayload = {
        "action": "deleted",
        "label": baseLabel,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendLabelWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Label deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!labelDeletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(labelDeletedNotified, msg = "expected a label deleted notification");
}
