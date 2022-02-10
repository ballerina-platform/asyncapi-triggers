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

import ballerina/http;
import ballerinax/asyncapi.native.handler;
import ballerinax/googleapis.gmail;
import ballerina/log;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string startHistoryId = "";
    private final string subscriptionResource;
    private final gmail:ConnectionConfig gmailConfig;

    public function init(gmail:ConnectionConfig gmailConfig, string subscriptionResource) {
        self.gmailConfig = gmailConfig;
        self.subscriptionResource = subscriptionResource;
    }

    public isolated function setStartHistoryId(string startHistoryId) {
        lock {
            self.startHistoryId = startHistoryId;
        }
    }

    public isolated function getStartHistoryId() returns string {
        lock {
            return self.startHistoryId;
        }
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
        json ReqPayload = check request.getJsonPayload();
        string incomingSubscription = check ReqPayload.subscription;

        if (self.subscriptionResource === incomingSubscription) {
            var mailboxHistoryPage = listHistory(self.gmailConfig, self.getStartHistoryId());
            if (mailboxHistoryPage is stream<gmail:History, error?>) {
                var history = mailboxHistoryPage.next();
                while (history is record {|gmail:History value;|}) {
                    check self.dispatch(history.value);
                    self.setStartHistoryId(<string>history.value?.historyId);
                    log:printDebug(NEXT_HISTORY_ID + self.getStartHistoryId());
                    history = mailboxHistoryPage.next();
                }
            } else {
                log:printError(ERR_HISTORY_LIST, 'error = mailboxHistoryPage);
            }
        } else {
            log:printWarn(WARN_UNKNOWN_PUSH_NOTIFICATION + incomingSubscription);
        }
        check caller->respond(http:STATUS_OK);
    }

    private isolated function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }

    isolated function dispatch(gmail:History history) returns @tainted error? {
        if (history?.messagesAdded is gmail:HistoryEvent[]) {
            gmail:HistoryEvent[] newMessages = <gmail:HistoryEvent[]>history?.messagesAdded;
            if newMessages.length() > 0 {
                foreach var newMessage in newMessages {
                    if (newMessage.message?.labelIds is string[]) {
                        foreach var labelId in <string[]>newMessage.message?.labelIds {
                            match labelId {
                                INBOX => {
                                    check self.dispatchNewMessage(newMessage);
                                    check self.dispatchNewThread(newMessage);
                                }
                            }
                        }
                    }
                }
            }
        }
        if (history?.labelsAdded is gmail:HistoryEvent[]) {
            gmail:HistoryEvent[] addedlabels = <gmail:HistoryEvent[]>history?.labelsAdded;
            if addedlabels.length() > 0 {
                foreach var addedlabel in addedlabels {
                    check self.dispatchLabelAddedEmail(addedlabel);
                    check self.dispatchStarredEmail(addedlabel);
                }
            }
        }
        if (history?.labelsRemoved is gmail:HistoryEvent[]) {
            gmail:HistoryEvent[] removedLabels = <gmail:HistoryEvent[]>history?.labelsRemoved;
            if removedLabels.length() > 0 {
                foreach var removedLabel in removedLabels {
                    check self.dispatchLabelRemovedEmail(removedLabel);
                    check self.dispatchStarRemovedEmail(removedLabel);
                }
            }
        }
    }

    isolated function dispatchNewMessage(gmail:HistoryEvent newMessage) returns @tainted error? {
        gmail:Message message = check readMessage(self.gmailConfig, <@untainted>newMessage.message.id);
        check self.executeRemoteFunc(message, "newEmail", "GmailService", "onNewEmail");
        if (message?.msgAttachments is gmail:MessageBodyPart[]) {
            gmail:MessageBodyPart[] msgAttachments = <gmail:MessageBodyPart[]>message?.msgAttachments;
            if (msgAttachments.length() > 0) {
                check self.dispatchNewAttachment(msgAttachments, message);
            }
        }
    }

    isolated function dispatchNewAttachment(gmail:MessageBodyPart[] msgAttachments, gmail:Message message) returns error? {
        MailAttachment mailAttachment = {
            messageId: message.id,
            msgAttachments: msgAttachments
        };
        check self.executeRemoteFunc(mailAttachment, "newAttachment", "GmailService", "onNewAttachment");
    }

    isolated function dispatchNewThread(gmail:HistoryEvent newMessage) returns @tainted error? {
        if (newMessage.message.id == newMessage.message.threadId) {
            gmail:MailThread thread = check readThread(self.gmailConfig, <@untainted>newMessage.message.threadId);
            check self.executeRemoteFunc(thread, "newThread", "GmailService", "onNewThread");
        }
    }

    isolated function dispatchLabelAddedEmail(gmail:HistoryEvent addedlabel) returns @tainted error? {
        ChangedLabel changedLabel = {messageDetail: {id: "", threadId: ""}, changedLabelId: []};
        if (addedlabel?.labelIds is string[]) {
            changedLabel.changedLabelId = <string[]>addedlabel?.labelIds;
        }
        gmail:Message message = check readMessage(self.gmailConfig, <@untainted>addedlabel.message.id);
        changedLabel.messageDetail = message;
        check self.executeRemoteFunc(changedLabel, "emailLabelAdded", "GmailService", "onEmailLabelAdded");
    }

    isolated function dispatchStarredEmail(gmail:HistoryEvent addedlabel) returns @tainted error? {
        if (addedlabel?.labelIds is string[]) {
            foreach var label in <string[]>addedlabel?.labelIds {
                match label {
                    STARRED => {
                        gmail:Message message = check readMessage(self.gmailConfig, <@untainted>addedlabel.message.id);
                        check self.executeRemoteFunc(message, "emailStarred", "GmailService", "onEmailStarred");
                    }
                }
            }
        }
    }

    isolated function dispatchLabelRemovedEmail(gmail:HistoryEvent removedLabel) returns @tainted error? {
        ChangedLabel changedLabel = {messageDetail: {id: "", threadId: ""}, changedLabelId: []};
        if (removedLabel?.labelIds is string[]) {
            changedLabel.changedLabelId = <string[]>removedLabel?.labelIds;
        }
        gmail:Message message = check readMessage(self.gmailConfig, <@untainted>removedLabel.message.id);
        changedLabel.messageDetail = message;
        check self.executeRemoteFunc(changedLabel, "emailLabelRemoved", "GmailService", "onEmailLabelRemoved");
    }

    isolated function dispatchStarRemovedEmail(gmail:HistoryEvent removedLabel) returns @tainted error? {
        if (removedLabel?.labelIds is string[]) {
            foreach var label in <string[]>removedLabel?.labelIds {
                match label {
                    STARRED => {
                        gmail:Message message = check readMessage(self.gmailConfig, <@untainted>removedLabel.message.id);
                        check self.executeRemoteFunc(message, "emailStarRemoved", "GmailService", "onEmailStarRemoved");
                    }
                }
            }
        }
    }
}
