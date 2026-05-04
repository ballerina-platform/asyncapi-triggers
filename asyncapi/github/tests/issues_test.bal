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

@test:Config {
    enable: true
}
function testWebhookNotificationOnIssueCreation() {
    json eventPayload = {
        "action": "opened",
        "issue": buildIssue({"title": "This is a test issue", "number": 14}),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue creation webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueCreationNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueCreationNotified, msg = "expected an issue creation notification");
    test:assertEquals(issueTitle, createdIssueTitle, msg = "invalid issue title");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueCreation],
    enable: true
}
function testWebhookNotificationOnIssueLabeling() {
    json bugLabel = {
        "id": 3012706683,
        "node_id": "MDU6TGFiZWwzMDEyNzA2Njgz",
        "url": "https://api.github.com/repos/ABCUser/samplestest/labels/bug",
        "name": "bug",
        "color": "d73a4a",
        "description": "Something isn't working"
    };
    json eventPayload = {
        "action": "labeled",
        "issue": buildIssue({"labels": [bugLabel], "assignee": senderField, "assignees": [senderField]}),
        "label": bugLabel,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue labeling webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueLabeledNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueLabeledNotified, msg = "expected an issue label notification");
    test:assertEquals(issueLabels, "bug", msg = "expected labeled label name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueLabeling],
    enable: true
}
function testWebhookNotificationOnIssueAssignment() {
    json eventPayload = {
        "action": "assigned",
        "issue": buildIssue({"assignee": senderField, "assignees": [senderField]}),
        "assignee": senderField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue assignment webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueAssignedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueAssignedNotified, msg = "expected an issue assigned notification");
    test:assertEquals(issueAssignee, "ABCUser", msg = "expected assignee login to match");
}

json baseIssue = {
    "url": "https://api.github.com/repos/ABCUser/samplestest/issues/22",
    "repository_url": "https://api.github.com/repos/ABCUser/samplestest",
    "labels_url": "https://api.github.com/repos/ABCUser/samplestest/issues/22/labels{/name}",
    "comments_url": "https://api.github.com/repos/ABCUser/samplestest/issues/22/comments",
    "events_url": "https://api.github.com/repos/ABCUser/samplestest/issues/22/events",
    "html_url": "https://github.com/ABCUser/samplestest/issues/22",
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
    "comments": 0,
    "created_at": "2022-05-06T04:56:16Z",
    "updated_at": "2022-05-06T04:56:16Z",
    "closed_at": null,
    "author_association": "OWNER",
    "active_lock_reason": null,
    "body": "Test issue body"
};

json senderField = {
    "login": "ABCUser",
    "id": 3378323,
    "node_id": "MDQ6VXNlcjMzNzgzMjM=",
    "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/ABCUser",
    "html_url": "https://github.com/ABCUser",
    "type": "User",
    "site_admin": false
};

json repositoryField = {
    "id": 368803855,
    "node_id": "MDEwOlJlcG9zaXRvcnkzNjg4MDM4NTU=",
    "name": "samplestest",
    "full_name": "ABCUser/samplestest",
    "private": false,
    "owner": {
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
    "html_url": "https://github.com/ABCUser/samplestest",
    "description": null,
    "fork": false,
    "url": "https://api.github.com/repos/ABCUser/samplestest",
    "created_at": "2021-05-19T08:52:12Z",
    "updated_at": "2021-05-19T08:55:58Z",
    "pushed_at": "2021-05-19T08:55:56Z",
    "git_url": "git://github.com/ABCUser/samplestest.git",
    "ssh_url": "git@github.com:ABCUser/samplestest.git",
    "clone_url": "https://github.com/ABCUser/samplestest.git",
    "homepage": null,
    "size": 0,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": null,
    "has_issues": true,
    "has_projects": true,
    "has_downloads": true,
    "has_wiki": true,
    "has_pages": false,
    "forks_count": 0,
    "mirror_url": null,
    "archived": false,
    "disabled": false,
    "open_issues_count": 8,
    "license": null,
    "allow_forking": true,
    "is_template": false,
    "topics": [],
    "visibility": "public",
    "forks": 0,
    "open_issues": 8,
    "watchers": 0,
    "default_branch": "main"
};

function buildIssue(map<json> overrides) returns json {
    map<json> issue = {
        "id": 1227419315,
        "node_id": "I_kwDOFfuAD85JKO6z",
        "number": 22,
        "title": "UserTestIssue",
        "user": senderField,
        "labels": [],
        "state": "open",
        "locked": false,
        "assignee": null,
        "assignees": [],
        "milestone": null,
        "comments": 0,
        "created_at": "2022-05-06T04:56:16Z",
        "updated_at": "2022-05-06T04:56:16Z",
        "closed_at": null,
        "author_association": "OWNER",
        "active_lock_reason": null,
        "body": "Test issue body"
    };
    foreach var [k, v] in overrides.entries() {
        issue[k] = v;
    }
    return issue;
}

function sendIssuesWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "issues");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueAssignment],
    enable: true
}
function testWebhookNotificationOnIssueClosed() {
    json closedIssue = buildIssue({"state": "closed", "closed_at": "2022-05-06T05:10:00Z"});
    json eventPayload = {
        "action": "closed",
        "issue": closedIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue closed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueClosedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueClosedNotified, msg = "expected an issue closed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueClosed],
    enable: true
}
function testWebhookNotificationOnIssueReopened() {
    json eventPayload = {
        "action": "reopened",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue reopened webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueReopenedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueReopenedNotified, msg = "expected an issue reopened notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueReopened],
    enable: true
}
function testWebhookNotificationOnIssueEdited() {
    json eventPayload = {
        "action": "edited",
        "issue": buildIssue({"title": "Updated Issue Title"}),
        "changes": {
            "title": {
                "from": "UserTestIssue"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueEditedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueEditedNotified, msg = "expected an issue edited notification");
    test:assertTrue(issueChanges != (), msg = "expected changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueEdited],
    enable: true
}
function testWebhookNotificationOnIssueLocked() {
    json lockedIssue = buildIssue({"locked": true, "active_lock_reason": "spam"});
    json eventPayload = {
        "action": "locked",
        "issue": lockedIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue locked webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueLockedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueLockedNotified, msg = "expected an issue locked notification");
    test:assertEquals(issueLockedReason, "spam", msg = "expected lock reason to be 'spam'");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueLocked],
    enable: true
}
function testWebhookNotificationOnIssueUnlocked() {
    json eventPayload = {
        "action": "unlocked",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue unlocked webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueUnlockedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueUnlockedNotified, msg = "expected an issue unlocked notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueUnlocked],
    enable: true
}
function testWebhookNotificationOnIssueMilestoned() {
    json milestoneField = {
        "id": 8012345,
        "node_id": "MI_kwDOFfuAD85JKO6z",
        "number": 1,
        "title": "v1.0",
        "description": "First release milestone",
        "state": "open",
        "open_issues": 3,
        "closed_issues": 1,
        "created_at": "2022-01-01T00:00:00Z",
        "updated_at": "2022-05-06T00:00:00Z",
        "due_on": "2022-06-01T07:00:00Z",
        "closed_at": null
    };
    json issueWithMilestone = buildIssue({"milestone": milestoneField});
    json eventPayload = {
        "action": "milestoned",
        "issue": issueWithMilestone,
        "milestone": milestoneField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue milestoned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueMilestonedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueMilestonedNotified, msg = "expected an issue milestoned notification");
    test:assertEquals(issueMilestoneTitle, "v1.0", msg = "expected milestone title to be 'v1.0'");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueMilestoned],
    enable: true
}
function testWebhookNotificationOnIssueDemilestoned() {
    json milestoneField = {
        "id": 8012345,
        "node_id": "MI_kwDOFfuAD85JKO6z",
        "number": 1,
        "title": "v1.0",
        "description": "First release milestone",
        "state": "open",
        "open_issues": 2,
        "closed_issues": 1,
        "created_at": "2022-01-01T00:00:00Z",
        "updated_at": "2022-05-06T00:00:00Z",
        "due_on": "2022-06-01T07:00:00Z",
        "closed_at": null
    };
    json eventPayload = {
        "action": "demilestoned",
        "issue": baseIssue,
        "milestone": milestoneField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue demilestoned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueDemilestonedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueDemilestonedNotified, msg = "expected an issue demilestoned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueDemilestoned],
    enable: true
}
function testWebhookNotificationOnIssueUnlabeled() {
    json removedLabel = {
        "id": 3012706683,
        "node_id": "MDU6TGFiZWwzMDEyNzA2Njgz",
        "url": "https://api.github.com/repos/ABCUser/samplestest/labels/bug",
        "name": "bug",
        "color": "d73a4a",
        "default": false,
        "description": "Something isn't working"
    };
    json eventPayload = {
        "action": "unlabeled",
        "issue": baseIssue,
        "label": removedLabel,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue unlabeled webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueUnlabeledNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueUnlabeledNotified, msg = "expected an issue unlabeled notification");
    test:assertEquals(issueUnlabeledName, "bug", msg = "expected unlabeled label name to be 'bug'");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueUnlabeled],
    enable: true
}
function testWebhookNotificationOnIssueUnassigned() {
    json assigneeField = {
        "login": "ABCUser",
        "id": 3378323,
        "node_id": "MDQ6VXNlcjMzNzgzMjM=",
        "avatar_url": "https://avatars.githubusercontent.com/u/3378323?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/ABCUser",
        "html_url": "https://github.com/ABCUser",
        "type": "User",
        "site_admin": false
    };
    json eventPayload = {
        "action": "unassigned",
        "issue": baseIssue,
        "assignee": assigneeField,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue unassigned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueUnassignedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueUnassignedNotified, msg = "expected an issue unassigned notification");
    test:assertEquals(issueUnassigneeLogin, "ABCUser", msg = "expected unassigned user login to be 'ABCUser'");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueUnassigned],
    enable: true
}
function testWebhookNotificationOnIssuePinned() {
    json eventPayload = {
        "action": "pinned",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue pinned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issuePinnedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issuePinnedNotified, msg = "expected an issue pinned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssuePinned],
    enable: true
}
function testWebhookNotificationOnIssueUnpinned() {
    json eventPayload = {
        "action": "unpinned",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue unpinned webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueUnpinnedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueUnpinnedNotified, msg = "expected an issue unpinned notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueUnpinned],
    enable: true
}
function testWebhookNotificationOnIssueTransferred() {
    json eventPayload = {
        "action": "transferred",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue transferred webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueTransferredNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueTransferredNotified, msg = "expected an issue transferred notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueTransferred],
    enable: true
}
function testWebhookNotificationOnIssueTyped() {
    json eventPayload = {
        "action": "typed",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue typed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueTypedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueTypedNotified, msg = "expected an issue typed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueTyped],
    enable: true
}
function testWebhookNotificationOnIssueUntyped() {
    json eventPayload = {
        "action": "untyped",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue untyped webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueUntypedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueUntypedNotified, msg = "expected an issue untyped notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnIssueUntyped],
    enable: true
}
function testWebhookNotificationOnIssueDeleted() {
    json eventPayload = {
        "action": "deleted",
        "issue": baseIssue,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendIssuesWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Issue deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!issueDeletedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(issueDeletedNotified, msg = "expected an issue deleted notification");
}
