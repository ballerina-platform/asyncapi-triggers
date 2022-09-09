## Overview
The QuickBooks trigger allows you to listen to [QuickBooks webhook notifications](https://developer.intuit.com/app/developer/qbo/docs/develop/webhooks).

After you subscribe for webhooks to receive event triggered callbacks for entities that your app needs to stay on top of. QuickBooks webhooks automatically notify you whenever data changes in your end-user’s QuickBooks Online company files.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Create a [QuickBooks](https://quickbooks.intuit.com/) account
* Add listener endpoint URL  to QuickBooks webhooks.
* [Optional] Select and Save Entities and their events.


## Quickstart
To use the QuickBooks trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import the trigger
First, import `ballerinax/trigger.quickBooks` module into the Ballerina project as follows.
```ballerina
    import ballerinax/trigger.quickBooks;
```

### Step 2: Create a new trigger instance
Initialize the trigger by providing the QuickBooks company ids in the listener config and the port number where your trigger will be running. You can also pass a http:Listener instance instead of the port number with the listener config. The QuickBooks companyId is shown in your app with the company list.
```ballerina
    listener quickBooks:Listener quickBookListener = new (configs = {realmIds: ["<COMPANY_ID_01>", "<COMPANY_ID_02>" ]}, listenOn = <PORT>);
```

If you don't provide a port it will use the default port which is 8090.

### Step 3: Run the trigger service
1. Use the correct service type for the corresponding event channel you are interested, when implementing the service (For example, `quickBooks:onBill`).  

    Following is an example on how to listen to QuickBooks Bill events using the QuickBooks trigger.

    ```ballerina
        service quickBooks:AppService on quickBooksListener {
            remote function onBill(quickBooks:EventNotifications event) returns error? {
                string operation =  event.operation;
                if(operation == "Create") {
                    //YOUR LOGIC ON THE EVENT
                }
                return;
            }

            remote function onAccount(quickBooks:EventNotifications event) returns error? {
                return;
            }

            remote function onBillPayment(quickBooks:EventNotifications event) returns error? {
                return;
            }
        }
    ```

2. Use `bal run` command to compile and run the Ballerina program. 

### Step 4: Subscribe to a webhook topic with the URL of the service
Please follow this guide[https://developer.intuit.com/app/developer/qbo/docs/develop/webhooks] to subscribe the events.

> **Note**: 
> - Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web service to the internet and to obtain a public URL (For example: 'https://7745640c2478.ngrok.io'). 
> - In Choreo, you can obtain this service URL from the `Invoke URL` section of the `Configure and Deploy` form under `Deploy` view before App deployment.
> - Add a trailing `/` to the end of public URL if it's not present. 