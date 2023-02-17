# Triggers when Choreo recieves a new message from Azure service bus. Available action: onMessage
public type MessageService service object {
    # Triggers when a new message is received from Azure service bus
    # + message - The Azure service bus message recieved
    # + caller - The Azure service bus caller instance
    # + return - Error on failure else nil()
    isolated remote function onMessage(Message message, Caller caller) returns error?;
    
    # Triggers when there is an error in message processing
    #
    # + context - Error message details  
    # + error - Ballerina error
    # + return - Error on failure else nil()
    isolated remote function onError(ErrorContext context, error 'error) returns error?;
};
