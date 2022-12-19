// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/http;
import ballerina/log;
import ballerina/mime;
import ballerina/lang.runtime;
import ballerina/url;

boolean twilioSmsSentNotified = false;
boolean twilioSmsDeiveredNotified = false;
boolean twilioSmsReceivedNotified = false;

configurable ListenerConfig listenerConfig = ?;

configurable string fromNo = ?;
configurable string toNo = ?;
configurable string message = ?;

configurable string senderSid = ?;
configurable string senderAuthToken = ?;

listener Listener twilioSmsStatusListener = new (listenerConfig, listenOn = 8095);

service SmsStatusService on twilioSmsStatusListener {
    remote function onSent(SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Sms Sent");
        twilioSmsSentNotified = true;
    }

    remote function onDelivered(SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Sms Delivered");
        twilioSmsDeiveredNotified = true;
    }

    remote function onReceived(SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Sms Received");
        twilioSmsReceivedNotified = true;
    }

    remote function onAccepted(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onFailed(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onQueued(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onReceiving(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onSending(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onUndelivered(SmsStatusChangeEventWrapper event) returns error? {
        return;
    }
}

@test:Config {
    enable: false
}
function testTwilioSmsSent() returns error? {
    runtime:sleep(5);
    http:Client twilioClient = check new (TWILIO_URL, {
        auth: {
            username: senderSid,
            password: senderAuthToken
        }
    });
    string requestBody = "";
    requestBody = check createUrlEncodedRequestBody(requestBody, "From", fromNo);
    requestBody = check createUrlEncodedRequestBody(requestBody, "To", fromNo);
    requestBody = check createUrlEncodedRequestBody(requestBody, "Body", message);
    http:Response _ = check twilioClient->post(string `/2010-04-01/Accounts/${senderSid}/Messages.json`, requestBody,
    mediaType = mime:APPLICATION_FORM_URLENCODED);

    int counter = 20;
    while (!twilioSmsSentNotified && counter >= 0) {
        runtime:sleep(3);
        counter -= 1;
    }
    test:assertTrue(twilioSmsSentNotified, msg = "Expected a sent message notification");

}

isolated function createUrlEncodedRequestBody(string requestBody, string key, string value) returns string|error {
    string encodedString = check url:encode(value, "UTF8");
    string body = "";
    if (requestBody != "") {
        body = requestBody + "&";
    }
    return body + key + "=" + encodedString;
}
