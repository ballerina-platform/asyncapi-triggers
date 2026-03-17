// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/log;
import ballerina/lang.runtime;
import ballerina/http;
import ballerinax/googleapis.gmail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = ?;
configurable string recipientEmail = ?;

# e.g. "projects/<PROJECT_ID>/subscriptions/<SUBSCRIPTION_ID>"
configurable string subscriptionResource = ?;

// Simulates a Pub/Sub push notification so the dispatcher fetches Gmail history.
function simulatePush(http:Client localClient, string subscription) returns error? {
    json|error resp = localClient->post("/", {subscription: subscription});
    if resp is error {
        log:printError("Push simulation failed", resp);
    }
}

// Spawns the test operations as a background strand so main() can return,
// allowing the Ballerina runtime to call listener 'start() and open port 8090.
public function main() returns error? {
    if subscriptionResource == "" {
        log:printError("Subscription resource not set. Please copy the subscription name from the startup logs and set the 'subscriptionResource' config variable.");
        return;
    }
    _ = check runTests();
}

function runTests() returns error? {
    log:printInfo("=== Starting Gmail Trigger Sample Tests ===");
    
    gmail:Client gmailClient = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshUrl,
            refreshToken
        }
    });

    http:Client localClient = check new ("http://localhost:8090");

    // 1. Send email → triggers onNewEmail, onNewThread, (onNewAttachment if applicable)
    gmail:Message sendResult = check gmailClient->/users/["me"]/messages/send.post({
        to: [recipientEmail],
        subject: "Test Email from Gmail Trigger Sample",
        bodyInText: "This is a test email to verify the trigger."
    });
    log:printInfo("Sent email", messageId = sendResult.id);
    runtime:sleep(3);
    check simulatePush(localClient, subscriptionResource);
    runtime:sleep(5);

    // 2. Star the message → triggers onEmailStarred / onEmailLabelAdded
    _ = check gmailClient->/users/["me"]/messages/[sendResult.id]/modify.post({
        addLabelIds: ["STARRED"]
    });
    log:printInfo("Starred email", messageId = sendResult.id);
    runtime:sleep(3);
    check simulatePush(localClient, subscriptionResource);
    runtime:sleep(5);

    // 3. Remove star → triggers onEmailStarRemoved / onEmailLabelRemoved
    _ = check gmailClient->/users/["me"]/messages/[sendResult.id]/modify.post({
        removeLabelIds: ["STARRED"]
    });
    log:printInfo("Removed star", messageId = sendResult.id);
    runtime:sleep(3);
    check simulatePush(localClient, subscriptionResource);
    runtime:sleep(5);

    // 4. Add label → triggers onEmailLabelAdded
    _ = check gmailClient->/users/["me"]/messages/[sendResult.id]/modify.post({
        addLabelIds: ["IMPORTANT"]
    });
    log:printInfo("Added IMPORTANT label", messageId = sendResult.id);
    runtime:sleep(3);
    check simulatePush(localClient, subscriptionResource);
    runtime:sleep(5);

    // 5. Remove label → triggers onEmailLabelRemoved
    _ = check gmailClient->/users/["me"]/messages/[sendResult.id]/modify.post({
        removeLabelIds: ["IMPORTANT"]
    });
    log:printInfo("Removed IMPORTANT label", messageId = sendResult.id);
    runtime:sleep(3);
    check simulatePush(localClient, subscriptionResource);

    log:printInfo("=== All test requests sent. Check the >>> logs above for listener events. ===");
}

