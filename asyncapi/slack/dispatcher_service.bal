import ballerina/http;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string verificationToken;

    public function init(string verificationToken) {
      self.verificationToken = verificationToken;
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
        json payload = check request.getJsonPayload();
        // Intent verification Handling
        if (payload.token !== self.verificationToken) {
            return error("Verification token mismatch");
        }
        string eventOrVerification = check payload.'type;
        if (eventOrVerification == "url_verification") {
            check self.verifyURL(caller, payload);
        } else {
            GenericDataType genericDataType = check payload.cloneWithType(GenericDataType);
            check self.matchRemoteFunc(genericDataType);
            check caller->respond(http:STATUS_OK);
        }
    }

    private function matchRemoteFunc(GenericDataType genericDataType) returns error? {
        match genericDataType.event.'type {
            "app_mention" => {
                check self.executeRemoteFunc(genericDataType, "app_mention", "SlackEventsAppService", "onAppMention");
            }
            "app_rate_limited" => {
                check self.executeRemoteFunc(genericDataType, "app_rate_limited", "SlackEventsAppService", "onAppRateLimited");
            }
            "app_uninstalled" => {
                check self.executeRemoteFunc(genericDataType, "app_uninstalled", "SlackEventsAppService", "onAppUninstalled");
            }
            "channel_archive" => {
                check self.executeRemoteFunc(genericDataType, "channel_archive", "SlackEventsChannelService", "onChannelArchive");
            }
            "channel_created" => {
                check self.executeRemoteFunc(genericDataType, "channel_created", "SlackEventsChannelService", "onChannelCreated");
            }
            "channel_deleted" => {
                check self.executeRemoteFunc(genericDataType, "channel_deleted", "SlackEventsChannelService", "onChannelDeleted");
            }
            "channel_history_changed" => {
                check self.executeRemoteFunc(genericDataType, "channel_history_changed", "SlackEventsChannelService", "onChannelHistoryChanged");
            }
            "channel_left" => {
                check self.executeRemoteFunc(genericDataType, "channel_left", "SlackEventsChannelService", "onChannelLeft");
            }
            "channel_rename" => {
                check self.executeRemoteFunc(genericDataType, "channel_rename", "SlackEventsChannelService", "onChannelRename");
            }
            "channel_unarchive" => {
                check self.executeRemoteFunc(genericDataType, "channel_unarchive", "SlackEventsChannelService", "onChannelUnarchive");
            }
            "dnd_updated" => {
                check self.executeRemoteFunc(genericDataType, "dnd_updated", "SlackEventsDndService", "onDndUpdated");
            }
            "dnd_updated_user" => {
                check self.executeRemoteFunc(genericDataType, "dnd_updated_user", "SlackEventsDndService", "onDndUpdatedUser");
            }
            "email_domain_changed" => {
                check self.executeRemoteFunc(genericDataType, "email_domain_changed", "SlackEventsEmailDomainChangedService", "onEmailDomainChanged");
            }
            "emoji_changed" => {
                check self.executeRemoteFunc(genericDataType, "emoji_changed", "SlackEventsEmojiChangedService", "onEmojiChanged");
            }
            "file_change" => {
                check self.executeRemoteFunc(genericDataType, "file_change", "SlackEventsFileService", "onFileChange");
            }
            "file_comment_added" => {
                check self.executeRemoteFunc(genericDataType, "file_comment_added", "SlackEventsFileService", "onFileCommentAdded");
            }
            "file_comment_deleted" => {
                check self.executeRemoteFunc(genericDataType, "file_comment_deleted", "SlackEventsFileService", "onFileCommentDeleted");
            }
            "file_comment_edited" => {
                check self.executeRemoteFunc(genericDataType, "file_comment_edited", "SlackEventsFileService", "onFileCommentEdited");
            }
            "file_created" => {
                check self.executeRemoteFunc(genericDataType, "file_created", "SlackEventsFileService", "onFileCreated");
            }
            "file_deleted" => {
                check self.executeRemoteFunc(genericDataType, "file_deleted", "SlackEventsFileService", "onFileDeleted");
            }
            "file_public" => {
                check self.executeRemoteFunc(genericDataType, "file_public", "SlackEventsFileService", "onFilePublic");
            }
            "file_shared" => {
                check self.executeRemoteFunc(genericDataType, "file_shared", "SlackEventsFileService", "onFileShared");
            }
            "file_unshared" => {
                check self.executeRemoteFunc(genericDataType, "file_unshared", "SlackEventsFileService", "onFileUnshared");
            }
            "grid_migration_finished" => {
                check self.executeRemoteFunc(genericDataType, "grid_migration_finished", "SlackEventsGridMigrationService", "onGridMigrationFinished");
            }
            "grid_migration_started" => {
                check self.executeRemoteFunc(genericDataType, "grid_migration_started", "SlackEventsGridMigrationService", "onGridMigrationStarted");
            }
            "group_archive" => {
                check self.executeRemoteFunc(genericDataType, "group_archive", "SlackEventsGroupService", "onGroupArchive");
            }
            "group_close" => {
                check self.executeRemoteFunc(genericDataType, "group_close", "SlackEventsGroupService", "onGroupClose");
            }
            "group_history_changed" => {
                check self.executeRemoteFunc(genericDataType, "group_history_changed", "SlackEventsGroupService", "onGroupHistoryChanged");
            }
            "group_left" => {
                check self.executeRemoteFunc(genericDataType, "group_left", "SlackEventsGroupService", "onGroupLeft");
            }
            "group_open" => {
                check self.executeRemoteFunc(genericDataType, "group_open", "SlackEventsGroupService", "onGroupOpen");
            }
            "group_rename" => {
                check self.executeRemoteFunc(genericDataType, "group_rename", "SlackEventsGroupService", "onGroupRename");
            }
            "group_unarchive" => {
                check self.executeRemoteFunc(genericDataType, "group_unarchive", "SlackEventsGroupService", "onGroupUnarchive");
            }
            "im_close" => {
                check self.executeRemoteFunc(genericDataType, "im_close", "SlackEventsImService", "onImClose");
            }
            "im_created" => {
                check self.executeRemoteFunc(genericDataType, "im_created", "SlackEventsImService", "onImCreated");
            }
            "im_history_changed" => {
                check self.executeRemoteFunc(genericDataType, "im_history_changed", "SlackEventsImService", "onImHistoryChanged");
            }
            "im_open" => {
                check self.executeRemoteFunc(genericDataType, "im_open", "SlackEventsImService", "onImOpen");
            }
            "link_shared" => {
                check self.executeRemoteFunc(genericDataType, "link_shared", "SlackEventsLinkSharedService", "onLinkShared");
            }
            "member_joined_channel" => {
                check self.executeRemoteFunc(genericDataType, "member_joined_channel", "SlackEventsMemberService", "onMemberJoinedChannel");
            }
            "member_left_channel" => {
                check self.executeRemoteFunc(genericDataType, "member_left_channel", "SlackEventsMemberService", "onMemberLeftChannel");
            }
            "message" => {
                check self.executeRemoteFunc(genericDataType, "message", "SlackEventsMessageService", "onMessage");
            }
            "message.app_home" => {
                check self.executeRemoteFunc(genericDataType, "message.app_home", "SlackEventsMessageService", "onMessageAppHome");
            }
            "message.channels" => {
                check self.executeRemoteFunc(genericDataType, "message.channels", "SlackEventsMessageService", "onMessageChannels");
            }
            "message.groups" => {
                check self.executeRemoteFunc(genericDataType, "message.groups", "SlackEventsMessageService", "onMessageGroups");
            }
            "message.im" => {
                check self.executeRemoteFunc(genericDataType, "message.im", "SlackEventsMessageService", "onMessageIm");
            }
            "message.mpim" => {
                check self.executeRemoteFunc(genericDataType, "message.mpim", "SlackEventsMessageService", "onMessageMpim");
            }
            "pin_added" => {
                check self.executeRemoteFunc(genericDataType, "pin_added", "SlackEventsPinService", "onPinAdded");
            }
            "pin_removed" => {
                check self.executeRemoteFunc(genericDataType, "pin_removed", "SlackEventsPinService", "onPinRemoved");
            }
            "reaction_added" => {
                check self.executeRemoteFunc(genericDataType, "reaction_added", "SlackEventsReactionService", "onReactionAdded");
            }
            "reaction_removed" => {
                check self.executeRemoteFunc(genericDataType, "reaction_removed", "SlackEventsReactionService", "onReactionRemoved");
            }
            "resources_added" => {
                check self.executeRemoteFunc(genericDataType, "resources_added", "SlackEventsResourcesService", "onResourcesAdded");
            }
            "resources_removed" => {
                check self.executeRemoteFunc(genericDataType, "resources_removed", "SlackEventsResourcesService", "onResourcesRemoved");
            }
            "scope_denied" => {
                check self.executeRemoteFunc(genericDataType, "scope_denied", "SlackEventsScopeService", "onScopeDenied");
            }
            "scope_granted" => {
                check self.executeRemoteFunc(genericDataType, "scope_granted", "SlackEventsScopeService", "onScopeGranted");
            }
            "star_added" => {
                check self.executeRemoteFunc(genericDataType, "star_added", "SlackEventsStarService", "onStarAdded");
            }
            "star_removed" => {
                check self.executeRemoteFunc(genericDataType, "star_removed", "SlackEventsStarService", "onStarRemoved");
            }
            "subteam_created" => {
                check self.executeRemoteFunc(genericDataType, "subteam_created", "SlackEventsSubteamService", "onSubteamCreated");
            }
            "subteam_members_changed" => {
                check self.executeRemoteFunc(genericDataType, "subteam_members_changed", "SlackEventsSubteamService", "onSubteamMembersChanged");
            }
            "subteam_self_added" => {
                check self.executeRemoteFunc(genericDataType, "subteam_self_added", "SlackEventsSubteamService", "onSubteamSelfAdded");
            }
            "subteam_self_removed" => {
                check self.executeRemoteFunc(genericDataType, "subteam_self_removed", "SlackEventsSubteamService", "onSubteamSelfRemoved");
            }
            "subteam_updated" => {
                check self.executeRemoteFunc(genericDataType, "subteam_updated", "SlackEventsSubteamService", "onSubteamUpdated");
            }
            "team_domain_change" => {
                check self.executeRemoteFunc(genericDataType, "team_domain_change", "SlackEventsTeamService", "onTeamDomainChange");
            }
            "team_join" => {
                check self.executeRemoteFunc(genericDataType, "team_join", "SlackEventsTeamService", "onTeamJoin");
            }
            "team_rename" => {
                check self.executeRemoteFunc(genericDataType, "team_rename", "SlackEventsTeamService", "onTeamRename");
            }
            "tokens_revoked" => {
                check self.executeRemoteFunc(genericDataType, "tokens_revoked", "SlackEventsTokensRevokedService", "onTokensRevoked");
            }
            "url_verification" => {
                check self.executeRemoteFunc(genericDataType, "url_verification", "SlackEventsUrlVerificationService", "onUrlVerification");
            }
            "user_change" => {
                check self.executeRemoteFunc(genericDataType, "user_change", "SlackEventsUserChangeService", "onUserChange");
            }
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }

    isolated function verifyURL(http:Caller caller, json payload) returns @untainted error? {
      http:Response response = new;
      response.statusCode = http:STATUS_OK;
      response.setPayload({challenge: check <@untainted>payload.challenge});
      check caller->respond(response);
  }
}
