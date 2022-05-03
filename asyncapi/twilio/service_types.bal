public type CallStatusService service object {
    remote function onQueued(CallStatusEventWrapper event) returns error?;
    remote function onRinging(CallStatusEventWrapper event) returns error?;
    remote function onInProgress(CallStatusEventWrapper event) returns error?;
    remote function onCompleted(CallStatusEventWrapper event) returns error?;
    remote function onBusy(CallStatusEventWrapper event) returns error?;
    remote function onFailed(CallStatusEventWrapper event) returns error?;
    remote function onNoAnswer(CallStatusEventWrapper event) returns error?;
    remote function onCanceled(CallStatusEventWrapper event) returns error?;
};

public type SmsStatusService service object {
    remote function onAccepted(SmsStatusChangeEventWrapper event) returns error?;
    remote function onQueued(SmsStatusChangeEventWrapper event) returns error?;
    remote function onSending(SmsStatusChangeEventWrapper event) returns error?;
    remote function onSent(SmsStatusChangeEventWrapper event) returns error?;
    remote function onFailed(SmsStatusChangeEventWrapper event) returns error?;
    remote function onDelivered(SmsStatusChangeEventWrapper event) returns error?;
    remote function onUndelivered(SmsStatusChangeEventWrapper event) returns error?;
    remote function onReceiving(SmsStatusChangeEventWrapper event) returns error?;
    remote function onReceived(SmsStatusChangeEventWrapper event) returns error?;
};

public type GenericServiceType CallStatusService|SmsStatusService;
