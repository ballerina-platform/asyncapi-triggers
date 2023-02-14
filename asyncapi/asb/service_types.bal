# Triggers when Choreo recieves a new message from Azure service bus. Available action: onMessage
public type MessageService service object {
    # Triggers when a new message is received from Azure service bus
    # + message - The Azure service bus message recieved
    # + caller - The Azure service bus caller instance
    # + return - Error on failure else nil()
    isolated remote function onMessage(Message message, Caller caller) returns error?;
};

# Triggers when it receives a new message from Azure service bus and handles error. Available action: onMessage and onError
public type MessageServiceErrorHandling service object {
    # Triggers when a new message is received from Azure service bus
    # + message - The Azure service bus message recieved
    # + caller - The Azure service bus caller instance
    # + return - Error on failure else nil()
    isolated remote function onMessage(Message message, Caller caller) returns error?;
    isolated remote function onError(ErrorContext context, error er) returns error?;
};