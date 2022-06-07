## Overview

The Twilio Trigger allows you to listen to Twilio SMS and Call status change events.
1. Listen to incoming message events and message status change callback events from the Twilio SMS.
2. Listen to incoming call events and call status change callback events from the Twilio Voice Call.

This module supports [Twilio Basic API 2010-04-01](https://www.twilio.com/docs/all) version.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Sign up to Twilio and create a Twilio account (https://support.twilio.com/hc/en-us/articles/360011177133-View-and-Create-New-Accounts-in-Twilio-Console).
* Get a twilio phone number which needs to purchase through Twilio to send messages or make phone calls using Twilio.
    1. Navigate to the Phone Numbers page in your console.
    2. Click `Buy a Number` to purchase your first Twilio number.
* Register the request URL
    1. Start ngrok on same port using the command 
    ` ngrok http 8090`
* Configure the TwilioML Calls 
    1. Go to Active numbers in `Phone Numbers -> Manage -> Active Numbers`
    2. Click on your number
    3. Under the `Voice & Fax` paste the `Forwarding` URL issued by ngrok under the `A CALL COMES IN` and select the type as `WEBHOOK` and `HTTP POST` as the protocol
    4. Save the changes
* Configure the TwilioML SMS 
    1. Go to `Messaging -> Services`
    2. Click on `Create a messaging service` to setup a messaging service.
        1. Give a name to the messaging service that you are creating.
        2. Add senders to the messaging service.
        3. Click on `Send a webhook` at the **Integration** step.
            1. Paste the **Forwarding** URL issued by the ngrok at `Request URL`
        4. Complete the Messaging Service Setup.

## Quickstart
To use the Twiolio trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the `ballerinax/trigger.twilio` module as shown below.
```ballerina
import ballerinax/trigger.twilio;
```

### Step 2: Create a new listener instance
Create a `twilio:Listener` using your port and initialize the trigger with it.
```ballerina
listener twilio:Listener TwilioListener = new (8090);
```

### Step 3: Implement a listener remote functions
1. Now you can implement a Twilio remote function/s supported by the trigger.

2. Write a remote function/s to receive a particular event type. Implement your logic within that function as shown in the below sample.

* Following are the event samples of SmsStatus events in Twilo trigger.
```ballerina
import ballerina/log;
import ballerinax/trigger.twilio;
listener twilio:Listener TwilioListener = new (8090);;
service twilio:SmsStatusService on TwilioListener{
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
* Following are the event samples of  CallStatus events in Twilo trigger.
```ballerina
import ballerina/log;
import ballerinax/trigger.twilio;
listener twilio:Listener TwilioListener = new (8090);;
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
2. Use follwing command to compile and run the Ballerina program.

```
bal run
```

## Receiving events
For receving the Twilio call/message events, use the active number to send a call/message.
