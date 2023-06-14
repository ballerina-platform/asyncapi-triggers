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

boolean appMentioned = false;

listener Listener slackListener = new (listenerConfig = {verificationToken: "ABCDE"}, listenOn = 8098);

service AppService on slackListener {

    remote function onAppMention(GenericEventWrapper payload) returns error? {
        appMentioned = true;
        return;
    }

    remote function onAppRateLimited(GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onAppUninstalled(GenericEventWrapper payload) returns error? {
        return;
    }
}

http:Client clientEndpoint = check new ("http://localhost:8098");

@test:Config {
    enable: true
}
function testOnAppMentionEvent() {
    json eventPayload = {
        "token": "ABCDE",
        "team_id": "xxxxxxxxx",
        "api_app_id": "xxxxxxxxx",
        "event": {
            "client_msg_id": "3e2cf6f0-800a-4bdc-86e0-423ffcbaee66",
            "type": "app_mention",
            "text": "<@xxxxxxxxx> Hellow again",
            "user": "xxxxxxxxx",
            "ts": "1652383205.111139",
            "team": "xxxxxxxxx",
            "blocks": [
                {
                    "type": "rich_text",
                    "block_id": "/p=n",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [
                                {
                                    "type": "user",
                                    "user_id": "xxxxxxxxx"
                                },
                                {
                                    "type": "text",
                                    "text": " Hellow again"
                                }
                            ]
                        }
                    ]
                }
            ],
            "channel": "xxxxxxxxx",
            "event_ts": "1652383205.111139"
        },
        "type": "event_callback",
        "event_id": "xxxxxxxxx",
        "event_time": 1652383205,
        "authorizations": [
            {
                "enterprise_id": null,
                "team_id": "xxxxxxxxx",
                "user_id": "xxxxxxxxx",
                "is_bot": true,
                "is_enterprise_install": false
            }
        ],
        "is_ext_shared_channel": false,
        "event_context": "xxxxxxxxxxx"
    };
    http:Request req = new;
    req.setPayload(eventPayload.toJsonString());
    http:Response|error appMentionPayload = clientEndpoint->post("/", req);

    if (appMentionPayload is error) {
        test:assertFail(msg = "App mention event failed: " + appMentionPayload.message());
    } else {
        test:assertTrue(appMentionPayload.statusCode === 200 || appMentionPayload.statusCode === 201, msg = "expected a 200/201 status code. Found " + appMentionPayload.statusCode.toBalString());
        test:assertEquals(appMentionPayload.getTextPayload(), "200", msg = "");
    }

    int counter = 10;
    while (!appMentioned && counter >= 0) {
        runtime:sleep(1);
        counter -= 1;
    }
    test:assertTrue(appMentioned, msg = "expected an app mention notification");
}
