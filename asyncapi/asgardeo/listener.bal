import ballerina/websub;
import ballerina/http;
import ballerina/cloud;

@display {label: "Asgardeo", iconPath: "docs/icon.png"}
public class Listener {
    private websub:Listener websubListener;
    private DispatcherService dispatcherService;
    private ListenerConfig config;
    private http:ClientConfiguration httpConfig = {};
    private string[] topics = [];

    public function init(ListenerConfig listenerConfig, @cloud:Expose int|http:Listener listenOn = 8090) returns error? {
        self.websubListener = check new (listenOn);
        self.config = listenerConfig;
        self.dispatcherService = new DispatcherService();
        string token = check self.fetchToken(listenerConfig.tokenEndpointHost, listenerConfig.clientId, listenerConfig.clientSecret);
        http:ClientConfiguration httpConfig = {
            auth: {
                token: token
            }
        };
        self.httpConfig = httpConfig;
    }

    private isolated function fetchToken(string tokenEndpoint, string clientId, string clientSecret) returns string|error {
        final http:Client clientEndpoint = check new (tokenEndpoint);
        string authHeader = string `${clientId}:${clientSecret}`;
        http:Request tokenRequest = new;
        tokenRequest.setHeader("Authorization", "Basic " + authHeader.toBytes().toBase64());
        tokenRequest.setHeader("Content-Type", "application/json");
        tokenRequest.setPayload({
            "grant_type": "client_credentials"
        });
        json resp = check clientEndpoint->post("/oauth2/token", tokenRequest);
        string accessToken = check resp.access_token;
        return accessToken;
    }

    public isolated function attach(GenericServiceType serviceRef, () attachPoint) returns @tainted error? {
        self.topics.push(self.getTopic(serviceRef));
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.addServiceRef(serviceTypeStr, serviceRef);
    }

    public isolated function detach(GenericServiceType serviceRef) returns error? {
        string serviceTypeStr = self.getServiceTypeStr(serviceRef);
        check self.dispatcherService.removeServiceRef(serviceTypeStr);
    }

    public isolated function 'start() returns error? {
        websub:SubscriberServiceConfiguration subConfig = {
            target: [self.config.hubURL, self.topics[0]],
            callback: self.config.callbackURL,
            appendServicePath: false,
            secret: self.config.hubSecret,
            httpConfig: self.httpConfig
        };
        check self.websubListener.attachWithConfig(self.dispatcherService, subConfig);
        return self.websubListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        return self.websubListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.websubListener.immediateStop();
    }

    private isolated function getServiceTypeStr(GenericServiceType serviceRef) returns string {
        if serviceRef is RegistrationService {
            return "RegistrationService";
        } else if serviceRef is UserOperationService {
            return "UserOperationService";
        } else {
            return "LoginService";
        }
    }

    private isolated function getTopic(GenericServiceType serviceRef) returns string {
        string base = string `${self.config.organization}-`;
        if serviceRef is RegistrationService {
            return base + "REGISTRATIONS";
        } else if serviceRef is UserOperationService {
            return base + "USER_OPERATIONS";
        } else {
            return base + "LOGINS";
        }
    }
}
