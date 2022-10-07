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
import ballerina/log;
import ballerina/mime;
import ballerina/url;

const string TWILIO_URL = "https://api.twilio.com";

@display {label: "Twilio", iconPath: "docs/icon.png"}
public class Listener {
    private http:Listener httpListener;
    private DispatcherService dispatcherService;
    private ListenerConfig config;
    private string serviceTypeStr = "";

    public function init(ListenerConfig config, int|http:Listener listenOn = 8090) returns error? {
        if listenOn is http:Listener {
            self.httpListener = listenOn;
        } else {
            self.httpListener = check new (listenOn);
        }
        self.dispatcherService = new DispatcherService();
        self.config = config;
    }

    public isolated function attach(GenericServiceType serviceRef, () attachPoint) returns @tainted error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        self.serviceTypeStr = serviceTypeStr;
        check self.dispatcherService.addServiceRef(serviceTypeStr, serviceRef);
    }

    public isolated function detach(GenericServiceType serviceRef) returns error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.removeServiceRef(serviceTypeStr);
    }

    public isolated function 'start() returns error? {
        check self.subscribe();
        check self.httpListener.attach(self.dispatcherService, ());
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is CallStatusService {
            return "CallStatusService";
        } else {
            return "SmsStatusService";
        }
    }

    private isolated function subscribe() returns error? {
        http:Client twilioClient = check new (TWILIO_URL, {
            auth: {
                username: self.config.accountSId,
                password: self.config.authToken
            }
        });
        string url = self.serviceTypeStr == "CallStatusService" ? "VoiceUrl" : "SmsUrl";
        string body = url + "=" + check url:encode(self.config.callbackURL, "UTF8");
        string path =
        string `/2010-04-01/Accounts/${self.config.accountSId}/IncomingPhoneNumbers/${self.config.phoneNumberSid}.json`;
        record {} _ = check twilioClient->post(path, body, mediaType = mime:APPLICATION_FORM_URLENCODED);
        log:printInfo("Webhook subscribed");
    }

}
