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

boolean twilioSmsSentNotified = false;
boolean twilioSmsDeiveredNotified = false;
boolean twilioSmsReceivedNotified = false;


listener Listener twilioSmsStatusListener = new (8095);

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

http:Client clientEndpoint = check new ("http://localhost:8095");

# Tests for Twilio SmsStaus Events
# + smsStatus - Type of the SmsStatus field
# + return - SmsStatusChange event payload object

function getTwiliSmsRecord(string smsStatus) returns map<string> {
    return (
        {
        ToCountry: "US",
        ToState: "TX",
        SmsMessageSid: "SM7b6c297028071eecda93e1c35477f3a8",
        NumMedia: "0",
        ToCity: "RAYMONDVILLE",
        FromZip: "34669",
        SmsSid: "SM7b6c297028071eecda93e1c35477f3a8",
        FromState: "FL",
        SmsStatus: smsStatus,
        FromCity: "HUDSON",
        Body: "[WSO2 Choreo Demo] Twilio First Test MSG",
        FromCountry: "US",
        To: "+12345678910",
        MessagingServiceSid: "MG8d82b9c409279e0a4da37ef5ea367d4f",
        ToZip: "78580",
        NumSegments: "1",
        ReferralNumMedia: "0",
        MessageSid: "SM7b6c297028071eecda93e1c35477f3a8",
        AccountSid: "AC1a1d1058731a7cbee5ba5a99ecb54a74",
        From: "+98765432110",
        ApiVersion: "2010-04-01"
    });
}

@test:Config {
    enable: true
}
function testTwilioSmsSent() {
    map<string> smsSentRecord = getTwiliSmsRecord("sent");
    http:Response|error smsSentPayload = clientEndpoint->post("/", smsSentRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);

    if (smsSentPayload is error) {
        test:assertFail(msg = "Sms sending failed" + smsSentPayload.message());
    } else {
        test:assertTrue(smsSentPayload.statusCode === 200, msg = "Expected a 200 status code. Found" + smsSentPayload.statusCode.toString());
        test:assertEquals(smsSentPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }

    int counter = 10;
    while (!twilioSmsSentNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioSmsSentNotified, msg = "Expected a call ringing notification");

}

@test:Config {
    enable: true,
    dependsOn: [testTwilioSmsSent]
}
function testTwilioSmsDelivered() {
    map<string> smsDeliveredRecord = getTwiliSmsRecord("delivered");
    http:Response|error smsDeliveredPayload = clientEndpoint->post("/", smsDeliveredRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);
    if (smsDeliveredPayload is error) {
        test:assertFail(msg = "Sms delivery failed" + smsDeliveredPayload.message());
    } else {
        test:assertTrue(smsDeliveredPayload.statusCode === 200, msg = "expected a 200 status code. Found" + smsDeliveredPayload.statusCode.toString());
        test:assertEquals(smsDeliveredPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }

    int counter = 10;
    while (!twilioSmsDeiveredNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioSmsDeiveredNotified, msg = "Expected a call ringing notification");
}

@test:Config {
    enable: true,
    dependsOn: [testTwilioSmsDelivered]
}
function testTwilioSmsReceived() {
    map<string> smsReceivedRecord = getTwiliSmsRecord("received");
    http:Response|error smsReceivedPayload = clientEndpoint->post("/", smsReceivedRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);
    if (smsReceivedPayload is error) {
        test:assertFail(msg = "Sms receving failed" + smsReceivedPayload.message());
    } else {
        test:assertTrue(smsReceivedPayload.statusCode === 200, msg = "Expected a 200 status code. Found" + smsReceivedPayload.statusCode.toString());
        test:assertEquals(smsReceivedPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }

    int counter = 10;
    while (!twilioSmsReceivedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioSmsReceivedNotified, msg = "Expected a call ringing notification");
}
