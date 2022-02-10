## Overview

The [Ballerina](https://ballerina.io/) listener for Google Calendar provides the capability to listen to calendar events using the [Google Calendar API V3](https://developers.google.com/calendar/api/v3/reference).

The trigger can listen to events triggered  when a calendar event is created, updated or deleted edited with the following trigger methods: 
* `onNewEvent`
* `onEventUpdate`
* `onEventDelete`

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

- Create [Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp)
- Generate OAuth credentials to be used with the Google Calendar API V3

    1. Go to [Google API Console](https://console.developers.google.com/) 
    2. Create a new project if needed
    3. Navigate to `APIs & Services > Enabled APIs and Services`.
    4. Click on `+ENABLE APIS AND SERVICES`
    5. Search for `Google Calendar API` and select it.
    6. In the Google Calendar API page click on `Enable This API`
    7. Go back to `APIs & Services` Page and navigate to `OAuth Consent Screen`.
    8. Create a new app providing a name and relevant details.
    9. Add at least the following scopes for the app. You can add further scopes accordingly
        - ./auth/calendar.app.created
        - ./auth/calendar.calendarlist.readonly
        - ./auth/calendar.events.freebusy
        - ./auth/calendar.events.public.readonly
    10. After completing the OAuth Consent, go back to `APIs & Services` Page and navigate to `Credentials`.
    11. Click on `+ Create Credentials` and click on OAuth Client ID.
    12. From the create credentials form select `Web Application` as application type.
    13. Add https://developers.google.com/oauthplayground to `Authorized redirect URIs`, if you hope to use Google OAuth playground to generate access and refresh tokens.
    14. Click on create and record Client ID and Client Secret you receive.
    15. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground/).
    16. Click the gear icon in the upper right corner and check the box labeled Use your own OAuth credentials (if it isn't already checked) and enter the OAuth2 client ID and OAuth2 client secret you obtained in step 14.
    17. Select required Google Calendar scopes, and then click Authorize APIs.
    18. When you receive your authorization code, click Exchange authorization code for tokens to obtain the refresh token and access token.

## Quickstart
To use the Google Calendar listener in your Ballerina application, update the .bal file as follows:

### Step 1: Import listener
Import the ballerinax/trigger.google.calendar module into the Ballerina project.
```ballerina
    import ballerinax/trigger.google.calendar;
```

### Step 2: Create a new listener instance
Create a `calendar:ListenerConfig` with the details obtained in the prerequisite steps, and initialize the listener with it. 
```ballerina
    listener calendar:Listener calendarListener = new(listenerConfig = {
        calendarId: "primary", // If you have a specific calendar ID you can use it. To address the primary calendar you can use "primary"
        address: "", // Callback URL for the Google calendar API. This is usually the public url of the ballerina service.ex:-You can use ngrok to get public url 
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

    Following is an example on how to listen to create events and update events of a calendar using the listener. 
    Add the trigger implementation logic under each section based on the event type you want to listen to using the Google calendar Listener.

    Listen to append events and update events

    ```ballerina
    service calendar:CalendarService on calendarListener {

        remote function onEventDelete(calendar:Event payload) returns error? {
            return;
        }

        remote function onEventUpdate(calendar:Event payload) returns error? {
            return;
        }

        remote function onNewEvent(calendar:Event payload) returns error? {
            return;
        }
    }
    ```

    **!!! NOTE:** The Google Calendar Trigger can listen to events triggered when a spreadsheet is edited such as when a new event is created, deleted or  updated with the following trigger methods: `onNewEvent`,`onEventDelete`, `onEventUpdate`. We can get more information about the event using the payload parameter in each of the remote function.

2. Use `bal run` command to compile and run the Ballerina program. 



