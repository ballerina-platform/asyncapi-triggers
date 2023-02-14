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
           
           It is in the format ‘queueName’.

    * For Service Bus Topics and Subscriptions

        1. [Create a namespace in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-namespace-in-the-azure-portal)

        2. [Get the connection string](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#get-the-connection-string)

        3. [Create a topic in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-a-topic-using-the-azure-portal)
           
           It's in the format ‘topicName‘.

        4. [Create a subscription in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-subscriptions-to-the-topic)
           
           It’s in the format ‘topicName/subscriptions/subscriptionName’.

## Quickstart

To use the Azure Service Bus listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener

Import the `ballerinax/trigger.asb` module as shown below.
```ballerina
import ballerinax/trigger.asb;
```

### Step 2: Create a new listener instance
```ballerina
asb:ListenerConfig configuration = {
    connectionString: "CONNECTION_STRING",
    entityConfig: {
        topicName: "TOPIC NAME",
        subscriptionName: "SUBCRIPTION NAME"
    },
    receiveMode: "asb:PEEK_LOCK OR asb:RECEIVE_AND_DELETE"
};

listener asb:Listener asbListener = new (configuration);
```
To listen to a queue, change the entity Config as follows,
```ballerina
entityConfig: {
  queueName: "QUEUE_NAME"
}
```

### Step 3: Implement a listener remote function
1. Now you can implement a listener remote function supported by this connector.

* Write a remote function to receive messages from the Azure Service Bus. 
  Implement your logic within that function as shown in the below sample.

* Following is an example on how to listen to messages from the Azure Service Bus using the Azure Service Bus listener. Optionally
  you can provide the receive mode which is PEEKLOCK by default. You can find more information about the receive
  modes [here](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.servicebus.receivemode?view=azure-java-stable).

   Listen to Messages from the Azure Service Bus

    ```ballerina
    import ballerina/lang.value; 
    import ballerina/log;
    import ballerinax/trigger.asb;

    asb:ListenerConfig configuration = {
        connectionString: "CONNECTION_STRING",
        entityConfig: {
          queueName: "QUEUE_NAME"
        },
        receiveMode: asb:PEEK_LOCK
    };

    listener asb:Listener asbListener = new (configuration);

    service asb:MessageService on asbListener {
        isolated remote function onMessage(asb:Message message, asb:Caller caller) returns error? {
            // Write your logic here
            log:printInfo("Azure service bus message as byte[] which is the standard according to the AMQP protocol" + 
            message.toString());
            }

            _ = check caller.complete(message);
        }
    };
    ```

   **!!! NOTE:**
   You can complete, abandon, deadLetter, defer, renewLock using the `asb:Caller` instance.

2. Use `bal run` command to compile and run the Ballerina program.
