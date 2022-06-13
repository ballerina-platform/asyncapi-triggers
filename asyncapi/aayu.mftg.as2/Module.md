
## Overview

This is a generated trigger for [MFT Gateway (by Aayu Technologies)](https://aayutechnologies.com/docs/product/mft-gateway/) that is capable of listening to the following events that occur in MFT Gateway. 
- Received Message
- Sent Message
- Failed Message

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Create a account on [MFT Gateway (by Aayu technologies)](https://console.mftgateway.com/auth/register)
* Create a [Station](https://aayutechnologies.com/docs/product/mft-gateway/creating-as2-station/) in the MFT Gateway account.

## Quickstart
To use the MFTG trigger in your Ballerina application, update the  .bal file as follows:

### Step 1: Import the trigger
First, import `ballerinax/trigger.aayu.mftg.as2` module into the Ballerina project as follows.

```ballerina
    import ballerinax/trigger.aayu.mftg.as2;
```

### Step 2: Initialize the MFTG Listener
Initialize the trigger by providing the listener config & port number/httpListener object.

```ballerina
    listener as2:Listener webhookListener = new (listenOn = 8090);
```

If you don't provide a port it will use the default port which is 8090.

```ballerina
    listener as2:Listener webhookListener = new;
```

### Step 3: Use the correct service type to implement the service
Use the correct service type for the corresponding channel when implementing the service.
Ex :- If you need to listen to Received Messages you may use `as2:ReceivedMessageService` service type as follows.

```ballerina
    service as2:ReceivedMessageService on webhookListener {}
```

### Step 4: Provide remote functions corresponding to the events which you are interested on
The remote functions can be provided as follows.

```ballerina
    service as2:ReceivedMessageService on webhookListener {
        remote function onMessageReceivedSuccess(as2:MessageReceivedEventWrapper event) returns error? {
            io:println("Received a message ", event);
            return;
        }
    }
```
### Step 5: Run the service 
Use `bal run` command to compile and run the Ballerina program.  

### Step 5: Configure MFTG webhook with the URL of the service
- Go to [MFTG webhook integrations](https://console.mftgateway.com/integration/webhook) and enable webhooks.
- Add the public URL of the started service as the Webhook URL.
- Select Stations and add/update the webhook.

This will add a subscription to MTF Gateway event API and the ballerina service functions will be triggerred once an event is fired.

Note:
- Add a trailing / to the public URL if its not present 
- Use ngrok to obtain a public URL for localhost instances



