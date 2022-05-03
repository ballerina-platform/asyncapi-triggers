# Actions related to apps. Available methods are onAppMention, onAppRateLimited and onAppUninstalled
public type AppService service object {
    remote function onAppMention(GenericEventWrapper payload) returns error?;
    remote function onAppRateLimited(GenericEventWrapper payload) returns error?;
    remote function onAppUninstalled(GenericEventWrapper payload) returns error?;
};

# Actions related to Slack channels. Available methods are onChannelArchive, onChannelCreated, 
# onChannelDeleted, onChannelHistoryChanged, onChannelLeft, onChannelRename and onChannelUnarchive
public type ChannelService service object {
    remote function onChannelArchive(GenericEventWrapper payload) returns error?;
    remote function onChannelCreated(GenericEventWrapper payload) returns error?;
    remote function onChannelDeleted(GenericEventWrapper payload) returns error?;
    remote function onChannelHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onChannelLeft(GenericEventWrapper payload) returns error?;
    remote function onChannelRename(GenericEventWrapper payload) returns error?;
    remote function onChannelUnarchive(GenericEventWrapper payload) returns error?;
};

# Actions related to Slack do not disturb settings (dnd). Available methods are onDndUpdated and onDndUpdatedUser
public type DndService service object {
    remote function onDndUpdated(GenericEventWrapper payload) returns error?;
    remote function onDndUpdatedUser(GenericEventWrapper payload) returns error?;
};

# Actions related to workspace email domain changes. Available method is onEmailDomainChanged
public type EmailDomainChangedService service object {
    remote function onEmailDomainChanged(GenericEventWrapper payload) returns error?;
};

# Actions related to custom emoji changes. Available method is onEmojiChanged
public type EmojiChangedService service object {
    remote function onEmojiChanged(GenericEventWrapper payload) returns error?;
};

# Actions related to files. Available methods are onFileChange, onFileCommentAdded, 
# onFileCommentDeleted, onFileCommentEdited, onFileCreated, onFileDeleted, onFilePublic, onFileShared and onFileUnshared
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

# Actions related to grid migrations. Available methods are onGridMigrationFinished and onGridMigrationStarted
public type GridMigrationService service object {
    remote function onGridMigrationFinished(GenericEventWrapper payload) returns error?;
    remote function onGridMigrationStarted(GenericEventWrapper payload) returns error?;
};

# Actions related to Slack groups. Available methods are onGroupArchive, onGroupClose, 
# onGroupHistoryChanged, onGroupLeft, onGroupOpen, onGroupRename and onGroupUnarchive
public type GroupService service object {
    remote function onGroupArchive(GenericEventWrapper payload) returns error?;
    remote function onGroupClose(GenericEventWrapper payload) returns error?;
    remote function onGroupHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onGroupLeft(GenericEventWrapper payload) returns error?;
    remote function onGroupOpen(GenericEventWrapper payload) returns error?;
    remote function onGroupRename(GenericEventWrapper payload) returns error?;
    remote function onGroupUnarchive(GenericEventWrapper payload) returns error?;
};

# Actions related to direct message channels. Available methods are onImClose, onImCreated, onImHistoryChanged and onImOpen
public type ImService service object {
    remote function onImClose(GenericEventWrapper payload) returns error?;
    remote function onImCreated(GenericEventWrapper payload) returns error?;
    remote function onImHistoryChanged(GenericEventWrapper payload) returns error?;
    remote function onImOpen(GenericEventWrapper payload) returns error?;
};

# Actions related to link sharing. Available method is onLinkShared
public type LinkSharedService service object {
    remote function onLinkShared(GenericEventWrapper payload) returns error?;
};

# Actions related to members. Available methods are onMemberJoinedChannel and onMemberLeftChannel
public type MemberService service object {
    remote function onMemberJoinedChannel(GenericEventWrapper payload) returns error?;
    remote function onMemberLeftChannel(GenericEventWrapper payload) returns error?;
};

# Actions related to messages. Available methods are onMessage, onMessageAppHome, onMessageChannels, 
# onMessageGroups, onMessageIm and onMessageMpim
public type MessageService service object {
    remote function onMessage(Message payload) returns error?;
    remote function onMessageAppHome(GenericEventWrapper payload) returns error?;
    remote function onMessageChannels(GenericEventWrapper payload) returns error?;
    remote function onMessageGroups(GenericEventWrapper payload) returns error?;
    remote function onMessageIm(GenericEventWrapper payload) returns error?;
    remote function onMessageMpim(GenericEventWrapper payload) returns error?;
};

# Actions related to pins of items. Available methods are onPinAdded and onPinRemoved
public type PinService service object {
    remote function onPinAdded(GenericEventWrapper payload) returns error?;
    remote function onPinRemoved(GenericEventWrapper payload) returns error?;
};

# Actions related to reactions. Available methods are onReactionAdded and onReactionRemoved
public type ReactionService service object {
    remote function onReactionAdded(GenericEventWrapper payload) returns error?;
    remote function onReactionRemoved(GenericEventWrapper payload) returns error?;
};

# Actions related to resources. Available methods are onResourcesAdded and onResourcesRemoved
public type ResourcesService service object {
    remote function onResourcesAdded(GenericEventWrapper payload) returns error?;
    remote function onResourcesRemoved(GenericEventWrapper payload) returns error?;
};

# Actions related to OAuth scopes. Available methods are onScopeDenied and onScopeGranted
public type ScopeService service object {
    remote function onScopeDenied(GenericEventWrapper payload) returns error?;
    remote function onScopeGranted(GenericEventWrapper payload) returns error?;
};

# Actions related to adding and removing stars to items. Available methods are StarService and onStarRemoved
public type StarService service object {
    remote function onStarAdded(GenericEventWrapper payload) returns error?;
    remote function onStarRemoved(GenericEventWrapper payload) returns error?;
};

# Actions related to adding and removing stars to items. Available methods are StarService and onStarRemoved
public type SubteamService service object {
    remote function onSubteamCreated(GenericEventWrapper payload) returns error?;
    remote function onSubteamMembersChanged(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfAdded(GenericEventWrapper payload) returns error?;
    remote function onSubteamSelfRemoved(GenericEventWrapper payload) returns error?;
    remote function onSubteamUpdated(GenericEventWrapper payload) returns error?;
};

# Actions related to teams. Available methods are onTeamDomainChange, onTeamJoin and onTeamRename
public type TeamService service object {
    remote function onTeamDomainChange(GenericEventWrapper payload) returns error?;
    remote function onTeamJoin(GenericEventWrapper payload) returns error?;
    remote function onTeamRename(GenericEventWrapper payload) returns error?;
};

# Actions related to tokens. Available method is onTokensRevoked
public type TokensRevokedService service object {
    remote function onTokensRevoked(GenericEventWrapper payload) returns error?;
};

# Actions related to url verifications. Available method is onUrlVerification
public type UrlVerificationService service object {
    remote function onUrlVerification(GenericEventWrapper payload) returns error?;
};

# Actions related to user changes. Available method is onUserChange
public type UserChangeService service object {
    remote function onUserChange(GenericEventWrapper payload) returns error?;
};

public type GenericServiceType AppService|ChannelService|DndService|EmailDomainChangedService|EmojiChangedService|FileService|GridMigrationService|GroupService|ImService|LinkSharedService|MemberService|MessageService|PinService|ReactionService|ResourcesService|ScopeService|StarService|SubteamService|TeamService|TokensRevokedService|UrlVerificationService|UserChangeService;
