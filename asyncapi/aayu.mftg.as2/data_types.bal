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

// Listener related configurations should be included here
public type ListenerConfigs record {
};

public type MessageFailedEvent record {
    # Name of the AWS.
    string bucketName;
    # Email associated with tenant.
    string tenantEmail;
    # AS2 identifier of the Partner.
    string 'partnerAS2ID;
    # Path of attachments.
    string[] attachments;
    # No of fail events.
    int failures;
    # AS2 identifier of the Station.
    string 'stationAS2ID;
    # Subject of the message.
    string messageSubject;
    # Name of the Partner.
    string partnerName;
    # Subject of the failed message
    string subject;
    # Event type.
    string eventType;
    # Timestamp of which message failed.
    int lastAttemptTime;
    # Name of the tenant.
    string tenantName;
    # AS2 identifier of the message.
    string 'messageAS2ID;
    # SSL Handshake Exception.
    string failureReason;
    # ID of the tenant.
    int tenantId?;
    # Name of the Station.
    string stationName;
    # Email address of the receiving party.
    string to;
};

public type MessageSentEvent record {
    # Name of the AWS.
    string bucketName;
    # Email associated with tenant.
    string tenantEmail;
    # AS2 identifier of the Partner.
    string 'partnerAS2ID;
    # Path of attachments.
    string[] attachments;
    # AS2 identifier of the Station.
    string 'stationAS2ID;
    # Subject of the message.
    string messageSubject;
    # Name of the Partner.
    string partnerName;
    # Event type.
    string eventType;
    # Timestamp of which message sent.
    int sentAt;
    # Name of the tenant.
    string tenantName;
    # AS2 identifier of the message.
    string 'messageAS2ID;
    # ID of the tenant.
    int tenantId;
    # Name of the Station.
    string stationName;
    # Email address of the receiving party.
    string to;
};

public type MessageReceivedEvent record {
    # Name of the AWS.
    string bucketName;
    # Email associated with tenant.
    string tenantEmail;
    # AS2 identifier of the Partner.
    string 'partnerAS2ID;
    # Path of attachments.
    string[] attachments;
    # AS2 identifier of the Station.
    string 'stationAS2ID;
    # Subject of the message.
    string messageSubject;
    # Name of the Partner.
    string partnerName;
    # Event type.
    string eventType;
    # Timestamp of which message received.
    int receivedAt;
    # Name of the tenant.
    string tenantName;
    # AS2 identifier of the message.
    string 'messageAS2ID;
    # ID of the tenant.
    int tenantId;
    # Name of the Station.
    string stationName;
    # Email address of the receiving party.
    string to;
};

public type GenericDataType MessageFailedEvent|MessageSentEvent|MessageReceivedEvent;
