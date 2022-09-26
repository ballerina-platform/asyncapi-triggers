## Overview
The QuickBooks trigger allows you to listen to [QuickBooks webhook notifications](https://developer.intuit.com/app/developer/qbo/docs/develop/webhooks).

After you subscribe for webhooks to receive event-triggered callbacks for entities that your application must listen to. QuickBooks webhooks automatically notify you whenever data changes in your end user’s QuickBooks Online company files.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Create a [QuickBooks](https://quickbooks.intuit.com/) account.
* Add listener endpoint URL to QuickBooks webhooks.
* [Optional] Select and Save Entities and their events.

## Quickstart
To use the QuickBooks trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import the trigger
First, import `ballerinax/trigger.quickbooks` module into the Ballerina project as follows.
```ballerina
    import ballerinax/trigger.quickbooks;
```

### Step 2: Create a new trigger instance
Initialize the trigger by providing the app-specific verifier token (to validate the webhook notifications from the callback are from Intuit) and QuickBooks company IDs in the listener config and the port number where your trigger will be running. You can also pass an http:Listerner instance instead of the port number with the listener config. The app-specific verifier token is shown under webhooks section of your QuickBooks app after registering an endpoint URL. The QuickBooks companyId is shown in your app under the company list.
```ballerina
    listener quickbooks:Listener quickBooksListener = new (
        listenerConfig = {
            verificationToken: "<VERIFIER_TOKEN>",
            realmIds: ["<COMPANY_ID_01>", "<COMPANY_ID_02>"]
        }, 
        listenOn = <PORT>
    );
```

If you don't provide a port it will use the default port which is 8090.

### Step 3: Run the trigger service
1. Implement a service using the correct service type for the relevant event channel (e.g., `quickbooks:CustomerService`). 

    The following is a sample service that listens to QuickBooks Customer events via the QuickBooks trigger:

    ```ballerina
        service quickbooks:CustomerService on quickBooksListener {
            remote function onCustomerCreate(quickbooks:QuickBookEvent event) returns error? {
                // YOUR LOGIC ON THE EVENT
            }
            remote function onCustomerUpdate(quickbooks:QuickBookEvent event) returns error? {}
            remote function onCustomerDelete(quickbooks:QuickBookEvent event) returns error? {}
            remote function onCustomerMerge(quickbooks:QuickBookEvent event) returns error? {}
        }
    ```

2. To compile and run the Ballerina program, issue the following command: `bal run`

### Step 4: Subscribe to a webhook topic with the URL of the service
For instructions to subscribe to a webhook topic with the URL of the service, see [Intuit Developer Documentation - Webhooks](https://developer.intuit.com/app/developer/qbo/docs/develop/webhooks).

> **Note**: 
> - Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web service to the internet and to obtain a public URL (For example: 'https://7745640c2478.ngrok.io'). 
> - In Choreo, you can obtain this service URL from the `Invoke URL` section of the `Configure and Deploy` form under `Deploy` view before App deployment.
> - Add a trailing `/` to the end of public URL if it's not present. 
