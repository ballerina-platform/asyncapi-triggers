# Triggers when a new event is received related to a Slack app. 
# Available actions: onAppMention, onAppRateLimited, and onAppUninstalled
public type AppService service object {
    remote function onAppMention(GenericEventWrapper payload) returns error?;
    remote function onAppRateLimited(GenericEventWrapper payload) returns error?;
    remote function onAppUninstalled(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to a Slack channel. 
# Available actions: onChannelArchive, onChannelCreated, onChannelDeleted,
# onChannelHistoryChanged, onChannelLeft, onChannelRename, and onChannelUnarchive
public type ChannelService service object {
    remote function onChannelArchive(GenericEventWrapper payload) returns error?;
    remote function onChannelCreated(GenericEventWrapper payload) returns error?;
    remote function onChannelDeleted(GenericEventWrapper payload) returns error?;
    remote function onChannelHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onChannelLeft(GenericEventWrapper payload) returns error?;
    remote function onChannelRename(GenericEventWrapper payload) returns error?;
    remote function onChannelUnarchive(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to Slack Do Not Disturb (DND) settings. 
# Available actions: onDndUpdated, and onDndUpdatedUser
public type DndService service object {
    remote function onDndUpdated(GenericEventWrapper payload) returns error?;
    remote function onDndUpdatedUser(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to workspace email domain changes. 
# Available action: onEmailDomainChanged
public type EmailDomainChangedService service object {
    remote function onEmailDomainChanged(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to custom emoji changes.
# Available action: onEmojiChanged
public type EmojiChangedService service object {
    remote function onEmojiChanged(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to files.
# Available actions: onFileChange, onFileCommentAdded, onFileCommentDeleted,
# onFileCommentEdited, onFileCreated, onFileDeleted, onFilePublic, onFileShared, and onFileUnshared
public type FileService service object {
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

# Triggers when a new event is received related to grid migrations. 
# Available actions: onGridMigrationFinished, and onGridMigrationStarted
public type GridMigrationService service object {
    remote function onGridMigrationFinished(GenericEventWrapper payload) returns error?;
    remote function onGridMigrationStarted(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to Slack groups. 
# Available actions: onGroupArchive, onGroupClose, onGroupHistoryChanged,
# onGroupLeft, onGroupOpen, onGroupRename, and onGroupUnarchive
public type GroupService service object {
    remote function onGroupArchive(GenericEventWrapper payload) returns error?;
    remote function onGroupClose(GenericEventWrapper payload) returns error?;
    remote function onGroupHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onGroupLeft(GenericEventWrapper payload) returns error?;
    remote function onGroupOpen(GenericEventWrapper payload) returns error?;
    remote function onGroupRename(GenericEventWrapper payload) returns error?;
    remote function onGroupUnarchive(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to direct message channels. 
# Available actions: onImClose, onImCreated, onImHistoryChanged, and onImOpen
public type ImService service object {
    remote function onImClose(GenericEventWrapper payload) returns error?;
    remote function onImCreated(GenericEventWrapper payload) returns error?;
    remote function onImHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onImOpen(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to link sharing. 
# Available action: onLinkShared
public type LinkSharedService service object {
    remote function onLinkShared(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to Slack workspace members. 
# Available actions: onMemberJoinedChannel, and onMemberLeftChannel
public type MemberService service object {
    remote function onMemberJoinedChannel(GenericEventWrapper payload) returns error?;
    remote function onMemberLeftChannel(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to messages. 
# Available actions: onMessage, onMessageAppHome, onMessageChannels, 
# onMessageGroups, onMessageIm, and onMessageMpim
public type MessageService service object {
    remote function onMessage(Message payload) returns error?;
    remote function onMessageAppHome(GenericEventWrapper payload) returns error?;
    remote function onMessageChannels(GenericEventWrapper payload) returns error?;
    remote function onMessageGroups(GenericEventWrapper payload) returns error?;
    remote function onMessageIm(GenericEventWrapper payload) returns error?;
    remote function onMessageMpim(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to pins of items. 
# Available actions: onPinAdded, and onPinRemoved
public type PinService service object {
    remote function onPinAdded(GenericEventWrapper payload) returns error?;
    remote function onPinRemoved(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to reactions. 
# Available actions: onReactionAdded, and onReactionRemoved
public type ReactionService service object {
    remote function onReactionAdded(GenericEventWrapper payload) returns error?;
    remote function onReactionRemoved(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to resources. 
# Available actions: onResourcesAdded, and onResourcesRemoved
public type ResourcesService service object {
    remote function onResourcesAdded(GenericEventWrapper payload) returns error?;
    remote function onResourcesRemoved(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to OAuth scopes. 
# Available actions: onScopeDenied, and onScopeGranted
public type ScopeService service object {
    remote function onScopeDenied(GenericEventWrapper payload) returns error?;
    remote function onScopeGranted(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to adding and removing stars to items. 
# Available actions: StarService, and onStarRemoved
public type StarService service object {
    remote function onStarAdded(GenericEventWrapper payload) returns error?;
    remote function onStarRemoved(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to sub-teams. 
# Available actions: onSubteamCreated, onSubteamMembersChanged, onSubteamSelfAdded, onSubteamSelfRemoved, and onSubteamUpdated
public type SubteamService service object {
    remote function onSubteamCreated(GenericEventWrapper payload) returns error?;
    remote function onSubteamMembersChanged(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfAdded(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfRemoved(GenericEventWrapper payload) returns error?;
    remote function onSubteamUpdated(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to teams. 
# Available actions: onTeamDomainChange, onTeamJoin, and onTeamRename
public type TeamService service object {
    remote function onTeamDomainChange(GenericEventWrapper payload) returns error?;
    remote function onTeamJoin(GenericEventWrapper payload) returns error?;
    remote function onTeamRename(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to tokens. 
# Available action: onTokensRevoked
public type TokensRevokedService service object {
    remote function onTokensRevoked(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to url verifications. 
# Available action: onUrlVerification
public type UrlVerificationService service object {
    remote function onUrlVerification(GenericEventWrapper payload) returns error?;
};

# Triggers when a new event is received related to user changes. 
# Available action: onUserChange
public type UserChangeService service object {
    remote function onUserChange(GenericEventWrapper payload) returns error?;
};

public type GenericServiceType AppService|ChannelService|DndService|EmailDomainChangedService|EmojiChangedService|FileService|GridMigrationService|GroupService|ImService|LinkSharedService|MemberService|MessageService|PinService|ReactionService|ResourcesService|ScopeService|StarService|SubteamService|TeamService|TokensRevokedService|UrlVerificationService|UserChangeService;
