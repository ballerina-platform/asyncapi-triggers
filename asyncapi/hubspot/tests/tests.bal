// Copyright (c) 2022, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/io;

configurable string callbackURL = ?;
configurable string clientSecret = ?;

listener Listener hubspotWebhook = new (listenerConfig = {clientSecret, callbackURL});

service CompanyService on hubspotWebhook {

    remote function onCompanyCreation(WebhookEvent event) returns error? {
        io:println("company created : ", event);
    }

    remote function onCompanyDeletion(WebhookEvent event) returns error? {
        io:println("Company deleted : ", event);
    }

    remote function onCompanyPropertychange(PropertyChangeEvent event) returns error? {
        io:println("Company updated : ", event);
    }
}

service ContactService on hubspotWebhook {

    remote function onContactCreation(WebhookEvent event) returns error? {
        io:println("Contact created : ", event);
    }

    remote function onContactDeletion(WebhookEvent event) returns error? {
        io:println("Contact deleted : ", event);
    }

    remote function onContactPropertychange(PropertyChangeEvent event) returns error? {
        io:println("Contact updated : ", event);
    }
}

service DealService on hubspotWebhook {

    remote function onDealCreation(WebhookEvent event) returns error? {
        io:println("Deal created : ", event);
    }

    remote function onDealDeletion(WebhookEvent event) returns error? {
        io:println("Deal deleted : ", event);
    }

    remote function onDealPropertychange(PropertyChangeEvent event) returns error? {
        io:println("Deal updated : ", event);
    }
}

service ConversationService on hubspotWebhook {
    
    remote function onConversationCreation(WebhookEvent event) returns error? {
        io:println("Conversation created : ", event);
    }

    remote function onConversationDeletion(WebhookEvent event) returns error? {
        io:println("Conversation deleted : ", event);
    }

    remote function onConversationPropertychange(PropertyChangeEvent event) returns error? {
        io:println("Conversation updated : ", event);
    }
}
