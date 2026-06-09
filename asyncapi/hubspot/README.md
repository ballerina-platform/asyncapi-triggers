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

Before using this connector in your Ballerina application, complete the following steps.

### Step 1: Create a HubSpot Developer Account

[Sign up for a HubSpot developer account](https://app.hubspot.com/signup-hubspot/) if you don't already have one.

### Step 2: Install the HubSpot CLI

Install the HubSpot CLI (v7.6.0 or later) using npm:

```sh
npm install -g @hubspot/cli@latest
```

Authenticate the CLI with your developer account:

```sh
hs account auth
```

This opens a browser window. Log in and follow the prompts to link the CLI to your developer account.

### Step 3: Create a Developer Test Account

A developer test account is an isolated HubSpot CRM account used for testing. It is separate from your developer account.

1. In your developer account portal, navigate to **Testing → Developer test accounts**.
2. Click **Create developer test account** and follow the prompts.

<img src=https://raw.githubusercontent.com/ballerina-platform/asyncapi-triggers/main/asyncapi/hubspot/docs/setup/resources/create-dev-account.png alt="Create developer test account" width="70%">

### Step 4: Set Up ngrok

The Ballerina listener runs locally and needs a publicly accessible URL so HubSpot can deliver webhook events to it. [ngrok](https://ngrok.com/) creates a secure tunnel from a public URL to your local service.

Install ngrok and start a tunnel on port `8090` (the default port for the Ballerina listener):

```sh
ngrok http 8090
```

Copy the HTTPS forwarding URL from the ngrok terminal output. It looks like:

```
https://xxxx-xxx-xxx-xxx.ngrok-free.app
```

> **Save this value** — you will need the ngrok URL when configuring the webhook in Step 6 and in the Quickstart section.

### Step 5: Create a HubSpot Developer Platform App

1. Create a new project using the HubSpot CLI:

    ```sh
    hs project create
    ```

    When prompted:
    - **Base contents** → select `App`
    - **Distribution** → select `private`
    - **Auth** → select `oauth`
    - **Features** → select `Webhooks` (press spacebar to select, enter to confirm)
    - **Name** → enter a name for your project (e.g. `hubspot-webhook-app`)

2. Replace the contents of `src/app/app-hsmeta.json` with the following, adjusting the `uid`, `name`, and `requiredScopes` as needed:

    ```json
    {
      "uid": "hubspot_webhook_app",
      "type": "app",
      "config": {
        "name": "hubspot-webhook-app",
        "distribution": "private",
        "auth": {
          "type": "oauth",
          "redirectUrls": ["http://localhost:3000/oauth-callback"],
          "requiredScopes": [
            "crm.objects.contacts.read",
            "crm.objects.companies.read",
            "crm.objects.deals.read"
          ],
          "optionalScopes": [],
          "conditionallyRequiredScopes": []
        },
        "permittedUrls": {
          "fetch": ["https://api.hubapi.com"],
          "iframe": [],
          "img": []
        },
        "support": {
          "supportEmail": "support@example.com",
          "documentationUrl": "https://example.com/docs",
          "supportUrl": "https://example.com/support",
          "supportPhone": "+18005555555"
        }
      }
    }
    ```

### Step 6: Configure Webhook Subscriptions

Replace the contents of `src/app/webhooks/webhook-hsmeta.json` with the following. Replace `<YOUR_NGROK_URL>` with the ngrok URL you copied in Step 4.

```json
{
  "uid": "hubspot_webhook_subscriptions",
  "type": "webhooks",
  "config": {
    "settings": {
      "targetUrl": "<YOUR_NGROK_URL>",
      "maxConcurrentRequests": 10
    },
    "subscriptions": {
      "legacyCrmObjects": [
        { "subscriptionType": "contact.creation", "active": true },
        { "subscriptionType": "contact.deletion", "active": true },
        { "subscriptionType": "contact.propertyChange", "propertyName": "email", "active": true },
        { "subscriptionType": "company.creation", "active": true },
        { "subscriptionType": "company.deletion", "active": true },
        { "subscriptionType": "company.propertyChange", "propertyName": "name", "active": true },
        { "subscriptionType": "deal.creation", "active": true },
        { "subscriptionType": "deal.deletion", "active": true },
        { "subscriptionType": "deal.propertyChange", "propertyName": "dealname", "active": true }
      ]
    }
  }
}
```

> **Note:** Add additional `propertyChange` entries for any other properties you want to monitor. Each property requires its own subscription entry with a `propertyName` field.

Upload the project to HubSpot:

```sh
hs project upload
```

Wait for both the build and deploy to succeed:

```
✔ Built hubspot-webhook-app #1
✔ Deployed hubspot-webhook-app #1
```

### Step 7: Retrieve the Client Secret

1. Open the project in the HubSpot portal:

    ```sh
    hs project open
    ```

2. Under **Project Components**, click the UID of your app.
3. Click the **Auth** tab.
4. Under **Client credentials**, copy the **Client Secret**.

<img src=https://raw.githubusercontent.com/ballerina-platform/asyncapi-triggers/main/asyncapi/hubspot/docs/setup/resources/app-auth-tab.png alt="App Client Secret" width="70%">

> **Save this value** — you will need the Client Secret in the Quickstart section when initialising the Ballerina listener.

### Step 8: Install the App in Your Test Account

The app must be installed in a HubSpot account for that account's events to trigger webhooks.

1. Start the OAuth quickstart server in a new terminal. This handles the OAuth token exchange when the browser redirects to `localhost:3000`:

    ```sh
    git clone https://github.com/HubSpot/oauth-quickstart-nodejs.git
    cd oauth-quickstart-nodejs
    npm install
    ```

    Create a `.env` file in the project directory:

    ```
    CLIENT_ID=<YOUR_CLIENT_ID>
    CLIENT_SECRET=<YOUR_CLIENT_SECRET>
    SCOPES=crm.objects.contacts.read,crm.objects.companies.read,crm.objects.deals.read
    ```

    Start the server:

    ```sh
    npm start
    ```

2. On your app's details page in the developer portal, go to the **Distribution** tab.
3. Click on **Test URL**, under **Sample install URL**.

    <img src=https://raw.githubusercontent.com/ballerina-platform/asyncapi-triggers/main/asyncapi/hubspot/docs/setup/resources/test-install-url.png alt="Test Install URL" width="70%">

5. When prompted, select your **developer test account** as the account to install into.
    <img src=https://raw.githubusercontent.com/ballerina-platform/asyncapi-triggers/main/asyncapi/hubspot/docs/setup/resources/choose-dev-account.png alt="HubSpot OAuth authorization screen showing the test account" width="70%">

6. After authorizing, the browser redirects to `http://localhost:3000`. The page displays an access token and a sample contact name, confirming the installation was successful.

### Compatibility

|                               | Version                       |
|-------------------------------|-------------------------------|
| Ballerina Language            | Ballerina Swan Lake 2201.11.0 |

## Quickstart

To use the HubSpot listener in your Ballerina application, update the `.bal` file as follows.

Before running the quickstart, ensure you have:
- The **Client Secret** from Step 7 of the Prerequisites
- Your **ngrok URL** from Step 4 of the Prerequisites
- ngrok running (`ngrok http 8090`)
- The OAuth quickstart server running (`npm start` in the `oauth-quickstart-nodejs` directory)

### Step 1: Import listener

To import the `ballerinax/trigger.hubspot` module into the Ballerina project, add the following statement:

```ballerina
import ballerinax/trigger.hubspot;
```

### Step 2: Create a new listener instance

Add the following to your `Config.toml` file, replacing the placeholders with the values saved during the Prerequisites:

```toml
clientSecret = "<YOUR_CLIENT_SECRET>"
callbackUrl = "<YOUR_NGROK_URL>"
```

Then initialise the listener in your `.bal` file:

```ballerina
configurable string clientSecret = ?;
configurable string callbackUrl = ?;

listener hubspot:Listener hubspotWebhook = new (
    {clientSecret: clientSecret, callbackURL: callbackUrl},
    listenOn = 8090
);
```

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

    remote function onCompanyPropertychange(hubspot:WebhookEvent event) returns error? {
        io:println(event);
    }
}
```

**Note:** The event payload does not contain metadata related to the event. You need to use the specific HubSpot client to obtain it.

To compile and run the Ballerina program, issue the following command:

```sh
bal run
```

To verify it is working, go to your **HubSpot test account** and create or delete a Contact, Company, or Deal. You should see the event printed in the Ballerina console output.

## Report issues

To report bugs, request new features, start new discussions, etc., go to the [Ballerina Library repository](https://github.com/ballerina-platform/ballerina-library)

## Useful links

- For more information go to the [`trigger.hubspot` package](https://central.ballerina.io/ballerinax/trigger.hubspot/latest).
- For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
