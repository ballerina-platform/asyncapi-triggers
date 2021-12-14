## Overview

The `ballerinax/trigger.asb` module supports asynchronous message listening capabilities from the [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/) via the Ballerina language. 
This module supports [Service Bus SDK 3.5.1 version](https://docs.microsoft.com/en-us/java/api/overview/azure/servicebus/client?view=azure-java-stable&preserve-view=true). 
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
    * Entity Path

  Obtain the authorization credentials:
    * For Service Bus Queues

        1. [Create a namespace in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-namespace-in-the-azure-portal)

        2. [Get the connection string](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#get-the-connection-string)

        3. [Create a queue in the Azure portal & get Entity Path](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-queue-in-the-azure-portal)
           . It is in the format ‘queueName’.

    * For Service Bus Topics and Subscriptions

        1. [Create a namespace in the Azure portal](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#create-a-namespace-in-the-azure-portal)

        2. [Get the connection string](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-portal#get-the-connection-string)

        3. [Create a topic in the Azure portal & get Entity Path](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-a-topic-using-the-azure-portal)
           . It's in the format ‘topicName‘.

        4. [Create a subscription in the Azure portal & get Entity Path](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal#create-subscriptions-to-the-topic)
           . It’s in the format ‘topicName/subscriptions/subscriptionName’.

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
    entityPath: "QUEUE_NAME_OR_SUBSCRIPTION_PATH",
    receiveMode: "PEEKLOCK_OR_RECEIVEANDDELETE"
};

listener asb:Listener asbListener = new (configuration);
```

### Step 3: Implement a listener remote function
1. Now you can implement a listener remote function supported by this connector.

* Write a remote function to receive messages from the Azure Service Bus. 
  Implement your logic within that function as shown in the below sample.

* Following is an example on how to listen to messages from the Azure Service Bus using the Azure Service Bus listener. Optionally
  you can provide the receive mode which is PEEKLOCK by default. You can find more information about the receive
  modes [here](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.servicebus.receivemode?view=azure-java-stable).

   Listen to Messages from the Azure Service Bus

   **!!! NOTE:**
   When configuring the listener, the entity path for a Queue is the entity name (Eg: "myQueueName") and the entity path
   for a subscription is in the following format `<topicName>/subscriptions/<subscriptionName>`
   (Eg: "myTopicName/subscriptions/mySubscriptionName").

    ```ballerina
    import ballerina/lang.value; 
    import ballerina/log;
    import ballerinax/trigger.asb;

    asb:ListenerConfig configuration = {
        connectionString: "CONNECTION_STRING",
        entityPath: "QUEUE_NAME_OR_SUBSCRIPTION_PATH",
        receiveMode: asb:PEEKLOCK
    };

    listener asb:Listener asbListener = new (configuration);

    service asb:MessageService on asbListener {
        isolated remote function onMessage(asb:Message message, asb:Caller caller) returns error? {
            // Write your logic here
            log:printInfo("Azure service bus message as byte[] which is the standard according to the AMQP protocol" + 
            message.toString());
            string|xml|json|byte[] received = message.body;

            match message?.contentType {
                asb:JSON => {
                    string stringMessage = check string:fromBytes(<byte[]> received);
                    json jsonMessage = check value:fromJsonString(stringMessage);
                    log:printInfo("The message received: " + jsonMessage.toJsonString());
                }
                asb:XML => {
                    string stringMessage = check 'string:fromBytes(<byte[]> received);
                    xml xmlMessage = check 'xml:fromString(stringMessage);
                    log:printInfo("The message received: " + xmlMessage.toString());
                }
                asb:TEXT => {
                    string stringMessage = check 'string:fromBytes(<byte[]> received);
                    log:printInfo("The message received: " + stringMessage);
                }
            }

            _ = check caller.complete(message);
        }
    };
    ```

   **!!! NOTE:**
   In the ASB listener we receive the message body as byte[] which is the standard according to the AMQP protocol. 
   We haven't re-engineered the listener. Rather we provide the message body as a standard byte[]. 
   So the user must do the conversion based on the content type of the message. 
   We have provided a sample code segment above, where you can do the conversion easily.
   You can also complete, abandon, deadLetter, defer, renewLock, and setPrefetchCount using the `asb:Caller` instance.

2. Use `bal run` command to compile and run the Ballerina program.
