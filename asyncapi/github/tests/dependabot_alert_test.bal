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

function buildDependabotAlert(int number, string state, string? dismissedAt, string? fixedAt,
        string? autoDismissedAt) returns json {
    return {
        "number": number,
        "state": state,
        "dependency": {
            "package": {
                "ecosystem": "npm",
                "name": "lodash"
            },
            "manifest_path": "package.json",
            "scope": "runtime"
        },
        "security_advisory": {
            "ghsa_id": "GHSA-xxxx-xxxx-xxxx",
            "cve_id": "CVE-2021-23337",
            "summary": "Prototype pollution in lodash",
            "description": "Lodash versions prior to 4.17.21 are vulnerable to prototype pollution.",
            "severity": "high",
            "vulnerabilities": []
        },
        "security_vulnerability": {
            "package": {
                "ecosystem": "npm",
                "name": "lodash"
            },
            "severity": "high",
            "vulnerable_version_range": "< 4.17.21",
            "first_patched_version": {
                "identifier": "4.17.21"
            }
        },
        "url": "https://api.github.com/repos/ABCUser/samplestest/dependabot/alerts/" + number.toString(),
        "html_url": "https://github.com/ABCUser/samplestest/security/dependabot/" + number.toString(),
        "created_at": "2026-04-22T08:00:00Z",
        "updated_at": "2026-04-22T10:00:00Z",
        "dismissed_at": dismissedAt,
        "dismissed_by": null,
        "dismissed_reason": null,
        "dismissed_comment": null,
        "fixed_at": fixedAt,
        "auto_dismissed_at": autoDismissedAt,
        "assignees": []
    };
}

function sendDependabotAlertWebhook(json payload) returns http:Response|error {
    string payloadStr = payload.toJsonString();
    byte[]|error hmac = crypto:hmacSha256(payloadStr.toBytes(), githubSecret.toBytes());
    if hmac is error {
        return hmac;
    }
    http:Request req = new;
    req.setPayload(payloadStr);
    req.setHeader("Content-Type", "application/json");
    req.setHeader("X-GitHub-Event", "dependabot_alert");
    req.setHeader("X-Hub-Signature-256", "sha256=" + hmac.toBase16());
    return clientEndpoint->post("/", req);
}

@test:Config {
    enable: true
}
function testWebhookNotificationOnDependabotAlertCreated() {
    json eventPayload = {
        "action": "created",
        "alert": buildDependabotAlert(1, "open", (), (), ()),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert created webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertCreatedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertCreatedNotified, msg = "expected a Dependabot alert created notification");
    test:assertEquals(dependabotAlertPackageName, "lodash", msg = "expected package name to match");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnDependabotAlertCreated],
    enable: true
}
function testWebhookNotificationOnDependabotAlertDismissed() {
    json dismissedAlert = buildDependabotAlert(1, "dismissed", "2026-04-22T11:00:00Z", (), ());
    json eventPayload = {
        "action": "dismissed",
        "alert": dismissedAlert,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert dismissed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertDismissedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertDismissedNotified, msg = "expected a Dependabot alert dismissed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnDependabotAlertDismissed],
    enable: true
}
function testWebhookNotificationOnDependabotAlertReopened() {
    json eventPayload = {
        "action": "reopened",
        "alert": buildDependabotAlert(1, "open", (), (), ()),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert reopened webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertReopenedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertReopenedNotified, msg = "expected a Dependabot alert reopened notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnDependabotAlertReopened],
    enable: true
}
function testWebhookNotificationOnDependabotAlertFixed() {
    json fixedAlert = buildDependabotAlert(1, "fixed", (), "2026-04-22T12:00:00Z", ());
    json eventPayload = {
        "action": "fixed",
        "alert": fixedAlert,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert fixed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertFixedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertFixedNotified, msg = "expected a Dependabot alert fixed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnDependabotAlertFixed],
    enable: true
}
function testWebhookNotificationOnDependabotAlertAutoDismissed() {
    json autoDismissedAlert = buildDependabotAlert(2, "auto_dismissed", (), (), "2026-04-22T13:00:00Z");
    json eventPayload = {
        "action": "auto_dismissed",
        "alert": autoDismissedAlert,
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert auto_dismissed webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertAutoDismissedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertAutoDismissedNotified,
            msg = "expected a Dependabot alert auto_dismissed notification");
}

@test:Config {
    dependsOn: [testWebhookNotificationOnDependabotAlertAutoDismissed],
    enable: true
}
function testWebhookNotificationOnDependabotAlertReintroduced() {
    json eventPayload = {
        "action": "reintroduced",
        "alert": buildDependabotAlert(2, "open", (), (), ()),
        "repository": repositoryField,
        "sender": senderField
    };
    http:Response|error response = sendDependabotAlertWebhook(eventPayload);
    if response is error {
        test:assertFail(msg = "Dependabot alert reintroduced webhook failed: " + response.message());
    } else {
        test:assertTrue(response.statusCode === 200 || response.statusCode === 201,
                msg = "expected a 200/201 status code. Found " + response.statusCode.toBalString());
    }
    int counter = 10;
    while (!dependabotAlertReintroducedNotified && counter > 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(dependabotAlertReintroducedNotified,
            msg = "expected a Dependabot alert reintroduced notification");
}
