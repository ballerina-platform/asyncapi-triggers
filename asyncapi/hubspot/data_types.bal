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

import ballerina/time;

// Listener related configurations should be included here
@display {label: "Listener Config"}
public type ListenerConfig record {
    @display {label: "Client Secret", "description": "The Client Secret of HubSpot App"}
    string clientSecret;
    @display {label: "Callback URL", "description": "The Callback URL"}
    string callbackURL;
};

@display {label: "Webhook Event"}
public type WebhookEvent record {
    # HubSpot will attempt to send the notification again in case of service timeout or error.
    # Number of attempts are saved in this variable.
    decimal attemptNumber?;
    # The ID of the event that triggered this notification. This value is not guaranteed to be unique.
    string eventId?;
    # The source of the change. This can be any of the change sources that appear in contact property histories.
    string changeSource?;
    # When this event occurred as a millisecond timestamp.
    decimal occurredAt?;
    # Type of the event
    string subscriptionType?;
    # The customer's (HubSpot account ID)[https://knowledge.hubspot.com/account/manage-multiple-hubspot-accounts?_ga=2.56562472.2054080341.1656611011-2068059512.1656469161#check-your-current-account] where the event occurred.
    decimal portalId?;
    # Flag of the change.
    string changeFlag?;
    # The ID of the subscription that triggered a notification about the event.
    decimal subscriptionId?;
    # The ID of the object that was created, changed, or deleted. For contacts this is the contact ID; for companies, 
    # the company ID; for deals, the deal ID; and for conversations the thread ID
    decimal objectId?;
};

public type GenericDataType WebhookEvent;

final time:Seconds FIVE_MINUTES_IN_MILLISECONDS = 300000;

final string eventValidationError = "Event validation failed";
final string signatureVerificationFailure = "Signature verification failure!";
final string requestTimeoutFailure = "Request timeout failure!";
