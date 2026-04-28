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

json baseMilestone = {
    "id": 66778899,
    "node_id": "MI_kwDOFfuAD85JKO6z",
    "number": 1,
    "title": "v1.0 Release",
    "description": "All issues to be resolved before the v1.0 release.",
    "state": "open",
    "open_issues": 5,
    "closed_issues": 2,
    "created_at": "2026-04-01T00:00:00Z",
    "updated_at": "2026-04-22T10:00:00Z",
    "due_on": "2026-05-01T07:00:00Z",
    "closed_at": null,
    "creator": {
        "login": "ABCUser",
        "id": 3378323,
        "node_id": "MDQ6VXNlcjMzNzgzMjM=",
        "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/ABCUser",
        "html_url": "https://github.com/ABCUser",
        "type": "User",
        "site_admin": false
    }
};

function sendMilestoneWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "milestone");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnMilestoneCreated() {
    json eventPayload = {
        "action": "created",
        "milestone": baseMilestone,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendMilestoneWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Milestone created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!milestoneCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(milestoneCreatedNotified, msg = "expected a milestone created notification");
    test:assertEquals(milestoneTitle, "v1.0 Release", msg = "expected milestone title to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnMilestoneCreated],
    enable: true
}
function testWebhookNotificationOnMilestoneEdited() {
    json editedMilestone = {
        "id": 66778899,
        "node_id": "MI_kwDOFfuAD85JKO6z",
        "number": 1,
        "title": "v1.0 Release — updated",
        "description": "Updated scope for v1.0 release.",
        "state": "open",
        "open_issues": 5,
        "closed_issues": 2,
        "created_at": "2026-04-01T00:00:00Z",
        "updated_at": "2026-04-22T11:00:00Z",
        "due_on": "2026-05-15T07:00:00Z",
        "closed_at": null,
        "creator": senderField
    };
    json eventPayload = {
        "action": "edited",
        "milestone": editedMilestone,
        "changes": {
            "title": {
                "from": "v1.0 Release"
            },
            "due_on": {
                "from": "2026-05-01T07:00:00Z"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendMilestoneWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Milestone edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!milestoneEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(milestoneEditedNotified, msg = "expected a milestone edited notification");
    test:assertTrue(milestoneChanges != (), msg = "expected milestone changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnMilestoneEdited],
    enable: true
}
function testWebhookNotificationOnMilestoneOpened() {
    json reopenedMilestone = {
        "id": 66778899,
        "node_id": "MI_kwDOFfuAD85JKO6z",
        "number": 1,
        "title": "v1.0 Release",
        "description": "All issues to be resolved before the v1.0 release.",
        "state": "open",
        "open_issues": 5,
        "closed_issues": 2,
        "created_at": "2026-04-01T00:00:00Z",
        "updated_at": "2026-04-22T12:00:00Z",
        "due_on": "2026-05-01T07:00:00Z",
        "closed_at": null,
        "creator": senderField
    };
    json eventPayload = {
        "action": "opened",
        "milestone": reopenedMilestone,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendMilestoneWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Milestone opened webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!milestoneOpenedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(milestoneOpenedNotified, msg = "expected a milestone opened notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnMilestoneOpened],
    enable: true
}
function testWebhookNotificationOnMilestoneClosed() {
    json closedMilestone = {
        "id": 66778899,
        "node_id": "MI_kwDOFfuAD85JKO6z",
        "number": 1,
        "title": "v1.0 Release",
        "description": "All issues to be resolved before the v1.0 release.",
        "state": "closed",
        "open_issues": 0,
        "closed_issues": 7,
        "created_at": "2026-04-01T00:00:00Z",
        "updated_at": "2026-04-22T13:00:00Z",
        "due_on": "2026-05-01T07:00:00Z",
        "closed_at": "2026-04-22T13:00:00Z",
        "creator": senderField
    };
    json eventPayload = {
        "action": "closed",
        "milestone": closedMilestone,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendMilestoneWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Milestone closed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!milestoneClosedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(milestoneClosedNotified, msg = "expected a milestone closed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnMilestoneClosed],
    enable: true
}
function testWebhookNotificationOnMilestoneDeleted() {
    json eventPayload = {
        "action": "deleted",
        "milestone": baseMilestone,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendMilestoneWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Milestone deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!milestoneDeletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(milestoneDeletedNotified, msg = "expected a milestone deleted notification");
}
