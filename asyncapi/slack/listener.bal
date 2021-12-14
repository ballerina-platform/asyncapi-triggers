import ballerina/http;
import ballerina/cloud;

@display {label: "Slack", iconPath: "docs/icon.png"}
public class Listener {
    private http:Listener httpListener;
    private DispatcherService dispatcherService;

    public function init(ListenerConfig listenerConfig, @cloud:Expose int|http:Listener listenOn = 8090) returns error? {
       if listenOn is http:Listener {
           self.httpListener = listenOn;
       } else {
           self.httpListener = check new (listenOn);
       }
       self.dispatcherService = new DispatcherService(listenerConfig);
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
        check self.httpListener.attach(self.dispatcherService, ());
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is SlackEventsAppService {
            return "SlackEventsAppService";
        } else if serviceRef is SlackEventsChannelService {
            return "SlackEventsChannelService";
        } else if serviceRef is SlackEventsDndService {
            return "SlackEventsDndService";
        } else if serviceRef is SlackEventsEmailDomainChangedService {
            return "SlackEventsEmailDomainChangedService";
        } else if serviceRef is SlackEventsEmojiChangedService {
            return "SlackEventsEmojiChangedService";
        } else if serviceRef is SlackEventsFileService {
            return "SlackEventsFileService";
        } else if serviceRef is SlackEventsGridMigrationService {
            return "SlackEventsGridMigrationService";
        } else if serviceRef is SlackEventsGroupService {
            return "SlackEventsGroupService";
        } else if serviceRef is SlackEventsImService {
            return "SlackEventsImService";
        } else if serviceRef is SlackEventsLinkSharedService {
            return "SlackEventsLinkSharedService";
        } else if serviceRef is SlackEventsMemberService {
            return "SlackEventsMemberService";
        } else if serviceRef is SlackEventsMessageService {
            return "SlackEventsMessageService";
        } else if serviceRef is SlackEventsPinService {
            return "SlackEventsPinService";
        } else if serviceRef is SlackEventsReactionService {
            return "SlackEventsReactionService";
        } else if serviceRef is SlackEventsResourcesService {
            return "SlackEventsResourcesService";
        } else if serviceRef is SlackEventsScopeService {
            return "SlackEventsScopeService";
        } else if serviceRef is SlackEventsStarService {
            return "SlackEventsStarService";
        } else if serviceRef is SlackEventsSubteamService {
            return "SlackEventsSubteamService";
        } else if serviceRef is SlackEventsTeamService {
            return "SlackEventsTeamService";
        } else if serviceRef is SlackEventsTokensRevokedService {
            return "SlackEventsTokensRevokedService";
        } else if serviceRef is SlackEventsUrlVerificationService {
            return "SlackEventsUrlVerificationService";
        } else {
            return "SlackEventsUserChangeService";
        }
    }
}
