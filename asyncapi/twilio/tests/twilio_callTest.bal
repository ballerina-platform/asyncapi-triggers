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

// import ballerina/test;
import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerina/mime;
import ballerina/lang.runtime;

boolean twilioCallRingingNotified = false;
boolean twilioCallCompletedNotified = false;
boolean twilioCallCancelledNotified = false;

listener Listener twilioCallStatusListener = new (listenOn = 8096);

service CallStatusService on twilioCallStatusListener {
    remote function onRinging(CallStatusEventWrapper event) returns error? {
        log:printInfo("Call Ringing");
        twilioCallRingingNotified = true;
    }

    remote function onCompleted(CallStatusEventWrapper event) returns error? {
        log:printInfo("Call Completed");
        twilioCallCompletedNotified = true;
    }

    remote function onCanceled(CallStatusEventWrapper event) returns error? {
        log:printInfo("Call Canceled");
        twilioCallCancelledNotified = true;
    }

    remote function onBusy(CallStatusEventWrapper event) returns error? {
        return;
    }

    remote function onFailed(CallStatusEventWrapper event) returns error? {
        return;
    }

    remote function onInProgress(CallStatusEventWrapper event) returns error? {
        return;
    }

    remote function onNoAnswer(CallStatusEventWrapper event) returns error? {
        return;
    }

    remote function onQueued(CallStatusEventWrapper event) returns error? {
        return;
    }
}

http:Client callClientEndpoint = check new ("http://localhost:8096");

function getTwilioCallRecord(string callStatus) returns map<string> {
    return (
        {
        AccountSid: "AccountSID",
        ApiVersion: "2010-04-01",
        CallSid: "CallSID",
        CallStatus: callStatus,
        CallToken: "CallToken",
        Called: "+12345678910",
        CalledCity: "RAYMONDVILLE",
        CalledCountry: "US",
        CalledState: "TX",
        CalledZip: "78580",
        Caller: "+123456789",
        CallerCity: "",
        CallerCountry: "LK",
        CallerState: "",
        CallerZip: "",
        Direction: "inbound",
        From: "+123456789",
        FromCity: "",
        FromCountry: "LK",
        FromState: "",
        FromZip: "",
        StirPassportToken: "PPToken",
        StirVerstat: "TN-Validation-Passed-C",
        To: "+12345678910",
        ToCity: "RAYMONDVILLE",
        ToCountry: "US",
        ToState: "TX",
        ToZip: "78580"
    });
}

# Tests for Twilio CallStatus Events
@test:Config {
    enable: true
}

function testTwilioCallRinging() {
    map<string> callRingingRecord = getTwilioCallRecord("ringing");
    http:Response|error callRingingPayload = callClientEndpoint->post("/", callRingingRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);

    if (callRingingPayload is error) {
        test:assertFail(msg = "Call ringing failed" + callRingingPayload.message());
    } else {
        test:assertTrue(callRingingPayload.statusCode === 200, msg = "Expected a 200 status code. Found" + callRingingPayload.statusCode.toString());
        test:assertEquals(callRingingPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }

    int counter = 10;
    while (!twilioCallRingingNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioCallRingingNotified, msg = "Expected a call ringing notification");
}

@test:Config {
    enable: true,
    dependsOn: [testTwilioCallRinging]
}
function testTwilioCallCompleted() {
    map<string> callCompletedRecord = getTwilioCallRecord("completed");
    http:Response|error callCompletedPayload = callClientEndpoint->post("/", callCompletedRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);

    if (callCompletedPayload is error) {
        test:assertFail(msg = "Call completion failed" + callCompletedPayload.message());
    } else {
        test:assertTrue(callCompletedPayload.statusCode === 200, msg = "Expected a 200 status code. Found" + callCompletedPayload.statusCode.toString());
        test:assertEquals(callCompletedPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }
    int counter = 10;
    while (!twilioCallCompletedNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioCallCompletedNotified, msg = "Expected a call completed notification");
}

@test:Config {
    enable: true,
    dependsOn: [testTwilioCallCompleted]
}
function testTwilioCallCanceled() {
    map<string> callCanceledRecord = getTwilioCallRecord("canceled");
    http:Response|error callCanceledPayload = callClientEndpoint->post("/", callCanceledRecord, mediaType = mime:APPLICATION_FORM_URLENCODED);

    if (callCanceledPayload is error) {
        test:assertFail(msg = "Call cancellation failed" + callCanceledPayload.message());
    } else {
        test:assertTrue(callCanceledPayload.statusCode === 200, msg = "Expected a 200 status code. Found" + callCanceledPayload.statusCode.toString());
        test:assertEquals(callCanceledPayload.getTextPayload(), "Event acknowledged successfully", msg = "Expected payload not received");
    }

    int counter = 10;
    while (!twilioCallCancelledNotified && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(twilioCallCancelledNotified, msg = "Expected a call cancelled notification");
}
