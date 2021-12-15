## Overview

The `ballerinax/trigger.sfdc` module provides a Listener to grasp events triggered from a Salesforce org. This functionality is provided by [Salesforce Streaming API](https://developer.salesforce.com/docs/atlas.en-us.api_streaming.meta/api_streaming/intro_stream.htm).

## Prerequisites
Before using this connector in your Ballerina application, complete the following:

* Create a Salesforce account.
* Obtain the security token for the your Salesforce org by visiting <br/> `Profile -> Settings -> My Personal Information -> Reset My Security Token`
* Add the **API Enabled** permission & **Streaming API** permissions for your Salesforce org. 
* Prerequisites for different kind of events
    - Subscribe to **Change Data Capture Events**
        1. Subscribe to channels to receive notifications for record changes by visiting <br/> `Setup -> Integrations -> Change Data Capture`

## Quickstart
To use the Salesforce listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the `ballerinax/trigger.sfdc` module as shown below.
```ballerina
import ballerinax/trigger.sfdc;
```

### Step 2: Create a new listener instance
Create a `sfdc:Listener` using your `Slack Verification Token`, port and initialize the listener with it.
```ballerina
sfdc:ListenerConfig configuration = {
    username: "USER_NAME",
    password: "PASSWORD_SECURITY_TOKEN",
    channelName: "CHANNEL_NAME"
};
listener Listener sfdcListener = new (configuration);
```

### Step 3: Implement a listener remote function
1. Now you can implement a listener remote function supported by this connector.

* Write a remote function to receive a particular event type. Implement your logic within that function as shown in the below sample.

* Following is a simple sample for using Salesforce listener
```ballerina
import ballerina/log;
import ballerinax/trigger.sfdc;

service sfdc:StreamingEventService on sfdcListener {
    isolated remote function onUpdate(sfdc:EventData event) returns error? {
        log:printInfo(event.toString());
    }

    isolated remote function onCreate(sfdc:EventData event) {

    }
        
    isolated remote function onDelete(sfdc:EventData event) {

    }

    isolated remote function onRestore(sfdc:EventData event) {

    }
}
```
2. Use `bal run` command to compile and run the Ballerina program.

* Receiving events
    * After successful verification of Request URL your ballerina service will receive events.
