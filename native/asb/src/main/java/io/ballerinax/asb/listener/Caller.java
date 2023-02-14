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

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.azure.messaging.servicebus.ServiceBusException;
import com.azure.messaging.servicebus.ServiceBusReceivedMessageContext;
import com.azure.messaging.servicebus.models.DeadLetterOptions;

import io.ballerina.runtime.api.values.BObject;
import io.ballerinax.asb.util.ASBUtils;

/**
 * Perform operations on dispatched messages.
 */
public class Caller {

    private static final Logger log = Logger.getLogger(MessageListener.class.getClass());

    /**
     * Complete Messages from Queue or Subscription based on messageLockToken
     *
     * @param caller    Ballerina Caller object.
     * @param lockToken Message lock token.
     * @return InterruptedException or ServiceBusException on failure to complete
     *         the message.
     */
    public static Object complete(BObject caller, Object lockToken) {
        try {
            ServiceBusReceivedMessageContext context = (ServiceBusReceivedMessageContext) caller
                    .getNativeData(lockToken.toString());
            context.complete();
            log.debug("Completing the message(Message Id: "+context.getMessage().getMessageId()+") using its lock token from "+ lockToken.toString());
            return null;
        } catch (ServiceBusException e) {
            return ASBUtils.returnErrorValue("Exception while completing message" + e.getMessage());
        }
    }

    /**
     * Abandon message & make available again for processing from Queue or
     * Subscription based on messageLockToken
     *
     * @param caller    Ballerina Caller object.
     * @param lockToken Message lock token.
     * @return InterruptedException or ServiceBusException on failure to abandon the
     *         message.
     */
    public static Object abandon(BObject caller, Object lockToken) {
        try {
            ServiceBusReceivedMessageContext context = (ServiceBusReceivedMessageContext) caller
                    .getNativeData(lockToken.toString());
            context.abandon();
            log.debug("Abandoned the message(Message Id: "+context.getMessage().getMessageId()+") using its lock token from "+ lockToken.toString());
            return null;
        } catch (ServiceBusException e) {
            return ASBUtils.returnErrorValue("Exception while abandon message" + e.getMessage());
        }
    }

    /**
     * Dead-Letter the message & moves the message to the Dead-Letter Queue based on
     * messageLockToken
     *
     * @param caller                     Ballerina Caller object.
     * @param lockToken                  Message lock token.
     * @param deadLetterReason           The dead letter reason.
     * @param deadLetterErrorDescription The dead letter error description.
     * @return InterruptedException or ServiceBusException on failure to dead letter
     *         the message.
     */
    public static Object deadLetter(BObject caller, Object lockToken, Object deadLetterReason,
            Object deadLetterErrorDescription) {
        try {
            ServiceBusReceivedMessageContext context = (ServiceBusReceivedMessageContext) caller
                    .getNativeData(lockToken.toString());
            DeadLetterOptions options = new DeadLetterOptions()
                    .setDeadLetterErrorDescription(deadLetterErrorDescription.toString());
            options.setDeadLetterReason(deadLetterReason.toString());
            context.deadLetter(options);
            log.debug("Done deadLetter the message(Message Id: "+context.getMessage().getMessageId()+") using its lock token from "+ lockToken.toString());
            return null;
        } catch (ServiceBusException e) {
            return ASBUtils.returnErrorValue("Exception while dead lettering message" + e.getMessage());
        }
    }

    /**
     * Defer the message in a Queue or Subscription based on messageLockToken
     *
     * @param caller    Ballerina Caller object.
     * @param lockToken Message lock token.
     * @return InterruptedException or ServiceBusException on failure to defer the
     *         message.
     */
    public static Object defer(BObject caller, Object lockToken) {
        try {
            ServiceBusReceivedMessageContext context = (ServiceBusReceivedMessageContext) caller
                    .getNativeData(lockToken.toString());
            context.defer();
            log.debug("Deferred the message(Message Id: "+context.getMessage().getMessageId()+") using its lock token from "+ lockToken.toString());
            return null;
        } catch (ServiceBusException e) {
            return ASBUtils.returnErrorValue("Exception while deferring message" + e.getMessage());
        }
    }
}
