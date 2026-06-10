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

# Triggers when a new event related to HubSpot Company is received.
# Available actions: onCompanyCreation, onCompanyDeletion, onCompanyPropertychange, onCompanyAssociationchange, 
# onCompanyMerge, onCompanyRestore
public type CompanyService service object {
    remote function onCompanyCreation(WebhookEvent event) returns error?;
    remote function onCompanyDeletion(WebhookEvent event) returns error?;
    remote function onCompanyPropertychange(WebhookEvent event) returns error?;
    remote function onCompanyAssociationchange(WebhookEvent event) returns error?;
    remote function onCompanyMerge(WebhookEvent event) returns error?;
    remote function onCompanyRestore(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Contact is received.
# Available actions: onContactCreation, onContactDeletion, onContactPropertychange, onContactAssociationchange, 
# onContactMerge, onContactRestore, onContactPrivacydeletion
public type ContactService service object {
    remote function onContactCreation(WebhookEvent event) returns error?;
    remote function onContactDeletion(WebhookEvent event) returns error?;
    remote function onContactPropertychange(WebhookEvent event) returns error?;
    remote function onContactAssociationchange(WebhookEvent event) returns error?;
    remote function onContactMerge(WebhookEvent event) returns error?;
    remote function onContactRestore(WebhookEvent event) returns error?;
    remote function onContactPrivacydeletion(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Conversation is received.
# Available actions: onConversationCreation, onConversationDeletion, onConversationPropertychange, 
# onConversationPrivacydeletion, onConversationNewmessage
public type ConversationService service object {
    remote function onConversationCreation(WebhookEvent event) returns error?;
    remote function onConversationDeletion(WebhookEvent event) returns error?;
    remote function onConversationPropertychange(WebhookEvent event) returns error?;
    remote function onConversationPrivacydeletion(WebhookEvent event) returns error?;
    remote function onConversationNewmessage(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Deal is received.
# Available actions: onDealCreation, onDealDeletion, onDealPropertychange, 
# onDealAssociationchange, onDealMerge, onDealRestore
public type DealService service object {
    remote function onDealCreation(WebhookEvent event) returns error?;
    remote function onDealDeletion(WebhookEvent event) returns error?;
    remote function onDealPropertychange(WebhookEvent event) returns error?;
    remote function onDealAssociationchange(WebhookEvent event) returns error?;
    remote function onDealMerge(WebhookEvent event) returns error?;
    remote function onDealRestore(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Ticket is received.
# Available actions: onTicketCreation, onTicketDeletion, onTicketPropertychange, 
# onTicketAssociationchange, onTicketMerge, onTicketRestore
public type TicketService service object {
    remote function onTicketCreation(WebhookEvent event) returns error?;
    remote function onTicketDeletion(WebhookEvent event) returns error?;
    remote function onTicketPropertychange(WebhookEvent event) returns error?;
    remote function onTicketAssociationchange(WebhookEvent event) returns error?;
    remote function onTicketMerge(WebhookEvent event) returns error?;
    remote function onTicketRestore(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Product is received.
# Available actions: onProductCreation, onProductDeletion, onProductPropertychange, 
# onProductMerge, onProductRestore
public type ProductService service object {
    remote function onProductCreation(WebhookEvent event) returns error?;
    remote function onProductDeletion(WebhookEvent event) returns error?;
    remote function onProductPropertychange(WebhookEvent event) returns error?;
    remote function onProductMerge(WebhookEvent event) returns error?;
    remote function onProductRestore(WebhookEvent event) returns error?;
};

# Triggers when a new event related to HubSpot Line Item is received.
# Available actions: onLineItemCreation, onLineItemDeletion, onLineItemPropertychange, 
# onLineItemAssociationchange, onLineItemMerge, onLineItemRestore
public type LineItemService service object {
    remote function onLineItemCreation(WebhookEvent event) returns error?;
    remote function onLineItemDeletion(WebhookEvent event) returns error?;
    remote function onLineItemPropertychange(WebhookEvent event) returns error?;
    remote function onLineItemAssociationchange(WebhookEvent event) returns error?;
    remote function onLineItemMerge(WebhookEvent event) returns error?;
    remote function onLineItemRestore(WebhookEvent event) returns error?;
};

# Generic Service Type
public type GenericServiceType
    CompanyService
    |ContactService
    |ConversationService
    |DealService
    |TicketService
    |ProductService
    |LineItemService;
