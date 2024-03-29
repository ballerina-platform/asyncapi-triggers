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

# Actions related to successfully received message
public type ReceivedMessageService service object {
    remote function onMessageReceivedSuccess(MessageReceivedEvent event) returns error?;
};

# Actions related to successfully send message
public type SentMessageService service object {
    remote function onMessageSendSuccess(MessageSentEvent event) returns error?;
};

# # Actions related to failed message on sending
public type FailedMessageService service object {
    remote function onMessageSendFailed(MessageFailedEvent event) returns error?;
};

public type GenericServiceType ReceivedMessageService|SentMessageService|FailedMessageService;
