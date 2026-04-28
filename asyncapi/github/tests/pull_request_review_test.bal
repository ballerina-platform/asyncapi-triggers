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

json baseReview = {
    "id": 1122334455,
    "node_id": "PRR_kwDOFfuAD85JKO6z",
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
    "body": "Looks good overall, a few minor comments.",
    "state": "approved",
    "html_url": "https://github.com/ABCUser/samplestest/pull/42#pullrequestreview-1122334455",
    "pull_request_url": "https://api.github.com/repos/ABCUser/samplestest/pulls/42",
    "submitted_at": "2026-04-22T11:00:00Z",
    "commit_id": "abc123def456abc123def456abc123def456abc1",
    "author_association": "CONTRIBUTOR"
};

json reviewPullRequest = {
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

function sendPullRequestReviewWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "pull_request_review");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnPullRequestReviewSubmitted() {
    json eventPayload = {
        "action": "submitted",
        "review": baseReview,
        "pull_request": reviewPullRequest,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review submitted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewSubmittedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewSubmittedNotified, msg = "expected a PR review submitted notification");
    test:assertEquals(prReviewState, "approved", msg = "expected review state to be approved");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReviewSubmitted],
    enable: true
}
function testWebhookNotificationOnPullRequestReviewEdited() {
    json updatedReview = {
        "id": 1122334455,
        "node_id": "PRR_kwDOFfuAD85JKO6z",
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
        "body": "Updated review body with more detailed comments.",
        "state": "changes_requested",
        "html_url": "https://github.com/ABCUser/samplestest/pull/42#pullrequestreview-1122334455",
        "pull_request_url": "https://api.github.com/repos/ABCUser/samplestest/pulls/42",
        "submitted_at": "2026-04-22T11:00:00Z",
        "commit_id": "abc123def456abc123def456abc123def456abc1",
        "author_association": "CONTRIBUTOR"
    };
    json eventPayload = {
        "action": "edited",
        "review": updatedReview,
        "pull_request": reviewPullRequest,
        "changes": {
            "body": {
                "from": "Looks good overall, a few minor comments."
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewEditedNotified, msg = "expected a PR review edited notification");
    test:assertTrue(prReviewChanges != (), msg = "expected review changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPullRequestReviewEdited],
    enable: true
}
function testWebhookNotificationOnPullRequestReviewDismissed() {
    json dismissedReview = {
        "id": 1122334455,
        "node_id": "PRR_kwDOFfuAD85JKO6z",
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
        "body": "",
        "state": "dismissed",
        "html_url": "https://github.com/ABCUser/samplestest/pull/42#pullrequestreview-1122334455",
        "pull_request_url": "https://api.github.com/repos/ABCUser/samplestest/pulls/42",
        "submitted_at": "2026-04-22T11:00:00Z",
        "commit_id": "abc123def456abc123def456abc123def456abc1",
        "author_association": "CONTRIBUTOR"
    };
    json eventPayload = {
        "action": "dismissed",
        "review": dismissedReview,
        "pull_request": reviewPullRequest,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPullRequestReviewWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "PR review dismissed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!prReviewDismissedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(prReviewDismissedNotified, msg = "expected a PR review dismissed notification");
}
