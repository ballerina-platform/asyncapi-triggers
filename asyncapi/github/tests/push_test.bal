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

function sendPushWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "push");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnPush() {
    json eventPayload = {
        "ref": "refs/heads/main",
        "before": "0000000000000000000000000000000000000000",
        "after": "abc123def456abc123def456abc123def456abc1",
        "created": false,
        "deleted": false,
        "forced": false,
        "compare": "https://github.com/ABCUser/samplestest/compare/abc123...def456",
        "commits": [
            {
                "id": "abc123def456abc123def456abc123def456abc1",
                "message": "Add new feature",
                "timestamp": "2026-04-22T10:00:00Z",
                "url": "https://github.com/ABCUser/samplestest/commit/abc123def456abc123def456abc123def456abc1",
                "author": {
                    "name": "ABCUser",
                    "email": "abcuser@example.com",
                    "username": "ABCUser"
                },
                "committer": {
                    "name": "ABCUser",
                    "email": "abcuser@example.com",
                    "username": "ABCUser"
                },
                "added": ["src/newfile.bal"],
                "removed": [],
                "modified": ["README.md"]
            }
        ],
        "head_commit": {
            "id": "abc123def456abc123def456abc123def456abc1",
            "message": "Add new feature",
            "timestamp": "2026-04-22T10:00:00Z",
            "url": "https://github.com/ABCUser/samplestest/commit/abc123def456abc123def456abc123def456abc1",
            "author": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "committer": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "added": ["src/newfile.bal"],
            "removed": [],
            "modified": ["README.md"]
        },
        "pusher": {
            "name": "ABCUser",
            "email": "abcuser@example.com",
            "username": "ABCUser"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPushWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Push webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!pushNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(pushNotified, msg = "expected a push notification");
    test:assertEquals(pushRef, "refs/heads/main", msg = "expected push ref to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnPush],
    enable: true
}
function testWebhookNotificationOnTagPush() {
    pushNotified = false;
    pushRef = "";
    json eventPayload = {
        "ref": "refs/tags/v1.0.0",
        "before": "0000000000000000000000000000000000000000",
        "after": "def456abc123def456abc123def456abc123def4",
        "created": true,
        "deleted": false,
        "forced": false,
        "compare": "https://github.com/ABCUser/samplestest/compare/v1.0.0",
        "commits": [],
        "head_commit": {
            "id": "def456abc123def456abc123def456abc123def4",
            "message": "Release v1.0.0",
            "timestamp": "2026-04-22T12:00:00Z",
            "url": "https://github.com/ABCUser/samplestest/commit/def456abc123def456abc123def456abc123def4",
            "author": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "committer": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "added": [],
            "removed": [],
            "modified": []
        },
        "pusher": {
            "name": "ABCUser",
            "email": "abcuser@example.com",
            "username": "ABCUser"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPushWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Tag push webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!pushNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(pushNotified, msg = "expected a tag push notification");
    test:assertEquals(pushRef, "refs/tags/v1.0.0", msg = "expected tag push ref to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnTagPush],
    enable: true
}
function testWebhookNotificationOnForcePush() {
    pushNotified = false;
    pushRef = "";
    json eventPayload = {
        "ref": "refs/heads/feature-branch",
        "before": "aaa111bbb222ccc333ddd444eee555fff666aaa1",
        "after": "fff666eee555ddd444ccc333bbb222aaa111fff6",
        "created": false,
        "deleted": false,
        "forced": true,
        "compare": "https://github.com/ABCUser/samplestest/compare/aaa111...fff666",
        "commits": [
            {
                "id": "fff666eee555ddd444ccc333bbb222aaa111fff6",
                "message": "Fix: rebase onto main",
                "timestamp": "2026-04-22T14:00:00Z",
                "url": "https://github.com/ABCUser/samplestest/commit/fff666eee555ddd444ccc333bbb222aaa111fff6",
                "author": {
                    "name": "ABCUser",
                    "email": "abcuser@example.com",
                    "username": "ABCUser"
                },
                "committer": {
                    "name": "ABCUser",
                    "email": "abcuser@example.com",
                    "username": "ABCUser"
                },
                "added": [],
                "removed": [],
                "modified": ["src/main.bal"]
            }
        ],
        "head_commit": {
            "id": "fff666eee555ddd444ccc333bbb222aaa111fff6",
            "message": "Fix: rebase onto main",
            "timestamp": "2026-04-22T14:00:00Z",
            "url": "https://github.com/ABCUser/samplestest/commit/fff666eee555ddd444ccc333bbb222aaa111fff6",
            "author": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "committer": {
                "name": "ABCUser",
                "email": "abcuser@example.com",
                "username": "ABCUser"
            },
            "added": [],
            "removed": [],
            "modified": ["src/main.bal"]
        },
        "pusher": {
            "name": "ABCUser",
            "email": "abcuser@example.com",
            "username": "ABCUser"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendPushWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Force push webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!pushNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(pushNotified, msg = "expected a force push notification");
    test:assertEquals(pushRef, "refs/heads/feature-branch", msg = "expected force push ref to match");
}
