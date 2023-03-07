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

# Azure service bus Message representation.
#
# + body - Message body, Here the connector supports AMQP message body types - DATA and VALUE, However, DATA type message bodies  
# will be received in Ballerina Byte[] type. VALUE message bodies can be any primitive AMQP type. therefore, the connector  
# supports for string, int or byte[]. Please refer Azure docs (https://learn.microsoft.com/en-us/java/api/com.azure.core.amqp.models.amqpmessagebody?view=azure-java-stable)  
# and AMQP docs (https://qpid.apache.org/amqp/type-reference.html#PrimitiveTypes)  
# + contentType - Message content type  
# + messageId - Message Id (optional)  
# + to - Message to (optional)  
# + replyTo - Message reply to (optional)  
# + replyToSessionId - Identifier of the session to reply to (optional)  
# + label - Message label (optional)  
# + sessionId - Message session Id (optional)  
# + correlationId - Message correlationId (optional)  
# + partitionKey - Message partition key (optional)  
# + timeToLive - Message time to live in seconds (optional)  
# + sequenceNumber - Message sequence number (optional)  
# + lockToken - Message lock token (optional)  
# + applicationProperties - Message broker application specific properties (optional)  
# + deliveryCount - Number of times a message has been delivered in a queue/subscription  
# + enqueuedTime - Timestamp indicating when a message was added to the queue/subscription 
# + enqueuedSequenceNumber - Sequence number assigned to a message when it is added to the queue/subscription 
# + deadLetterErrorDescription - Error description of why a message went to a dead-letter queue  
# + deadLetterReason - Reason why a message was moved to a dead-letter queue  
# + deadLetterSource - Original queue/subscription where the message was before being moved to the dead-letter queue 
# + state - Current state of a message in the queue/subscription, could be "Active", "Scheduled", "Deferred", etc.
@display {label: "Message"}
public type Message record {|
    @display {label: "Body"}
    string|int|byte[] body;
    @display {label: "Content Type"}
    string contentType;
    @display {label: "Message Id"}
    string messageId;
    @display {label: "To"}
    string to?;
    @display {label: "Reply To"}
    string replyTo?;
    @display {label: "Reply To Session Id"}
    string replyToSessionId?;
    @display {label: "Label"}
    string label?;
    @display {label: "Session Id"}
    string sessionId?;
    @display {label: "Correlation Id"}
    string correlationId?;
    @display {label: "Partition Key"}
    string partitionKey?;
    @display {label: "Time To Live"}
    int timeToLive?;
    @display {label: "Sequence Number"}
    readonly int sequenceNumber?;
    @display {label: "Lock Token"}
    readonly string lockToken;
    ApplicationProperties applicationProperties?;
    @display {label: "Delivery Count"}
    int deliveryCount?;
    @display {label: "Enqueued Time"}
    string enqueuedTime?;
    @display {label: "Enqueued SequenceNumber"}
    int enqueuedSequenceNumber?;
    @display {label: "DeadLetter Error Description"}
    string deadLetterErrorDescription?;
    @display {label: "DeadLetter Reason"}
    string deadLetterReason?;
    @display {label: "DeadLetter Source"}
    string deadLetterSource?;
    @display {label: "Message State"}
    string state?;
|};

# Azure service bus message, application specific properties representation.
#
# + properties - Key-value pairs for each brokered property (optional)
@display {label: "Application Properties"}
public type ApplicationProperties record {|
    @display {label: "Properties"}
    map<any> properties?;
|};

# Represents the Asb module related errors.
public type AsbError distinct error;

# The union of the Asb module related errors.
public type Error AsbError;

// Default values
const string EMPTY_STRING = "";

# Azure service bus listener configuration.
public type ListenerConfig record {
    # The connection string of Azure service bus
    @display {label: "Connection String", "description": "The connection string of Azure service bus"}
    string connectionString;
};

# Represents Custom configurations for the ASB connector
#
# + logLevel - Enables the connector debug log prints (log4j log levels), default: OFF
public type Options record {
    @display {label: "Log Level"}
    LogLevel logLevel = OFF;
};

# Message receiver modes
public enum ReceiveMode {
    @display {label: "RECEIVE AND DELETE"}
    RECEIVE_AND_DELETE = "RECEIVEANDDELETE",
    @display {label: "PEEK LOCK"}
    PEEK_LOCK = "PEEKLOCK"
}

# Log_levels
public enum LogLevel {
    @display {label: "DEBUG"}
    DEBUG,
    @display {label: "INFO"}
    INFO,
    @display {label: "WARNING"}
    WARNING,
    @display {label: "ERROR"}
    ERROR,
    @display {label: "FATAL"}
    FATAL,
    @display {label: "OFF"}
    OFF
}

# ErrorContext is a record type that represents error context information
#
# + entityPath - The entity path of the error source  
# + className - The name of the class that threw the error  
# + namespace - The namespace of the error source  
# + errorSource - The error source, such as a function or action name  
# + reason - The error reason
public type ErrorContext record {
    string entityPath;
    string className;
    string namespace;
    string errorSource;
    string reason;
};

public type ASBServiceConfig record {|
    string queueName?;
    boolean peekLockModeEnabled = false;
    string topicName?;
    string subscriptionName?;
    int maxConcurrency = 1;
    int prefetchCount =  0;
    int maxAutoLockRenewDuration = 300;
    string logLevel = ERROR;
|};

public annotation ASBServiceConfig ServiceConfig on service, class;
