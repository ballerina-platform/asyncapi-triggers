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
        io:println("Company created : ", event);
    }

    remote function onCompanyDeletion(WebhookEvent event) returns error? {
        io:println("Company deleted : ", event);
    }

    remote function onCompanyPropertychange(WebhookEvent event) returns error? {
        io:println("Company updated : ", event);
    }

    remote function onCompanyAssociationchange(WebhookEvent event) returns error? {
        io:println("Company association changed : ", event);
    }

    remote function onCompanyMerge(WebhookEvent event) returns error? {
        io:println("Company merged : ", event);
    }

    remote function onCompanyRestore(WebhookEvent event) returns error? {
        io:println("Company restored : ", event);
    }
}

service ContactService on hubspotWebhook {

    remote function onContactCreation(WebhookEvent event) returns error? {
        io:println("Contact created : ", event);
    }

    remote function onContactDeletion(WebhookEvent event) returns error? {
        io:println("Contact deleted : ", event);
    }

    remote function onContactPropertychange(WebhookEvent event) returns error? {
        io:println("Contact updated : ", event);
    }

    remote function onContactAssociationchange(WebhookEvent event) returns error? {
        io:println("Contact association changed : ", event);
    }

    remote function onContactMerge(WebhookEvent event) returns error? {
        io:println("Contact merged : ", event);
    }

    remote function onContactRestore(WebhookEvent event) returns error? {
        io:println("Contact restored : ", event);
    }

    remote function onContactPrivacydeletion(WebhookEvent event) returns error? {
        io:println("Contact privacy deleted : ", event);
    }
}

service DealService on hubspotWebhook {

    remote function onDealCreation(WebhookEvent event) returns error? {
        io:println("Deal created : ", event);
    }

    remote function onDealDeletion(WebhookEvent event) returns error? {
        io:println("Deal deleted : ", event);
    }

    remote function onDealPropertychange(WebhookEvent event) returns error? {
        io:println("Deal updated : ", event);
    }

    remote function onDealAssociationchange(WebhookEvent event) returns error? {
        io:println("Deal association changed : ", event);
    }

    remote function onDealMerge(WebhookEvent event) returns error? {
        io:println("Deal merged : ", event);
    }

    remote function onDealRestore(WebhookEvent event) returns error? {
        io:println("Deal restored : ", event);
    }
}

service ConversationService on hubspotWebhook {

    remote function onConversationCreation(WebhookEvent event) returns error? {
        io:println("Conversation created : ", event);
    }

    remote function onConversationDeletion(WebhookEvent event) returns error? {
        io:println("Conversation deleted : ", event);
    }

    remote function onConversationPropertychange(WebhookEvent event) returns error? {
        io:println("Conversation updated : ", event);
    }

    remote function onConversationPrivacydeletion(WebhookEvent event) returns error? {
        io:println("Conversation privacy deleted : ", event);
    }

    remote function onConversationNewmessage(WebhookEvent event) returns error? {
        io:println("Conversation new message : ", event);
    }
}

service TicketService on hubspotWebhook {

    remote function onTicketCreation(WebhookEvent event) returns error? {
        io:println("Ticket created : ", event);
    }

    remote function onTicketDeletion(WebhookEvent event) returns error? {
        io:println("Ticket deleted : ", event);
    }

    remote function onTicketPropertychange(WebhookEvent event) returns error? {
        io:println("Ticket updated : ", event);
    }

    remote function onTicketAssociationchange(WebhookEvent event) returns error? {
        io:println("Ticket association changed : ", event);
    }

    remote function onTicketMerge(WebhookEvent event) returns error? {
        io:println("Ticket merged : ", event);
    }

    remote function onTicketRestore(WebhookEvent event) returns error? {
        io:println("Ticket restored : ", event);
    }
}

service ProductService on hubspotWebhook {

    remote function onProductCreation(WebhookEvent event) returns error? {
        io:println("Product created : ", event);
    }

    remote function onProductDeletion(WebhookEvent event) returns error? {
        io:println("Product deleted : ", event);
    }

    remote function onProductPropertychange(WebhookEvent event) returns error? {
        io:println("Product updated : ", event);
    }

    remote function onProductMerge(WebhookEvent event) returns error? {
        io:println("Product merged : ", event);
    }

    remote function onProductRestore(WebhookEvent event) returns error? {
        io:println("Product restored : ", event);
    }
}

service LineItemService on hubspotWebhook {

    remote function onLineItemCreation(WebhookEvent event) returns error? {
        io:println("Line item created : ", event);
    }

    remote function onLineItemDeletion(WebhookEvent event) returns error? {
        io:println("Line item deleted : ", event);
    }

    remote function onLineItemPropertychange(WebhookEvent event) returns error? {
        io:println("Line item updated : ", event);
    }

    remote function onLineItemAssociationchange(WebhookEvent event) returns error? {
        io:println("Line item association changed : ", event);
    }

    remote function onLineItemMerge(WebhookEvent event) returns error? {
        io:println("Line item merged : ", event);
    }

    remote function onLineItemRestore(WebhookEvent event) returns error? {
        io:println("Line item restored : ", event);
    }
}
