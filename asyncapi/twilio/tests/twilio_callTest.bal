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

listener Listener twilioCallStatusListener = new (8096);

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
        AccountSid: "AC1a1d1058731a7cbee5ba5a99ecb54a74",
        ApiVersion: "2010-04-01",
        CallSid: "CAe32edfb3ec470daf2627395877dbf70f",
        CallStatus: callStatus,
        CallToken: "%7B%22parentCallInfoToken%22%3A%22eyJhbGciOiJFUzI1NiJ9.eyJjYWxsU2lkIjoiQ0FlMzJlZGZiM2VjNDcwZGFmMjYyNzM5NTg3N2RiZjcwZiIsImZyb20iOiIrOTQ3MTY4NjYzODYiLCJ0byI6IisxOTU2MzA0NjA0OCIsImlhdCI6IjE2NTEwNTYwNDIifQ.c0LJ6skOmtj87elnUkDhwTKlB-KUwtwtMDINnp4IbSz-l_rzWB9GmbID2sS05XkglIYsmUJzaJX27pbJvLc-PQ%22%2C%22identityHeaderTokens%22%3A%5B%22eyJhbGciOiJFUzI1NiIsInBwdCI6InNoYWtlbiIsInR5cCI6InBhc3Nwb3J0IiwieDV1IjoiaHR0cHM6Ly9jci5jY2lkLm5ldXN0YXIuYml6L2NjaWQvYXV0aG4vdjIvY2VydHMvMTEwMDEuMTAwMTIifQ.eyJhdHRlc3QiOiJDIiwiZGVzdCI6eyJ0biI6WyIxOTU2MzA0NjA0OCJdfSwiaWF0IjoxNjUxMDU2MDQxLCJvcmlnIjp7InRuIjoiOTQ3MTY4NjYzODYifSwib3JpZ2lkIjoiODg2ZGYxMmEtMGE5NS00MzdmLWE3NDYtOGVmYzAzYjEwMzBkIn0.KzAq7wZkBw3jFdcwbjJYc7cZcD5ozmEIYlsDPcfu67nB9afEtxdeWz7_hPyjPSeiZbanTQ_tAiSWUoQZLzdk9g%3Binfo%3D%3Chttps%3A%2F%2Fcr.ccid.neustar.biz%2Fccid%2Fauthn%2Fv2%2Fcerts%2F11001.10012%3E%3Balg%3DES256%3Bppt%3D%5C%22shaken%5C%22%22%5D%7D",
        Called: "+12345678910",
        CalledCity: "RAYMONDVILLE",
        CalledCountry: "US",
        CalledState: "TX",
        CalledZip: "78580",
        Caller: "+98765432110",
        CallerCity: "",
        CallerCountry: "LK",
        CallerState: "",
        CallerZip: "",
        Direction: "inbound",
        From: "+98765432110",
        FromCity: "",
        FromCountry: "LK",
        FromState: "",
        FromZip: "",
        StirPassportToken: "eyJhbGciOiJFUzI1NiIsInBwdCI6InNoYWtlbiIsInR5cCI6InBhc3Nwb3J0IiwieDV1IjoiaHR0cHM6Ly9jci5jY2lkLm5ldXN0YXIuYml6L2NjaWQvYXV0aG4vdjIvY2VydHMvMTEwMDEuMTAwMTIifQ.eyJhdHRlc3QiOiJDIiwiZGVzdCI6eyJ0biI6WyIxOTU2MzA0NjA0OCJdfSwiaWF0IjoxNjUxMDU2MDQxLCJvcmlnIjp7InRuIjoiOTQ3MTY4NjYzODYifSwib3JpZ2lkIjoiODg2ZGYxMmEtMGE5NS00MzdmLWE3NDYtOGVmYzAzYjEwMzBkIn0.KzAq7wZkBw3jFdcwbjJYc7cZcD5ozmEIYlsDPcfu67nB9afEtxdeWz7_hPyjPSeiZbanTQ_tAiSWUoQZLzdk9g",
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
