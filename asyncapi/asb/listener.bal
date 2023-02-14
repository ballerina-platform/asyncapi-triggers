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

import ballerina/jballerina.java as java;

# Ballerina Azure Service Bus Message Listener.
# Provides a listener to consume messages from the Azure Service Bus.
@display {label: "Azure Service Bus", iconPath: "docs/icon.png"}
public class Listener {

    final string connectionString;
    final handle listenerHandle;
    final string queueName;
    final string subscriptionName;
    final string topicName;

    Caller caller;

    # Gets invoked to initialize the `listener`.
    # The listener initialization requires setting the credentials. 
    # Create an [Azure account](https://azure.microsoft.com) and obtain tokens following [this guide](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal).
    #
    # + listenerConfig - The configurations to be used when initializing the `listener`
    # + return - An error if listener initialization failed
    public isolated function init(ListenerConfig config) returns error? {
        self.connectionString = config.connectionString;
        if config.entityConfig is QueueConfig {
            QueueConfig queueConfig = check config.entityConfig.ensureType(QueueConfig);
            self.queueName = queueConfig.queueName;
            self.subscriptionName = EMPTY_STRING;
            self.topicName = EMPTY_STRING;
        } else {
            TopicSubsConfig topicSubsConfig = check config.entityConfig.ensureType(TopicSubsConfig);
            self.topicName = topicSubsConfig.topicName;
            self.subscriptionName = topicSubsConfig.subscriptionName;
            self.queueName = EMPTY_STRING;
        }

        self.listenerHandle = check initListener(java:fromString(self.connectionString),
        java:fromString(self.queueName), java:fromString(self.topicName), java:fromString(self.subscriptionName),
        java:fromString(config.receiveMode), java:fromString(customConfiguration.logLevel), config.maxConcurrentCalls,
        config.prefetchCount, config.maxAutoLockRenewDuration);
        self.caller = new ();
        externalInit(self.listenerHandle, self, self.caller);
    }

    # Attaches the service to the `asb:Listener` endpoint.
    #
    # + s - Type descriptor of the service
    # + name - Name of the service
    # + return - `()` or else an error upon failure to register the service
    public isolated function attach(MessageService s, string[]|string? name = ()) returns Error? {
        return registerListener(self.listenerHandle, self, s);
    }

    # Starts consuming the messages on all the attached services.
    #
    # + return - `()` or else an error upon failure to start
    public isolated function 'start() returns Error? {
        return 'start(self.listenerHandle, self);
    }

    # Stops consuming messages and detaches the service from the `asb:Listener` endpoint.
    #
    # + s - Type descriptor of the service
    # + return - `()` or else  an error upon failure to detach the service
    public isolated function detach(MessageService s) returns Error? {
        return detach(self.listenerHandle, self, s);
    }

    # Stops consuming messages through all consumer services by terminating the connection and all its channels.
    #
    # + return - `()` or else  an error upon failure to close the `ChannelListener`
    public isolated function gracefulStop() returns Error? {
        return stop(self.listenerHandle, self);
    }

    # Stops consuming messages through all the consumer services and terminates the connection
    # with the server.
    #
    # + return - `()` or else  an error upon failure to close the `ChannelListener`.
    public isolated function immediateStop() returns Error? {
        return abortConnection(self.listenerHandle, self);
    }
}

isolated function initListener(handle connectionString, handle queueName, handle topicName, handle subscriptionName,
        handle receiveMode, handle logLevel, int maxConcurrentCalls, int prefetchCount, int maxAutoLockRenewDuration)
returns handle|error = @java:Constructor {
    'class: "io.ballerinax.asb.listener.MessageListener",
    paramTypes: [
        "java.lang.String",
        "java.lang.String",
        "java.lang.String",
        "java.lang.String",
        "java.lang.String",
        "java.lang.String",
        "int",
        "int",
        "int"
    ]
} external;

isolated function registerListener(handle listenerHandle, Listener lis, MessageService serviceType)
returns Error? = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;

isolated function 'start(handle listenerHandle, Listener lis) returns Error? = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;

isolated function detach(handle listenerHandle, Listener lis, MessageService serviceType)
returns Error? = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;

isolated function stop(handle listenerHandle, Listener lis) returns Error? = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;

isolated function abortConnection(handle listenerHandle, Listener lis) returns Error? = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;

isolated function externalInit(handle listenerHandle, Listener lis, Caller caller) = @java:Method {
    'class: "io.ballerinax.asb.listener.MessageListener"
} external;
