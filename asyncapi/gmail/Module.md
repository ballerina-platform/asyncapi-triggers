## Overview

The Gmail Ballerina Trigger supports to listen to the changes of Gmail mailbox such as receiving a new message, receiving a new thread, adding a new label to a message, adding star to a message, removing label from a message, removing star from a message, and receiving a new attachment with the following trigger methods: `onNewEmail`, `onNewThread`, `onEmailLabelAdded`, `onEmailStarred`, `onEmailLabelRemoved`,`onEmailStarRemoved`, `onNewAttachment`.

This module supports [Gmail API v1](https://developers.google.com/gmail/api).

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

1. Create a [Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp). (If you already have one, you can use that.)

2. Obtain tokens

- Follow [this guide](https://developers.google.com/identity/protocols/oauth2)
  > **Note :** Enable `Cloud Pub/Sub API` or user setup service account with pubsub admin role. [Create a service account](https://developers.google.com/identity/protocols/oauth2/service-account#creatinganaccount) with pubsub admin

## Quickstart

To use the `Gmail` Trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import the Gmail Ballerina Trigger library

Import the ballerinax/trigger.gmail module into the Ballerina project.

```ballerina
    import ballerinax/trigger.gmail;
```

### Step 2: Initialize the Gmail Webhook Listener

Initialize the Trigger by providing the listener config & port number/httpListener object.

```ballerina
    gmail:ListenerConfig config = {
        clientId: "xxxx",
        clientSecret: "xxxx",
        refreshUrl: "https://oauth2.googleapis.com/token",
        refreshToken: "xxxx",
        pushEndpoint: "xxxx",
        project: "xxxx"
    };
    listener gmail:Listener webhookListener = new(config, 8090);
```

> **NOTE :**
>
> Here
>
> - `project` is the Id of the project which is created in `Google Cloud Platform` to create credentials (`clientId` and `clientSecret`).
> - `pushEndpoint` is the endpoint URL of the listener.

### Step 3: Use the correct service type to implement the service

Initialize the GmailService as below.

```ballerina
service gmail:GmailService on webhookListener {

    remote function onEmailLabelAdded(gmail:ChangedLabel changedLabel) returns error? {
        return;
    }

    remote function onEmailLabelRemoved(gmail:ChangedLabel changedLabel) returns error? {
        return;
    }

    remote function onEmailStarRemoved(gmail:Message message) returns error? {
        return;
    }

    remote function onEmailStarred(gmail:Message message) returns error? {
        log:printInfo(message.toString());
        return;
    }

    remote function onNewAttachment(gmail:MailAttachment attachment) returns error? {
        return;
    }

    remote function onNewEmail(gmail:Message message) returns error? {
        return;
    }

    remote function onNewThread(gmail:MailThread thread) returns error? {
        return;
    }
}
```

### Step 4: Provide remote functions corresponding to the events which you are interested on

The remote functions can be provided as follows.

```ballerina
    remote function onNewEmail(gmail:Message message) returns error? {
        log:printInfo("Received new email", eventPayload = message);
    }
```
