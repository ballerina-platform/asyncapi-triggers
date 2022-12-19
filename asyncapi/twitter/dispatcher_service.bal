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

import ballerina/crypto;
import ballerina/http;
import ballerina/log;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private ListenerConfig listenerConfig;

    public function init(ListenerConfig listenerConfig) {
        self.listenerConfig = listenerConfig;
    }

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error("Service of type " + serviceType + " has already been attached");
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error("Cannot detach the service of type " + serviceType 
                    + ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post webhook/twitter(http:Caller caller, http:Request request) returns error? {
        byte[] binaryPayload = check request.getBinaryPayload();
        json payload = check request.getJsonPayload();
        map<json> payloadMap = <map<json>> payload;
        if (request.hasHeader("X-Twitter-Webhooks-Signature")) {
            string hmacHeader = check  request.getHeader("X-Twitter-Webhooks-Signature");
            byte [] output = check crypto:hmacSha256(binaryPayload, self.listenerConfig.apiSecret.toBytes());
            string computedHmac = output.toBase64();
            string trimmedHeader = hmacHeader.substring(7, hmacHeader.length());
            if (computedHmac != trimmedHeader) {
                // Validate secret with X-Twitter-Webhooks-Signature header for intent verification
                log:printError("Signature verification failure");
                return caller->respond(http:STATUS_UNAUTHORIZED);
            }
        }
        check self.matchRemoteFunc(payloadMap);
        return caller->respond(http:STATUS_OK);
    }

    private function matchRemoteFunc(map<json> payloadMap) returns error? {
        GenericDataType genericDataType = check payloadMap.cloneWithType(GenericDataType);
        if payloadMap.hasKey("tweet_create_events") {
            check self.executeRemoteFunc(genericDataType, "tweets/create", "TweetsService", "onTweetsCreate");
        } else if (payloadMap.hasKey("tweet_delete_events")) { 
            check self.executeRemoteFunc(genericDataType, "tweets/delete", "TweetsService", "onTweetsDelete");
        } else if (payloadMap.hasKey("follow_events")) { 
            check self.executeRemoteFunc(genericDataType, "tweets/follow", "TweetsService", "onFollow");
        } else if (payloadMap.hasKey("favorite_events")) { 
            check self.executeRemoteFunc(genericDataType, "tweets/favorite", "TweetsService", "onFavorite");
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];    
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
