// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerinax/asyncapi.native.handler;
import ballerina/crypto;

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
            return error("Cannot detach the service of type " + serviceType + ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns error? {
        json payload = check <@untainted> request.getJsonPayload();
        byte [] binaryPay = <@untainted>  payload.toString().toBytes();
        string eventName = check  request.getHeader("X-GitHub-Event");
        string secret = check  request.getHeader("X-Hub-Signature-256");
        string trimmedSecret = secret.substring(7, secret.length());
        byte [] output = check crypto:hmacSha256(binaryPay, self.listenerConfig.webhookSecret.toBytes());
        string computedDigest = output.toBase16();
        if (trimmedSecret.length() != computedDigest.length() || trimmedSecret !== computedDigest) {
            // Validate secret with X-Hub-Signature-256 header for intent verification
            log:printError("Signature verification failure");
            http:Response response = new;
            response.statusCode = http:STATUS_UNAUTHORIZED;
            response.setPayload("Signature verification failure");
            check caller->respond(response);
        } else {
            GenericDataType|error genericDataType = payload.cloneWithType(GenericDataType);
            if (genericDataType is error) {
                log:printError("Unsupported Event Type : " + eventName);
                return genericDataType;
            } else {
                check self.matchRemoteFunc(genericDataType, eventName);
                check caller->respond("Event acknoledged successfully");
            }
        }
    }

    private function matchRemoteFunc(anydata genericDataType, string eventName) returns error? {
        if (genericDataType is GenericDataType) {
            string actionName = genericDataType?.action.toString();
            match eventName {
                "issues" => {
                    match actionName {
                        "opened" => {
                            check self.executeRemoteFunc(genericDataType, "opened", "IssuesService", "onOpened");
                        }
                        "closed" => {
                            check self.executeRemoteFunc(genericDataType, "closed", "IssuesService", "onClosed");
                        }
                        "reopened" => {
                            check self.executeRemoteFunc(genericDataType, "reopened", "IssuesService", "onReopened");
                        }
                        "assigned" => {
                            check self.executeRemoteFunc(genericDataType, "assigned", "IssuesService", "onAssigned");
                        }
                        "unassigned" => {
                            check self.executeRemoteFunc(genericDataType, "unassigned", "IssuesService", "onUnassigned");
                        }
                        "labeled" => {
                            check self.executeRemoteFunc(genericDataType, "labeled", "IssuesService", "onLabeled");
                        }
                        "unlabeled" => {
                            check self.executeRemoteFunc(genericDataType, "unlabeled", "IssuesService", "onUnlabeled");
                        }
                    }
                }
                "issue_comment" => {
                    match actionName {
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "IssueCommentService", "onCreated");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "IssueCommentService", "onEdited");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "IssueCommentService", "onDeleted");
                        }
                    }
                }
                "pull_request" => {
                    match actionName {
                        "opened" => {
                            check self.executeRemoteFunc(genericDataType, "opened", "PullRequestService", "onOpened");
                        }
                        "closed" => {
                            check self.executeRemoteFunc(genericDataType, "closed", "PullRequestService", "onClosed");
                        }
                        "reopened" => {
                            check self.executeRemoteFunc(genericDataType, "reopened", "PullRequestService", "onReopened");
                        }
                        "assigned" => {
                            check self.executeRemoteFunc(genericDataType, "assigned", "PullRequestService", "onAssigned");
                        }
                        "unassigned" => {
                            check self.executeRemoteFunc(genericDataType, "unassigned", "PullRequestService", "onUnassigned");
                        }
                        "review_requested" => {
                            check self.executeRemoteFunc(genericDataType, "review_requested", "PullRequestService", "onReviewRequested");
                        }
                        "review_request_removed" => {
                            check self.executeRemoteFunc(genericDataType, "review_request_removed", "PullRequestService", "onReviewRequestRemoved");
                        }
                        "labeled" => {
                            check self.executeRemoteFunc(genericDataType, "labeled", "PullRequestService", "onLabeled");
                        }
                        "unlabeled" => {
                            check self.executeRemoteFunc(genericDataType, "unlabeled", "PullRequestService", "onUnlabeled");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "PullRequestService", "onEdited");
                        }
                    }
                }
                "pull_request_review" => {
                    match actionName {
                        "submitted" => {
                            check self.executeRemoteFunc(genericDataType, "submitted", "PullRequestReviewService", "onSubmitted");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "PullRequestReviewService", "onEdited");
                        }
                        "dismissed" => {
                            check self.executeRemoteFunc(genericDataType, "dismissed", "PullRequestReviewService", "onDismissed");
                        }
                    }
                }
                "pull_request_review_comment" => {
                    match actionName {
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "PullRequestReviewCommentService", "onCreated");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "PullRequestReviewCommentService", "onEdited");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "PullRequestReviewCommentService", "onDeleted");
                        }
                    }
                }
                "release" => {
                    match actionName {
                        "published" => {
                            check self.executeRemoteFunc(genericDataType, "published", "ReleaseService", "onPublished");
                        }
                        "unpublished" => {
                            check self.executeRemoteFunc(genericDataType, "unpublished", "ReleaseService", "onUnpublished");
                        }
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "ReleaseService", "onCreated");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "ReleaseService", "onEdited");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "ReleaseService", "onDeleted");
                        }
                        "pre_released" => {
                            check self.executeRemoteFunc(genericDataType, "pre_released", "ReleaseService", "onPreReleased");
                        }
                        "released" => {
                            check self.executeRemoteFunc(genericDataType, "released", "ReleaseService", "onReleased");
                        }
                    }
                }
                "label" => {
                    match actionName {
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "LabelService", "onCreated");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "LabelService", "onEdited");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "LabelService", "onDeleted");
                        }
                    }
                }
                "milestone" => {
                    match actionName {
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "MilestoneService", "onCreated");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "MilestoneService", "onEdited");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "MilestoneService", "onDeleted");
                        }
                        "closed" => {
                            check self.executeRemoteFunc(genericDataType, "closed", "MilestoneService", "onClosed");
                        }
                        "opened" => {
                            check self.executeRemoteFunc(genericDataType, "opened", "MilestoneService", "onOpened");
                        }
                    }
                }
                "push" => {
                    check self.executeRemoteFunc(genericDataType, "pushed", "PushService", "onPush");
                }
                "project_card" => {
                    match actionName {
                        "created" => {
                            check self.executeRemoteFunc(genericDataType, "created", "ProjectCardService", "onCreate");
                        }
                        "edited" => {
                            check self.executeRemoteFunc(genericDataType, "edited", "ProjectCardService", "onEdit");
                        }
                        "moved" => {
                            check self.executeRemoteFunc(genericDataType, "moved", "ProjectCardService", "onMove");
                        }
                        "converted" => {
                            check self.executeRemoteFunc(genericDataType, "converted", "ProjectCardService", "onConvert");
                        }
                        "deleted" => {
                            check self.executeRemoteFunc(genericDataType, "deleted", "ProjectCardService", "onDelete");
                        }
                    }
                }
            }
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
