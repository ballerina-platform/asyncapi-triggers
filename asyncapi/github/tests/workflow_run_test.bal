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

json baseWorkflow = {
    "id": 11223344,
    "node_id": "W_kwDOFfuAD85JKO6z",
    "name": "CI",
    "path": ".github/workflows/ci.yml",
    "state": "active",
    "created_at": "2026-01-01T00:00:00Z",
    "updated_at": "2026-01-01T00:00:00Z",
    "url": "https://api.github.com/repos/ABCUser/samplestest/actions/workflows/11223344",
    "html_url": "https://github.com/ABCUser/samplestest/actions/workflows/ci.yml",
    "badge_url": "https://github.com/ABCUser/samplestest/workflows/CI/badge.svg"
};

function buildWorkflowRun(string status, string? conclusion) returns json {
    return {
        "id": 99887766,
        "name": "CI",
        "node_id": "WFR_kwDOFfuAD85JKO6z",
        "check_suite_id": 12345678,
        "head_branch": "main",
        "head_sha": "abc123def456abc123def456abc123def456abc1",
        "run_number": 42,
        "event": "push",
        "status": status,
        "conclusion": conclusion,
        "workflow_id": 11223344,
        "url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766",
        "html_url": "https://github.com/ABCUser/samplestest/actions/runs/99887766",
        "pull_requests": [],
        "created_at": "2026-04-22T10:00:00Z",
        "updated_at": "2026-04-22T10:05:00Z",
        "run_attempt": 1,
        "run_started_at": "2026-04-22T10:00:00Z",
        "actor": senderField,
        "triggering_actor": senderField,
        "jobs_url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766/jobs",
        "logs_url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766/logs",
        "artifacts_url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766/artifacts",
        "cancel_url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766/cancel",
        "rerun_url": "https://api.github.com/repos/ABCUser/samplestest/actions/runs/99887766/rerun",
        "workflow_url": "https://api.github.com/repos/ABCUser/samplestest/actions/workflows/11223344"
    };
}

function sendWorkflowRunWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "workflow_run");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnWorkflowRunRequested() {
    json eventPayload = {
        "action": "requested",
        "workflow_run": buildWorkflowRun("queued", ()),
        "workflow": baseWorkflow,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendWorkflowRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Workflow run requested webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!workflowRunRequestedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(workflowRunRequestedNotified, msg = "expected a workflow run requested notification");
    test:assertEquals(workflowRunName, "CI", msg = "expected workflow run name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnWorkflowRunRequested],
    enable: true
}
function testWebhookNotificationOnWorkflowRunInProgress() {
    json eventPayload = {
        "action": "in_progress",
        "workflow_run": buildWorkflowRun("in_progress", ()),
        "workflow": baseWorkflow,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendWorkflowRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Workflow run in_progress webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!workflowRunInProgressNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(workflowRunInProgressNotified, msg = "expected a workflow run in_progress notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnWorkflowRunInProgress],
    enable: true
}
function testWebhookNotificationOnWorkflowRunCompleted() {
    json eventPayload = {
        "action": "completed",
        "workflow_run": buildWorkflowRun("completed", "success"),
        "workflow": baseWorkflow,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendWorkflowRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Workflow run completed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!workflowRunCompletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(workflowRunCompletedNotified, msg = "expected a workflow run completed notification");
    test:assertEquals(workflowRunConclusion, "success", msg = "expected workflow run conclusion to be success");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnWorkflowRunCompleted],
    enable: true
}
function testWebhookNotificationOnWorkflowRunCompletedWithFailure() {
    workflowRunCompletedNotified = false;
    workflowRunConclusion = "";
    json eventPayload = {
        "action": "completed",
        "workflow_run": buildWorkflowRun("completed", "failure"),
        "workflow": baseWorkflow,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendWorkflowRunWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Workflow run completed (failure) webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!workflowRunCompletedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(workflowRunCompletedNotified, msg = "expected a workflow run completed (failure) notification");
    test:assertEquals(workflowRunConclusion, "failure", msg = "expected workflow run conclusion to be failure");
}
