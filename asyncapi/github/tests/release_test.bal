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

json baseRelease = {
    "id": 55443322,
    "node_id": "RE_kwDOFfuAD85JKO6z",
    "url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443322",
    "html_url": "https://github.com/ABCUser/samplestest/releases/tag/v1.0.0",
    "assets_url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443322/assets",
    "upload_url": "https://uploads.github.com/repos/ABCUser/samplestest/releases/55443322/assets{?name,label}",
    "tag_name": "v1.0.0",
    "name": "v1.0.0 - Initial Release",
    "body": "First stable release.",
    "draft": false,
    "prerelease": false,
    "target_commitish": "main",
    "author": {
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
    "assets": [],
    "created_at": "2026-04-22T10:00:00Z",
    "published_at": "2026-04-22T10:05:00Z"
};

function sendReleaseWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "release");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnReleaseCreated() {
    json eventPayload = {
        "action": "created",
        "release": baseRelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releaseCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releaseCreatedNotified, msg = "expected a release created notification");
    test:assertEquals(releaseTagName, "v1.0.0", msg = "expected release tag name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleaseCreated],
    enable: true
}
function testWebhookNotificationOnReleasePublished() {
    json eventPayload = {
        "action": "published",
        "release": baseRelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release published webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releasePublishedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releasePublishedNotified, msg = "expected a release published notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleasePublished],
    enable: true
}
function testWebhookNotificationOnReleaseReleased() {
    json eventPayload = {
        "action": "released",
        "release": baseRelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release released webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releaseReleasedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releaseReleasedNotified, msg = "expected a release released notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleaseReleased],
    enable: true
}
function testWebhookNotificationOnReleasePrereleased() {
    json prerelease = {
        "id": 55443323,
        "node_id": "RE_kwDOFfuAD85JKO6a",
        "url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443323",
        "html_url": "https://github.com/ABCUser/samplestest/releases/tag/v1.1.0-beta",
        "assets_url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443323/assets",
        "upload_url": "https://uploads.github.com/repos/ABCUser/samplestest/releases/55443323/assets{?name,label}",
        "tag_name": "v1.1.0-beta",
        "name": "v1.1.0-beta - Pre-release",
        "body": "Beta pre-release for testing.",
        "draft": false,
        "prerelease": true,
        "target_commitish": "main",
        "author": senderField,
        "assets": [],
        "created_at": "2026-04-22T12:00:00Z",
        "published_at": "2026-04-22T12:05:00Z"
    };
    json eventPayload = {
        "action": "prereleased",
        "release": prerelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release prereleased webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releasePrereleasedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releasePrereleasedNotified, msg = "expected a release prereleased notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleasePrereleased],
    enable: true
}
function testWebhookNotificationOnReleaseEdited() {
    json editedRelease = {
        "id": 55443322,
        "node_id": "RE_kwDOFfuAD85JKO6z",
        "url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443322",
        "html_url": "https://github.com/ABCUser/samplestest/releases/tag/v1.0.0",
        "assets_url": "https://api.github.com/repos/ABCUser/samplestest/releases/55443322/assets",
        "upload_url": "https://uploads.github.com/repos/ABCUser/samplestest/releases/55443322/assets{?name,label}",
        "tag_name": "v1.0.0",
        "name": "v1.0.0 - Stable Release (edited)",
        "body": "First stable release. Updated description.",
        "draft": false,
        "prerelease": false,
        "target_commitish": "main",
        "author": senderField,
        "assets": [],
        "created_at": "2026-04-22T10:00:00Z",
        "published_at": "2026-04-22T10:05:00Z"
    };
    json eventPayload = {
        "action": "edited",
        "release": editedRelease,
        "changes": {
            "body": {
                "from": "First stable release."
            },
            "name": {
                "from": "v1.0.0 - Initial Release"
            }
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release edited webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releaseEditedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releaseEditedNotified, msg = "expected a release edited notification");
    test:assertTrue(releaseChanges != (), msg = "expected release changes to be captured");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleaseEdited],
    enable: true
}
function testWebhookNotificationOnReleaseUnpublished() {
    json eventPayload = {
        "action": "unpublished",
        "release": baseRelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release unpublished webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releaseUnpublishedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releaseUnpublishedNotified, msg = "expected a release unpublished notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnReleaseUnpublished],
    enable: true
}
function testWebhookNotificationOnReleaseDeleted() {
    json eventPayload = {
        "action": "deleted",
        "release": baseRelease,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendReleaseWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Release deleted webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!releaseDeletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(releaseDeletedNotified, msg = "expected a release deleted notification");
}
