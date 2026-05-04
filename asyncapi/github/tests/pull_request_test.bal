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

json basePullRequest = {
    "id": 987654321,
    "node_id": "PR_kwDOFfuAD85JKO6z",
    "number": 42,
    "title": "Test pull request",
    "state": "open",
    "locked": false,
    "draft": false,
    "merged": false,
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
    "body": "This is a test PR body",
    "labels": [],
    "assignees": [],
    "head": {
        "label": "ABCUser:feature-branch",
        "ref": "feature-branch",
        "sha": "abc123def456"
    },
    "base": {
        "label": "ABCUser:main",
        "ref": "main",
        "sha": "def456abc123"
    },
    "created_at": "2026-04-22T10:00:00Z",
    "updated_at": "2026-04-22T10:00:00Z",
    "closed_at": null,
    "merged_at": null,
    "author_association": "OWNER"
};

function sendPullRequestWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "pull_request");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnPullRequestOpened() {
    json eventPayload = {
        "action": "opened",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR opened webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prOpenedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prOpenedNotified, msg = "expected a PR opened notification");
    test:assertEquals(prTitle, "Test pull request", msg = "expected PR title to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestOpened],
    enable: true
}
function testWebhookNotificationOnPullRequestClosed() {
    json closedPR = {
        "id": 987654321,
        "node_id": "PR_kwDOFfuAD85JKO6z",
        "number": 42,
        "title": "Test pull request",
        "state": "closed",
        "locked": false,
        "draft": false,
        "merged": true,
        "user": senderField,
        "body": "This is a test PR body",
        "labels": [],
        "assignees": [],
        "head": {"label": "ABCUser:feature-branch", "ref": "feature-branch", "sha": "abc123def456"},
        "base": {"label": "ABCUser:main", "ref": "main", "sha": "def456abc123"},
        "created_at": "2026-04-22T10:00:00Z",
        "updated_at": "2026-04-22T11:00:00Z",
        "closed_at": "2026-04-22T11:00:00Z",
        "merged_at": "2026-04-22T11:00:00Z",
        "author_association": "OWNER"
    };
    json eventPayload = {
        "action": "closed",
        "number": 42,
        "pull_request": closedPR,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR closed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prClosedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prClosedNotified, msg = "expected a PR closed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestClosed],
    enable: true
}
function testWebhookNotificationOnPullRequestReopened() {
    json eventPayload = {
        "action": "reopened",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR reopened webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReopenedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReopenedNotified, msg = "expected a PR reopened notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReopened],
    enable: true
}
function testWebhookNotificationOnPullRequestEdited() {
    json eventPayload = {
        "action": "edited",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "changes": {
            "title": {
                "from": "Old PR title"
            },
            "body": {
                "from": "Old PR body"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prEditedNotified, msg = "expected a PR edited notification");
    test:assertTrue(prChanges != (), msg = "expected PR changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestEdited],
    enable: true
}
function testWebhookNotificationOnPullRequestLabeled() {
    json eventPayload = {
        "action": "labeled",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "label": {
            "id": 123456,
            "node_id": "LA_kwDOFfuAD87654321",
            "name": "bug",
            "color": "d73a4a",
            "description": "Something isn't working"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR labeled webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prLabeledNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prLabeledNotified, msg = "expected a PR labeled notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestLabeled],
    enable: true
}
function testWebhookNotificationOnPullRequestUnlabeled() {
    json eventPayload = {
        "action": "unlabeled",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "label": {
            "id": 123456,
            "node_id": "LA_kwDOFfuAD87654321",
            "name": "bug",
            "color": "d73a4a",
            "description": "Something isn't working"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR unlabeled webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prUnlabeledNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prUnlabeledNotified, msg = "expected a PR unlabeled notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestUnlabeled],
    enable: true
}
function testWebhookNotificationOnPullRequestAssigned() {
    json eventPayload = {
        "action": "assigned",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR assigned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prAssignedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prAssignedNotified, msg = "expected a PR assigned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestAssigned],
    enable: true
}
function testWebhookNotificationOnPullRequestUnassigned() {
    json eventPayload = {
        "action": "unassigned",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR unassigned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prUnassignedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prUnassignedNotified, msg = "expected a PR unassigned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestUnassigned],
    enable: true
}
function testWebhookNotificationOnPullRequestSynchronize() {
    json eventPayload = {
        "action": "synchronize",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR synchronize webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prSynchronizeNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prSynchronizeNotified, msg = "expected a PR synchronize notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestSynchronize],
    enable: true
}
function testWebhookNotificationOnPullRequestReadyForReview() {
    json readyPR = {
        "id": 987654321,
        "node_id": "PR_kwDOFfuAD85JKO6z",
        "number": 42,
        "title": "Test pull request",
        "state": "open",
        "locked": false,
        "draft": false,
        "merged": false,
        "user": senderField,
        "body": "This is a test PR body",
        "labels": [],
        "assignees": [],
        "head": {"label": "ABCUser:feature-branch", "ref": "feature-branch", "sha": "abc123def456"},
        "base": {"label": "ABCUser:main", "ref": "main", "sha": "def456abc123"},
        "created_at": "2026-04-22T10:00:00Z",
        "updated_at": "2026-04-22T10:30:00Z",
        "closed_at": null,
        "merged_at": null,
        "author_association": "OWNER"
    };
    json eventPayload = {
        "action": "ready_for_review",
        "number": 42,
        "pull_request": readyPR,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR ready_for_review webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReadyForReviewNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReadyForReviewNotified, msg = "expected a PR ready_for_review notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReadyForReview],
    enable: true
}
function testWebhookNotificationOnPullRequestConvertedToDraft() {
    json draftPR = {
        "id": 987654321,
        "node_id": "PR_kwDOFfuAD85JKO6z",
        "number": 42,
        "title": "Test pull request",
        "state": "open",
        "locked": false,
        "draft": true,
        "merged": false,
        "user": senderField,
        "body": "This is a test PR body",
        "labels": [],
        "assignees": [],
        "head": {"label": "ABCUser:feature-branch", "ref": "feature-branch", "sha": "abc123def456"},
        "base": {"label": "ABCUser:main", "ref": "main", "sha": "def456abc123"},
        "created_at": "2026-04-22T10:00:00Z",
        "updated_at": "2026-04-22T10:45:00Z",
        "closed_at": null,
        "merged_at": null,
        "author_association": "OWNER"
    };
    json eventPayload = {
        "action": "converted_to_draft",
        "number": 42,
        "pull_request": draftPR,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR converted_to_draft webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prConvertedToDraftNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prConvertedToDraftNotified, msg = "expected a PR converted_to_draft notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestConvertedToDraft],
    enable: true
}
function testWebhookNotificationOnPullRequestReviewRequested() {
    json eventPayload = {
        "action": "review_requested",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "requested_reviewer": {
            "login": "ReviewerUser",
            "id": 9876543,
            "node_id": "MDQ6VXNlcjk4NzY1NDM=",
            "avatar_url": "https://avatars.githubusercontent.com/u/9876543?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/ReviewerUser",
            "html_url": "https://github.com/ReviewerUser",
            "type": "User",
            "site_admin": false
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review_requested webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewRequestedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewRequestedNotified, msg = "expected a PR review_requested notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReviewRequested],
    enable: true
}
function testWebhookNotificationOnPullRequestLocked() {
    json lockedPR = {
        "id": 987654321,
        "node_id": "PR_kwDOFfuAD85JKO6z",
        "number": 42,
        "title": "Test pull request",
        "state": "open",
        "locked": true,
        "draft": false,
        "merged": false,
        "user": senderField,
        "body": "This is a test PR body",
        "labels": [],
        "assignees": [],
        "head": {"label": "ABCUser:feature-branch", "ref": "feature-branch", "sha": "abc123def456"},
        "base": {"label": "ABCUser:main", "ref": "main", "sha": "def456abc123"},
        "created_at": "2026-04-22T10:00:00Z",
        "updated_at": "2026-04-22T11:30:00Z",
        "closed_at": null,
        "merged_at": null,
        "author_association": "OWNER"
    };
    json eventPayload = {
        "action": "locked",
        "number": 42,
        "pull_request": lockedPR,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR locked webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prLockedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prLockedNotified, msg = "expected a PR locked notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestLocked],
    enable: true
}
function testWebhookNotificationOnPullRequestUnlocked() {
    json eventPayload = {
        "action": "unlocked",
        "number": 42,
        "pull_request": basePullRequest,
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR unlocked webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prUnlockedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prUnlockedNotified, msg = "expected a PR unlocked notification");
}
