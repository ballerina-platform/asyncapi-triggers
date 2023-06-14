// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import ballerina/test;
import ballerina/lang.runtime;

boolean updateRowEventTriggered = false;

listener Listener sheetListener = new(listenerConfig = {spreadsheetId: "ABCD123"}, listenOn = 8097);

service SheetRowService on sheetListener {

    remote function onAppendRow(GSheetEvent payload) returns error? {
        return;
    }

    remote function onUpdateRow(GSheetEvent payload) returns error? {
        updateRowEventTriggered = true;
        return;
    }
}

http:Client clientEndpoint = check new ("http://localhost:8097");
@test:Config {
    enable: true
}
function testOnAppendRowEvent() {
    json eventPayload = {
        "spreadsheetId":"ABCD123",
        "spreadsheetName":"AAATesting",
        "worksheetId":0,
        "worksheetName":"Sheet1",
        "rangeUpdated":"A3",
        "startingRowPosition":3,
        "startingColumnPosition":1,
        "endRowPosition":3,
        "endColumnPosition":1,
        "newValues":[
            [
                "New Column"
            ]
        ],
        "lastRowWithContent":3,
        "lastColumnWithContent":5,
        "previousLastRow":3,
        "eventType":"updateRow",
        "eventData":{
            "authMode":"FULL",
            "oldValue":"ABC",
            "range":{
                "columnEnd":1,
                "columnStart":1,
                "rowEnd":3,
                "rowStart":3
            },
            "source":{
                
            },
            "triggerUid":"9580098",
            "user":{
                "email":"abctest@gmail.com",
                "nickname":"abctest"
            },
            "value":"New Column"
        }
    };
    http:Request req = new;
    req.setPayload(eventPayload.toJsonString());
    http:Response|error updateRowPayload =  clientEndpoint->post("/", req);

    if (updateRowPayload is error) {
        test:assertFail(msg = "Issue creation failed: " + updateRowPayload.message());
    } else {
        test:assertTrue(updateRowPayload.statusCode === 200 || updateRowPayload.statusCode === 201, msg = "expected a 200/201 status code. Found " + updateRowPayload.statusCode.toBalString());
        test:assertEquals(updateRowPayload.getTextPayload(), "200", msg = "");
    }

    int counter = 10;
    while (!updateRowEventTriggered && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(updateRowEventTriggered, msg = "expected an issue creation notification");
}
