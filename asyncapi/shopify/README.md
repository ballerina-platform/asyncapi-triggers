## Overview
The Shopify trigger allows you to listen to [Shopify webhook notifications](https://shopify.dev/apps/webhooks).
You can use webhook subscriptions to receive notifications about particular events in Shopify shops.
After you've subscribed to a webhook topic, your app can execute code immediately after specific events occur in shops that have your app installed, instead of having to make API calls periodically to check their status.

## Prerequisites
Before using this trigger in your Ballerina application, complete the following:

* Create a [Shopify](https://www.shopify.com) account

### Compatibility

|                               | Version                       |
|-------------------------------|-------------------------------|
| Ballerina Language            | Ballerina Swan Lake 2201.11.0 |
| Shopify Webhook API           | 2021-10                       |

## Quickstart
To use the Shopify trigger in your Ballerina application, update the .bal file as follows:

### Step 1: Import the trigger
First, import `ballerinax/trigger.shopify` module into the Ballerina project as follows.
```ballerina
    import ballerinax/trigger.shopify;
```

### Step 2: Create a new trigger instance
Initialize the trigger by providing the Shopify API secret key in the listener config and the port number where your trigger will be running. You can also pass a http:Listener instance instead of the port number with the listener config. The Shopify API secret key is viewable under `Webhooks` in the Shopify admin dashboard (if the webhook is created using the dashboard) or under `API credentials` in the Shopify App (if the webhook is created programatically).
```ballerina
    shopify:ListenerConfig listenerConfig = {
        apiSecretKey: "<SHOPIFY_API_SECRET_KEY>"
    };
    listener shopify:Listener shopifyListener = new(listenerConfig, 8090);
```

If you don't provide a port it will use the default port which is 8090.
```ballerina
    shopify:ListenerConfig listenerConfig = {
        apiSecretKey: "<SHOPIFY_API_SECRET_KEY>"
    };
    listener shopify:Listener shopifyListener = new(listenerConfig);
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
Subscribe to a webhook topic by following [this guide](https://shopify.dev/apps/webhooks/configuration/https). You can use the `createWebhook` operation of the [Ballerina Shopify Admin connector](https://central.ballerina.io/ballerinax/shopify.admin) to programatically subscribe to a webhook topic. You can also use the Shopify Admin dashboard to manually create a webhook. In your Shopify Admin dashboard, head to `Settings > Notifications` and scroll down to `Webhooks` to create a new webhook. The ballerina service functions will be triggerred everytime a specific event (that you have subscribed) occurs in the shop that have your Shopify app installed.

> **Note**: 
> - Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web service to the internet and to obtain a public URL (For example: 'https://7745640c2478.ngrok.io'). 
> - In Choreo, you can obtain this service URL from the `Invoke URL` section of the `Configure and Deploy` form under `Deploy` view before App deployment.
> - Add a trailing `/` to the end of public URL if it's not present. 

## Report issues

To report bugs, request new features, start new discussions, etc., go to the [Ballerina Library repository](https://github.com/ballerina-platform/ballerina-library)

## Useful links

- For more information go to the [`trigger.shopify` package](https://central.ballerina.io/ballerinax/trigger.shopify/latest).
- For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
