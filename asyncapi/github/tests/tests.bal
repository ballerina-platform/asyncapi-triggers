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

import ballerina/log;
import ballerina/http;

boolean webhookRegistrationNotified = false;
string webhookHookType = "";

boolean issueCreationNotified = false;
string issueTitle = "";

boolean issueLabeledNotified = false;
string issueLabels = "";

boolean issueAssignedNotified = false;
string issueAssignee = "";

boolean issueEditedNotified = false;
record {}? issueChanges = ();

int createdIssueNumber = -1;

boolean issueReopenedNotified = false;
boolean issueClosedNotified = false;
boolean issueLockedNotified = false;
string issueLockedReason = "";
boolean issueUnlockedNotified = false;
boolean issueUnassignedNotified = false;
string issueUnassigneeLogin = "";
boolean issueUnlabeledNotified = false;
string issueUnlabeledName = "";
boolean issueMilestonedNotified = false;
string issueMilestoneTitle = "";
boolean issueDemilestonedNotified = false;
boolean issuePinnedNotified = false;
boolean issueUnpinnedNotified = false;
boolean issueTransferredNotified = false;
boolean issueTypedNotified = false;
boolean issueUntypedNotified = false;
boolean issueDeletedNotified = false;

boolean issueCommentCreatedNotified = false;
string issueCommentBody = "";
boolean issueCommentEditedNotified = false;
record {}? issueCommentChanges = ();
boolean issueCommentDeletedNotified = false;
boolean issueCommentPinnedNotified = false;
boolean issueCommentUnpinnedNotified = false;

boolean prOpenedNotified = false;
string prTitle = "";
boolean prClosedNotified = false;
boolean prReopenedNotified = false;
boolean prEditedNotified = false;
record {}? prChanges = ();
boolean prLabeledNotified = false;
boolean prUnlabeledNotified = false;
boolean prAssignedNotified = false;
boolean prUnassignedNotified = false;
boolean prSynchronizeNotified = false;
boolean prReadyForReviewNotified = false;
boolean prConvertedToDraftNotified = false;
boolean prReviewRequestedNotified = false;
boolean prLockedNotified = false;
boolean prUnlockedNotified = false;

boolean pushNotified = false;
string pushRef = "";

boolean prReviewSubmittedNotified = false;
string prReviewState = "";
boolean prReviewEditedNotified = false;
record {}? prReviewChanges = ();
boolean prReviewDismissedNotified = false;

boolean releaseCreatedNotified = false;
string releaseTagName = "";
boolean releasePublishedNotified = false;
boolean releaseReleasedNotified = false;
boolean releasePrereleasedNotified = false;
boolean releaseUnpublishedNotified = false;
boolean releaseDeletedNotified = false;
boolean releaseEditedNotified = false;
record {}? releaseChanges = ();

boolean workflowRunRequestedNotified = false;
string workflowRunName = "";
boolean workflowRunInProgressNotified = false;
boolean workflowRunCompletedNotified = false;
string workflowRunConclusion = "";

boolean labelCreatedNotified = false;
string labelCreatedName = "";
boolean labelEditedNotified = false;
record {}? labelChanges = ();
boolean labelDeletedNotified = false;

boolean milestoneCreatedNotified = false;
string milestoneTitle = "";
boolean milestoneEditedNotified = false;
record {}? milestoneChanges = ();
boolean milestoneOpenedNotified = false;
boolean milestoneClosedNotified = false;
boolean milestoneDeletedNotified = false;

boolean prReviewCommentCreatedNotified = false;
string prReviewCommentBody = "";
boolean prReviewCommentEditedNotified = false;
record {}? prReviewCommentChanges = ();
boolean prReviewCommentDeletedNotified = false;

boolean dependabotAlertCreatedNotified = false;
string dependabotAlertPackageName = "";
boolean dependabotAlertDismissedNotified = false;
boolean dependabotAlertAutoDismissedNotified = false;
boolean dependabotAlertFixedNotified = false;
boolean dependabotAlertReopenedNotified = false;
boolean dependabotAlertAutoReopenedNotified = false;
boolean dependabotAlertReintroducedNotified = false;
boolean dependabotAlertAssigneesChangedNotified = false;

boolean checkRunCreatedNotified = false;
string checkRunName = "";
boolean checkRunCompletedNotified = false;
string checkRunConclusion = "";
boolean checkRunRerequestedNotified = false;
boolean checkRunRequestedActionNotified = false;

configurable string githubSecret = "q234";

listener Listener githubListener = new ({webhookSecret: githubSecret});

service IssuesService on githubListener {

    remote function onAssigned(IssuesEvent payload) returns error? {
       log:printInfo("Issue assigned");
       issueAssignedNotified = true;
       issueAssignee = payload.assignee?.login ?: "";
    }

    remote function onClosed(IssuesEvent payload) returns error? {
        log:printInfo("Issue closed");
        issueClosedNotified = true;
    }

    remote function onLabeled(IssuesEvent payload) returns error? {
        log:printInfo("Issue labeled");
        issueLabeledNotified = true;
        issueLabels = payload.label?.name ?: "";
    }

    remote function onOpened(IssuesEvent payload) returns error? {
        log:printInfo("Issue opened", notificationMsg = payload);
        issueCreationNotified = true;
        issueTitle = <@untainted> payload.issue.title;
    }

    remote function onReopened(IssuesEvent payload) returns error? {
        log:printInfo("Issue reopened");
        issueReopenedNotified = true;
    }

    remote function onUnassigned(IssuesEvent payload) returns error? {
        log:printInfo("Issue unassigned");
        issueUnassignedNotified = true;
        issueUnassigneeLogin = payload.assignee?.login ?: "";
    }

    remote function onUnlabeled(IssuesEvent payload) returns error? {
        log:printInfo("Issue unlabeled");
        issueUnlabeledNotified = true;
        issueUnlabeledName = payload.label?.name ?: "";
    }

    remote function onDeleted(IssuesEvent payload) returns error? {
        log:printInfo("Issue deleted");
        issueDeletedNotified = true;
    }

    remote function onDemilestoned(IssuesEvent payload) returns error? {
        log:printInfo("Issue demilestoned");
        issueDemilestonedNotified = true;
    }

    remote function onMilestoned(IssuesEvent payload) returns error? {
        log:printInfo("Issue milestoned");
        issueMilestonedNotified = true;
        issueMilestoneTitle = payload.milestone?.title ?: "";
    }

    remote function onPinned(IssuesEvent payload) returns error? {
        log:printInfo("Issue pinned");
        issuePinnedNotified = true;
    }

    remote function onUnpinned(IssuesEvent payload) returns error? {
        log:printInfo("Issue unpinned");
        issueUnpinnedNotified = true;
    }

    remote function onTransferred(IssuesEvent payload) returns error? {
        log:printInfo("Issue transferred");
        issueTransferredNotified = true;
    }

    remote function onTyped(IssuesEvent payload) returns error? {
        log:printInfo("Issue typed");
        issueTypedNotified = true;
    }

    remote function onUntyped(IssuesEvent payload) returns error? {
        log:printInfo("Issue untyped");
        issueUntypedNotified = true;
    }

    remote function onLocked(IssuesEvent payload) returns error? {
        log:printInfo("Issue locked");
        issueLockedNotified = true;
        issueLockedReason = payload.issue.active_lock_reason ?: "";
    }

    remote function onUnlocked(IssuesEvent payload) returns error? {
        log:printInfo("Issue unlocked");
        issueUnlockedNotified = true;
    }

    remote function onEdited(IssuesEvent payload) returns error? {
        log:printInfo("Issue edited");
        issueEditedNotified = true;
        issueChanges = payload.changes;
    }
}

service IssueCommentService on githubListener {

    remote function onCreated(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment created");
        issueCommentCreatedNotified = true;
        issueCommentBody = payload.comment.body;
    }

    remote function onEdited(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment edited");
        issueCommentEditedNotified = true;
        issueCommentChanges = payload.changes;
    }

    remote function onDeleted(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment deleted");
        issueCommentDeletedNotified = true;
    }

    remote function onPinned(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment pinned");
        issueCommentPinnedNotified = true;
    }

    remote function onUnpinned(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment unpinned");
        issueCommentUnpinnedNotified = true;
    }
}

service PullRequestService on githubListener {

    remote function onOpened(PullRequestEvent payload) returns error? {
        log:printInfo("PR opened");
        prOpenedNotified = true;
        prTitle = payload.pull_request.title;
    }

    remote function onClosed(PullRequestEvent payload) returns error? {
        log:printInfo("PR closed");
        prClosedNotified = true;
    }

    remote function onReopened(PullRequestEvent payload) returns error? {
        log:printInfo("PR reopened");
        prReopenedNotified = true;
    }

    remote function onEdited(PullRequestEvent payload) returns error? {
        log:printInfo("PR edited");
        prEditedNotified = true;
        prChanges = payload.changes;
    }

    remote function onLabeled(PullRequestEvent payload) returns error? {
        log:printInfo("PR labeled");
        prLabeledNotified = true;
    }

    remote function onUnlabeled(PullRequestEvent payload) returns error? {
        log:printInfo("PR unlabeled");
        prUnlabeledNotified = true;
    }

    remote function onAssigned(PullRequestEvent payload) returns error? {
        log:printInfo("PR assigned");
        prAssignedNotified = true;
    }

    remote function onUnassigned(PullRequestEvent payload) returns error? {
        log:printInfo("PR unassigned");
        prUnassignedNotified = true;
    }

    remote function onSynchronize(PullRequestEvent payload) returns error? {
        log:printInfo("PR synchronize");
        prSynchronizeNotified = true;
    }

    remote function onReadyForReview(PullRequestEvent payload) returns error? {
        log:printInfo("PR ready for review");
        prReadyForReviewNotified = true;
    }

    remote function onConvertedToDraft(PullRequestEvent payload) returns error? {
        log:printInfo("PR converted to draft");
        prConvertedToDraftNotified = true;
    }

    remote function onReviewRequested(PullRequestEvent payload) returns error? {
        log:printInfo("PR review requested");
        prReviewRequestedNotified = true;
    }

    remote function onLocked(PullRequestEvent payload) returns error? {
        log:printInfo("PR locked");
        prLockedNotified = true;
    }

    remote function onUnlocked(PullRequestEvent payload) returns error? {
        log:printInfo("PR unlocked");
        prUnlockedNotified = true;
    }

    remote function onEnqueued(PullRequestEvent payload) returns error? {}
    remote function onDequeued(PullRequestEvent payload) returns error? {}
    remote function onReviewRequestRemoved(PullRequestEvent payload) returns error? {}
    remote function onAutoMergeEnabled(PullRequestEvent payload) returns error? {}
    remote function onAutoMergeDisabled(PullRequestEvent payload) returns error? {}
    remote function onMilestoned(PullRequestEvent payload) returns error? {}
    remote function onDemilestoned(PullRequestEvent payload) returns error? {}
}

service DependabotAlertService on githubListener {

    remote function onCreated(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert created");
        dependabotAlertCreatedNotified = true;
        dependabotAlertPackageName = payload.alert.dependency?.package?.name ?: "";
    }

    remote function onDismissed(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert dismissed");
        dependabotAlertDismissedNotified = true;
    }

    remote function onAutoDismissed(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert auto-dismissed");
        dependabotAlertAutoDismissedNotified = true;
    }

    remote function onFixed(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert fixed");
        dependabotAlertFixedNotified = true;
    }

    remote function onReopened(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert reopened");
        dependabotAlertReopenedNotified = true;
    }

    remote function onAutoReopened(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert auto-reopened");
        dependabotAlertAutoReopenedNotified = true;
    }

    remote function onReintroduced(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert reintroduced");
        dependabotAlertReintroducedNotified = true;
    }

    remote function onAssigneesChanged(DependabotAlertEvent payload) returns error? {
        log:printInfo("Dependabot alert assignees changed");
        dependabotAlertAssigneesChangedNotified = true;
    }
}

service CheckRunService on githubListener {

    remote function onCreated(CheckRunEvent payload) returns error? {
        log:printInfo("Check run created");
        checkRunCreatedNotified = true;
        checkRunName = payload.check_run.name;
    }

    remote function onCompleted(CheckRunEvent payload) returns error? {
        log:printInfo("Check run completed");
        checkRunCompletedNotified = true;
        checkRunConclusion = payload.check_run.conclusion ?: "";
    }

    remote function onRerequested(CheckRunEvent payload) returns error? {
        log:printInfo("Check run rerequested");
        checkRunRerequestedNotified = true;
    }

    remote function onRequestedAction(CheckRunEvent payload) returns error? {
        log:printInfo("Check run requested action");
        checkRunRequestedActionNotified = true;
    }
}

service PullRequestReviewCommentService on githubListener {

    remote function onCreated(PullRequestReviewCommentEvent payload) returns error? {
        log:printInfo("PR review comment created");
        prReviewCommentCreatedNotified = true;
        prReviewCommentBody = payload.comment.body;
    }

    remote function onEdited(PullRequestReviewCommentEvent payload) returns error? {
        log:printInfo("PR review comment edited");
        prReviewCommentEditedNotified = true;
        prReviewCommentChanges = payload.changes;
    }

    remote function onDeleted(PullRequestReviewCommentEvent payload) returns error? {
        log:printInfo("PR review comment deleted");
        prReviewCommentDeletedNotified = true;
    }
}

service MilestoneService on githubListener {

    remote function onCreated(MilestoneEvent payload) returns error? {
        log:printInfo("Milestone created");
        milestoneCreatedNotified = true;
        milestoneTitle = payload.milestone.title ?: "";
    }

    remote function onEdited(MilestoneEvent payload) returns error? {
        log:printInfo("Milestone edited");
        milestoneEditedNotified = true;
        milestoneChanges = payload.changes;
    }

    remote function onOpened(MilestoneEvent payload) returns error? {
        log:printInfo("Milestone opened");
        milestoneOpenedNotified = true;
    }

    remote function onClosed(MilestoneEvent payload) returns error? {
        log:printInfo("Milestone closed");
        milestoneClosedNotified = true;
    }

    remote function onDeleted(MilestoneEvent payload) returns error? {
        log:printInfo("Milestone deleted");
        milestoneDeletedNotified = true;
    }
}

service LabelService on githubListener {

    remote function onCreated(LabelEvent payload) returns error? {
        log:printInfo("Label created");
        labelCreatedNotified = true;
        labelCreatedName = payload.label.name;
    }

    remote function onEdited(LabelEvent payload) returns error? {
        log:printInfo("Label edited");
        labelEditedNotified = true;
        labelChanges = payload.changes;
    }

    remote function onDeleted(LabelEvent payload) returns error? {
        log:printInfo("Label deleted");
        labelDeletedNotified = true;
    }
}

service WorkflowRunService on githubListener {

    remote function onRequested(WorkflowRunEvent payload) returns error? {
        log:printInfo("Workflow run requested");
        workflowRunRequestedNotified = true;
        workflowRunName = payload.workflow_run.name;
    }

    remote function onInProgress(WorkflowRunEvent payload) returns error? {
        log:printInfo("Workflow run in progress");
        workflowRunInProgressNotified = true;
    }

    remote function onCompleted(WorkflowRunEvent payload) returns error? {
        log:printInfo("Workflow run completed");
        workflowRunCompletedNotified = true;
        workflowRunConclusion = payload.workflow_run.conclusion ?: "";
    }
}

service ReleaseService on githubListener {

    remote function onCreated(ReleaseEvent payload) returns error? {
        log:printInfo("Release created");
        releaseCreatedNotified = true;
        releaseTagName = payload.release.tag_name;
    }

    remote function onPublished(ReleaseEvent payload) returns error? {
        log:printInfo("Release published");
        releasePublishedNotified = true;
    }

    remote function onReleased(ReleaseEvent payload) returns error? {
        log:printInfo("Release released");
        releaseReleasedNotified = true;
    }

    remote function onPrereleased(ReleaseEvent payload) returns error? {
        log:printInfo("Release prereleased");
        releasePrereleasedNotified = true;
    }

    remote function onUnpublished(ReleaseEvent payload) returns error? {
        log:printInfo("Release unpublished");
        releaseUnpublishedNotified = true;
    }

    remote function onDeleted(ReleaseEvent payload) returns error? {
        log:printInfo("Release deleted");
        releaseDeletedNotified = true;
    }

    remote function onEdited(ReleaseEvent payload) returns error? {
        log:printInfo("Release edited");
        releaseEditedNotified = true;
        releaseChanges = payload.changes;
    }
}

service PullRequestReviewService on githubListener {

    remote function onSubmitted(PullRequestReviewEvent payload) returns error? {
        log:printInfo("PR review submitted");
        prReviewSubmittedNotified = true;
        prReviewState = payload.review.state;
    }

    remote function onEdited(PullRequestReviewEvent payload) returns error? {
        log:printInfo("PR review edited");
        prReviewEditedNotified = true;
        prReviewChanges = payload.changes;
    }

    remote function onDismissed(PullRequestReviewEvent payload) returns error? {
        log:printInfo("PR review dismissed");
        prReviewDismissedNotified = true;
    }
}

service PushService on githubListener {

    remote function onPush(PushEvent payload) returns error? {
        log:printInfo("Push received");
        pushNotified = true;
        pushRef = payload.'ref;
    }
}

string createdIssueTitle = "This is a test issue";
string updatedIssueTitle = "Updated Issue Title";
string[] createdIssueLabelArray = ["bug", "critical"];

http:Client clientEndpoint = check new ("http://localhost:8090");
