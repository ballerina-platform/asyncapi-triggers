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

import ballerina/cloud;
import ballerina/uuid;
import ballerina/websub;

const string GITHUB_REST_API_BASE_URL = "https://api.github.com";
const string HUB = "https://api.github.com/hub";

@display {label: "GitHub", iconPath: "docs/icon.png"}
public class Listener {
    private DispatcherService dispatcherService;
    private websub:Listener websubListener;
    private websub:SubscriberServiceConfiguration websubConfig = {};
    private string token;

    public function init(ListenerConfig config, @cloud:Expose int listenOn = 8090) returns error? {
        self.websubListener = check new (listenOn);
        self.dispatcherService = new DispatcherService();
        self.websubConfig = {
            target: [HUB, config.topic],
            callback: config.callbackURL,
            secret: uuid:createType1AsString(),
            httpConfig: {
                auth: {
                    token: config.token
                }
            }
        };
        self.token = config.token;
    }

    public isolated function attach(GenericServiceType serviceRef, () attachPoint) returns @tainted error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.addServiceRef(serviceTypeStr, serviceRef);
    }

    public isolated function detach(GenericServiceType serviceRef) returns error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.removeServiceRef(serviceTypeStr);
    }

    public isolated function 'start() returns error? {
        check self.websubListener.attachWithConfig(self.dispatcherService, self.websubConfig);
        return self.websubListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.websubListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.websubListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is IssuesService {
            return "IssuesService";
        } else if serviceRef is IssueCommentService {
            return "IssueCommentService";
        } else if serviceRef is PullRequestService {
            return "PullRequestService";
        } else if serviceRef is PullRequestReviewService {
            return "PullRequestReviewService";
        } else if serviceRef is PullRequestReviewCommentService {
            return "PullRequestReviewCommentService";
        } else if serviceRef is ReleaseService {
            return "ReleaseService";
        } else if serviceRef is LabelService {
            return "LabelService";
        } else if serviceRef is MilestoneService {
            return "MilestoneService";
        } else if serviceRef is ProjectCardService {
            return "ProjectCardService";
        } else {
            return "PushService";
        }

    }

}

const string DEFAULT_SECRET = "";
