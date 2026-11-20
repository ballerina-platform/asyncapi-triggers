> [!WARNING]
> **This package is deprecated.** Use [`ballerinax/identityserver.trigger`](https://central.ballerina.io/ballerinax/identityserver.trigger) instead. It receives the webhooks of both WSO2 Identity Server and Asgardeo, verified with a webhook secret. This package gets no further updates.
>
> To move to it:
> - Import `ballerinax/identityserver.trigger` in place of `ballerinax/trigger.identityserver`.
> - Events are grouped in 10 service types, such as `LoginService` and `UserService`, following the server's webhook events.
> - `ListenerConfig.webhookSecret` stays.

## Overview

The `ballerinax/trigger.identityserver` module provides a Listener to grasp events triggered from your [WSO2 Identity Server](https://wso2.com/identity-server/). This functionality is provided by the [WSO2 Identity Server webhooks](https://is.docs.wso2.com/en/next/guides/webhooks/webhook-events-and-payloads/).
The WSO2 Identity Server Trigger module allows you to listen to the following events when they occur in your WSO2 Identity Server organization:

- **User account management events**
   - User created event
   - User profile updated event
   - User disabled event
   - User enabled event
   - User account locked event
   - User account unlocked event
   - User deleted event

Learn more about [WSO2 Identity Server events](https://is.docs.wso2.com/en/next/guides/webhooks/understanding-webhooks/).

### Compatibility

|                               | Version                       |
|-------------------------------|-------------------------------|
| Ballerina Language            | Ballerina Swan Lake 2201.12.0 |
