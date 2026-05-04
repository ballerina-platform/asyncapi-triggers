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

json baseReviewComment = {
    "id": 998877665,
    "node_id": "PRRC_kwDOFfuAD85JKO6z",
    "pull_request_review_id": 1122334455,
    "url": "https://api.github.com/repos/ABCUser/samplestest/pulls/comments/998877665",
    "html_url": "https://github.com/ABCUser/samplestest/pull/42#discussion_r998877665",
    "body": "This line could be simplified.",
    "diff_hunk": "@@ -10,6 +10,7 @@ function foo() {",
    "path": "src/main.bal",
    "position": 5,
    "original_position": 5,
    "commit_id": "abc123def456abc123def456abc123def456abc1",
    "original_commit_id": "abc123def456abc123def456abc123def456abc1",
    "user": {
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
    "created_at": "2026-04-22T11:00:00Z",
    "updated_at": "2026-04-22T11:00:00Z",
    "author_association": "CONTRIBUTOR",
    "side": "RIGHT"
};

json reviewCommentPullRequest = {
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
    "head": {"label": "ABCUser:feature-branch", "ref": "feature-branch", "sha": "abc123def456"},
    "base": {"label": "ABCUser:main", "ref": "main", "sha": "def456abc123"},
    "created_at": "2026-04-22T10:00:00Z",
    "updated_at": "2026-04-22T11:00:00Z",
    "closed_at": null,
    "merged_at": null,
    "author_association": "OWNER"
};

function sendPullRequestReviewCommentWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "pull_request_review_comment");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnPullRequestReviewCommentCreated() {
    json eventPayload = {
        "action": "created",
        "comment": baseReviewComment,
        "pull_request": reviewCommentPullRequest,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review comment created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewCommentCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewCommentCreatedNotified, msg = "expected a PR review comment created notification");
    test:assertEquals(prReviewCommentBody, "This line could be simplified.",
            msg = "expected review comment body to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReviewCommentCreated],
    enable: true
}
function testWebhookNotificationOnPullRequestReviewCommentEdited() {
    json editedComment = {
        "id": 998877665,
        "node_id": "PRRC_kwDOFfuAD85JKO6z",
        "pull_request_review_id": 1122334455,
        "url": "https://api.github.com/repos/ABCUser/samplestest/pulls/comments/998877665",
        "html_url": "https://github.com/ABCUser/samplestest/pull/42#discussion_r998877665",
        "body": "This line could be simplified — consider using a helper function.",
        "diff_hunk": "@@ -10,6 +10,7 @@ function foo() {",
        "path": "src/main.bal",
        "position": 5,
        "original_position": 5,
        "commit_id": "abc123def456abc123def456abc123def456abc1",
        "original_commit_id": "abc123def456abc123def456abc123def456abc1",
        "user": {
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
        "created_at": "2026-04-22T11:00:00Z",
        "updated_at": "2026-04-22T11:30:00Z",
        "author_association": "CONTRIBUTOR",
        "side": "RIGHT"
    };
    json eventPayload = {
        "action": "edited",
        "comment": editedComment,
        "pull_request": reviewCommentPullRequest,
        "changes": {
            "body": {
                "from": "This line could be simplified."
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review comment edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewCommentEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewCommentEditedNotified, msg = "expected a PR review comment edited notification");
    test:assertTrue(prReviewCommentChanges != (), msg = "expected review comment changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReviewCommentEdited],
    enable: true
}
function testWebhookNotificationOnPullRequestReviewCommentDeleted() {
    json eventPayload = {
        "action": "deleted",
        "comment": baseReviewComment,
        "pull_request": reviewCommentPullRequest,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewCommentWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review comment deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewCommentDeletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewCommentDeletedNotified, msg = "expected a PR review comment deleted notification");
}
