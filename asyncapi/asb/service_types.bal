# Actions related to Azure service bus messaging. Available method is onMessage
public type MessageService service object {
    # Triggers when a new message is received from Azure service bus
    # + message - The Azure service bus message recieved
    # + caller - The Azure service bus caller instance
    # + return - Error on failure else nil()
    remote function onMessage(Message message, Caller caller) returns error?;
};
