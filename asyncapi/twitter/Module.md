## Overview
This is a trigger for [Twitter](https://developer.twitter.com/en/docs/twitter-api/enterprise/account-activity-api/api-reference) that is capable of listening to the following events that occur in Twitter. 
- Tweeted
- Deleted Tweet
- Favorited Tweet
- Followed

This module supports the [Twitter Account Activity API v1.1](https://developer.twitter.com/en/docs/twitter-api/enterprise/account-activity-api/api-reference).

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
* Create [Twitter Developer Account](https://developer.twitter.com/en/apply-for-access)
* Obtain tokens
        
    Follow [this link](https://developer.twitter.com/en/docs/authentication/oauth-1-0a) to obtain the API key, API key secret, Access token and Access token secret.

## Quickstart
To use the Twitter trigger in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import listener
Import the **ballerinax/trigger.twitter** module as follows:
```ballerina
import ballerinax/trigger.twitter;
```

### Step 2: Create a new listener instance
Create a **twitter:Listener** using your port and initialize the trigger with it.
```ballerina
listener twitter:Listener TwitterListener = new (8090);
```

### Step 3: Implement listener remote functions
You can implement one or more Twitter remote functions supported by the trigger.

To write a remote function to receive a particular event type, you can implement the logic within the function as shown in the following samples:

* Following is a sample of the `Tweet` event of the Twitter trigger:

```ballerina
import ballerina/log;
import ballerinax/trigger.twitter;

listener twitter:Listener TwitterListener = new (8090);

service twitter:TweetsService on TwitterListener {

    remote function onAccepted(twitter:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onAccepted");
        return;
    }
    remote function onTweetsCreate(twitter:TweetEvent event) returns error? {
        log:printInfo("TweetEvent");
        return;
    }
    remote function onTweetsDelete(twitter:TweetDeleteEvent event) returns error? {
        log:printInfo("TweetDeleteEvent");
        return;
    }
    remote function onFollow(twitter:FollowEvent event) returns error? {
        log:printInfo("FollowEvent");
        return;
    }
    remote function onFavorite(twitter:FavoriteEvent event) returns error? {
        log:printInfo("FavoriteEvent");
        return;
    }
}
```

You can use the following command to compile and run the Ballerina program:

```
bal run
```
