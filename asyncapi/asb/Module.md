## Overview

The `ballerinax/trigger.asb` module supports asynchronous message listening capabilities from the [Azure Service Bus](https://learn.microsoft.com/en-us/java/api/com.azure.messaging.servicebus?view=azure-java-stable) via the Ballerina language. 
This module supports [Service Bus SDK 7.13.1 version](https://learn.microsoft.com/en-us/java/api/com.azure.messaging.servicebus?view=azure-java-stable). 
The source code on GitHub is located [here](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/servicebus/microsoft-azure-servicebus). 
The primary wire protocol for Service Bus is Advanced Messaging Queueing Protocol (AMQP) 1.0, an open ISO/IEC standard.

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

* Create an Azure account and a subscription. If you don't have an Azure
  subscription, [sign up for a free Azure account](https://azure.microsoft.com/free/).

* Create a Service Bus namespace. If you don't
  have [a service bus namespace](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-create-namespace-portal)
  , learn how to create your Service Bus namespace.

* Create a messaging entity, such as a queue, topic or subscription. If you don't have these items, learn how to
    * [Create a queue in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-queue-in-the-azure-portal)
    * [Create a topic using the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-a-topic-using-the-azure-portal)
    * [Create subscriptions to the topic](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-subscriptions-to-the-topic)

* Obtain tokens

  Shared Access Signature (SAS) Authentication Credentials are required to communicate with the Azure Service Bus.
    * Connection String

  Obtain the authorization credentials:
    * For Service Bus Queues

        1. [Create a namespace in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-namespace-in-the-azure-portal)

        2. [Get the connection string](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#get-the-connection-string)

        3. [Create a queue in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-queue-in-the-azure-portal)

    * For Service Bus Topics and Subscriptions

        1. [Create a namespace in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-namespace-in-the-azure-portal)

        2. [Get the connection string](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#get-the-connection-string)

        3. [Create a topic in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-a-topic-using-the-azure-portal)

        4. [Create a subscription in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-subscriptions-to-the-topic)

## Quickstart

To use the Azure Service Bus listener in your Ballerina application, update the .bal file as follows:

### Enabling Azure SDK Logs
To enable Azure logs in a Ballerina module, you need to set the environment variable ASB_CLOUD_LOGS to ACTIVE. You can do this by adding the following line to your shell script or using the export command in your terminal(to deactivate,remove the variable value):

`export ASB_CLOUD_LOGS=ACTIVE`

### Enabling Internal Connector Logs
To enable internal connector logs in a Ballerina module, you need to set the log level in the Config.toml file using the  custom configuration record Where <log_level> is the desired log level (e.g. DEBUG, INFO, WARN, (Default)ERROR, FATAL, OFF)

```
[ballerinax.trigger.asb.options]
logLevel="OFF"
```

### Step 1: Import listener

Import the `ballerinax/trigger.asb` module as shown below.
```ballerina
import ballerinax/trigger.asb;
```

### Step 2: Create a new listener endpoint
```ballerina
asb:ListenerConfig configuration = {
    connectionString: "CONNECTION_STRING"
};

listener asb:Listener asbListener = new (configuration);
```

### Step 3: Define a consumer service 

* Now you can define one or more consumer services and attach it to the defined listener endpoint. The messages will then be delivered automatically as they arrive rather than having to be explicitly requested. Multiple consumer services can be bound to one Ballerina Azure Service Bus `asb:Listener`. 

* Listener configurations such as queue or topic name to listen to, message receive mode etc. are configured in the `asb:ServiceConfig`  annotation of the service. 

  ```ballerina
  @asb:ServiceConfig {
        queueName: "MyQueue",
        peekLockModeEnabled: true,
        topicName: "myTopic",
        subscriptionName: "abc",
        maxConcurrency: 1,
        prefetchCount: 10,
        maxAutoLockRenewDuration: 300,
        logLevel: ERROR
    }
    service asb:Service on myTestListener {
        remote function onMessage(asb:Message message) {
            //process message
        }
    }
  ```

  1. queueName : Name of the queue service should listen to. Either queueName or topicName should be configured. 
  2. topicName : Name of the topic service should listen to. Either queueName or topicName should be configured.
  3. peekLockModeEnabled : ASB has two modes of message receive. Setting this to `true` makes the mode to `PEEK_LOCK`. Making it false or not setting it makes the mode to `RECEIVE_AND_DELETE `. You can find more information about receive
  modes [here](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.servicebus.receivemode?view=azure-java-stable)
  4. subscriptionName : Name of the subscription if a topicName is specified. 
  5. maxConcurrency : How many messages are parallelly dispatched to the service (default =1, means sequential). 
  6. prefetchCount: Number of messages pre-fetched by underlying subscriber for efficiency (default - 0, means prefetch off) 
  7. maxAutoLockRenewDuration: Sets the amount of time to continue auto-renewing the lock in `seconds`. Setting Duration to #ZERO disables   auto-renewal. This is not considered when `peekLockModeEnabled` is false. (default 300 seconds)
  8. logLevel:  desired log level (e.g. DEBUG, INFO, WARN, (Default)ERROR, FATAL, OFF) for underlying SDK

* Implement logic on how to process the message under `onMessage` resource. 
* Implement logic on how to process error when receiving a message under `onError` resource. 
* Following is a complete example on how to listen to messages from an Azure Service Bus queue called `MyQueue` sequentially using Ballerina ASB listener. 

   Listen to Messages from the Azure Service Bus

    ```ballerina
    import ballerina/lang.value; 
    import ballerina/log;
    import ballerinax/trigger.asb;

    asb:ListenerConfig configuration = {
        connectionString: "CONNECTION_STRING"
    };

    listener asb:Listener asbListener = new (configuration);

    @asb:ServiceConfig {
        queueName: "MyQueue",
        peekLockModeEnabled: true,
        maxConcurrency: 1,
        prefetchCount: 10,
        maxAutoLockRenewDuration: 300
    }
    service asb:MessageService on asbListener {
        isolated remote function onMessage(asb:Message message, asb:Caller caller) returns error? {
            // Write your message processing logic here
            log:printInfo("Message received from queue: " + message.toBalString());
            _ = check caller.complete(message);
        }
  
        isolated remote function onError(asb:ErrorContext context, error 'error) returns error? {
            // Write your error handling logic here
        }
    };
    ```

   **!!! NOTE:**
   You can complete, abandon, deadLetter, defer, renewLock using the `asb:Caller` instance. If you want to handle to errors that come when processing messages, use `MessageServiceErrorHandling` service type.

  Use `bal run` command to compile and run the Ballerina program.
