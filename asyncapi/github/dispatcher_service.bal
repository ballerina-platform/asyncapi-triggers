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

import ballerina/crypto;
import ballerina/http;
import ballerina/lang.regexp;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string webhookSecret;

    function init(string webhookSecret) {
        self.webhookSecret = webhookSecret;
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

    resource function post .(http:Caller caller, http:Request request) returns error? {
        error? verifyResult = self.verifyWebhookSignature(request, self.webhookSecret);
        if verifyResult is error {
            http:Response r = new;
            r.statusCode = http:STATUS_UNAUTHORIZED;
            check caller->respond(r);
            return;
        }
        json payload = check request.getJsonPayload();
        string eventType = check request.getHeader("X-GitHub-Event");
        string eventIdentifier = eventType;
        json|error actionField = payload.action;
        if actionField is json && actionField != () {
            eventIdentifier = eventType + "_" + actionField.toString();
        }
        GenericDataType genericDataType = check payload.cloneWithType(GenericDataType);
        check self.matchRemoteFunc(genericDataType, eventIdentifier, eventType);
        check caller->respond(http:STATUS_OK);
    }

    private function verifyWebhookSignature(http:Request request, string webhookSecret) returns error? {
        if !request.hasHeader("X-Hub-Signature-256") {
            return error("Unauthorized");
        }
        string signature = check request.getHeader("X-Hub-Signature-256");
        byte[] binaryPay = check request.getBinaryPayload();
        string[] parts = regexp:split(re`=`, signature);
        if parts.length() < 2 {
            return error("Unauthorized");
        }
        string algorithm = parts[0];
        byte[] computedHmac;
        string expected;
        if algorithm == "sha256" {
            computedHmac = check crypto:hmacSha256(binaryPay, webhookSecret.toBytes());
            expected = "sha256=" + computedHmac.toBase16();
        } else if algorithm == "sha1" {
            computedHmac = check crypto:hmacSha1(binaryPay, webhookSecret.toBytes());
            expected = "sha1=" + computedHmac.toBase16();
        } else if algorithm == "sha384" {
            computedHmac = check crypto:hmacSha384(binaryPay, webhookSecret.toBytes());
            expected = "sha384=" + computedHmac.toBase16();
        } else if algorithm == "sha512" {
            computedHmac = check crypto:hmacSha512(binaryPay, webhookSecret.toBytes());
            expected = "sha512=" + computedHmac.toBase16();
        } else {
            return error("Unauthorized");
        }
        if !crypto:equalConstantTime(signature.toBytes(), expected.toBytes()) {
            return error("Unauthorized");
        }
        return;
    }

    private function matchRemoteFunc(GenericDataType genericDataType, string eventIdentifier, string eventType) returns error? {
        match eventType {
            "delete" => { check self.matchRemoteFuncForDelete(genericDataType, eventIdentifier); }
            "meta" => { check self.matchRemoteFuncForMeta(genericDataType, eventIdentifier); }
            "workflow_dispatch" => { check self.matchRemoteFuncForWorkflowDispatch(genericDataType, eventIdentifier); }
            "security_and_analysis" => { check self.matchRemoteFuncForSecurityAndAnalysis(genericDataType, eventIdentifier); }
            "deploy_key" => { check self.matchRemoteFuncForDeployKey(genericDataType, eventIdentifier); }
            "project_column" => { check self.matchRemoteFuncForProjectColumn(genericDataType, eventIdentifier); }
            "marketplace_purchase" => { check self.matchRemoteFuncForMarketplacePurchase(genericDataType, eventIdentifier); }
            "branch_protection_configuration" => { check self.matchRemoteFuncForBranchProtectionConfiguration(genericDataType, eventIdentifier); }
            "pull_request" => { check self.matchRemoteFuncForPullRequest(genericDataType, eventIdentifier); }
            "label" => { check self.matchRemoteFuncForLabel(genericDataType, eventIdentifier); }
            "deployment" => { check self.matchRemoteFuncForDeployment(genericDataType, eventIdentifier); }
            "team_add" => { check self.matchRemoteFuncForTeamAdd(genericDataType, eventIdentifier); }
            "code_scanning_alert" => { check self.matchRemoteFuncForCodeScanningAlert(genericDataType, eventIdentifier); }
            "membership" => { check self.matchRemoteFuncForMembership(genericDataType, eventIdentifier); }
            "secret_scanning_alert" => { check self.matchRemoteFuncForSecretScanningAlert(genericDataType, eventIdentifier); }
            "push" => { check self.matchRemoteFuncForPush(genericDataType, eventIdentifier); }
            "member" => { check self.matchRemoteFuncForMember(genericDataType, eventIdentifier); }
            "repository_dispatch" => { check self.matchRemoteFuncForRepositoryDispatch(genericDataType, eventIdentifier); }
            "status" => { check self.matchRemoteFuncForStatus(genericDataType, eventIdentifier); }
            "repository_import" => { check self.matchRemoteFuncForRepositoryImport(genericDataType, eventIdentifier); }
            "personal_access_token_request" => { check self.matchRemoteFuncForPersonalAccessTokenRequest(genericDataType, eventIdentifier); }
            "sub_issues" => { check self.matchRemoteFuncForSubIssues(genericDataType, eventIdentifier); }
            "repository_ruleset" => { check self.matchRemoteFuncForRepositoryRuleset(genericDataType, eventIdentifier); }
            "milestone" => { check self.matchRemoteFuncForMilestone(genericDataType, eventIdentifier); }
            "public" => { check self.matchRemoteFuncForPublic(genericDataType, eventIdentifier); }
            "workflow_run" => { check self.matchRemoteFuncForWorkflowRun(genericDataType, eventIdentifier); }
            "projects_v2_status_update" => { check self.matchRemoteFuncForProjectsV2statusUpdate(genericDataType, eventIdentifier); }
            "projects_v2_item" => { check self.matchRemoteFuncForProjectsV2item(genericDataType, eventIdentifier); }
            "sponsorship" => { check self.matchRemoteFuncForSponsorship(genericDataType, eventIdentifier); }
            "merge_group" => { check self.matchRemoteFuncForMergeGroup(genericDataType, eventIdentifier); }
            "project" => { check self.matchRemoteFuncForProject(genericDataType, eventIdentifier); }
            "org_block" => { check self.matchRemoteFuncForOrgBlock(genericDataType, eventIdentifier); }
            "secret_scanning_alert_location" => { check self.matchRemoteFuncForSecretScanningAlertLocation(genericDataType, eventIdentifier); }
            "installation_target" => { check self.matchRemoteFuncForInstallationTarget(genericDataType, eventIdentifier); }
            "check_suite" => { check self.matchRemoteFuncForCheckSuite(genericDataType, eventIdentifier); }
            "ping" => { check self.matchRemoteFuncForPing(genericDataType, eventIdentifier); }
            "issue_comment" => { check self.matchRemoteFuncForIssueComment(genericDataType, eventIdentifier); }
            "security_advisory" => { check self.matchRemoteFuncForSecurityAdvisory(genericDataType, eventIdentifier); }
            "package" => { check self.matchRemoteFuncForPackage(genericDataType, eventIdentifier); }
            "discussion" => { check self.matchRemoteFuncForDiscussion(genericDataType, eventIdentifier); }
            "fork" => { check self.matchRemoteFuncForFork(genericDataType, eventIdentifier); }
            "pull_request_review" => { check self.matchRemoteFuncForPullRequestReview(genericDataType, eventIdentifier); }
            "organization" => { check self.matchRemoteFuncForOrganization(genericDataType, eventIdentifier); }
            "issues" => { check self.matchRemoteFuncForIssues(genericDataType, eventIdentifier); }
            "registry_package" => { check self.matchRemoteFuncForRegistryPackage(genericDataType, eventIdentifier); }
            "projects_v2" => { check self.matchRemoteFuncForProjectsV2(genericDataType, eventIdentifier); }
            "repository_vulnerability_alert" => { check self.matchRemoteFuncForRepositoryVulnerabilityAlert(genericDataType, eventIdentifier); }
            "star" => { check self.matchRemoteFuncForStar(genericDataType, eventIdentifier); }
            "create" => { check self.matchRemoteFuncForCreate(genericDataType, eventIdentifier); }
            "deployment_review" => { check self.matchRemoteFuncForDeploymentReview(genericDataType, eventIdentifier); }
            "gollum" => { check self.matchRemoteFuncForGollum(genericDataType, eventIdentifier); }
            "github_app_authorization" => { check self.matchRemoteFuncForGithubAppAuthorization(genericDataType, eventIdentifier); }
            "watch" => { check self.matchRemoteFuncForWatch(genericDataType, eventIdentifier); }
            "team" => { check self.matchRemoteFuncForTeam(genericDataType, eventIdentifier); }
            "workflow_job" => { check self.matchRemoteFuncForWorkflowJob(genericDataType, eventIdentifier); }
            "release" => { check self.matchRemoteFuncForRelease(genericDataType, eventIdentifier); }
            "installation" => { check self.matchRemoteFuncForInstallation(genericDataType, eventIdentifier); }
            "commit_comment" => { check self.matchRemoteFuncForCommitComment(genericDataType, eventIdentifier); }
            "discussion_comment" => { check self.matchRemoteFuncForDiscussionComment(genericDataType, eventIdentifier); }
            "branch_protection_rule" => { check self.matchRemoteFuncForBranchProtectionRule(genericDataType, eventIdentifier); }
            "issue_dependencies" => { check self.matchRemoteFuncForIssueDependencies(genericDataType, eventIdentifier); }
            "repository" => { check self.matchRemoteFuncForRepository(genericDataType, eventIdentifier); }
            "pull_request_review_comment" => { check self.matchRemoteFuncForPullRequestReviewComment(genericDataType, eventIdentifier); }
            "deployment_protection_rule" => { check self.matchRemoteFuncForDeploymentProtectionRule(genericDataType, eventIdentifier); }
            "custom_property_values" => { check self.matchRemoteFuncForCustomPropertyValues(genericDataType, eventIdentifier); }
            "installation_repositories" => { check self.matchRemoteFuncForInstallationRepositories(genericDataType, eventIdentifier); }
            "secret_scanning_scan" => { check self.matchRemoteFuncForSecretScanningScan(genericDataType, eventIdentifier); }
            "project_card" => { check self.matchRemoteFuncForProjectCard(genericDataType, eventIdentifier); }
            "check_run" => { check self.matchRemoteFuncForCheckRun(genericDataType, eventIdentifier); }
            "page_build" => { check self.matchRemoteFuncForPageBuild(genericDataType, eventIdentifier); }
            "custom_property" => { check self.matchRemoteFuncForCustomProperty(genericDataType, eventIdentifier); }
            "dependabot_alert" => { check self.matchRemoteFuncForDependabotAlert(genericDataType, eventIdentifier); }
            "deployment_status" => { check self.matchRemoteFuncForDeploymentStatus(genericDataType, eventIdentifier); }
            "repository_advisory" => { check self.matchRemoteFuncForRepositoryAdvisory(genericDataType, eventIdentifier); }
            "pull_request_review_thread" => { check self.matchRemoteFuncForPullRequestReviewThread(genericDataType, eventIdentifier); }
        }
    }

    private function matchRemoteFuncForDelete(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "delete" => {
                check self.executeRemoteFunc(genericDataType, "delete", "DeleteService", "onDelete");
            }
        }
    }

    private function matchRemoteFuncForMeta(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "meta" => {
                check self.executeRemoteFunc(genericDataType, "meta", "MetaService", "onMeta");
            }
        }
    }

    private function matchRemoteFuncForWorkflowDispatch(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "workflow_dispatch" => {
                check self.executeRemoteFunc(genericDataType, "workflow_dispatch", "WorkflowDispatchService", "onWorkflowDispatch");
            }
        }
    }

    private function matchRemoteFuncForSecurityAndAnalysis(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "security_and_analysis" => {
                check self.executeRemoteFunc(genericDataType, "security_and_analysis", "SecurityAndAnalysisService", "onSecurityAndAnalysis");
            }
        }
    }

    private function matchRemoteFuncForDeployKey(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "deploy_key_created" => {
                check self.executeRemoteFunc(genericDataType, "deploy_key_created", "DeployKeyService", "onCreated");
            }
            "deploy_key_deleted" => {
                check self.executeRemoteFunc(genericDataType, "deploy_key_deleted", "DeployKeyService", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForProjectColumn(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "project_column_moved" => {
                check self.executeRemoteFunc(genericDataType, "project_column_moved", "ProjectColumnService", "onMoved");
            }
            "project_column_edited" => {
                check self.executeRemoteFunc(genericDataType, "project_column_edited", "ProjectColumnService", "onEdited");
            }
            "project_column_deleted" => {
                check self.executeRemoteFunc(genericDataType, "project_column_deleted", "ProjectColumnService", "onDeleted");
            }
            "project_column_created" => {
                check self.executeRemoteFunc(genericDataType, "project_column_created", "ProjectColumnService", "onCreated");
            }
        }
    }

    private function matchRemoteFuncForMarketplacePurchase(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "marketplace_purchase_purchased" => {
                check self.executeRemoteFunc(genericDataType, "marketplace_purchase_purchased", "MarketplacePurchaseService", "onPurchased");
            }
            "marketplace_purchase_cancelled" => {
                check self.executeRemoteFunc(genericDataType, "marketplace_purchase_cancelled", "MarketplacePurchaseService", "onCancelled");
            }
            "marketplace_purchase_pending_change_cancelled" => {
                check self.executeRemoteFunc(genericDataType, "marketplace_purchase_pending_change_cancelled", "MarketplacePurchaseService", "onPendingChangeCancelled");
            }
            "marketplace_purchase_pending_change" => {
                check self.executeRemoteFunc(genericDataType, "marketplace_purchase_pending_change", "MarketplacePurchaseService", "onPendingChange");
            }
            "marketplace_purchase_changed" => {
                check self.executeRemoteFunc(genericDataType, "marketplace_purchase_changed", "MarketplacePurchaseService", "onChanged");
            }
        }
    }

    private function matchRemoteFuncForBranchProtectionConfiguration(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "branch_protection_configuration_enabled" => {
                check self.executeRemoteFunc(genericDataType, "branch_protection_configuration_enabled", "BranchProtectionConfigurationService", "onEnabled");
            }
            "branch_protection_configuration_disabled" => {
                check self.executeRemoteFunc(genericDataType, "branch_protection_configuration_disabled", "BranchProtectionConfigurationService", "onDisabled");
            }
        }
    }

    private function matchRemoteFuncForPullRequest(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "pull_request_enqueued" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_enqueued", "PullRequestService", "onEnqueued");
            }
            "pull_request_review_request_removed" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_request_removed", "PullRequestService", "onReviewRequestRemoved");
            }
            "pull_request_opened" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_opened", "PullRequestService", "onOpened");
            }
            "pull_request_ready_for_review" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_ready_for_review", "PullRequestService", "onReadyForReview");
            }
            "pull_request_labeled" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_labeled", "PullRequestService", "onLabeled");
            }
            "pull_request_unassigned" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_unassigned", "PullRequestService", "onUnassigned");
            }
            "pull_request_edited" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_edited", "PullRequestService", "onEdited");
            }
            "pull_request_synchronize" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_synchronize", "PullRequestService", "onSynchronize");
            }
            "pull_request_review_requested" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_requested", "PullRequestService", "onReviewRequested");
            }
            "pull_request_reopened" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_reopened", "PullRequestService", "onReopened");
            }
            "pull_request_auto_merge_disabled" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_auto_merge_disabled", "PullRequestService", "onAutoMergeDisabled");
            }
            "pull_request_locked" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_locked", "PullRequestService", "onLocked");
            }
            "pull_request_auto_merge_enabled" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_auto_merge_enabled", "PullRequestService", "onAutoMergeEnabled");
            }
            "pull_request_milestoned" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_milestoned", "PullRequestService", "onMilestoned");
            }
            "pull_request_dequeued" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_dequeued", "PullRequestService", "onDequeued");
            }
            "pull_request_unlabeled" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_unlabeled", "PullRequestService", "onUnlabeled");
            }
            "pull_request_closed" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_closed", "PullRequestService", "onClosed");
            }
            "pull_request_unlocked" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_unlocked", "PullRequestService", "onUnlocked");
            }
            "pull_request_assigned" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_assigned", "PullRequestService", "onAssigned");
            }
            "pull_request_converted_to_draft" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_converted_to_draft", "PullRequestService", "onConvertedToDraft");
            }
            "pull_request_demilestoned" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_demilestoned", "PullRequestService", "onDemilestoned");
            }
        }
    }

    private function matchRemoteFuncForLabel(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "label_edited" => {
                check self.executeRemoteFunc(genericDataType, "label_edited", "LabelService", "onEdited");
            }
            "label_created" => {
                check self.executeRemoteFunc(genericDataType, "label_created", "LabelService", "onCreated");
            }
            "label_deleted" => {
                check self.executeRemoteFunc(genericDataType, "label_deleted", "LabelService", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForDeployment(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "deployment" => {
                check self.executeRemoteFunc(genericDataType, "deployment", "DeploymentService", "onDeployment");
            }
        }
    }

    private function matchRemoteFuncForTeamAdd(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "team_add" => {
                check self.executeRemoteFunc(genericDataType, "team_add", "TeamAddService", "onTeamAdd");
            }
        }
    }

    private function matchRemoteFuncForCodeScanningAlert(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "code_scanning_alert_appeared_in_branch" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_appeared_in_branch", "CodeScanningAlertService", "onAppearedInBranch");
            }
            "code_scanning_alert_closed_by_user" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_closed_by_user", "CodeScanningAlertService", "onClosedByUser");
            }
            "code_scanning_alert_created" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_created", "CodeScanningAlertService", "onCreated");
            }
            "code_scanning_alert_fixed" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_fixed", "CodeScanningAlertService", "onFixed");
            }
            "code_scanning_alert_reopened" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_reopened", "CodeScanningAlertService", "onReopened");
            }
            "code_scanning_alert_reopened_by_user" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_reopened_by_user", "CodeScanningAlertService", "onReopenedByUser");
            }
            "code_scanning_alert_updated_assignment" => {
                check self.executeRemoteFunc(genericDataType, "code_scanning_alert_updated_assignment", "CodeScanningAlertService", "onUpdatedAssignment");
            }
        }
    }

    private function matchRemoteFuncForMembership(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "membership_added" => {
                check self.executeRemoteFunc(genericDataType, "membership_added", "MembershipService", "onAdded");
            }
            "membership_removed" => {
                check self.executeRemoteFunc(genericDataType, "membership_removed", "MembershipService", "onRemoved");
            }
        }
    }

    private function matchRemoteFuncForSecretScanningAlert(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "secret_scanning_alert_assigned" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_assigned", "SecretScanningAlertService", "onAssigned");
            }
            "secret_scanning_alert_reopened" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_reopened", "SecretScanningAlertService", "onReopened");
            }
            "secret_scanning_alert_unassigned" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_unassigned", "SecretScanningAlertService", "onUnassigned");
            }
            "secret_scanning_alert_created" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_created", "SecretScanningAlertService", "onCreated");
            }
            "secret_scanning_alert_publicly_leaked" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_publicly_leaked", "SecretScanningAlertService", "onPubliclyLeaked");
            }
            "secret_scanning_alert_validated" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_validated", "SecretScanningAlertService", "onValidated");
            }
            "secret_scanning_alert_resolved" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_resolved", "SecretScanningAlertService", "onResolved");
            }
        }
    }

    private function matchRemoteFuncForPush(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "push" => {
                check self.executeRemoteFunc(genericDataType, "push", "PushService", "onPush");
            }
        }
    }

    private function matchRemoteFuncForMember(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "member_edited" => {
                check self.executeRemoteFunc(genericDataType, "member_edited", "MemberService", "onEdited");
            }
            "member_added" => {
                check self.executeRemoteFunc(genericDataType, "member_added", "MemberService", "onAdded");
            }
            "member_removed" => {
                check self.executeRemoteFunc(genericDataType, "member_removed", "MemberService", "onRemoved");
            }
        }
    }

    private function matchRemoteFuncForRepositoryDispatch(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_dispatch" => {
                check self.executeRemoteFunc(genericDataType, "repository_dispatch", "RepositoryDispatchService", "onRepositoryDispatch");
            }
        }
    }

    private function matchRemoteFuncForStatus(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "status" => {
                check self.executeRemoteFunc(genericDataType, "status", "StatusService", "onStatus");
            }
        }
    }

    private function matchRemoteFuncForRepositoryImport(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_import" => {
                check self.executeRemoteFunc(genericDataType, "repository_import", "RepositoryImportService", "onRepositoryImport");
            }
        }
    }

    private function matchRemoteFuncForPersonalAccessTokenRequest(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "personal_access_token_request_created" => {
                check self.executeRemoteFunc(genericDataType, "personal_access_token_request_created", "PersonalAccessTokenRequestService", "onCreated");
            }
            "personal_access_token_request_approved" => {
                check self.executeRemoteFunc(genericDataType, "personal_access_token_request_approved", "PersonalAccessTokenRequestService", "onApproved");
            }
            "personal_access_token_request_denied" => {
                check self.executeRemoteFunc(genericDataType, "personal_access_token_request_denied", "PersonalAccessTokenRequestService", "onDenied");
            }
            "personal_access_token_request_cancelled" => {
                check self.executeRemoteFunc(genericDataType, "personal_access_token_request_cancelled", "PersonalAccessTokenRequestService", "onCancelled");
            }
        }
    }

    private function matchRemoteFuncForSubIssues(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "sub_issues_child_issue_added" => {
                check self.executeRemoteFunc(genericDataType, "sub_issues_child_issue_added", "SubIssuesService", "onChildIssueAdded");
            }
            "sub_issues_parent_issue_added" => {
                check self.executeRemoteFunc(genericDataType, "sub_issues_parent_issue_added", "SubIssuesService", "onParentIssueAdded");
            }
            "sub_issues_child_issue_removed" => {
                check self.executeRemoteFunc(genericDataType, "sub_issues_child_issue_removed", "SubIssuesService", "onChildIssueRemoved");
            }
            "sub_issues_parent_issue_removed" => {
                check self.executeRemoteFunc(genericDataType, "sub_issues_parent_issue_removed", "SubIssuesService", "onParentIssueRemoved");
            }
        }
    }

    private function matchRemoteFuncForRepositoryRuleset(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_ruleset_created" => {
                check self.executeRemoteFunc(genericDataType, "repository_ruleset_created", "RepositoryRulesetService", "onCreated");
            }
            "repository_ruleset_edited" => {
                check self.executeRemoteFunc(genericDataType, "repository_ruleset_edited", "RepositoryRulesetService", "onEdited");
            }
            "repository_ruleset_deleted" => {
                check self.executeRemoteFunc(genericDataType, "repository_ruleset_deleted", "RepositoryRulesetService", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForMilestone(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "milestone_created" => {
                check self.executeRemoteFunc(genericDataType, "milestone_created", "MilestoneService", "onCreated");
            }
            "milestone_edited" => {
                check self.executeRemoteFunc(genericDataType, "milestone_edited", "MilestoneService", "onEdited");
            }
            "milestone_opened" => {
                check self.executeRemoteFunc(genericDataType, "milestone_opened", "MilestoneService", "onOpened");
            }
            "milestone_deleted" => {
                check self.executeRemoteFunc(genericDataType, "milestone_deleted", "MilestoneService", "onDeleted");
            }
            "milestone_closed" => {
                check self.executeRemoteFunc(genericDataType, "milestone_closed", "MilestoneService", "onClosed");
            }
        }
    }

    private function matchRemoteFuncForPublic(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "public" => {
                check self.executeRemoteFunc(genericDataType, "public", "PublicService", "onPublic");
            }
        }
    }

    private function matchRemoteFuncForWorkflowRun(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "workflow_run_in_progress" => {
                check self.executeRemoteFunc(genericDataType, "workflow_run_in_progress", "WorkflowRunService", "onInProgress");
            }
            "workflow_run_completed" => {
                check self.executeRemoteFunc(genericDataType, "workflow_run_completed", "WorkflowRunService", "onCompleted");
            }
            "workflow_run_requested" => {
                check self.executeRemoteFunc(genericDataType, "workflow_run_requested", "WorkflowRunService", "onRequested");
            }
        }
    }

    private function matchRemoteFuncForProjectsV2statusUpdate(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "projects_v2_status_update_edited" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_status_update_edited", "ProjectsV2statusUpdateService", "onEdited");
            }
            "projects_v2_status_update_deleted" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_status_update_deleted", "ProjectsV2statusUpdateService", "onDeleted");
            }
            "projects_v2_status_update_created" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_status_update_created", "ProjectsV2statusUpdateService", "onCreated");
            }
        }
    }

    private function matchRemoteFuncForProjectsV2item(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "projects_v2_item_edited" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_edited", "ProjectsV2itemService", "onEdited");
            }
            "projects_v2_item_created" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_created", "ProjectsV2itemService", "onCreated");
            }
            "projects_v2_item_archived" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_archived", "ProjectsV2itemService", "onArchived");
            }
            "projects_v2_item_deleted" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_deleted", "ProjectsV2itemService", "onDeleted");
            }
            "projects_v2_item_restored" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_restored", "ProjectsV2itemService", "onRestored");
            }
            "projects_v2_item_reordered" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_reordered", "ProjectsV2itemService", "onReordered");
            }
            "projects_v2_item_converted" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_item_converted", "ProjectsV2itemService", "onConverted");
            }
        }
    }

    private function matchRemoteFuncForSponsorship(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "sponsorship_cancelled" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_cancelled", "SponsorshipService", "onCancelled");
            }
            "sponsorship_edited" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_edited", "SponsorshipService", "onEdited");
            }
            "sponsorship_tier_changed" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_tier_changed", "SponsorshipService", "onTierChanged");
            }
            "sponsorship_pending_cancellation" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_pending_cancellation", "SponsorshipService", "onPendingCancellation");
            }
            "sponsorship_created" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_created", "SponsorshipService", "onCreated");
            }
            "sponsorship_pending_tier_change" => {
                check self.executeRemoteFunc(genericDataType, "sponsorship_pending_tier_change", "SponsorshipService", "onPendingTierChange");
            }
        }
    }

    private function matchRemoteFuncForMergeGroup(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "merge_group_destroyed" => {
                check self.executeRemoteFunc(genericDataType, "merge_group_destroyed", "MergeGroupService", "onDestroyed");
            }
            "merge_group_checks_requested" => {
                check self.executeRemoteFunc(genericDataType, "merge_group_checks_requested", "MergeGroupService", "onChecksRequested");
            }
        }
    }

    private function matchRemoteFuncForProject(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "project_deleted" => {
                check self.executeRemoteFunc(genericDataType, "project_deleted", "ProjectService", "onDeleted");
            }
            "project_created" => {
                check self.executeRemoteFunc(genericDataType, "project_created", "ProjectService", "onCreated");
            }
            "project_closed" => {
                check self.executeRemoteFunc(genericDataType, "project_closed", "ProjectService", "onClosed");
            }
            "project_reopened" => {
                check self.executeRemoteFunc(genericDataType, "project_reopened", "ProjectService", "onReopened");
            }
            "project_edited" => {
                check self.executeRemoteFunc(genericDataType, "project_edited", "ProjectService", "onEdited");
            }
        }
    }

    private function matchRemoteFuncForOrgBlock(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "org_block_blocked" => {
                check self.executeRemoteFunc(genericDataType, "org_block_blocked", "OrgBlockService", "onBlocked");
            }
            "org_block_unblocked" => {
                check self.executeRemoteFunc(genericDataType, "org_block_unblocked", "OrgBlockService", "onUnblocked");
            }
        }
    }

    private function matchRemoteFuncForSecretScanningAlertLocation(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "secret_scanning_alert_location" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_alert_location", "SecretScanningAlertLocationService", "onSecretScanningAlertLocation");
            }
        }
    }

    private function matchRemoteFuncForInstallationTarget(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "installation_target" => {
                check self.executeRemoteFunc(genericDataType, "installation_target", "InstallationTargetService", "onInstallationTarget");
            }
        }
    }

    private function matchRemoteFuncForCheckSuite(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "check_suite_completed" => {
                check self.executeRemoteFunc(genericDataType, "check_suite_completed", "CheckSuiteService", "onCompleted");
            }
            "check_suite_requested" => {
                check self.executeRemoteFunc(genericDataType, "check_suite_requested", "CheckSuiteService", "onRequested");
            }
            "check_suite_rerequested" => {
                check self.executeRemoteFunc(genericDataType, "check_suite_rerequested", "CheckSuiteService", "onRerequested");
            }
        }
    }

    private function matchRemoteFuncForPing(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "ping" => {
                check self.executeRemoteFunc(genericDataType, "ping", "PingService", "onPing");
            }
        }
    }

    private function matchRemoteFuncForIssueComment(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "issue_comment_edited" => {
                check self.executeRemoteFunc(genericDataType, "issue_comment_edited", "IssueCommentService", "onEdited");
            }
            "issue_comment_pinned" => {
                check self.executeRemoteFunc(genericDataType, "issue_comment_pinned", "IssueCommentService", "onPinned");
            }
            "issue_comment_deleted" => {
                check self.executeRemoteFunc(genericDataType, "issue_comment_deleted", "IssueCommentService", "onDeleted");
            }
            "issue_comment_created" => {
                check self.executeRemoteFunc(genericDataType, "issue_comment_created", "IssueCommentService", "onCreated");
            }
            "issue_comment_unpinned" => {
                check self.executeRemoteFunc(genericDataType, "issue_comment_unpinned", "IssueCommentService", "onUnpinned");
            }
        }
    }

    private function matchRemoteFuncForSecurityAdvisory(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "security_advisory_withdrawn" => {
                check self.executeRemoteFunc(genericDataType, "security_advisory_withdrawn", "SecurityAdvisoryService", "onWithdrawn");
            }
            "security_advisory_published" => {
                check self.executeRemoteFunc(genericDataType, "security_advisory_published", "SecurityAdvisoryService", "onPublished");
            }
            "security_advisory_updated" => {
                check self.executeRemoteFunc(genericDataType, "security_advisory_updated", "SecurityAdvisoryService", "onUpdated");
            }
        }
    }

    private function matchRemoteFuncForPackage(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "package_published" => {
                check self.executeRemoteFunc(genericDataType, "package_published", "PackageService", "onPublished");
            }
            "package_updated" => {
                check self.executeRemoteFunc(genericDataType, "package_updated", "PackageService", "onUpdated");
            }
        }
    }

    private function matchRemoteFuncForDiscussion(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "discussion_unanswered" => {
                check self.executeRemoteFunc(genericDataType, "discussion_unanswered", "DiscussionService", "onUnanswered");
            }
            "discussion_created" => {
                check self.executeRemoteFunc(genericDataType, "discussion_created", "DiscussionService", "onCreated");
            }
            "discussion_transferred" => {
                check self.executeRemoteFunc(genericDataType, "discussion_transferred", "DiscussionService", "onTransferred");
            }
            "discussion_category_changed" => {
                check self.executeRemoteFunc(genericDataType, "discussion_category_changed", "DiscussionService", "onCategoryChanged");
            }
            "discussion_deleted" => {
                check self.executeRemoteFunc(genericDataType, "discussion_deleted", "DiscussionService", "onDeleted");
            }
            "discussion_unlocked" => {
                check self.executeRemoteFunc(genericDataType, "discussion_unlocked", "DiscussionService", "onUnlocked");
            }
            "discussion_pinned" => {
                check self.executeRemoteFunc(genericDataType, "discussion_pinned", "DiscussionService", "onPinned");
            }
            "discussion_edited" => {
                check self.executeRemoteFunc(genericDataType, "discussion_edited", "DiscussionService", "onEdited");
            }
            "discussion_reopened" => {
                check self.executeRemoteFunc(genericDataType, "discussion_reopened", "DiscussionService", "onReopened");
            }
            "discussion_answered" => {
                check self.executeRemoteFunc(genericDataType, "discussion_answered", "DiscussionService", "onAnswered");
            }
            "discussion_closed" => {
                check self.executeRemoteFunc(genericDataType, "discussion_closed", "DiscussionService", "onClosed");
            }
            "discussion_unlabeled" => {
                check self.executeRemoteFunc(genericDataType, "discussion_unlabeled", "DiscussionService", "onUnlabeled");
            }
            "discussion_labeled" => {
                check self.executeRemoteFunc(genericDataType, "discussion_labeled", "DiscussionService", "onLabeled");
            }
            "discussion_unpinned" => {
                check self.executeRemoteFunc(genericDataType, "discussion_unpinned", "DiscussionService", "onUnpinned");
            }
            "discussion_locked" => {
                check self.executeRemoteFunc(genericDataType, "discussion_locked", "DiscussionService", "onLocked");
            }
        }
    }

    private function matchRemoteFuncForFork(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "fork" => {
                check self.executeRemoteFunc(genericDataType, "fork", "ForkService", "onFork");
            }
        }
    }

    private function matchRemoteFuncForPullRequestReview(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "pull_request_review_submitted" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_submitted", "PullRequestReviewService", "onSubmitted");
            }
            "pull_request_review_edited" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_edited", "PullRequestReviewService", "onEdited");
            }
            "pull_request_review_dismissed" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_dismissed", "PullRequestReviewService", "onDismissed");
            }
        }
    }

    private function matchRemoteFuncForOrganization(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "organization_member_added" => {
                check self.executeRemoteFunc(genericDataType, "organization_member_added", "OrganizationService", "onAdded");
            }
            "organization_member_removed" => {
                check self.executeRemoteFunc(genericDataType, "organization_member_removed", "OrganizationService", "onRemoved");
            }
            "organization_deleted" => {
                check self.executeRemoteFunc(genericDataType, "organization_deleted", "OrganizationService", "onDeleted");
            }
            "organization_renamed" => {
                check self.executeRemoteFunc(genericDataType, "organization_renamed", "OrganizationService", "onRenamed");
            }
            "organization_member_invited" => {
                check self.executeRemoteFunc(genericDataType, "organization_member_invited", "OrganizationService", "onMemberInvited");
            }
        }
    }

    private function matchRemoteFuncForIssues(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "issues_reopened" => {
                check self.executeRemoteFunc(genericDataType, "issues_reopened", "IssuesService", "onReopened");
            }
            "issues_transferred" => {
                check self.executeRemoteFunc(genericDataType, "issues_transferred", "IssuesService", "onTransferred");
            }
            "issues_unpinned" => {
                check self.executeRemoteFunc(genericDataType, "issues_unpinned", "IssuesService", "onUnpinned");
            }
            "issues_assigned" => {
                check self.executeRemoteFunc(genericDataType, "issues_assigned", "IssuesService", "onAssigned");
            }
            "issues_milestoned" => {
                check self.executeRemoteFunc(genericDataType, "issues_milestoned", "IssuesService", "onMilestoned");
            }
            "issues_labeled" => {
                check self.executeRemoteFunc(genericDataType, "issues_labeled", "IssuesService", "onLabeled");
            }
            "issues_opened" => {
                check self.executeRemoteFunc(genericDataType, "issues_opened", "IssuesService", "onOpened");
            }
            "issues_pinned" => {
                check self.executeRemoteFunc(genericDataType, "issues_pinned", "IssuesService", "onPinned");
            }
            "issues_typed" => {
                check self.executeRemoteFunc(genericDataType, "issues_typed", "IssuesService", "onTyped");
            }
            "issues_edited" => {
                check self.executeRemoteFunc(genericDataType, "issues_edited", "IssuesService", "onEdited");
            }
            "issues_untyped" => {
                check self.executeRemoteFunc(genericDataType, "issues_untyped", "IssuesService", "onUntyped");
            }
            "issues_demilestoned" => {
                check self.executeRemoteFunc(genericDataType, "issues_demilestoned", "IssuesService", "onDemilestoned");
            }
            "issues_locked" => {
                check self.executeRemoteFunc(genericDataType, "issues_locked", "IssuesService", "onLocked");
            }
            "issues_unassigned" => {
                check self.executeRemoteFunc(genericDataType, "issues_unassigned", "IssuesService", "onUnassigned");
            }
            "issues_unlocked" => {
                check self.executeRemoteFunc(genericDataType, "issues_unlocked", "IssuesService", "onUnlocked");
            }
            "issues_unlabeled" => {
                check self.executeRemoteFunc(genericDataType, "issues_unlabeled", "IssuesService", "onUnlabeled");
            }
            "issues_closed" => {
                check self.executeRemoteFunc(genericDataType, "issues_closed", "IssuesService", "onClosed");
            }
            "issues_deleted" => {
                check self.executeRemoteFunc(genericDataType, "issues_deleted", "IssuesService", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForRegistryPackage(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "registry_package_updated" => {
                check self.executeRemoteFunc(genericDataType, "registry_package_updated", "RegistryPackageService", "onUpdated");
            }
            "registry_package_published" => {
                check self.executeRemoteFunc(genericDataType, "registry_package_published", "RegistryPackageService", "onPublished");
            }
        }
    }

    private function matchRemoteFuncForProjectsV2(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "projects_v2_created" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_created", "ProjectsV2Service", "onCreated");
            }
            "projects_v2_edited" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_edited", "ProjectsV2Service", "onEdited");
            }
            "projects_v2_closed" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_closed", "ProjectsV2Service", "onClosed");
            }
            "projects_v2_reopened" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_reopened", "ProjectsV2Service", "onReopened");
            }
            "projects_v2_deleted" => {
                check self.executeRemoteFunc(genericDataType, "projects_v2_deleted", "ProjectsV2Service", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForRepositoryVulnerabilityAlert(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_vulnerability_alert_resolve" => {
                check self.executeRemoteFunc(genericDataType, "repository_vulnerability_alert_resolve", "RepositoryVulnerabilityAlertService", "onResolve");
            }
            "repository_vulnerability_alert_reopen" => {
                check self.executeRemoteFunc(genericDataType, "repository_vulnerability_alert_reopen", "RepositoryVulnerabilityAlertService", "onReopen");
            }
            "repository_vulnerability_alert_dismiss" => {
                check self.executeRemoteFunc(genericDataType, "repository_vulnerability_alert_dismiss", "RepositoryVulnerabilityAlertService", "onDismiss");
            }
            "repository_vulnerability_alert_create" => {
                check self.executeRemoteFunc(genericDataType, "repository_vulnerability_alert_create", "RepositoryVulnerabilityAlertService", "onCreate");
            }
        }
    }

    private function matchRemoteFuncForStar(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "star_created" => {
                check self.executeRemoteFunc(genericDataType, "star_created", "StarService", "onCreated");
            }
            "star_deleted" => {
                check self.executeRemoteFunc(genericDataType, "star_deleted", "StarService", "onDeleted");
            }
        }
    }

    private function matchRemoteFuncForCreate(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "create" => {
                check self.executeRemoteFunc(genericDataType, "create", "CreateService", "onCreate");
            }
        }
    }

    private function matchRemoteFuncForDeploymentReview(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "deployment_review_requested" => {
                check self.executeRemoteFunc(genericDataType, "deployment_review_requested", "DeploymentReviewService", "onRequested");
            }
            "deployment_review_rejected" => {
                check self.executeRemoteFunc(genericDataType, "deployment_review_rejected", "DeploymentReviewService", "onRejected");
            }
            "deployment_review_approved" => {
                check self.executeRemoteFunc(genericDataType, "deployment_review_approved", "DeploymentReviewService", "onApproved");
            }
        }
    }

    private function matchRemoteFuncForGollum(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "gollum" => {
                check self.executeRemoteFunc(genericDataType, "gollum", "GollumService", "onGollum");
            }
        }
    }

    private function matchRemoteFuncForGithubAppAuthorization(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "github_app_authorization" => {
                check self.executeRemoteFunc(genericDataType, "github_app_authorization", "GithubAppAuthorizationService", "onGithubAppAuthorization");
            }
        }
    }

    private function matchRemoteFuncForWatch(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "watch" => {
                check self.executeRemoteFunc(genericDataType, "watch", "WatchService", "onWatch");
            }
        }
    }

    private function matchRemoteFuncForTeam(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "team_created" => {
                check self.executeRemoteFunc(genericDataType, "team_created", "TeamService", "onCreated");
            }
            "team_deleted" => {
                check self.executeRemoteFunc(genericDataType, "team_deleted", "TeamService", "onDeleted");
            }
            "team_edited" => {
                check self.executeRemoteFunc(genericDataType, "team_edited", "TeamService", "onEdited");
            }
            "team_added_to_repository" => {
                check self.executeRemoteFunc(genericDataType, "team_added_to_repository", "TeamService", "onAddedToRepository");
            }
            "team_removed_from_repository" => {
                check self.executeRemoteFunc(genericDataType, "team_removed_from_repository", "TeamService", "onRemovedFromRepository");
            }
        }
    }

    private function matchRemoteFuncForWorkflowJob(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "workflow_job_queued" => {
                check self.executeRemoteFunc(genericDataType, "workflow_job_queued", "WorkflowJobService", "onQueued");
            }
            "workflow_job_waiting" => {
                check self.executeRemoteFunc(genericDataType, "workflow_job_waiting", "WorkflowJobService", "onWaiting");
            }
            "workflow_job_completed" => {
                check self.executeRemoteFunc(genericDataType, "workflow_job_completed", "WorkflowJobService", "onCompleted");
            }
            "workflow_job_in_progress" => {
                check self.executeRemoteFunc(genericDataType, "workflow_job_in_progress", "WorkflowJobService", "onInProgress");
            }
        }
    }

    private function matchRemoteFuncForRelease(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "release_created" => {
                check self.executeRemoteFunc(genericDataType, "release_created", "ReleaseService", "onCreated");
            }
            "release_published" => {
                check self.executeRemoteFunc(genericDataType, "release_published", "ReleaseService", "onPublished");
            }
            "release_released" => {
                check self.executeRemoteFunc(genericDataType, "release_released", "ReleaseService", "onReleased");
            }
            "release_prereleased" => {
                check self.executeRemoteFunc(genericDataType, "release_prereleased", "ReleaseService", "onPrereleased");
            }
            "release_unpublished" => {
                check self.executeRemoteFunc(genericDataType, "release_unpublished", "ReleaseService", "onUnpublished");
            }
            "release_deleted" => {
                check self.executeRemoteFunc(genericDataType, "release_deleted", "ReleaseService", "onDeleted");
            }
            "release_edited" => {
                check self.executeRemoteFunc(genericDataType, "release_edited", "ReleaseService", "onEdited");
            }
        }
    }

    private function matchRemoteFuncForInstallation(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "installation_new_permissions_accepted" => {
                check self.executeRemoteFunc(genericDataType, "installation_new_permissions_accepted", "InstallationService", "onNewPermissionsAccepted");
            }
            "installation_suspend" => {
                check self.executeRemoteFunc(genericDataType, "installation_suspend", "InstallationService", "onSuspend");
            }
            "installation_created" => {
                check self.executeRemoteFunc(genericDataType, "installation_created", "InstallationService", "onCreated");
            }
            "installation_deleted" => {
                check self.executeRemoteFunc(genericDataType, "installation_deleted", "InstallationService", "onDeleted");
            }
            "installation_unsuspend" => {
                check self.executeRemoteFunc(genericDataType, "installation_unsuspend", "InstallationService", "onUnsuspend");
            }
        }
    }

    private function matchRemoteFuncForCommitComment(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "commit_comment" => {
                check self.executeRemoteFunc(genericDataType, "commit_comment", "CommitCommentService", "onCommitComment");
            }
        }
    }

    private function matchRemoteFuncForDiscussionComment(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "discussion_comment_deleted" => {
                check self.executeRemoteFunc(genericDataType, "discussion_comment_deleted", "DiscussionCommentService", "onDeleted");
            }
            "discussion_comment_created" => {
                check self.executeRemoteFunc(genericDataType, "discussion_comment_created", "DiscussionCommentService", "onCreated");
            }
            "discussion_comment_edited" => {
                check self.executeRemoteFunc(genericDataType, "discussion_comment_edited", "DiscussionCommentService", "onEdited");
            }
        }
    }

    private function matchRemoteFuncForBranchProtectionRule(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "branch_protection_rule_deleted" => {
                check self.executeRemoteFunc(genericDataType, "branch_protection_rule_deleted", "BranchProtectionRuleService", "onDeleted");
            }
            "branch_protection_rule_edited" => {
                check self.executeRemoteFunc(genericDataType, "branch_protection_rule_edited", "BranchProtectionRuleService", "onEdited");
            }
            "branch_protection_rule_created" => {
                check self.executeRemoteFunc(genericDataType, "branch_protection_rule_created", "BranchProtectionRuleService", "onCreated");
            }
        }
    }

    private function matchRemoteFuncForIssueDependencies(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "issue_dependencies_issue_dependency_added" => {
                check self.executeRemoteFunc(genericDataType, "issue_dependencies_issue_dependency_added", "IssueDependenciesService", "onIssueDependencyAdded");
            }
            "issue_dependencies_issue_dependency_removed" => {
                check self.executeRemoteFunc(genericDataType, "issue_dependencies_issue_dependency_removed", "IssueDependenciesService", "onIssueDependencyRemoved");
            }
        }
    }

    private function matchRemoteFuncForRepository(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_privatized" => {
                check self.executeRemoteFunc(genericDataType, "repository_privatized", "RepositoryService", "onPrivatized");
            }
            "repository_created" => {
                check self.executeRemoteFunc(genericDataType, "repository_created", "RepositoryService", "onCreated");
            }
            "repository_renamed" => {
                check self.executeRemoteFunc(genericDataType, "repository_renamed", "RepositoryService", "onRenamed");
            }
            "repository_transferred" => {
                check self.executeRemoteFunc(genericDataType, "repository_transferred", "RepositoryService", "onTransferred");
            }
            "repository_edited" => {
                check self.executeRemoteFunc(genericDataType, "repository_edited", "RepositoryService", "onEdited");
            }
            "repository_deleted" => {
                check self.executeRemoteFunc(genericDataType, "repository_deleted", "RepositoryService", "onDeleted");
            }
            "repository_archived" => {
                check self.executeRemoteFunc(genericDataType, "repository_archived", "RepositoryService", "onArchived");
            }
            "repository_publicized" => {
                check self.executeRemoteFunc(genericDataType, "repository_publicized", "RepositoryService", "onPublicized");
            }
            "repository_unarchived" => {
                check self.executeRemoteFunc(genericDataType, "repository_unarchived", "RepositoryService", "onUnarchived");
            }
        }
    }

    private function matchRemoteFuncForPullRequestReviewComment(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "pull_request_review_comment_created" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_comment_created", "PullRequestReviewCommentService", "onCreated");
            }
            "pull_request_review_comment_deleted" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_comment_deleted", "PullRequestReviewCommentService", "onDeleted");
            }
            "pull_request_review_comment_edited" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_comment_edited", "PullRequestReviewCommentService", "onEdited");
            }
        }
    }

    private function matchRemoteFuncForDeploymentProtectionRule(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "deployment_protection_rule" => {
                check self.executeRemoteFunc(genericDataType, "deployment_protection_rule", "DeploymentProtectionRuleService", "onDeploymentProtectionRule");
            }
        }
    }

    private function matchRemoteFuncForCustomPropertyValues(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "custom_property_values" => {
                check self.executeRemoteFunc(genericDataType, "custom_property_values", "CustomPropertyValuesService", "onCustomPropertyValues");
            }
        }
    }

    private function matchRemoteFuncForInstallationRepositories(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "installation_repositories_removed" => {
                check self.executeRemoteFunc(genericDataType, "installation_repositories_removed", "InstallationRepositoriesService", "onRemoved");
            }
            "installation_repositories_added" => {
                check self.executeRemoteFunc(genericDataType, "installation_repositories_added", "InstallationRepositoriesService", "onAdded");
            }
        }
    }

    private function matchRemoteFuncForSecretScanningScan(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "secret_scanning_scan" => {
                check self.executeRemoteFunc(genericDataType, "secret_scanning_scan", "SecretScanningScanService", "onSecretScanningScan");
            }
        }
    }

    private function matchRemoteFuncForProjectCard(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "project_card_edited" => {
                check self.executeRemoteFunc(genericDataType, "project_card_edited", "ProjectCardService", "onProjectCardEdited");
            }
            "project_card_deleted" => {
                check self.executeRemoteFunc(genericDataType, "project_card_deleted", "ProjectCardService", "onProjectCardDeleted");
            }
            "project_card_moved" => {
                check self.executeRemoteFunc(genericDataType, "project_card_moved", "ProjectCardService", "onProjectCardMoved");
            }
            "project_card_converted" => {
                check self.executeRemoteFunc(genericDataType, "project_card_converted", "ProjectCardService", "onProjectCardConverted");
            }
            "project_card_created" => {
                check self.executeRemoteFunc(genericDataType, "project_card_created", "ProjectCardService", "onProjectCardCreated");
            }
        }
    }

    private function matchRemoteFuncForCheckRun(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "check_run_created" => {
                check self.executeRemoteFunc(genericDataType, "check_run_created", "CheckRunService", "onCreated");
            }
            "check_run_completed" => {
                check self.executeRemoteFunc(genericDataType, "check_run_completed", "CheckRunService", "onCompleted");
            }
            "check_run_requested_action" => {
                check self.executeRemoteFunc(genericDataType, "check_run_requested_action", "CheckRunService", "onRequestedAction");
            }
            "check_run_rerequested" => {
                check self.executeRemoteFunc(genericDataType, "check_run_rerequested", "CheckRunService", "onRerequested");
            }
        }
    }

    private function matchRemoteFuncForPageBuild(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "page_build" => {
                check self.executeRemoteFunc(genericDataType, "page_build", "PageBuildService", "onPageBuild");
            }
        }
    }

    private function matchRemoteFuncForCustomProperty(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "custom_property_updated" => {
                check self.executeRemoteFunc(genericDataType, "custom_property_updated", "CustomPropertyService", "onUpdated");
            }
            "custom_property_deleted" => {
                check self.executeRemoteFunc(genericDataType, "custom_property_deleted", "CustomPropertyService", "onDeleted");
            }
            "custom_property_promote_to_enterprise" => {
                check self.executeRemoteFunc(genericDataType, "custom_property_promote_to_enterprise", "CustomPropertyService", "onPromoteToEnterprise");
            }
            "custom_property_created" => {
                check self.executeRemoteFunc(genericDataType, "custom_property_created", "CustomPropertyService", "onCreated");
            }
        }
    }

    private function matchRemoteFuncForDependabotAlert(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "dependabot_alert_auto_dismissed" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_auto_dismissed", "DependabotAlertService", "onAutoDismissed");
            }
            "dependabot_alert_auto_reopened" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_auto_reopened", "DependabotAlertService", "onAutoReopened");
            }
            "dependabot_alert_created" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_created", "DependabotAlertService", "onCreated");
            }
            "dependabot_alert_dismissed" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_dismissed", "DependabotAlertService", "onDismissed");
            }
            "dependabot_alert_reopened" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_reopened", "DependabotAlertService", "onReopened");
            }
            "dependabot_alert_reintroduced" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_reintroduced", "DependabotAlertService", "onReintroduced");
            }
            "dependabot_alert_assignees_changed" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_assignees_changed", "DependabotAlertService", "onAssigneesChanged");
            }
            "dependabot_alert_fixed" => {
                check self.executeRemoteFunc(genericDataType, "dependabot_alert_fixed", "DependabotAlertService", "onFixed");
            }
        }
    }

    private function matchRemoteFuncForDeploymentStatus(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "deployment_status" => {
                check self.executeRemoteFunc(genericDataType, "deployment_status", "DeploymentStatusService", "onDeploymentStatus");
            }
        }
    }

    private function matchRemoteFuncForRepositoryAdvisory(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "repository_advisory_reported" => {
                check self.executeRemoteFunc(genericDataType, "repository_advisory_reported", "RepositoryAdvisoryService", "onReported");
            }
            "repository_advisory_published" => {
                check self.executeRemoteFunc(genericDataType, "repository_advisory_published", "RepositoryAdvisoryService", "onPublished");
            }
        }
    }

    private function matchRemoteFuncForPullRequestReviewThread(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "pull_request_review_thread_unresolved" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_thread_unresolved", "PullRequestReviewThreadService", "onUnresolved");
            }
            "pull_request_review_thread_resolved" => {
                check self.executeRemoteFunc(genericDataType, "pull_request_review_thread_resolved", "PullRequestReviewThreadService", "onResolved");
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
