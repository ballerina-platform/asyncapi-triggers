// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
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

public type TicketService service object {
    remote function onTicketPropertyChange(WebhookEvent payload) returns error?;
    remote function onTicketDeletion(WebhookEvent payload) returns error?;
    remote function onTicketCreation(WebhookEvent payload) returns error?;
    remote function onTicketMerge(WebhookEvent payload) returns error?;
    remote function onTicketRestore(WebhookEvent payload) returns error?;
    remote function onTicketAssociationChange(WebhookEvent payload) returns error?;
};

public type CompanyService service object {
    remote function onCompanyDeletion(WebhookEvent payload) returns error?;
    remote function onCompanyRestore(WebhookEvent payload) returns error?;
    remote function onCompanyMerge(WebhookEvent payload) returns error?;
    remote function onCompanyPropertyChange(WebhookEvent payload) returns error?;
    remote function onCompanyCreation(WebhookEvent payload) returns error?;
    remote function onCompanyAssociationChange(WebhookEvent payload) returns error?;
};

public type LineItemService service object {
    remote function onLineItemMerge(WebhookEvent payload) returns error?;
    remote function onLineItemDeletion(WebhookEvent payload) returns error?;
    remote function onLineItemPropertyChange(WebhookEvent payload) returns error?;
    remote function onLineItemRestore(WebhookEvent payload) returns error?;
    remote function onLineItemAssociationChange(WebhookEvent payload) returns error?;
    remote function onLineItemCreation(WebhookEvent payload) returns error?;
};

public type ProductService service object {
    remote function onProductPropertyChange(WebhookEvent payload) returns error?;
    remote function onProductDeletion(WebhookEvent payload) returns error?;
    remote function onProductMerge(WebhookEvent payload) returns error?;
    remote function onProductRestore(WebhookEvent payload) returns error?;
    remote function onProductCreation(WebhookEvent payload) returns error?;
};

public type ConversationService service object {
    remote function onConversationCreation(WebhookEvent payload) returns error?;
    remote function onConversationPropertyChange(WebhookEvent payload) returns error?;
    remote function onConversationPrivacyDeletion(WebhookEvent payload) returns error?;
    remote function onConversationNewMessage(WebhookEvent payload) returns error?;
    remote function onConversationDeletion(WebhookEvent payload) returns error?;
};

public type DealService service object {
    remote function onDealDeletion(WebhookEvent payload) returns error?;
    remote function onDealCreation(WebhookEvent payload) returns error?;
    remote function onDealMerge(WebhookEvent payload) returns error?;
    remote function onDealPropertyChange(WebhookEvent payload) returns error?;
    remote function onDealRestore(WebhookEvent payload) returns error?;
    remote function onDealAssociationChange(WebhookEvent payload) returns error?;
};

public type ContactService service object {
    remote function onContactCreation(WebhookEvent payload) returns error?;
    remote function onContactAssociationChange(WebhookEvent payload) returns error?;
    remote function onContactDeletion(WebhookEvent payload) returns error?;
    remote function onContactPrivacyDeletion(WebhookEvent payload) returns error?;
    remote function onContactPropertyChange(WebhookEvent payload) returns error?;
    remote function onContactMerge(WebhookEvent payload) returns error?;
    remote function onContactRestore(WebhookEvent payload) returns error?;
};

public type GenericServiceType TicketService|CompanyService|LineItemService|ProductService|ConversationService|DealService|ContactService;

