/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerinax.asb;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.ballerina.runtime.api.concurrent.StrandMetadata;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.azure.core.amqp.models.AmqpAnnotatedMessage;
import com.azure.core.amqp.models.AmqpMessageBodyType;
import com.azure.messaging.servicebus.ServiceBusClientBuilder.ServiceBusProcessorClientBuilder;
import com.azure.messaging.servicebus.models.ServiceBusReceiveMode;
import com.azure.messaging.servicebus.ServiceBusClientBuilder;
import com.azure.messaging.servicebus.ServiceBusErrorContext;
import com.azure.messaging.servicebus.ServiceBusException;
import com.azure.messaging.servicebus.ServiceBusFailureReason;
import com.azure.messaging.servicebus.ServiceBusProcessorClient;
import com.azure.messaging.servicebus.ServiceBusReceivedMessage;
import com.azure.messaging.servicebus.ServiceBusReceivedMessageContext;

import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerinax.asb.util.ASBConstants;
import io.ballerinax.asb.util.ASBUtils;
import io.ballerinax.asb.util.ModuleUtils;

import static io.ballerinax.asb.util.ModuleUtils.getProperties;

/**
 * Creates underlying listener and dispatches messages with data binding.
 */
public class MessageDispatcher {
    private static final Logger log = Logger.getLogger(MessageDispatcher.class);

    private Runtime runtime;
    private BObject service;
    private BObject caller;
    private ServiceBusProcessorClient messageProcessor;
    private boolean isStarted = false;

    /**
     * Initializes the Message Dispatcher.
     *
     * @param service             Ballerina service instance
     * @param runtime             Ballerina runtime instance
     * @param sharedClientBuilder ASB message builder instance common to the
     *                            listener
     * @throws IllegalStateException    If input values are wrong
     * @throws IllegalArgumentException If queueName/topicname not set
     * @throws NullPointerException     If callbacks are not set
     */
    public MessageDispatcher(Runtime runtime, BObject service,
            BObject caller, ServiceBusClientBuilder sharedClientBuilder) {

        this.runtime = runtime;
        this.service = service;
        this.caller = caller;

        setLogLevel(service);

        this.messageProcessor = createMessageProcessor(sharedClientBuilder);
    }

    private void setLogLevel(BObject service) {
        String logLevel = ASBUtils.getServiceConfigStringValue(service, ASBConstants.LOG_LEVEL_CONGIG_KEY);
        log.setLevel(Level.toLevel(logLevel, Level.ERROR)); // if not set, default level is set
    }

    private ServiceBusProcessorClient createMessageProcessor(ServiceBusClientBuilder sharedClientBuilder) {
        String queueName = ASBUtils.getServiceConfigStringValue(service, ASBConstants.QUEUE_NAME_CONFIG_KEY); 
        String topicName = ASBUtils.getServiceConfigStringValue(service, ASBConstants.TOPIC_NAME_CONFIG_KEY);
        String subscriptionName = ASBUtils.getServiceConfigStringValue(service,
                ASBConstants.SUBSCRIPTION_NAME_CONFIG_KEY);
        boolean isPeekLockModeEnabled = ASBUtils.isPeekLockModeEnabled(service);
        int maxConcurrentCalls = ASBUtils.getServiceConfigSNumericValue(service,
                ASBConstants.MAX_CONCURRENCY_CONFIG_KEY, ASBConstants.MAX_CONCURRENCY_DEFAULT);
        int prefetchCount = ASBUtils.getServiceConfigSNumericValue(service, ASBConstants.MSG_PREFETCH_COUNT_CONFIG_KEY,
                ASBConstants.MSG_PREFETCH_COUNT_DEFAULT);
        int maxAutoLockRenewDuration = ASBUtils.getServiceConfigSNumericValue(service,
                ASBConstants.LOCK_RENEW_DURATION_CONFIG_KEY, ASBConstants.LOCK_RENEW_DURATION_DEFAULT);

        if (log.isDebugEnabled()) {
            log.debug(
                    "Initializing message listener with PeekLockModeEnabled = " + isPeekLockModeEnabled
                            + ", maxConcurrentCalls- "
                            + maxConcurrentCalls + ", prefetchCount - " + prefetchCount
                            + ", maxAutoLockRenewDuration(seconds) - " + maxAutoLockRenewDuration);
        }
        // create processor client using sharedClientBuilder attahed to the listener
        ServiceBusProcessorClientBuilder clientBuilder = sharedClientBuilder.processor()
                .maxConcurrentCalls(maxConcurrentCalls)
                .disableAutoComplete()
                .prefetchCount(prefetchCount);
        if (!queueName.isEmpty()) {
            if (isPeekLockModeEnabled) {
                clientBuilder
                        .receiveMode(ServiceBusReceiveMode.PEEK_LOCK)
                        .queueName(queueName)
                        .maxAutoLockRenewDuration(Duration.ofSeconds(maxAutoLockRenewDuration));
            } else {
                clientBuilder
                        .receiveMode(ServiceBusReceiveMode.RECEIVE_AND_DELETE)
                        .queueName(queueName);
            }
        } else if (!subscriptionName.isEmpty() && !topicName.isEmpty()) {
            if (isPeekLockModeEnabled) {
                clientBuilder
                        .receiveMode(ServiceBusReceiveMode.PEEK_LOCK)
                        .topicName(topicName)
                        .subscriptionName(subscriptionName)
                        .maxAutoLockRenewDuration(Duration.ofSeconds(maxAutoLockRenewDuration));
            } else {
                clientBuilder
                        .receiveMode(ServiceBusReceiveMode.RECEIVE_AND_DELETE)
                        .topicName(topicName)
                        .subscriptionName(subscriptionName);
            }
        }
        ServiceBusProcessorClient processorClient = clientBuilder.processMessage(t -> {
            try {
                this.processMessage(t);
            } catch (Exception e) {
                log.error("Exception occurred when processing the message", e);
            }
        }).processError(context -> {
            try {
                processError(context);
            } catch (Exception e) {
                log.error("Exception while processing the error found when processing the message", e);
            }
        }).buildProcessorClient();

        return processorClient;

    }

    /**
     * Starts receiving messages asynchronously and dispatch the messages to the
     * attached service.
     */
    public void startListeningAndDispatching() {

        this.messageProcessor.start();
        isStarted = true;

        if (log.isDebugEnabled()) {
            log.debug("[Message Dispatcher]Receiving started, identifier: " + messageProcessor.getIdentifier());
        }
    }

    /**
     * Stops receiving messages and close the undlying ASB listener.
     */
    public void stopListeningAndDispatching() {
        this.messageProcessor.stop();

        if (log.isDebugEnabled()) {
            log.debug("[Message Dispatcher]Receiving stopped, identifier: " + messageProcessor.getIdentifier());
        }
    }

    /**
     * Gets undeling ASB message listener instance
     * 
     * @return ServiceBusProcessorClient instance
     */
    public ServiceBusProcessorClient getProcessorClient() {
        return this.messageProcessor;
    }

    /**
     * Checks if dispatcher is running.
     * 
     * @return true if dispatcher is listenering for messages
     */
    public boolean isRunning() {
        return isStarted;
    }

    /**
     * Handles the dispatching of message to the service.
     *
     * @param context ServiceBusReceivedMessageContext containing the ASB message
     */
    private void processMessage(ServiceBusReceivedMessageContext context) throws InterruptedException {
        MethodType method = this.getFunction(0, ASBConstants.FUNC_ON_MESSAGE);
        if (method == null) {
            return;
        }
        this.caller.addNativeData(context.getMessage().getLockToken(), context);
        dispatchMessage(context.getMessage());
    }

    private MethodType getFunction(int index, String functionName) {
        MethodType[] attachedFunctions = service.getType().getMethods();
        MethodType onMessageFunction = null;
        if (functionName.equals(attachedFunctions[index].getName())) {
            onMessageFunction = attachedFunctions[0];
        }
        return onMessageFunction;
    }

    /**
     * Handles and dispatches errors occured when receiving messages to the attahed
     * service.
     * 
     * @param context ServiceBusErrorContext related to the ASB error
     * @throws IOException
     */
    private void processError(ServiceBusErrorContext context) throws InterruptedException {
        MethodType method = this.getFunction(1, ASBConstants.FUNC_ON_ERROR);
        if (method == null) {
            return;
        }
        ServiceBusException exception = (ServiceBusException) context.getException();
        ServiceBusFailureReason reason = exception.getReason();
        if (reason == ServiceBusFailureReason.MESSAGING_ENTITY_DISABLED
                || reason == ServiceBusFailureReason.MESSAGING_ENTITY_NOT_FOUND
                || reason == ServiceBusFailureReason.UNAUTHORIZED) {
            log.error("An error occurred when processing with reason: " + reason + " message: "
                    + exception.getMessage());
        }

        Exception e = (Exception) context.getException();
        BError error = ASBUtils.createErrorValue(e.getClass().getTypeName(), e);
        BMap<BString, Object> errorDetailBMap = getErrorMessage(context);
        executeResourceOnError(errorDetailBMap, error);
    }

    /**
     * Dispatches message to the service.
     *
     * @param message Received azure service bus message instance.
     * @return BError if failed to dispatch.
     * @throws IOException
     */
    private void dispatchMessage(ServiceBusReceivedMessage message) throws InterruptedException {
        BMap<BString, Object> messageBObject = null;
        messageBObject = getReceivedMessage(message);
        executeResourceOnMessage(messageBObject, this.caller);
    }

    private Object convertAMQPToJava(String messageId, Object amqpValue) {
        if (log.isDebugEnabled()) {
            log.debug("Type of amqpValue object of received message " + messageId + " is " + amqpValue.getClass());
        }
        Class<?> clazz = amqpValue.getClass();
        switch (clazz.getSimpleName()) {
            case "Integer":
                return (Integer) amqpValue;
            case "Long":
                return (Long) amqpValue;
            case "Float":
                return (Float) amqpValue;
            case "Double":
                return (Double) amqpValue;
            case "String":
                return (String) amqpValue;
            case "Boolean":
                return (Boolean) amqpValue;
            case "Byte":
                return (Byte) amqpValue;
            case "Short":
                return (Short) amqpValue;
            case "Character":
                return (Character) amqpValue;
            case "BigDecimal":
                return (BigDecimal) amqpValue;
            case "Date":
                return (java.util.Date) amqpValue;
            case "UUID":
                return (UUID) amqpValue;
            default:
                if (log.isDebugEnabled()) {
                    log.debug("The type of amqpValue object- " + clazz.toString() + " is not supported");
                }
                return null;
        }
    }

    /**
     * Prepares the message body content
     * 
     * @param receivedMessage ASB received message
     * @return Object containing message data
     */
    private Object getMessageContent(ServiceBusReceivedMessage receivedMessage) {
        AmqpAnnotatedMessage rawAmqpMessage = receivedMessage.getRawAmqpMessage();
        AmqpMessageBodyType bodyType = rawAmqpMessage.getBody().getBodyType();
        switch (bodyType) {
            case DATA:
                return rawAmqpMessage.getBody().getFirstData();
            case VALUE:
                Object amqpValue = rawAmqpMessage.getBody().getValue();
                if (log.isDebugEnabled()) {
                    log.debug("Received a message with messageId: "
                            + receivedMessage.getMessageId()
                            + " AMQPMessageBodyType: {}"
                            + bodyType);
                }
                amqpValue = convertAMQPToJava(receivedMessage.getMessageId(), amqpValue);
                return amqpValue;
            default:
                throw new RuntimeException("Invalid message body type: " + receivedMessage.getMessageId());
        }
    }

    /**
     * Constructs Ballerina representaion of ASB message.
     * 
     * @param receivedMessage Received ASB message
     * @return BMap<BString, Object> representing Ballerina record
     */
    private BMap<BString, Object> getReceivedMessage(ServiceBusReceivedMessage receivedMessage) {
        Map<String, Object> map = new HashMap<>();
        Object body = getMessageContent(receivedMessage);
        if (body instanceof byte[]) {
            byte[] bodyA = (byte[]) body;
            map.put("body", ValueCreator.createArrayValue(bodyA));
        } else {
            map.put("body", body);
        }
        if (receivedMessage.getContentType() != null) {
            map.put("contentType", StringUtils.fromString(receivedMessage.getContentType()));
        }
        map.put("messageId", StringUtils.fromString(receivedMessage.getMessageId()));
        map.put("to", StringUtils.fromString(receivedMessage.getTo()));
        map.put("replyTo", StringUtils.fromString(receivedMessage.getReplyTo()));
        map.put("replyToSessionId", StringUtils.fromString(receivedMessage.getReplyToSessionId()));
        map.put("label", StringUtils.fromString(receivedMessage.getSubject()));
        map.put("sessionId", StringUtils.fromString(receivedMessage.getSessionId()));
        map.put("correlationId", StringUtils.fromString(receivedMessage.getCorrelationId()));
        map.put("partitionKey", StringUtils.fromString(receivedMessage.getPartitionKey()));
        map.put("timeToLive", (int) receivedMessage.getTimeToLive().getSeconds());
        map.put("sequenceNumber", (int) receivedMessage.getSequenceNumber());
        map.put("lockToken", StringUtils.fromString(receivedMessage.getLockToken()));
        map.put("deliveryCount", (int) receivedMessage.getDeliveryCount());
        map.put("enqueuedTime", StringUtils.fromString(receivedMessage.getEnqueuedTime().toString()));
        map.put("enqueuedSequenceNumber", (int) receivedMessage.getEnqueuedSequenceNumber());
        map.put("deadLetterErrorDescription", StringUtils.fromString(receivedMessage.getDeadLetterErrorDescription()));
        map.put("deadLetterReason", StringUtils.fromString(receivedMessage.getDeadLetterReason()));
        map.put("deadLetterSource", StringUtils.fromString(receivedMessage.getDeadLetterSource()));
        map.put("state", StringUtils.fromString(receivedMessage.getState().toString()));
        BMap<BString, Object> applicationProperties = ValueCreator.createRecordValue(ModuleUtils.getModule(),
                ASBConstants.APPLICATION_PROPERTIES);
        Object appProperties = ASBUtils.toBMap(receivedMessage.getApplicationProperties());
        map.put("applicationProperties", ValueCreator.createRecordValue(applicationProperties, appProperties));
        BMap<BString, Object> createRecordValue = ValueCreator.createRecordValue(ModuleUtils.getModule(),
                ASBConstants.MESSAGE_RECORD, map);
        return createRecordValue;
    }

    /**
     * Constructs Ballerina representation of ASB error.
     * 
     * @param context ServiceBusErrorContext containing error detail
     * @return BMap<BString, Object> representing Ballerina record
     */
    private BMap<BString, Object> getErrorMessage(ServiceBusErrorContext context) {
        Map<String, Object> map = new HashMap<>();
        map.put("entityPath", StringUtils.fromString(context.getEntityPath()));
        map.put("className", StringUtils.fromString(context.getClass().getSimpleName()));
        map.put("namespace", StringUtils.fromString(context.getFullyQualifiedNamespace()));
        map.put("errorSource", StringUtils.fromString(context.getErrorSource().toString()));
        ServiceBusException exception = (ServiceBusException) context.getException();
        ServiceBusFailureReason reason = exception.getReason();
        map.put("reason", StringUtils.fromString(reason.toString()));
        BMap<BString, Object> createRecordValue = ValueCreator.createRecordValue(ModuleUtils.getModule(),
                "ErrorContext", map);
        return createRecordValue;
    }

    private void executeResourceOnMessage(Object... args) {
        Map<String, Object> metaData = getProperties(ASBConstants.FUNC_ON_MESSAGE);
        executeResource(ASBConstants.FUNC_ON_MESSAGE, metaData, args);
    }

    private void executeResourceOnError(Object... args) {
        Map<String, Object> metaData = getProperties(ASBConstants.FUNC_ON_ERROR);
        executeResource(ASBConstants.FUNC_ON_ERROR, metaData, args);
    }

    private void executeResource(String function, Map<String, Object> metaData,
                                 Object... args) {
        Thread.startVirtualThread(() -> {
            try {
                Object result = runtime.callMethod(service, function, new StrandMetadata(false, metaData), args);
                if (result instanceof BError) {
                    ((BError) result).printStackTrace();
                }
            } catch (BError ignored) {}

        });
    }
}
