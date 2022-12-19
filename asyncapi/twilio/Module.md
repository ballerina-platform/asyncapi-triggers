## Overview

The Twilio trigger allows you to listen to Twilio SMS and call status change events similar to the following.
- Incoming message events and message status change callback events from Twilio SMS.
- Incoming call events and call status change callback events from Twilio voice call.

This module supports the [Twilio Basic API 2010-04-01](https://www.twilio.com/docs/all) version.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Sign up to Twilio and create a Twilio account. For step-by-step instructions, see [View and Create New Accounts in Twilio](https://support.twilio.com/hc/en-us/articles/360011177133-View-and-Create-New-Accounts-in-Twilio-Console).
* Follow the steps below to purchase a Twilio phone number to send messages and make phone calls using Twilio:
    1. Go to **Phone Numbers -> Manage** on the left navigation pane under the **Develop** section.
    2. Click **Buy a Number** and proceed to purchase.
* Follow the steps below to register the request URL:
    1. Run the following command to start ngrok on the same port: 
    ```
    ngrok http 8090
    ``` 
    2. Copy the **Forwarding URL** displayed in your terminal. You need this URL to configure **TwilioML SMS**.

## Quickstart
To use the Twilio trigger in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import listener
Import the **ballerinax/trigger.twilio** module as follows:
```ballerina
import ballerinax/trigger.twilio;
```

### Step 2: Create a new listener instance
Create a **twilio:Listener** using your port and initialize the trigger with it.
```ballerina
listener twilio:Listener TwilioListener = new (8090);
```

### Step 3: Implement listener remote functions
You can implement one or more Twilio remote functions supported by the trigger.

To write a remote function to receive a particular event type, you can implement the logic within the function as shown in the following samples:

* Following is a sample of the `SmsStatus` event of the Twilio trigger:

```ballerina
import ballerina/log;
import ballerinax/trigger.twilio;

listener twilio:Listener TwilioListener = new (8090);

service twilio:SmsStatusService on TwilioListener {

    remote function onAccepted(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onAccepted");
        return;
    }

    remote function onDelivered(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onDelivered");
        return;
    }

    remote function onFailed(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onFailed");
        return;
    }

    remote function onQueued(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onQueued");
        return;
    }

    remote function onReceived(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onReceived");
        return;
    }

    remote function onReceiving(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onReceiving");
        return;
    }

    remote function onSending(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onSending");
        return;
    }

    remote function onSent(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onSent");
        return;
    }

    remote function onUndelivered(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onUndelivered");
        return;
    }
}
```
* Following is a sample of the `CallStatus` event of the Twilio trigger:
```ballerina
import ballerina/log;
import ballerinax/trigger.twilio;

listener twilio:Listener TwilioListener = new (8090);

service twilio:SmsStatusService on TwilioListener{

        remote function onBusy(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event  onBusy triggered");
        return;
    }

    remote function onCanceled(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event  onCanceled triggered");
        return;
    }

    remote function onCompleted(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event  onCompleted triggered");
        return;
    }

    remote function onFailed(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event  onFailed triggered");
        return;
    }

    remote function onInProgress(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event onInProgress triggered");
        return;
    }

    remote function onNoAnswer(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event onNoAnswer triggered");
        return;
    }

    remote function onQueued(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event onQueued triggered");
        return;
    }

    remote function onRinging(twilio:CallStatusEventWrapper event) returns error? {
        log:printInfo("Twilio call event onRinging triggered");
        return;
    }
}
```
You can use the following command to compile and run the Ballerina program:

```
bal run
```
## Receiving events
To try out receiving Twilio call/message events, you can use an active Twilio number to send a call/message.
