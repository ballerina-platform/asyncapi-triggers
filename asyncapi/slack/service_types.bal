public type SlackEventsAppService service object {
    remote function onAppMention(GenericEventWrapper payload) returns error?;
    remote function onAppRateLimited(GenericEventWrapper payload) returns error?;
    remote function onAppUninstalled(GenericEventWrapper payload) returns error?;
};

public type SlackEventsChannelService service object {
    remote function onChannelArchive(GenericEventWrapper payload) returns error?;
    remote function onChannelCreated(GenericEventWrapper payload) returns error?;
    remote function onChannelDeleted(GenericEventWrapper payload) returns error?;
    remote function onChannelHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onChannelLeft(GenericEventWrapper payload) returns error?;
    remote function onChannelRename(GenericEventWrapper payload) returns error?;
    remote function onChannelUnarchive(GenericEventWrapper payload) returns error?;
};

public type SlackEventsDndService service object {
    remote function onDndUpdated(GenericEventWrapper payload) returns error?;
    remote function onDndUpdatedUser(GenericEventWrapper payload) returns error?;
};

public type SlackEventsEmailDomainChangedService service object {
    remote function onEmailDomainChanged(GenericEventWrapper payload) returns error?;
};

public type SlackEventsEmojiChangedService service object {
    remote function onEmojiChanged(GenericEventWrapper payload) returns error?;
};

public type SlackEventsFileService service object {
    remote function onFileChange(GenericEventWrapper payload) returns error?;
    remote function onFileCommentAdded(GenericEventWrapper payload) returns error?;
    remote function onFileCommentDeleted(GenericEventWrapper payload) returns error?;
    remote function onFileCommentEdited(GenericEventWrapper payload) returns error?;
    remote function onFileCreated(GenericEventWrapper payload) returns error?;
    remote function onFileDeleted(GenericEventWrapper payload) returns error?;
    remote function onFilePublic(GenericEventWrapper payload) returns error?;
    remote function onFileShared(GenericEventWrapper payload) returns error?;
    remote function onFileUnshared(GenericEventWrapper payload) returns error?;
};

public type SlackEventsGridMigrationService service object {
    remote function onGridMigrationFinished(GenericEventWrapper payload) returns error?;
    remote function onGridMigrationStarted(GenericEventWrapper payload) returns error?;
};

public type SlackEventsGroupService service object {
    remote function onGroupArchive(GenericEventWrapper payload) returns error?;
    remote function onGroupClose(GenericEventWrapper payload) returns error?;
    remote function onGroupHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onGroupLeft(GenericEventWrapper payload) returns error?;
    remote function onGroupOpen(GenericEventWrapper payload) returns error?;
    remote function onGroupRename(GenericEventWrapper payload) returns error?;
    remote function onGroupUnarchive(GenericEventWrapper payload) returns error?;
};

public type SlackEventsImService service object {
    remote function onImClose(GenericEventWrapper payload) returns error?;
    remote function onImCreated(GenericEventWrapper payload) returns error?;
    remote function onImHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onImOpen(GenericEventWrapper payload) returns error?;
};

public type SlackEventsLinkSharedService service object {
    remote function onLinkShared(GenericEventWrapper payload) returns error?;
};

public type SlackEventsMemberService service object {
    remote function onMemberJoinedChannel(GenericEventWrapper payload) returns error?;
    remote function onMemberLeftChannel(GenericEventWrapper payload) returns error?;
};

public type SlackEventsMessageService service object {
    remote function onMessage(Message payload) returns error?;
    remote function onMessageAppHome(GenericEventWrapper payload) returns error?;
    remote function onMessageChannels(GenericEventWrapper payload) returns error?;
    remote function onMessageGroups(GenericEventWrapper payload) returns error?;
    remote function onMessageIm(GenericEventWrapper payload) returns error?;
    remote function onMessageMpim(GenericEventWrapper payload) returns error?;
};

public type SlackEventsPinService service object {
    remote function onPinAdded(GenericEventWrapper payload) returns error?;
    remote function onPinRemoved(GenericEventWrapper payload) returns error?;
};

public type SlackEventsReactionService service object {
    remote function onReactionAdded(GenericEventWrapper payload) returns error?;
    remote function onReactionRemoved(GenericEventWrapper payload) returns error?;
};

public type SlackEventsResourcesService service object {
    remote function onResourcesAdded(GenericEventWrapper payload) returns error?;
    remote function onResourcesRemoved(GenericEventWrapper payload) returns error?;
};

public type SlackEventsScopeService service object {
    remote function onScopeDenied(GenericEventWrapper payload) returns error?;
    remote function onScopeGranted(GenericEventWrapper payload) returns error?;
};

public type SlackEventsStarService service object {
    remote function onStarAdded(GenericEventWrapper payload) returns error?;
    remote function onStarRemoved(GenericEventWrapper payload) returns error?;
};

public type SlackEventsSubteamService service object {
    remote function onSubteamCreated(GenericEventWrapper payload) returns error?;
    remote function onSubteamMembersChanged(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfAdded(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfRemoved(GenericEventWrapper payload) returns error?;
    remote function onSubteamUpdated(GenericEventWrapper payload) returns error?;
};

public type SlackEventsTeamService service object {
    remote function onTeamDomainChange(GenericEventWrapper payload) returns error?;
    remote function onTeamJoin(GenericEventWrapper payload) returns error?;
    remote function onTeamRename(GenericEventWrapper payload) returns error?;
};

public type SlackEventsTokensRevokedService service object {
    remote function onTokensRevoked(GenericEventWrapper payload) returns error?;
};

public type SlackEventsUrlVerificationService service object {
    remote function onUrlVerification(GenericEventWrapper payload) returns error?;
};

public type SlackEventsUserChangeService service object {
    remote function onUserChange(GenericEventWrapper payload) returns error?;
};

public type GenericServiceType SlackEventsAppService|SlackEventsChannelService|SlackEventsDndService|SlackEventsEmailDomainChangedService|SlackEventsEmojiChangedService|SlackEventsFileService|SlackEventsGridMigrationService|SlackEventsGroupService|SlackEventsImService|SlackEventsLinkSharedService|SlackEventsMemberService|SlackEventsMessageService|SlackEventsPinService|SlackEventsReactionService|SlackEventsResourcesService|SlackEventsScopeService|SlackEventsStarService|SlackEventsSubteamService|SlackEventsTeamService|SlackEventsTokensRevokedService|SlackEventsUrlVerificationService|SlackEventsUserChangeService;
