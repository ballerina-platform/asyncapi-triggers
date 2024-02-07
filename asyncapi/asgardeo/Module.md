## Overview

The `ballerinax/trigger.asgardeo` module provides a Listener to grasp events triggered from your [Asgardeo](https://wso2.com/asgardeo/) organization. This functionality is provided by the [Asgardeo Events API](https://wso2.com/asgardeo/docs/references/asgardeo-events/).
The Asgardeo Trigger module allows you to listen to the following events when they occur in your Asgardeo organization:

- **Registration Events**
   - Add User Event
   - Accept User Invite Event
   - Confirm Self Sign Up Event
- **User Operation Events**
   - User Account Lock Event
   - User Account Unlock Event
   - User Credential Update Event
   - User Delete Event
   - User Group Update Event
- **Login Events**
   - Login Success Event
   - Login Failed Event

Learn more about [Asgardeo events](https://wso2.com/asgardeo/docs/references/asgardeo-events/#configure-asgardeo-to-publish-events).


## Prerequisites
- An organization in Asgardeo. Learn how to sign up and create an organization from [here](https://wso2.com/asgardeo/docs/get-started/create-asgardeo-account/#sign-up).
- An organization in [Choreo](https://wso2.com/choreo/) created with the same email address and under the same name that was used to create the organization in Asgardeo.
- Enable event publishing in your Asgardeo Organization. Learn how to enable from [here.](https://wso2.com/asgardeo/docs/references/asgardeo-events/#configure-asgardeo-to-publish-events)

## Quickstart

Follow the steps given below to try out the Asgardeo listener.
### Step 1: Create a webhook in Choreo to receive Asgardeo events

To use the Asgardeo listener, go to the [Choreo Console](https://console.choreo.dev) and create a webhook  with **Asgardeo** as the trigger type.
Learn more about [how to develop a webhook](https://wso2.com/choreo/docs/webhook/#develop-a-webhook).

### Step 2: Program a logic to trigger for Asgardeo events

Now you can implement listener remote functions supported by this connector.
1. Write a remote function to receive a particular event type. 
2. Implement your logic within that function as shown in the below sample. This is an example of logging Asgardeo events in the Choreo console.

    ```ballerina
    import ballerinax/trigger.asgardeo;
    import ballerina/log;
    import ballerina/http;
    
    configurable asgardeo:ListenerConfig config = ?;
    
    listener http:Listener httpListener = new(8090);
    listener asgardeo:Listener webhookListener =  new(config,httpListener);
    
    service asgardeo:RegistrationService on webhookListener {
      
        remote function onAddUser(asgardeo:AddUserEvent event ) returns error? {
            log:printInfo(event.toJsonString());
        }
      
        remote function onConfirmSelfSignup(asgardeo:GenericEvent event ) returns error? {
            log:printInfo(event.toJsonString());
        }
      
        remote function onAcceptUserInvite(asgardeo:GenericEvent event ) returns error? {
            log:printInfo(event.toJsonString());
        }
    }
    
    service /ignore on httpListener {}
    ```

### Step 3: Deploy the Webhook in Choreo
Once you have created the webhook, go to the **Deploy** tab on the Choreo Console and click on **Config & Deploy** button to start the deployment process. Learn more about how to deploy a webhook from [here.](https://wso2.com/choreo/docs/webhook/#deploy-a-webhook).
