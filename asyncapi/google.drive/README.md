## Overview

The [Ballerina](https://ballerina.io/) listener for Google Drive provides the capability to listen to drive events using the [Google Drive API V3](https://developers.google.com/drive/api/v3/reference).

The trigger can listen to events triggered  when a drive event is created, updated or deleted edited with the following trigger methods: 
* `onFileCreate`
* `onFolderCreate`
* `onFileUpdate`
* `onFileUpdate`
* `onFolderUpdate`
* `onDelete`
* `onFileTrash`
* `onFolderTrash`

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

- Create [Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp)
- Generate OAuth credentials to be used with the Google Drive API V3

    1. Go to [Google API Console](https://console.developers.google.com/) 
    2. Create a new project if needed
    3. Navigate to `APIs & Services > Enabled APIs and Services`.
    4. Click on `+ENABLE APIS AND SERVICES`
    5. Search for `Google Drive API` and select it.
    6. In the Google Drive API page click on `Enable This API`
    7. Go back to `APIs & Services` Page and navigate to `OAuth Consent Screen`.
    8. Create a new app providing a name and relevant details.
    9. Add required scopes accordingly
    10. After completing the OAuth Consent, go back to `APIs & Services` Page and navigate to `Credentials`.
    11. Click on `+ Create Credentials` and click on OAuth Client ID.
    12. From the create credentials form select `Web Application` as application type.
    13. Add https://developers.google.com/oauthplayground to `Authorized redirect URIs`, if you hope to use Google OAuth playground to generate access and refresh tokens.
    14. Click on create and record Client ID and Client Secret you receive.
    15. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground/).
    16. Click the gear icon in the upper right corner and check the box labeled Use your own OAuth credentials (if it isn't already checked) and enter the OAuth2 client ID and OAuth2 client secret you obtained in step 14.
    17. Select required Google Drive scopes, and then click Authorize APIs.
    18. When you receive your authorization code, click Exchange authorization code for tokens to obtain the refresh token and access token.

### Compatibility

|                               | Version                       |
|-------------------------------|-------------------------------|
| Ballerina Language            | Ballerina Swan Lake 2201.11.0 |
| Google Drive API              | v3                            | 

## Quickstart
To use the Google Drive listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the ballerinax/trigger.google.drive module into the Ballerina project.
```ballerina
    import ballerinax/trigger.google.drive;
```

### Step 2: Create a new listener instance
Create a `drive:ListenerConfiguration` with the details obtained in the prerequisite steps, and initialize the listener with it. 
```ballerina
    listener drive:Listener driveListener = new(listenerConfig = { 
        auth: {
            refreshUrl: "https://oauth2.googleapis.com/token", // For google services you can use this refresh URL
            refreshToken: "", // Obtained in prerequisite step 18
            clientId: "", // Obtained in prerequisite step 14
            clientSecret: "", // Obtained in prerequisite step 14
        }
    });
```

### Step 3: Invoke listener triggers
1. Now you can use the triggers available within the listener. 

    Following is an example on how to listen to create events and update events of a drive using the listener. 
    Add the trigger implementation logic under each section based on the event type you want to listen to using the Google drive Listener.

    Listen to append events and update events

    ```service drive:DriveService on driveListener {
    remote function onDelete(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFileCreate(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFileTrash(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFileUpdate(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFolderCreate(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFolderTrash(drive:Change changeInfo) returns error? {
            return;
    }

    remote function onFolderUpdate(drive:Change changeInfo) returns error? {
            return;
    }
}
    ```

    **!!! NOTE:** The Google Drive Trigger can listen to events triggered when a drive is edited such as when a new file and folder is created, trashed ,updated or deleted with the following trigger methods: `onFileCreate`,`onFileTrash`, `onFileUpdate`,`onFolderCreate`,`onFolderTrash`,`onFolderUpdate`,`onDelete`. We can get more information about the event using the payload parameter in each of the remote function.

2. Use `bal run` command to compile and run the Ballerina program. 

## Report issues

To report bugs, request new features, start new discussions, etc., go to the [Ballerina Library repository](https://github.com/ballerina-platform/ballerina-library)

## Useful links

- For more information go to the [`trigger.google.drive` package](https://central.ballerina.io/ballerinax/trigger.google.drive/latest).
- For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
