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

 package io.ballerinax.asb.listener;

 import java.time.Duration;
 import java.util.ArrayList;
 import java.util.HashMap;
 import java.util.List;
 import java.util.Map;
 import java.util.Objects;
 import java.util.concurrent.ExecutorService;
 import java.util.concurrent.Executors;
 import java.util.concurrent.Future;
 
 import org.apache.log4j.Level;
 import org.apache.log4j.Logger;
 
 import com.azure.messaging.servicebus.ServiceBusClientBuilder;
 import com.azure.messaging.servicebus.ServiceBusClientBuilder.ServiceBusProcessorClientBuilder;
 import com.azure.messaging.servicebus.ServiceBusException;
 import com.azure.messaging.servicebus.models.ServiceBusReceiveMode;
 
 import io.ballerina.runtime.api.Environment;
 import io.ballerina.runtime.api.Runtime;
 import io.ballerina.runtime.api.values.BObject;
 import io.ballerinax.asb.MessageDispatcher;
 import io.ballerinax.asb.util.ASBConstants;
 import io.ballerinax.asb.util.ASBUtils;
 
 /**
  * Listens to incoming messages from Azure Service Bus.
  */
 public class MessageListener {
     private final Logger log = Logger.getLogger(MessageListener.class);
 
     private Runtime runtime;
     private ArrayList<BObject> services = new ArrayList<>();
     private Map<BObject, MessageDispatcher> dispatcherSet = new HashMap<BObject, MessageDispatcher>();
     private List<Future<?>> futures = new ArrayList<>();
     private BObject caller;
     private Level logLevel;
     private ServiceBusProcessorClientBuilder clientBuilder;
     private boolean started = false;
 
     /**
      * Initialize Azure Service Bus listener.
      *
      * @param connectionString Azure service bus connection string.
      * @param entityPath       Entity path (QueueName or SubscriptionPath).
      * @param receiveMode      Receive Mode as PeekLock or Receive&Delete.
      * @throws ServiceBusException  on failure initiating IMessage Receiver in Azure
      *                              Service Bus instance.
      * @throws InterruptedException on failure initiating IMessage Receiver due to
      *                              thread interruption.
      */
     public MessageListener(String connectionString, String queueName, String topicName, String subscriptionName,
             String receiveMode, String logLevel, int maxConcurrentCalls, int prefetchCount,
             int maxAutoLockRenewDuration)
             throws ServiceBusException, InterruptedException {
         this.logLevel = Level.toLevel(logLevel, Level.DEBUG);
         log.setLevel(this.logLevel);
         if (log.isDebugEnabled()) {
         log.debug(
                 "Initializing message listener with receiveMode " + receiveMode + ", maxConcurrentCalls- "
                         + maxConcurrentCalls + ", prefetchCount - " + prefetchCount
                         + ", maxAutoLockRenewDuration(seconds) - " + maxAutoLockRenewDuration);
         }
 
         this.clientBuilder = new ServiceBusClientBuilder()
                 .connectionString(connectionString)
                 .processor()
                 .maxConcurrentCalls(maxConcurrentCalls)
                 .disableAutoComplete()
                 .prefetchCount(prefetchCount);
         if (!queueName.isEmpty()) {
             if (Objects.equals(receiveMode, ASBConstants.RECEIVE_AND_DELETE)) {
                 this.clientBuilder = this.clientBuilder
                         .receiveMode(ServiceBusReceiveMode.RECEIVE_AND_DELETE)
                         .queueName(queueName);
 
             } else {
                 this.clientBuilder = this.clientBuilder
                         .receiveMode(ServiceBusReceiveMode.PEEK_LOCK)
                         .queueName(queueName)
                         .maxAutoLockRenewDuration(Duration.ofSeconds(maxAutoLockRenewDuration));
             }
         } else if (!subscriptionName.isEmpty() && !topicName.isEmpty()) {
             if (Objects.equals(receiveMode, ASBConstants.RECEIVE_AND_DELETE)) {
                 this.clientBuilder = this.clientBuilder
                         .receiveMode(ServiceBusReceiveMode.RECEIVE_AND_DELETE)
                         .topicName(topicName)
                         .subscriptionName(subscriptionName);
 
             } else {
                 this.clientBuilder = this.clientBuilder
                         .receiveMode(ServiceBusReceiveMode.PEEK_LOCK)
                         .topicName(topicName)
                         .subscriptionName(subscriptionName)
                         .maxAutoLockRenewDuration(Duration.ofSeconds(maxAutoLockRenewDuration));
             }
         }
     }
 
     public void externalInit(Environment environment, BObject listenerBObject, BObject caller) {
         this.caller = caller;
     }
 
     /**
      * Attaches the service to the Asb listener endpoint.
      *
      * @param environment     Ballerina runtime.
      * @param listenerBObject Ballerina listener object..
      * @param service         Ballerina service instance.
      * @return An error if failed to create IMessageReceiver connection instance.
      */
     public Object registerListener(Environment environment, BObject listenerBObject, BObject service) {
         runtime = environment.getRuntime();
         if (service == null) {
             throw new IllegalArgumentException("Service object is null");
         }
         if (!services.contains(service)) {
             services.add(service);
         }
         return null;
     }
 
     /**
      * Starts consuming the messages on all the attached services.
      *
      * @param environment     Ballerina runtime.
      * @param listenerBObject Ballerina listener object
      * @return An error if failed to start the listener.
      */
     public Object start(Environment environment, BObject listenerBObject) {
         runtime = environment.getRuntime();
         if (services.isEmpty()) {
             return ASBUtils.createErrorValue("Error in starting receiving messages");
         }
         ExecutorService executor = Executors.newFixedThreadPool(services.size());
         futures = new ArrayList<>();
         for (BObject service : services) {
             MessageDispatcher messageDispatcher = new MessageDispatcher(service, this.caller, runtime, clientBuilder, logLevel);
             Future<?> future = executor.submit(() -> {
                 try {
                     messageDispatcher.receiveMessages(listenerBObject);
                 } catch (Exception e) {
                     return ASBUtils.createErrorValue("Error in starting receiving messages", e);
                 }
                 return null;
             });
             futures.add(future);
             dispatcherSet.put(service, messageDispatcher);
         }
         started = true;
         return null;
 
     }
 
     /**
      * Stops consuming messages and detaches the service from the Asb Listener
      * endpoint.
      *
      * @param listenerBObject Ballerina listener object..
      * @param service         Ballerina service instance.
      * @return An error if failed detaching the service.
      */
     public Object detach(BObject listenerBObject, BObject service) {
         services.remove(service);
         return null;
     }
 
     /**
      * Stops consuming messages through all consumer services by terminating the
      * connection.
      *
      * @param listenerBObject Ballerina listener object.
      * @return An error if listener fails to stop.
      */
     public Object stop(BObject listenerBObject) {
         if (!started) {
             return ASBUtils.createErrorValue("Listener has not properly started.");
         } else {
             for (Map.Entry<BObject, MessageDispatcher> entry : dispatcherSet.entrySet()) {
                 entry.getValue().getProcessorClient().close();
             }
             try {
                 for (Future<?> future : futures) {
                     future.cancel(true);
                 }
                 Thread.currentThread().checkAccess();
                 Thread.currentThread().interrupt();
             } catch (Exception e) {
                 return ASBUtils.createErrorValue("Error occurred while stopping the service", e);
             }
         }
         return null;
     }
 
     /**
      * Stops consuming messages through all the consumer services and terminates the
      * connection with server.
      *
      * @param listenerBObject Ballerina listener object.
      * @return An error if listener fails to abort the connection.
      */
     public Object abortConnection(BObject listenerBObject) {
         if (clientBuilder == null || !started) {
             return ASBUtils.createErrorValue("clientBuilder is not properly initialized.");
         } else {
             try {
                 for (Map.Entry<BObject, MessageDispatcher> entry : dispatcherSet.entrySet()) {
                     entry.getValue().getProcessorClient().stop();
                 }
                 for (Future<?> future : futures) {
                     future.cancel(true);
                 }
                 if (log.isDebugEnabled()) {
                    log.debug("Consumer service aborted");
                 }
                 System.exit(0);
             } catch (ServiceBusException e) {
                 return ASBUtils.createErrorValue("Error occurred while stopping the service");
             }
         }
         return null;
     }
 }
 