// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
# Twilio CallStatus service object
public type CallStatusService service object {
    # Triggers on a call is ready and waiting in line before going out.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onQueued(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call is currently ringing.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onRinging(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call is answered and is actively in progress.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onInProgress(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call is answered and has ended normally.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onCompleted(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the caller received a busy singnal.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onBusy(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call could not be completed as dialed.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onFailed(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call ended without being answered.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onNoAnswer(CallStatusEventWrapper event) returns error?;
    
    # Triggers when the call got candelled via the REST API while queued or ringing.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onCanceled(CallStatusEventWrapper event) returns error?;
};
# Twilio SmsStatus service object
public type SmsStatusService service object {
    # Triggers when Twilio has received the message request.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onAccepted(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when the API request to send a message was successful the message is queued to sent out.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onQueued(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when Twilio is in the process of dispatching the message.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onSending(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when the nearest upstream carrier accepted the message.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onSent(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when the message could not be sent.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onFailed(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when Twilio has received the confirmation of message delivery from the upstream carrier..
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onDelivered(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when Twilio received a delivery recipt indicating that mesage was not delivered.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onUndelivered(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when the inbound message has been received by Twilio and is currently being processed.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onReceiving(SmsStatusChangeEventWrapper event) returns error?;
    
    # Triggers when the inbound message was received by one of your Twilio numbers.
    # 
    #  + event  - The information about the triggered event
    #  + return - `()` on success else an `error`
    remote function onReceived(SmsStatusChangeEventWrapper event) returns error?;
};

public type GenericServiceType CallStatusService|SmsStatusService;
