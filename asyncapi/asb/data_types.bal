// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Azure service bus listener configuration.
public type ListenerConfig record {
    # The connection string of Azure service bus
    @display {label: "Connection String", "description": "The connection string of Azure service bus"}
    string connectionString;
    # Name or path of the entity (e.g : Queue name, Subscription path)
    @display {label: "Entity Path", "description": "Name or path of the entity (e.g : Queue name, Subscription path)"}
    string entityPath;
    # Receive mode as PEEKLOCK or RECEIVEANDDELETE (default : PEEKLOCK)
    @display {label: "Receive Mode", "description": "Receive mode as PEEKLOCK or RECEIVEANDDELETE (default : PEEKLOCK)"}
    string receiveMode?;
};

# Azure service bus message representation.
public type Message record {|
    # Message body 
    string|xml|json|byte[] body;
    # Message content type
    string contentType?;
    # Message Id (optional)
    string messageId?;
    # Message to (optional)
    string to?;
    # Message reply to (optional)
    string replyTo?;
    # Identifier of the session to reply to (optional)
    string replyToSessionId?;
    # Message label (optional)
    string label?;
    # Message session Id (optional)
    string sessionId?;
    # Message correlationId (optional)
    string correlationId?;
    # Message partition key (optional)
    string partitionKey?;
    # Message time to live in seconds (optional)
    int timeToLive?;
    # Message sequence number (optional)
    readonly int sequenceNumber?;
    # Message lock token (optional)
    readonly string lockToken?;
    # Message broker application specific properties (optional)
    ApplicationProperties applicationProperties?;
|};

# Azure service bus message, application specific properties representation.
public type ApplicationProperties record {|
    # Key-value pairs for each brokered property (optional)
    map<string> properties?;
|};

# Represents the Asb module related errors.
public type AsbError distinct error;

# The union of the Asb module related errors.
public type Error AsbError;

// Default values
const string DEFAULT_MESSAGE_LOCK_TOKEN = "00000000-0000-0000-0000-000000000000";

# Message content type in text format
public const string TEXT = "text/plain";
# Message content type in json format
public const string JSON = "application/json";
# Message content type in xml format
public const string XML = "application/xml";
# Message content type in byte array format
public const string BYTE_ARRAY = "application/octet-stream";

# Message receive modes.
public enum ReceiveMode {
    # Receive messages in Peeklock mode
    PEEKLOCK,
    # Receive messages in Receive and delete mode
    RECEIVEANDDELETE
}
