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
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error("Service of type " + serviceType + " has already been attached");
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error("Cannot detach the service of type " + serviceType + ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    resource function post .(http:Caller caller, http:Request request) returns error? {
        map<string> payload = check request.getFormParams();
        error? matchRemoteFuncResult = self.matchRemoteFunc(payload);
        if matchRemoteFuncResult is error {
            return matchRemoteFuncResult;
        } else {
            check caller->respond("Event acknowledged successfully");
        }
    }

    private function matchRemoteFunc(map<string> payload) returns error? {
        if (payload.hasKey("CallStatus")) {
            CallStatusEventWrapper eventPayload = check payload.cloneWithType(CallStatusEventWrapper);
            string? CallStatus = eventPayload?.CallStatus;
            match CallStatus.toString() {
                "queued" => {
                    check self.executeRemoteFunc(eventPayload, "queued", "CallStatusService", "onQueued");
                }
                "ringing" => {
                    check self.executeRemoteFunc(eventPayload, "ringing", "CallStatusService", "onRinging");
                }
                "in-progress" => {
                    check self.executeRemoteFunc(eventPayload, "in-progress", "CallStatusService", "onInProgress");
                }
                "completed" => {
                    check self.executeRemoteFunc(eventPayload, "completed", "CallStatusService", "onCompleted");
                }
                "busy" => {
                    check self.executeRemoteFunc(eventPayload, "busy", "CallStatusService", "onBusy");
                }
                "failed" => {
                    check self.executeRemoteFunc(eventPayload, "failed", "CallStatusService", "onFailed");
                }
                "no-answer" => {
                    check self.executeRemoteFunc(eventPayload, "no-answer", "CallStatusService", "onNoAnswer");
                }
                "canceled" => {
                    check self.executeRemoteFunc(eventPayload, "canceled", "CallStatusService", "onCanceled");
                }
                _ => {
                    return error("Invalid payload or an event type that twilio trigger currenlty does not support");
                }
            }
            return;
        } else if (payload.hasKey("SmsStatus")) {
            SmsStatusChangeEventWrapper eventPayload = check payload.cloneWithType(SmsStatusChangeEventWrapper);
            string? SmsStatus = eventPayload?.SmsStatus;
            match SmsStatus.toString() {

                "accepted" => {
                    check self.executeRemoteFunc(eventPayload, "accepted", "SmsStatusService", "onAccepted");
                }
                "queued" => {
                    check self.executeRemoteFunc(eventPayload, "queued", "SmsStatusService", "onQueued");
                }
                "sending" => {
                    check self.executeRemoteFunc(eventPayload, "sending", "SmsStatusService", "onSending");
                }
                "sent" => {
                    check self.executeRemoteFunc(eventPayload, "sent", "SmsStatusService", "onSent");
                }
                "failed" => {
                    check self.executeRemoteFunc(eventPayload, "failed", "SmsStatusService", "onFailed");
                }
                "delivered" => {
                    check self.executeRemoteFunc(eventPayload, "delivered", "SmsStatusService", "onDelivered");
                }
                "undelivered" => {
                    check self.executeRemoteFunc(eventPayload, "undelivered", "SmsStatusService", "onUndelivered");
                }
                "receiving" => {
                    check self.executeRemoteFunc(eventPayload, "receiving", "SmsStatusService", "onReceiving");
                }
                "received" => {
                    check self.executeRemoteFunc(eventPayload, "received", "SmsStatusService", "onReceived");
                }
                _ => {
                    return error(" Invalid event type that twilio currenlty does not support");
                }
            }
            return;
        } else {
            return error(" Invalid payload or an event type that twilio trigger currenlty does not support");
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
