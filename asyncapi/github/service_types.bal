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

public type IssuesService service object {
    remote function onOpened(IssuesEvent payload) returns error?;
    remote function onClosed(IssuesEvent payload) returns error?;
    remote function onReopened(IssuesEvent payload) returns error?;
    remote function onAssigned(IssuesEvent payload) returns error?;
    remote function onUnassigned(IssuesEvent payload) returns error?;
    remote function onLabeled(IssuesEvent payload) returns error?;
    remote function onUnlabeled(IssuesEvent payload) returns error?;
};

public type IssueCommentService service object {
    remote function onCreated(IssueCommentEvent payload) returns error?;
    remote function onEdited(IssueCommentEvent payload) returns error?;
    remote function onDeleted(IssueCommentEvent payload) returns error?;
};

public type PullRequestService service object {
    remote function onOpened(PullRequestEvent payload) returns error?;
    remote function onClosed(PullRequestEvent payload) returns error?;
    remote function onReopened(PullRequestEvent payload) returns error?;
    remote function onAssigned(PullRequestEvent payload) returns error?;
    remote function onUnassigned(PullRequestEvent payload) returns error?;
    remote function onReviewRequested(PullRequestEvent payload) returns error?;
    remote function onReviewRequestRemoved(PullRequestEvent payload) returns error?;
    remote function onLabeled(PullRequestEvent payload) returns error?;
    remote function onUnlabeled(PullRequestEvent payload) returns error?;
    remote function onEdited(PullRequestEvent payload) returns error?;
};

public type PullRequestReviewService service object {
    remote function onSubmitted(PullRequestReviewEvent payload) returns error?;
    remote function onEdited(PullRequestReviewEvent payload) returns error?;
    remote function onDismissed(PullRequestReviewEvent payload) returns error?;
};

public type PullRequestReviewCommentService service object {
    remote function onCreated(PullRequestReviewCommentEvent payload) returns error?;
    remote function onEdited(PullRequestReviewCommentEvent payload) returns error?;
    remote function onDeleted(PullRequestReviewCommentEvent payload) returns error?;
};


public type ReleaseService service object {
    remote function onPublished(ReleaseEvent payload) returns error?;
    remote function onUnpublished(ReleaseEvent payload) returns error?;
    remote function onCreated(ReleaseEvent payload) returns error?;
    remote function onEdited(ReleaseEvent payload) returns error?;
    remote function onDeleted(ReleaseEvent payload) returns error?;
    remote function onPreReleased(ReleaseEvent payload) returns error?;
    remote function onReleased(ReleaseEvent payload) returns error?;
};

public type LabelService service object {
    remote function onCreated(LabelEvent payload) returns error?;
    remote function onEdited(LabelEvent payload) returns error?;
    remote function onDeleted(LabelEvent payload) returns error?;
};

public type MilestoneService service object {
    remote function onCreated(MilestoneEvent payload) returns error?;
    remote function onEdited(MilestoneEvent payload) returns error?;
    remote function onDeleted(MilestoneEvent payload) returns error?;
    remote function onClosed(MilestoneEvent payload) returns error?;
    remote function onOpened(MilestoneEvent payload) returns error?;
};

public type PushService service object {
    remote function onPush(PushEvent payload) returns error?;
};

public type GenericServiceType IssuesService|IssueCommentService|PullRequestService|PullRequestReviewService|PullRequestReviewCommentService|ReleaseService|LabelService|MilestoneService|PushService;
