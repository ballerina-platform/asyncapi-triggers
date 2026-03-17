// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerinax/trigger.google.mail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = ?;
configurable string project = ?;
configurable string callbackURL = ?;

mail:ListenerConfig listenerConfig = {
    clientId,
    clientSecret,
    refreshUrl,
    refreshToken,
    project,
    callbackURL
};

listener mail:Listener gmailListener = new (listenerConfig);

service mail:GmailService on gmailListener {

    remote function onNewEmail(mail:Message message) returns error? {
        log:printInfo(">>> onNewEmail", subject = message.subject, 'from = message.'from);
    }

    remote function onNewThread(mail:MailThread thread) returns error? {
        log:printInfo(">>> onNewThread", threadId = thread.id);
    }

    remote function onEmailLabelAdded(mail:ChangedLabel changedLabel) returns error? {
        log:printInfo(">>> onEmailLabelAdded", labelIds = changedLabel.changedLabelId);
    }

    remote function onEmailStarred(mail:Message message) returns error? {
        log:printInfo(">>> onEmailStarred", subject = message.subject);
    }

    remote function onEmailLabelRemoved(mail:ChangedLabel changedLabel) returns error? {
        log:printInfo(">>> onEmailLabelRemoved", labelIds = changedLabel.changedLabelId);
    }

    remote function onEmailStarRemoved(mail:Message message) returns error? {
        log:printInfo(">>> onEmailStarRemoved", subject = message.subject);
    }

    remote function onNewAttachment(mail:MailAttachment attachment) returns error? {
        log:printInfo(">>> onNewAttachment", messageId = attachment.messageId,
                count = attachment.msgAttachments.length());
    }
}
