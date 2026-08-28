// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
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

const string DEFAULT_SECRET = "";

# Configuration for the webhook listener, including the secret used to verify incoming requests.
public type ListenerConfig record {
    # The secret used to verify incoming webhook signatures.
    @display {label: "Webhook Secret"}
    string webhookSecret = DEFAULT_SECRET;
};

# A single CloudEvents-formatted QuickBooks webhook notification.
public type QuickBookEvent record {
    # The CloudEvents specification version (currently always "1.0").
    string specversion;
    # A unique identifier for this event.
    string id;
    # Identifies the QuickBooks company instance that raised the event.
    string 'source;
    # The entity and operation this event represents, e.g. qbo.customer.created.v1.
    string 'type;
    # The content type of the data field.
    string datacontenttype?;
    # The timestamp the event occurred, in ISO 8601 format.
    string time;
    # The ID of the entity that changed.
    string intuitentityid;
    # The QuickBooks company (realm) ID this event belongs to.
    string intuitaccountid;
    # Operation-specific event data. Confirmed shapes so far: empty on create, {"deletedId": "..."} on merge. Shape for update/delete/void/email is not yet confirmed against a real delivery.
    record {} data?;
};

# The union of every possible webhook payload type this listener can receive.
public type GenericDataType QuickBookEvent;
