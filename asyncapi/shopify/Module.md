## Overview
The Shopify trigger allows you to listen to [Shopify webhook notifications](https://shopify.dev/apps/webhooks).
You can use webhook subscriptions to receive notifications about particular events in Shopify shops.
After you've subscribed to a webhook topic, your app can execute code immediately after specific events occur in shops that have your app installed, instead of having to make API calls periodically to check their status.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Create a [Shopify](https://www.shopify.com) account
* Subscribe to a webhook topic by following [this guide](https://shopify.dev/apps/webhooks/configuration/https). You can also use the [Ballerina Shopify Admin connector](https://central.ballerina.io/ballerinax/shopify.admin) to subscribe to a webhook topic.

## Quickstart
To use the Shopify trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import the trigger
First, import `ballerinax/trigger.shopify` module into the Ballerina project as follows.
```ballerina
    import ballerinax/trigger.shopify;
```

### Step 2: Create a new trigger instance
Initialize the trigger by providing the port number where your trigger will be running or by passing a http:Listener instance.
```ballerina
listener shopify:Listener shopifyListener = new(8090);
```

If you don't provide a port it will use the default port which is 8090.
```ballerina
    listener shopify:Listener shopifyListener = new;
```

### Step 3: Run the trigger service
1. Use the correct service type for the corresponding event channel you are interested, when implementing the service (For example, `shopify:OrdersService`). Now you can implement the trigger remote functions (For example, `onOrdersCreate`, `onOrdersCancelled` etc) supported under this service type. 

    Following is an example on how to listen to Shopify order events using the Shopify trigger.

    ```ballerina
    service shopify:OrdersService on shopifyListener {
        remote function onOrdersCreate(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
        remote function onOrdersCancelled(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
        remote function onOrdersFulfilled(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
        remote function onOrdersPaid(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
        remote function onOrdersPartiallyFulfilled(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
        remote function onOrdersUpdated(shopify:OrderEvent event) returns error? {
            // Write your logic here
        }
    }
    ```

2. Use `bal run` command to compile and run the Ballerina program. 

### Step 4: Subscribe to a webhook topic with the URL of the service
Subscribe to a webhook topic by following [this guide](https://shopify.dev/apps/webhooks/configuration/https). You can also use the [Ballerina Shopify Admin connector](https://central.ballerina.io/ballerinax/shopify.admin) to subscribe to a webhook topic. The ballerina service functions will be triggerred everytime a specific event (that you have subscribed) occurs in the shop that have your Shopify app installed.

> **Note**: 
> - Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web service to the internet and to obtain a public URL (For example: 'https://7745640c2478.ngrok.io'). 
> - In Choreo, you can obtain this service URL after App deployment.
> - Add a trailing `/` to the end of public URL if it's not present. 
