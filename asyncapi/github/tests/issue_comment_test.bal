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

json baseComment = {
    "id": 1098765432,
    "node_id": "IC_kwDOFfuAD85JKO6z",
    "url": "https://api.github.com/repos/ABCUser/samplestest/issues/comments/1098765432",
    "html_url": "https://github.com/ABCUser/samplestest/issues/22#issuecomment-1098765432",
    "body": "This is a test comment",
    "user": {
        "login": "ABCUser",
        "id": 3378323,
        "node_id": "MDQ6VXNlcjMzNzgzMjM=",
        "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/ABCUser",
        "html_url": "https://github.com/ABCUser",
        "type": "User",
        "site_admin": false
    },
    "created_at": "2022-05-06T06:00:00Z",
    "updated_at": "2022-05-06T06:00:00Z",
    "author_association": "OWNER"
};

json commentIssue = {
    "id": 1227419315,
    "node_id": "I_kwDOFfuAD85JKO6z",
    "number": 22,
    "title": "UserTestIssue",
    "user": {
        "login": "ABCUser",
        "id": 3378323,
        "node_id": "MDQ6VXNlcjMzNzgzMjM=",
        "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/ABCUser",
        "html_url": "https://github.com/ABCUser",
        "type": "User",
        "site_admin": false
    },
    "labels": [],
    "state": "open",
    "locked": false,
    "assignee": null,
    "assignees": [],
    "milestone": null,
    "comments": 1,
    "created_at": "2022-05-06T04:56:16Z",
    "updated_at": "2022-05-06T06:00:00Z",
    "closed_at": null,
    "author_association": "OWNER",
    "active_lock_reason": null,
    "body": "Test issue body"
};

function sendIssueCommentWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "issue_comment");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnIssueCommentCreation() {
    json eventPayload = {
        "action": "created",
        "issue": commentIssue,
        "comment": baseComment,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssueCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue comment created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCommentCreatedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCommentCreatedNotified, msg = "expected an issue comment created notification");
    test:assertEquals(issueCommentBody, "This is a test comment", msg = "expected comment body to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueCommentCreation],
    enable: true
}
function testWebhookNotificationOnIssueCommentEdited() {
    json updatedComment = {
        "id": 1098765432,
        "node_id": "IC_kwDOFfuAD85JKO6z",
        "url": "https://api.github.com/repos/ABCUser/samplestest/issues/comments/1098765432",
        "html_url": "https://github.com/ABCUser/samplestest/issues/22#issuecomment-1098765432",
        "body": "This is an edited comment",
        "user": {
            "login": "ABCUser",
            "id": 3378323,
            "node_id": "MDQ6VXNlcjMzNzgzMjM=",
            "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/ABCUser",
            "html_url": "https://github.com/ABCUser",
            "type": "User",
            "site_admin": false
        },
        "created_at": "2022-05-06T06:00:00Z",
        "updated_at": "2022-05-06T06:05:00Z",
        "author_association": "OWNER"
    };
    json eventPayload = {
        "action": "edited",
        "issue": commentIssue,
        "comment": updatedComment,
        "changes": {
            "body": {
                "from": "This is a test comment"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssueCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue comment edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCommentEditedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCommentEditedNotified, msg = "expected an issue comment edited notification");
    test:assertTrue(issueCommentChanges != (), msg = "expected comment changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueCommentEdited],
    enable: true
}
function testWebhookNotificationOnIssueCommentDeleted() {
    json eventPayload = {
        "action": "deleted",
        "issue": commentIssue,
        "comment": baseComment,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssueCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue comment deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCommentDeletedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCommentDeletedNotified, msg = "expected an issue comment deleted notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueCommentDeleted],
    enable: true
}
function testWebhookNotificationOnIssueCommentPinned() {
    json eventPayload = {
        "action": "pinned",
        "issue": commentIssue,
        "comment": baseComment,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssueCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue comment pinned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCommentPinnedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCommentPinnedNotified, msg = "expected an issue comment pinned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueCommentPinned],
    enable: true
}
function testWebhookNotificationOnIssueCommentUnpinned() {
    json eventPayload = {
        "action": "unpinned",
        "issue": commentIssue,
        "comment": baseComment,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssueCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue comment unpinned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCommentUnpinnedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCommentUnpinnedNotified, msg = "expected an issue comment unpinned notification");
}
