## Overview

The `ballerinax/trigger.slack` module provides a Listener to grasp events triggered from your Slack App. This functionality is provided by [Slack Events API](https://api.slack.com/apis/connections/events-api).

## Prerequisites
Before using this connector in your Ballerina application, complete the following:

* Create a Slack account.
* Subscribe to events and obtain verification token
    1. Visit https://api.slack.com/apps, create your own Slack App and enable Event Subscription by going to `Event Subscriptions` section in your Slack App.
    2. Add events that you are planning to listen in the `Subscribe to events on behalf of users` section and save changes.
    3. Obtain `Verification Token` from the `Basic Information` section of your Slack App.

## Quickstart
To use the Slack listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the `ballerinax/trigger.slack` module as shown below.
```ballerina
import ballerinax/trigger.slack;
```

### Step 2: Create a new listener instance
Create a `slack:Listener` using your `Slack Verification Token`, port and initialize the listener with it.
```ballerina
slack:ListenerConfig configuration = {
    verificationToken: "VERIFICATION_TOKEN"
};

listener slack:Listener slackListener = new (configuration);
```

### Step 3: Implement a listener remote function
1. Now you can implement a listener remote function supported by this connector.

* Write a remote function to receive a particular event type. Implement your logic within that function as shown in the below sample.

* Following is a simple sample for using Slack listener
```ballerina
import ballerina/log;
import ballerinax/trigger.slack;
listener slack:Listener slackListener = new (verificationToken);
service slack:UserChangeService on slackListener {
    isolated remote function onUserChange(slack:GenericEventWrapper event) returns error? {
        log:printInfo("New Message");
    }
}
```
2. Use `bal run` command to compile and run the Ballerina program.

* Register the request URL
    1. Run your ballerina service (similar to above sample) on prefered port.
    2. Start ngrok on same port using the command ``` ./ngrok http 9090 ```
    3. In `Event Subscriptions` section of your Slack App settings, paste the URL issued by ngrok following with your service path (eg : ```https://365fc542d344.ngrok.io/slack/events```) (`'/slack/events'` should be added after thr ngrok URL. Even if it's not an ngrok URL, trailing / at the end of the URL is mandatory).
    4. Slack Event API will send a url_verification event containing the token and challenge key value pairs.
    5. Slack Listener will automatically verify the URL by comparing the token and send the required response back to slack
    6. Check whether your request URL displayed as `verified` in `Event Subscriptions` section of your Slack App.
    7. Subscribe to the events that you are planning to listen and click `Save Changes` button.

* Receiving events
    * After successful verification of Request URL your ballerina service will receive events.
