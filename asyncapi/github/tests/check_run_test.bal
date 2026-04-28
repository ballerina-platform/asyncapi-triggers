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

function buildCheckRun(string status, string? conclusion) returns json {
    return {
        "id": 44556677,
        "name": "build-and-test",
        "node_id": "CR_kwDOFfuAD85JKO6z",
        "head_sha": "abc123def456abc123def456abc123def456abc1",
        "external_id": "42",
        "url": "https://api.github.com/repos/ABCUser/samplestest/check-runs/44556677",
        "html_url": "https://github.com/ABCUser/samplestest/runs/44556677",
        "status": status,
        "conclusion": conclusion,
        "started_at": "2026-04-22T10:00:00Z",
        "completed_at": conclusion != () ? "2026-04-22T10:10:00Z" : (),
        "output": {
            "title": "Build and Test",
            "summary": "All checks passed.",
            "annotations_count": 0,
            "annotations_url": "https://api.github.com/repos/ABCUser/samplestest/check-runs/44556677/annotations"
        },
        "check_suite": {
            "id": 12345678
        },
        "pull_requests": []
    };
}

function sendCheckRunWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "check_run");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnCheckRunCreated() {
    json eventPayload = {
        "action": "created",
        "check_run": buildCheckRun("queued", ()),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendCheckRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Check run created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!checkRunCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(checkRunCreatedNotified, msg = "expected a check run created notification");
    test:assertEquals(checkRunName, "build-and-test", msg = "expected check run name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnCheckRunCreated],
    enable: true
}
function testWebhookNotificationOnCheckRunCompleted() {
    json eventPayload = {
        "action": "completed",
        "check_run": buildCheckRun("completed", "success"),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendCheckRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Check run completed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!checkRunCompletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(checkRunCompletedNotified, msg = "expected a check run completed notification");
    test:assertEquals(checkRunConclusion, "success", msg = "expected check run conclusion to be success");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnCheckRunCompleted],
    enable: true
}
function testWebhookNotificationOnCheckRunCompletedWithFailure() {
    checkRunCompletedNotified = false;
    checkRunConclusion = "";
    json eventPayload = {
        "action": "completed",
        "check_run": buildCheckRun("completed", "failure"),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendCheckRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Check run completed (failure) webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!checkRunCompletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(checkRunCompletedNotified, msg = "expected a check run completed (failure) notification");
    test:assertEquals(checkRunConclusion, "failure", msg = "expected check run conclusion to be failure");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnCheckRunCompletedWithFailure],
    enable: true
}
function testWebhookNotificationOnCheckRunRerequested() {
    json eventPayload = {
        "action": "rerequested",
        "check_run": buildCheckRun("queued", ()),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendCheckRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Check run rerequested webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!checkRunRerequestedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(checkRunRerequestedNotified, msg = "expected a check run rerequested notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnCheckRunRerequested],
    enable: true
}
function testWebhookNotificationOnCheckRunRequestedAction() {
    json eventPayload = {
        "action": "requested_action",
        "check_run": buildCheckRun("completed", "action_required"),
        "requested_action": {
            "identifier": "fix-lint"
        },
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendCheckRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Check run requested_action webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!checkRunRequestedActionNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(checkRunRequestedActionNotified, msg = "expected a check run requested_action notification");
}
