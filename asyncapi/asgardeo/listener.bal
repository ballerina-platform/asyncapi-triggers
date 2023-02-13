// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/cloud;
import ballerina/crypto;
import ballerina/http;
import ballerina/websub;

@display {label: "Asgardeo", iconPath: "docs/icon.png"}
public class Listener {
    private websub:Listener websubListener;
    private DispatcherService dispatcherService;
    private ListenerConfig config;
    private http:ClientConfiguration httpConfig = {};
    private string[] topics = [];

    public function init(ListenerConfig listenerConfig, @cloud:Expose int|http:Listener listenOn = 8090) returns error? {
        self.websubListener = check new (listenOn);
        self.config = listenerConfig;
        self.dispatcherService = new DispatcherService();
        string token = check fetchToken(listenerConfig.tokenEndpointHost, listenerConfig.clientId, listenerConfig.clientSecret);
        http:ClientConfiguration httpConfig = {
            auth: {
                token: token
            }
        };
        self.httpConfig = httpConfig;
        KeyData decryptionKey = check fetchDecryptionKey(self.config.keyServiceURL, token, listenerConfig.organization, 0);
        self.dispatcherService.setOrgInfo(decryptionKey.key, decryptionKey.algo, token, listenerConfig);
    }

    private isolated function getMd5Hash(string str) returns string {
        byte[] input = str.toBytes();
        byte[] output = crypto:hashMd5(input);
        return output.toBase16();
    }

    public isolated function attach(GenericServiceType serviceRef, () attachPoint) returns @tainted error? {
        self.topics.push(self.getTopic(serviceRef));
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.addServiceRef(serviceTypeStr, serviceRef);
    }

    public isolated function detach(GenericServiceType serviceRef) returns error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.removeServiceRef(serviceTypeStr);
    }

    public isolated function 'start() returns error? {
        string hubSecret = self.getMd5Hash(self.config.callbackURL);
        websub:SubscriberServiceConfiguration subConfig = {
            target: [self.config.hubURL, self.topics[0]],
            callback: self.config.callbackURL,
            appendServicePath: false,
            secret: hubSecret,
            httpConfig: self.httpConfig
        };
        check self.websubListener.attachWithConfig(self.dispatcherService, subConfig);
        return self.websubListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.websubListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.websubListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is RegistrationService {
            return "RegistrationService";
        } else if serviceRef is UserOperationService {
            return "UserOperationService";
        } else if serviceRef is NotificationService {
            return "NotificationService";
        } else {
            return "LoginService";
        }
    }

    private isolated function getTopic(GenericServiceType serviceRef) returns string {
        string base = string `${self.config.organization}-`;
        if serviceRef is RegistrationService {
            return base + "REGISTRATIONS";
        } else if serviceRef is UserOperationService {
            return base + "USER_OPERATIONS";
        } else if serviceRef is NotificationService {
            return base + "NOTIFICATIONS";
        } else {
            return base + "LOGINS";
        }
    }
}
