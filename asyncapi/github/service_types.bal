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

# Actions related to an issue. Available methods are onOpened, onClosed, 
# onReopened, onAssigned, onUnassigned, onLabeled and onUnlabeled
public type IssuesService service object {
    remote function onOpened(IssuesEvent payload) returns error?;
    remote function onClosed(IssuesEvent payload) returns error?;
    remote function onReopened(IssuesEvent payload) returns error?;
    remote function onAssigned(IssuesEvent payload) returns error?;
    remote function onUnassigned(IssuesEvent payload) returns error?;
    remote function onLabeled(IssuesEvent payload) returns error?;
    remote function onUnlabeled(IssuesEvent payload) returns error?;
};

# Actions related to an issue or pull request comment.
# Available methods are onCreated, onEdited and onDeleted
public type IssueCommentService service object {
    remote function onCreated(IssueCommentEvent payload) returns error?;
    remote function onEdited(IssueCommentEvent payload) returns error?;
    remote function onDeleted(IssueCommentEvent payload) returns error?;
};

# Actions related to an issue or pull request comment. Available methods are onOpened, 
# onClosed, onReopened, onAssigned, onUnassigned, onReviewRequested, onReviewRequestRemoved, 
# onLabeled, onUnlabeled and onEdited
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

# Actions related to pull request reviews. Available methods are onSubmitted, onEdited and onDismissed
public type PullRequestReviewService service object {
    remote function onSubmitted(PullRequestReviewEvent payload) returns error?;
    remote function onEdited(PullRequestReviewEvent payload) returns error?;
    remote function onDismissed(PullRequestReviewEvent payload) returns error?;
};

# Actions related to pull request review comments in the pull request's unified diff. 
# Available methods are onCreated, onEdited and onDeleted
public type PullRequestReviewCommentService service object {
    remote function onCreated(PullRequestReviewCommentEvent payload) returns error?;
    remote function onEdited(PullRequestReviewCommentEvent payload) returns error?;
    remote function onDeleted(PullRequestReviewCommentEvent payload) returns error?;
};

# Actions related to a release. Available methods are onPublished, onUnpublished, 
# onCreated, onEdited, onDeleted, onPreReleased and onReleased
public type ReleaseService service object {
    remote function onPublished(ReleaseEvent payload) returns error?;
    remote function onUnpublished(ReleaseEvent payload) returns error?;
    remote function onCreated(ReleaseEvent payload) returns error?;
    remote function onEdited(ReleaseEvent payload) returns error?;
    remote function onDeleted(ReleaseEvent payload) returns error?;
    remote function onPreReleased(ReleaseEvent payload) returns error?;
    remote function onReleased(ReleaseEvent payload) returns error?;
};

# Actions related to a label. Available methods are onCreated, onEdited and onDeleted
public type LabelService service object {
    remote function onCreated(LabelEvent payload) returns error?;
    remote function onEdited(LabelEvent payload) returns error?;
    remote function onDeleted(LabelEvent payload) returns error?;
};

# Actions related to milestones. Available methods are onCreated, onEdited, onDeleted, onClosed and onOpened
public type MilestoneService service object {
    remote function onCreated(MilestoneEvent payload) returns error?;
    remote function onEdited(MilestoneEvent payload) returns error?;
    remote function onDeleted(MilestoneEvent payload) returns error?;
    remote function onClosed(MilestoneEvent payload) returns error?;
    remote function onOpened(MilestoneEvent payload) returns error?;
};

# Actions related to push events. Available methods is onPush
public type PushService service object {
    remote function onPush(PushEvent payload) returns error?;
};

# Actions related to project cards. Available methods are onCreated, onEdited, onMoved, onConverted and onDeleted
public type ProjectCardService service object {
    remote function onCreated(ProjectCardEvent payload) returns error?;
    remote function onEdited(ProjectCardEvent payload) returns error?;
    remote function onMoved(ProjectCardEvent payload) returns error?;
    remote function onConverted(ProjectCardEvent payload) returns error?;
    remote function onDeleted(ProjectCardEvent payload) returns error?;
};

public type GenericServiceType IssuesService|IssueCommentService|PullRequestService|PullRequestReviewService|PullRequestReviewCommentService|ReleaseService|LabelService|MilestoneService|PushService|ProjectCardService;
