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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.azure.core.amqp.models.AmqpAnnotatedMessage;
import com.azure.core.amqp.models.AmqpMessageBodyType;
import com.azure.messaging.servicebus.ServiceBusClientBuilder.ServiceBusProcessorClientBuilder;
import com.azure.messaging.servicebus.ServiceBusErrorContext;
import com.azure.messaging.servicebus.ServiceBusException;
import com.azure.messaging.servicebus.ServiceBusFailureReason;
import com.azure.messaging.servicebus.ServiceBusProcessorClient;
import com.azure.messaging.servicebus.ServiceBusReceivedMessage;
import com.azure.messaging.servicebus.ServiceBusReceivedMessageContext;

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.async.StrandMetadata;
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

/**
 * Handles and dispatched messages with data binding.
 */
public class MessageDispatcher {
    private static final Logger log = Logger.getLogger(MessageDispatcher.class);

    private BObject service;
    private BObject caller;
    private Runtime runtime;
    private ServiceBusProcessorClientBuilder builder;

    /**
     * Initialize the Message Dispatcher.
     *
     * @param service       Ballerina service instance.
     * @param runtime       Ballerina runtime instance.
     * @param clientBuilder Asb MessageReceiver instance.
     */
    public MessageDispatcher(BObject service, BObject caller, Runtime runtime,
            ServiceBusProcessorClientBuilder clientBuilder) {
        this.service = service;
        this.caller = caller;
        this.runtime = runtime;
        this.builder = clientBuilder;
        log.setLevel(Level.ERROR);
    }

    /**
     * Start receiving messages asynchronously and dispatch the messages to the
     * attached service.
     *
     * @param listener Ballerina listener object.
     * @return IllegalArgumentException if failed.
     */
    public void receiveMessages(BObject listener, MessageDispatcher md) {
        try {
            CountDownLatch countdownLatch = new CountDownLatch(1);
            ServiceBusProcessorClient processorClient = this.builder.processMessage(t -> {
                try {
                    md.processMessage(t);
                } catch (IOException e) {
                    log.error("IOException occurred when processing the message", e);
                    throw new RuntimeException(e);
                }
            }).processError(context -> {
                try {
                    processError(context, countdownLatch);
                } catch (IOException e) {
                    log.error("IOException while processing the error found when processing the message", e);
                }
            }).buildProcessorClient();
            processorClient.start();
            log.debug("(Message Dispatcher)Receiving started identifier: " + processorClient.getIdentifier());
            countdownLatch.await();
            if (processorClient.isRunning()) {
                processorClient.close();
                log.debug("(Message Dispatcher)Processor client closed identifier: " + processorClient.getIdentifier());
            }
            ;
        } catch (IllegalArgumentException e) {
            ASBUtils.returnErrorValue(e.getMessage());
        } catch (Exception e) {
            ASBUtils.returnErrorValue(e.getMessage());
        }
        ArrayList<BObject> startedServices = (ArrayList<BObject>) listener.getNativeData(ASBConstants.STARTED_SERVICES);
        startedServices.add(service);
    }

    /**
     * Handle the dispatch of message to the service.
     *
     * @param message Received azure service bus message instance.
     * @throws IOException
     */
    public void processMessage(ServiceBusReceivedMessageContext context) throws IOException {
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

    public void processError(ServiceBusErrorContext context, CountDownLatch countdownLatch) throws IOException {
        MethodType method = this.getFunction(1, ASBConstants.FUNC_ON_ERROR);
        if (method == null) {
            return;
        }
        ServiceBusException exception = (ServiceBusException) context.getException();
        ServiceBusFailureReason reason = exception.getReason();
        if (reason == ServiceBusFailureReason.MESSAGING_ENTITY_DISABLED
                || reason == ServiceBusFailureReason.MESSAGING_ENTITY_NOT_FOUND
                || reason == ServiceBusFailureReason.UNAUTHORIZED) {
            log.error("An unrecoverable error occurred. Stopping processing with reason: " + reason + " message: "
                    + exception.getMessage());
            countdownLatch.countDown();
        }

        Exception e = (Exception) context.getException();
        BError error = ASBUtils.createErrorValue(e.getClass().getTypeName(), e);
        BMap<BString, Object> messageBObject = null;
        messageBObject = getErrorMessage(context);
        Callback callback = new ASBResourceCallback();
        executeResourceOnError(callback, messageBObject, true, error, true);
    }

    /**
     * Dispatch message to the service.
     *
     * @param message Received azure service bus message instance.
     * @return BError if failed to dispatch.
     * @throws IOException
     */
    private void dispatchMessage(ServiceBusReceivedMessage message) throws IOException {
        Callback callback = new ASBResourceCallback();
        BMap<BString, Object> messageBObject = getReceivedMessage(message);
        executeResourceOnMessage(callback, messageBObject, true, this.caller, true);
    }

    public Object convertAMQPToJava(String messageId, Object amqpValue) {
        log.debug("Type of amqpValue object of received message " + messageId + " is " + amqpValue.getClass());
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
                log.debug("The type of amqpValue object- " + clazz.toString() + " is not supported");
                return null;
        }
    }

    /**
     * Prepares the message body content
     * 
     * @param receivedMessage ASB received message
     * @return
     * @throws IOException
     */
    private Object getMessageContent(ServiceBusReceivedMessage receivedMessage) throws IOException {
        AmqpAnnotatedMessage rawAmqpMessage = receivedMessage.getRawAmqpMessage();
        AmqpMessageBodyType bodyType = rawAmqpMessage.getBody().getBodyType();
        switch (bodyType) {
            case DATA:
                return rawAmqpMessage.getBody().getFirstData();
            case VALUE:
                Object amqpValue = rawAmqpMessage.getBody().getValue();
                log.debug("Received a message with messageId: " + receivedMessage.getMessageId()
                        + " AMQPMessageBodyType: {}" + bodyType);

                amqpValue = convertAMQPToJava(receivedMessage.getMessageId(), amqpValue);
                return amqpValue;
            default:
                throw new RuntimeException("Invalid message body type: " + receivedMessage.getMessageId());
        }
    }

    /**
     * @param endpointClient  Ballerina client object
     * @param receivedMessage Received Message
     * @return
     * @throws IOException
     */
    private BMap<BString, Object> getReceivedMessage(ServiceBusReceivedMessage receivedMessage)
            throws IOException {
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
     * @param endpointClient  Ballerina client object
     * @param receivedMessage Received Message
     * @return
     * @throws IOException
     */
    private BMap<BString, Object> getErrorMessage(ServiceBusErrorContext errContext)
            throws IOException {
        Map<String, Object> map = new HashMap<>();
        map.put("entityPath", StringUtils.fromString(errContext.getEntityPath()));
        map.put("className", StringUtils.fromString(errContext.getClass().getSimpleName()));
        map.put("namespace", StringUtils.fromString(errContext.getFullyQualifiedNamespace()));
        map.put("errorSource", StringUtils.fromString(errContext.getErrorSource().toString()));
        BMap<BString, Object> createRecordValue = ValueCreator.createRecordValue(ModuleUtils.getModule(),
                "ErrorContext", map);
        return createRecordValue;
    }

    private void executeResourceOnMessage(Callback callback, Object... args) {
        StrandMetadata metaData = new StrandMetadata(ModuleUtils.getModule().getOrg(),
                ModuleUtils.getModule().getName(), ModuleUtils.getModule().getMajorVersion(),
                ASBConstants.FUNC_ON_MESSAGE);
        executeResource(ASBConstants.FUNC_ON_MESSAGE, callback, metaData, args);
    }

    private void executeResourceOnError(Callback callback, Object... args) {
        StrandMetadata metaData = new StrandMetadata(ModuleUtils.getModule().getOrg(),
                ModuleUtils.getModule().getName(), ModuleUtils.getModule().getMajorVersion(),
                ASBConstants.FUNC_ON_ERROR);
        executeResource(ASBConstants.FUNC_ON_ERROR, callback, metaData, args);
    }

    private void executeResource(String function, Callback callback, StrandMetadata metaData,
            Object... args) {
        runtime.invokeMethodAsyncSequentially(service, function, null, metaData, callback, null,
                PredefinedTypes.TYPE_NULL, args);
    }
}
