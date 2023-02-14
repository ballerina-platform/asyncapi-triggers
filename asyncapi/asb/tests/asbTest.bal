import ballerina/log;
//import ballerina/http;
import ballerina/test;

ListenerConfig config = {
    connectionString: "",
    entityConfig: {
        queueName: ""
    },
    receiveMode: PEEK_LOCK
};

//listener http:Listener httpListener = new(8090);
listener Listener webhookListener = new(config);


service MessageService on webhookListener {
    
    remote function onMessage(Message message, Caller caller) returns error? {
        log:printInfo(message.sequenceNumber.toString());
        check caller.complete(message);
    }
}

@test:Config {
    enable: true
}
function testOnMessage() returns error? {
    while true {
    }
}
