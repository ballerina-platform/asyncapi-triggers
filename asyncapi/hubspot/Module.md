## Overview

The [Ballerina](https://ballerina.io/) listener for Hubspot allows you to listen to the following events in a HubSpot account.
* `onCompanyCreation`
* `onCompanyDeletion`
* `onCompanyPropertyChange`
* `onContactCreation`
* `onContactDeletion`
* `onContactPropertyChange`
* `onConversationCreation`
* `onConversationDeletion`
* `onConversationPropertyChange`
* `onDealCreation`
* `onDealDeletion`
* `onDealPropertyChange`

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

- Create [HubSpot account](https://app.hubspot.com/signup-hubspot/)
- Create an [application](https://developers.hubspot.com/get-started) in  the Developer Portal.
- Go to [webhooks](https://developers.hubspot.com/docs/api/webhooks) and register a targetURL for notifications.
- Create a subscription with required events.

## Quickstart
To use the HubSpot listener in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import listener
To import the `ballerinax/trigger.hubspot` module into the Ballerina project, add the following statement:
```ballerina
    import ballerinax/trigger.hubspot;
```

### Step 2: Create a new listener instance
To create a `listenerConfig` with the application secret and the callback URL, add the following configuration.
```ballerina
    listener hubspot:Listener hubspotWebhook = new(listenerConfig = {clientSecret, callbackURL});
```
**Note** You can obtain the `clientSecret` from the HubSpot portal.

### Step 3: Invoke listener triggers
Now let's use the triggers available within the listener.

For example, you can configure the Ballerina listener to listen to company creation and deletion events as follows:

Listen to HubSpot Company Creation and Deletion

    ```ballerina
        service hubspot:CompanyService on hubspotWebhook {
            remote function onCompanyCreation(hubspot:WebhookEvent event) returns error? {
                io:println(event);
            }

            remote function onCompanyDeletion(hubspot:WebhookEvent event) returns error? {
                io:println(event);
            }
        }
    ```

**Note:** The event payload does not contain metadata related to the event. You need to use the specific HubSpot client to obtain it.

To compile and run the Ballerina program, issue the following command:

`bal run`