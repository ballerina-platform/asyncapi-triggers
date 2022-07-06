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

# Triggers when a new event related to HubSpot Company is received. 
# Available actions: onCompanyCreation, onCompanyDeletion
public type CompanyService service object {
    remote function onCompanyCreation(WebhookEvent event) returns error?;
    remote function onCompanyDeletion(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Contact is received. 
# Available actions: onContactCreation, onContactDeletion
public type ContactService service object {
    remote function onContactCreation(WebhookEvent event) returns error?;
    remote function onContactDeletion(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Conversation is received. 
# Available actions: onConversationCreation, onConversationDeletion
public type ConversationService service object {
    remote function onConversationCreation(WebhookEvent event) returns error?;
    remote function onConversationDeletion(WebhookEvent event) returns error?;
};
# Triggers when a new event related to HubSpot Deal is received. 
# Available actions: onDealCreation, onDealDeletion
public type DealService service object {
    remote function onDealCreation(WebhookEvent event) returns error?; 
    remote function onDealDeletion(WebhookEvent event) returns error?;
};

# Generic Service Type
public type GenericServiceType CompanyService|ContactService|ConversationService|DealService;
