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

public type DeleteService service object {
    remote function onDelete(DeleteEvent payload) returns error?;
};

public type MetaService service object {
    remote function onMeta(MetaEvent payload) returns error?;
};

public type WorkflowDispatchService service object {
    remote function onWorkflowDispatch(WorkflowDispatchEvent payload) returns error?;
};

public type SecurityAndAnalysisService service object {
    remote function onSecurityAndAnalysis(SecurityAndAnalysisEvent payload) returns error?;
};

public type DeployKeyService service object {
    remote function onCreated(DeployKeyEvent payload) returns error?;
    remote function onDeleted(DeployKeyEvent payload) returns error?;
};

public type ProjectColumnService service object {
    remote function onMoved(ProjectColumnEvent payload) returns error?;
    remote function onEdited(ProjectColumnEvent payload) returns error?;
    remote function onDeleted(ProjectColumnEvent payload) returns error?;
    remote function onCreated(ProjectColumnEvent payload) returns error?;
};

public type MarketplacePurchaseService service object {
    remote function onPurchased(MarketplacePurchaseEvent payload) returns error?;
    remote function onCancelled(MarketplacePurchaseEvent payload) returns error?;
    remote function onPendingChangeCancelled(MarketplacePurchaseEvent payload) returns error?;
    remote function onPendingChange(MarketplacePurchaseEvent payload) returns error?;
    remote function onChanged(MarketplacePurchaseEvent payload) returns error?;
};

public type BranchProtectionConfigurationService service object {
    remote function onEnabled(BranchProtectionConfigurationEvent payload) returns error?;
    remote function onDisabled(BranchProtectionConfigurationEvent payload) returns error?;
};

public type PullRequestService service object {
    remote function onEnqueued(PullRequestEvent payload) returns error?;
    remote function onReviewRequestRemoved(PullRequestEvent payload) returns error?;
    remote function onOpened(PullRequestEvent payload) returns error?;
    remote function onReadyForReview(PullRequestEvent payload) returns error?;
    remote function onLabeled(PullRequestEvent payload) returns error?;
    remote function onUnassigned(PullRequestEvent payload) returns error?;
    remote function onEdited(PullRequestEvent payload) returns error?;
    remote function onSynchronize(PullRequestEvent payload) returns error?;
    remote function onReviewRequested(PullRequestEvent payload) returns error?;
    remote function onReopened(PullRequestEvent payload) returns error?;
    remote function onAutoMergeDisabled(PullRequestEvent payload) returns error?;
    remote function onLocked(PullRequestEvent payload) returns error?;
    remote function onAutoMergeEnabled(PullRequestEvent payload) returns error?;
    remote function onMilestoned(PullRequestEvent payload) returns error?;
    remote function onDequeued(PullRequestEvent payload) returns error?;
    remote function onUnlabeled(PullRequestEvent payload) returns error?;
    remote function onClosed(PullRequestEvent payload) returns error?;
    remote function onUnlocked(PullRequestEvent payload) returns error?;
    remote function onAssigned(PullRequestEvent payload) returns error?;
    remote function onConvertedToDraft(PullRequestEvent payload) returns error?;
    remote function onDemilestoned(PullRequestEvent payload) returns error?;
};

public type LabelService service object {
    remote function onEdited(LabelEvent payload) returns error?;
    remote function onCreated(LabelEvent payload) returns error?;
    remote function onDeleted(LabelEvent payload) returns error?;
};

public type DeploymentService service object {
    remote function onDeployment(DeploymentEvent payload) returns error?;
};

public type TeamAddService service object {
    remote function onTeamAdd(TeamAddEvent payload) returns error?;
};

public type CodeScanningAlertService service object {
    remote function onAppearedInBranch(CodeScanningAlertEvent payload) returns error?;
    remote function onClosedByUser(CodeScanningAlertEvent payload) returns error?;
    remote function onCreated(CodeScanningAlertEvent payload) returns error?;
    remote function onFixed(CodeScanningAlertEvent payload) returns error?;
    remote function onReopened(CodeScanningAlertEvent payload) returns error?;
    remote function onReopenedByUser(CodeScanningAlertEvent payload) returns error?;
    remote function onUpdatedAssignment(CodeScanningAlertEvent payload) returns error?;
};

public type MembershipService service object {
    remote function onAdded(MembershipEvent payload) returns error?;
    remote function onRemoved(MembershipEvent payload) returns error?;
};

public type SecretScanningAlertService service object {
    remote function onAssigned(SecretScanningAlertEvent payload) returns error?;
    remote function onReopened(SecretScanningAlertEvent payload) returns error?;
    remote function onUnassigned(SecretScanningAlertEvent payload) returns error?;
    remote function onCreated(SecretScanningAlertEvent payload) returns error?;
    remote function onPubliclyLeaked(SecretScanningAlertEvent payload) returns error?;
    remote function onValidated(SecretScanningAlertEvent payload) returns error?;
    remote function onResolved(SecretScanningAlertEvent payload) returns error?;
};

public type PushService service object {
    remote function onPush(PushEvent payload) returns error?;
};

public type MemberService service object {
    remote function onEdited(MemberEvent payload) returns error?;
    remote function onAdded(MemberEvent payload) returns error?;
    remote function onRemoved(MemberEvent payload) returns error?;
};

public type RepositoryDispatchService service object {
    remote function onRepositoryDispatch(RepositoryDispatchEvent payload) returns error?;
};

public type StatusService service object {
    remote function onStatus(StatusEvent payload) returns error?;
};

public type RepositoryImportService service object {
    remote function onRepositoryImport(RepositoryImportEvent payload) returns error?;
};

public type PersonalAccessTokenRequestService service object {
    remote function onCreated(PersonalAccessTokenRequestEvent payload) returns error?;
    remote function onApproved(PersonalAccessTokenRequestEvent payload) returns error?;
    remote function onDenied(PersonalAccessTokenRequestEvent payload) returns error?;
    remote function onCancelled(PersonalAccessTokenRequestEvent payload) returns error?;
};

public type SubIssuesService service object {
    remote function onChildIssueAdded(SubIssuesEvent payload) returns error?;
    remote function onParentIssueAdded(SubIssuesEvent payload) returns error?;
    remote function onChildIssueRemoved(SubIssuesEvent payload) returns error?;
    remote function onParentIssueRemoved(SubIssuesEvent payload) returns error?;
};

public type RepositoryRulesetService service object {
    remote function onCreated(RepositoryRulesetEvent payload) returns error?;
    remote function onEdited(RepositoryRulesetEvent payload) returns error?;
    remote function onDeleted(RepositoryRulesetEvent payload) returns error?;
};

public type MilestoneService service object {
    remote function onCreated(MilestoneEvent payload) returns error?;
    remote function onEdited(MilestoneEvent payload) returns error?;
    remote function onOpened(MilestoneEvent payload) returns error?;
    remote function onDeleted(MilestoneEvent payload) returns error?;
    remote function onClosed(MilestoneEvent payload) returns error?;
};

public type PublicService service object {
    remote function onPublic(PublicEvent payload) returns error?;
};

public type WorkflowRunService service object {
    remote function onInProgress(WorkflowRunEvent payload) returns error?;
    remote function onCompleted(WorkflowRunEvent payload) returns error?;
    remote function onRequested(WorkflowRunEvent payload) returns error?;
};

public type ProjectsV2statusUpdateService service object {
    remote function onEdited('ProjectsV2StatusUpdateEvent payload) returns error?;
    remote function onDeleted('ProjectsV2StatusUpdateEvent payload) returns error?;
    remote function onCreated('ProjectsV2StatusUpdateEvent payload) returns error?;
};

public type ProjectsV2itemService service object {
    remote function onEdited('ProjectsV2ItemEvent payload) returns error?;
    remote function onCreated('ProjectsV2ItemEvent payload) returns error?;
    remote function onArchived('ProjectsV2ItemEvent payload) returns error?;
    remote function onDeleted('ProjectsV2ItemEvent payload) returns error?;
    remote function onRestored('ProjectsV2ItemEvent payload) returns error?;
    remote function onReordered('ProjectsV2ItemEvent payload) returns error?;
    remote function onConverted('ProjectsV2ItemEvent payload) returns error?;
};

public type SponsorshipService service object {
    remote function onCancelled(SponsorshipEvent payload) returns error?;
    remote function onEdited(SponsorshipEvent payload) returns error?;
    remote function onTierChanged(SponsorshipEvent payload) returns error?;
    remote function onPendingCancellation(SponsorshipEvent payload) returns error?;
    remote function onCreated(SponsorshipEvent payload) returns error?;
    remote function onPendingTierChange(SponsorshipEvent payload) returns error?;
};

public type MergeGroupService service object {
    remote function onDestroyed(MergeGroupEvent payload) returns error?;
    remote function onChecksRequested(MergeGroupEvent payload) returns error?;
};

public type ProjectService service object {
    remote function onDeleted(ProjectEvent payload) returns error?;
    remote function onCreated(ProjectEvent payload) returns error?;
    remote function onClosed(ProjectEvent payload) returns error?;
    remote function onReopened(ProjectEvent payload) returns error?;
    remote function onEdited(ProjectEvent payload) returns error?;
};

public type OrgBlockService service object {
    remote function onBlocked(OrgBlockEvent payload) returns error?;
    remote function onUnblocked(OrgBlockEvent payload) returns error?;
};

public type SecretScanningAlertLocationService service object {
    remote function onSecretScanningAlertLocation(SecretScanningAlertLocationEvent payload) returns error?;
};

public type InstallationTargetService service object {
    remote function onInstallationTarget(InstallationTargetEvent payload) returns error?;
};

public type CheckSuiteService service object {
    remote function onCompleted(CheckSuiteEvent payload) returns error?;
    remote function onRequested(CheckSuiteEvent payload) returns error?;
    remote function onRerequested(CheckSuiteEvent payload) returns error?;
};

public type PingService service object {
    remote function onPing(PingEvent payload) returns error?;
};

public type IssueCommentService service object {
    remote function onEdited(IssueCommentEvent payload) returns error?;
    remote function onPinned(IssueCommentEvent payload) returns error?;
    remote function onDeleted(IssueCommentEvent payload) returns error?;
    remote function onCreated(IssueCommentEvent payload) returns error?;
    remote function onUnpinned(IssueCommentEvent payload) returns error?;
};

public type SecurityAdvisoryService service object {
    remote function onWithdrawn(SecurityAdvisoryEvent payload) returns error?;
    remote function onPublished(SecurityAdvisoryEvent payload) returns error?;
    remote function onUpdated(SecurityAdvisoryEvent payload) returns error?;
};

public type PackageService service object {
    remote function onPublished(PackageEvent payload) returns error?;
    remote function onUpdated(PackageEvent payload) returns error?;
};

public type DiscussionService service object {
    remote function onUnanswered(DiscussionEvent payload) returns error?;
    remote function onCreated(DiscussionEvent payload) returns error?;
    remote function onTransferred(DiscussionEvent payload) returns error?;
    remote function onCategoryChanged(DiscussionEvent payload) returns error?;
    remote function onDeleted(DiscussionEvent payload) returns error?;
    remote function onUnlocked(DiscussionEvent payload) returns error?;
    remote function onPinned(DiscussionEvent payload) returns error?;
    remote function onEdited(DiscussionEvent payload) returns error?;
    remote function onReopened(DiscussionEvent payload) returns error?;
    remote function onAnswered(DiscussionEvent payload) returns error?;
    remote function onClosed(DiscussionEvent payload) returns error?;
    remote function onUnlabeled(DiscussionEvent payload) returns error?;
    remote function onLabeled(DiscussionEvent payload) returns error?;
    remote function onUnpinned(DiscussionEvent payload) returns error?;
    remote function onLocked(DiscussionEvent payload) returns error?;
};

public type ForkService service object {
    remote function onFork(ForkEvent payload) returns error?;
};

public type PullRequestReviewService service object {
    remote function onSubmitted(PullRequestReviewEvent payload) returns error?;
    remote function onEdited(PullRequestReviewEvent payload) returns error?;
    remote function onDismissed(PullRequestReviewEvent payload) returns error?;
};

public type OrganizationService service object {
    remote function onAdded(OrganizationEvent payload) returns error?;
    remote function onRemoved(OrganizationEvent payload) returns error?;
    remote function onDeleted(OrganizationEvent payload) returns error?;
    remote function onRenamed(OrganizationEvent payload) returns error?;
    remote function onMemberInvited(OrganizationEvent payload) returns error?;
};

public type IssuesService service object {
    remote function onReopened(IssuesEvent payload) returns error?;
    remote function onTransferred(IssuesEvent payload) returns error?;
    remote function onUnpinned(IssuesEvent payload) returns error?;
    remote function onAssigned(IssuesEvent payload) returns error?;
    remote function onMilestoned(IssuesEvent payload) returns error?;
    remote function onLabeled(IssuesEvent payload) returns error?;
    remote function onOpened(IssuesEvent payload) returns error?;
    remote function onPinned(IssuesEvent payload) returns error?;
    remote function onTyped(IssuesEvent payload) returns error?;
    remote function onEdited(IssuesEvent payload) returns error?;
    remote function onUntyped(IssuesEvent payload) returns error?;
    remote function onDemilestoned(IssuesEvent payload) returns error?;
    remote function onLocked(IssuesEvent payload) returns error?;
    remote function onUnassigned(IssuesEvent payload) returns error?;
    remote function onUnlocked(IssuesEvent payload) returns error?;
    remote function onUnlabeled(IssuesEvent payload) returns error?;
    remote function onClosed(IssuesEvent payload) returns error?;
    remote function onDeleted(IssuesEvent payload) returns error?;
};

public type RegistryPackageService service object {
    remote function onUpdated(RegistryPackageEvent payload) returns error?;
    remote function onPublished(RegistryPackageEvent payload) returns error?;
};

public type ProjectsV2Service service object {
    remote function onCreated('ProjectsV2Event payload) returns error?;
    remote function onEdited('ProjectsV2Event payload) returns error?;
    remote function onClosed('ProjectsV2Event payload) returns error?;
    remote function onReopened('ProjectsV2Event payload) returns error?;
    remote function onDeleted('ProjectsV2Event payload) returns error?;
};

public type RepositoryVulnerabilityAlertService service object {
    remote function onResolve(RepositoryVulnerabilityAlertEvent payload) returns error?;
    remote function onReopen(RepositoryVulnerabilityAlertEvent payload) returns error?;
    remote function onDismiss(RepositoryVulnerabilityAlertEvent payload) returns error?;
    remote function onCreate(RepositoryVulnerabilityAlertEvent payload) returns error?;
};

public type StarService service object {
    remote function onCreated(StarEvent payload) returns error?;
    remote function onDeleted(StarEvent payload) returns error?;
};

public type CreateService service object {
    remote function onCreate(CreateEvent payload) returns error?;
};

public type DeploymentReviewService service object {
    remote function onRequested(DeploymentReviewEvent payload) returns error?;
    remote function onRejected(DeploymentReviewEvent payload) returns error?;
    remote function onApproved(DeploymentReviewEvent payload) returns error?;
};

public type GollumService service object {
    remote function onGollum(GollumEvent payload) returns error?;
};

public type GithubAppAuthorizationService service object {
    remote function onGithubAppAuthorization(GithubAppAuthorizationEvent payload) returns error?;
};

public type WatchService service object {
    remote function onWatch(WatchEvent payload) returns error?;
};

public type TeamService service object {
    remote function onCreated(TeamEvent payload) returns error?;
    remote function onDeleted(TeamEvent payload) returns error?;
    remote function onEdited(TeamEvent payload) returns error?;
    remote function onAddedToRepository(TeamEvent payload) returns error?;
    remote function onRemovedFromRepository(TeamEvent payload) returns error?;
};

public type WorkflowJobService service object {
    remote function onQueued(WorkflowJobEvent payload) returns error?;
    remote function onWaiting(WorkflowJobEvent payload) returns error?;
    remote function onCompleted(WorkflowJobEvent payload) returns error?;
    remote function onInProgress(WorkflowJobEvent payload) returns error?;
};

public type ReleaseService service object {
    remote function onCreated(ReleaseEvent payload) returns error?;
    remote function onPublished(ReleaseEvent payload) returns error?;
    remote function onReleased(ReleaseEvent payload) returns error?;
    remote function onPrereleased(ReleaseEvent payload) returns error?;
    remote function onUnpublished(ReleaseEvent payload) returns error?;
    remote function onDeleted(ReleaseEvent payload) returns error?;
    remote function onEdited(ReleaseEvent payload) returns error?;
};

public type InstallationService service object {
    remote function onNewPermissionsAccepted(InstallationEvent payload) returns error?;
    remote function onSuspend(InstallationEvent payload) returns error?;
    remote function onCreated(InstallationEvent payload) returns error?;
    remote function onDeleted(InstallationEvent payload) returns error?;
    remote function onUnsuspend(InstallationEvent payload) returns error?;
};

public type CommitCommentService service object {
    remote function onCommitComment(CommitCommentEvent payload) returns error?;
};

public type DiscussionCommentService service object {
    remote function onDeleted(DiscussionCommentEvent payload) returns error?;
    remote function onCreated(DiscussionCommentEvent payload) returns error?;
    remote function onEdited(DiscussionCommentEvent payload) returns error?;
};

public type BranchProtectionRuleService service object {
    remote function onDeleted(BranchProtectionRuleEvent payload) returns error?;
    remote function onEdited(BranchProtectionRuleEvent payload) returns error?;
    remote function onCreated(BranchProtectionRuleEvent payload) returns error?;
};

public type IssueDependenciesService service object {
    remote function onIssueDependencyAdded(IssueDependenciesEvent payload) returns error?;
    remote function onIssueDependencyRemoved(IssueDependenciesEvent payload) returns error?;
};

public type RepositoryService service object {
    remote function onPrivatized(RepositoryEvent payload) returns error?;
    remote function onCreated(RepositoryEvent payload) returns error?;
    remote function onRenamed(RepositoryEvent payload) returns error?;
    remote function onTransferred(RepositoryEvent payload) returns error?;
    remote function onEdited(RepositoryEvent payload) returns error?;
    remote function onDeleted(RepositoryEvent payload) returns error?;
    remote function onArchived(RepositoryEvent payload) returns error?;
    remote function onPublicized(RepositoryEvent payload) returns error?;
    remote function onUnarchived(RepositoryEvent payload) returns error?;
};

public type PullRequestReviewCommentService service object {
    remote function onCreated(PullRequestReviewCommentEvent payload) returns error?;
    remote function onDeleted(PullRequestReviewCommentEvent payload) returns error?;
    remote function onEdited(PullRequestReviewCommentEvent payload) returns error?;
};

public type DeploymentProtectionRuleService service object {
    remote function onDeploymentProtectionRule(DeploymentProtectionRuleEvent payload) returns error?;
};

public type CustomPropertyValuesService service object {
    remote function onCustomPropertyValues(CustomPropertyValuesEvent payload) returns error?;
};

public type InstallationRepositoriesService service object {
    remote function onRemoved(InstallationRepositoriesEvent payload) returns error?;
    remote function onAdded(InstallationRepositoriesEvent payload) returns error?;
};

public type SecretScanningScanService service object {
    remote function onSecretScanningScan(SecretScanningScanEvent payload) returns error?;
};

public type ProjectCardService service object {
    remote function onProjectCardEdited(ProjectCardEvent payload) returns error?;
    remote function onProjectCardDeleted(ProjectCardEvent payload) returns error?;
    remote function onProjectCardMoved(ProjectCardEvent payload) returns error?;
    remote function onProjectCardConverted(ProjectCardEvent payload) returns error?;
    remote function onProjectCardCreated(ProjectCardEvent payload) returns error?;
};

public type CheckRunService service object {
    remote function onCreated(CheckRunEvent payload) returns error?;
    remote function onCompleted(CheckRunEvent payload) returns error?;
    remote function onRequestedAction(CheckRunEvent payload) returns error?;
    remote function onRerequested(CheckRunEvent payload) returns error?;
};

public type PageBuildService service object {
    remote function onPageBuild(PageBuildEvent payload) returns error?;
};

public type CustomPropertyService service object {
    remote function onUpdated(CustomPropertyEvent payload) returns error?;
    remote function onDeleted(CustomPropertyEvent payload) returns error?;
    remote function onPromoteToEnterprise(CustomPropertyEvent payload) returns error?;
    remote function onCreated(CustomPropertyEvent payload) returns error?;
};

public type DependabotAlertService service object {
    remote function onAutoDismissed(DependabotAlertEvent payload) returns error?;
    remote function onAutoReopened(DependabotAlertEvent payload) returns error?;
    remote function onCreated(DependabotAlertEvent payload) returns error?;
    remote function onDismissed(DependabotAlertEvent payload) returns error?;
    remote function onReopened(DependabotAlertEvent payload) returns error?;
    remote function onReintroduced(DependabotAlertEvent payload) returns error?;
    remote function onAssigneesChanged(DependabotAlertEvent payload) returns error?;
    remote function onFixed(DependabotAlertEvent payload) returns error?;
};

public type DeploymentStatusService service object {
    remote function onDeploymentStatus(DeploymentStatusEvent payload) returns error?;
};

public type RepositoryAdvisoryService service object {
    remote function onReported(RepositoryAdvisoryEvent payload) returns error?;
    remote function onPublished(RepositoryAdvisoryEvent payload) returns error?;
};

public type PullRequestReviewThreadService service object {
    remote function onUnresolved(PullRequestReviewThreadEvent payload) returns error?;
    remote function onResolved(PullRequestReviewThreadEvent payload) returns error?;
};

public type GenericServiceType DeleteService|MetaService|WorkflowDispatchService|SecurityAndAnalysisService
    |DeployKeyService|ProjectColumnService|MarketplacePurchaseService|BranchProtectionConfigurationService
    |PullRequestService|LabelService|DeploymentService|TeamAddService|CodeScanningAlertService|MembershipService
    |SecretScanningAlertService|PushService|MemberService|RepositoryDispatchService|StatusService
    |RepositoryImportService|PersonalAccessTokenRequestService|SubIssuesService|RepositoryRulesetService
    |MilestoneService|PublicService|WorkflowRunService|ProjectsV2statusUpdateService|ProjectsV2itemService
    |SponsorshipService|MergeGroupService|ProjectService|OrgBlockService|SecretScanningAlertLocationService
    |InstallationTargetService|CheckSuiteService|PingService|IssueCommentService|SecurityAdvisoryService
    |PackageService|DiscussionService|ForkService|PullRequestReviewService|OrganizationService|IssuesService
    |RegistryPackageService|ProjectsV2Service|RepositoryVulnerabilityAlertService|StarService|CreateService
    |DeploymentReviewService|GollumService|GithubAppAuthorizationService|WatchService|TeamService
    |WorkflowJobService|ReleaseService|InstallationService|CommitCommentService|DiscussionCommentService
    |BranchProtectionRuleService|IssueDependenciesService|RepositoryService|PullRequestReviewCommentService
    |DeploymentProtectionRuleService|CustomPropertyValuesService|InstallationRepositoriesService
    |SecretScanningScanService|ProjectCardService|CheckRunService|PageBuildService|CustomPropertyService
    |DependabotAlertService|DeploymentStatusService|RepositoryAdvisoryService|PullRequestReviewThreadService;
