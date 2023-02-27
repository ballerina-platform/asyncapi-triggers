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

package io.ballerinax.asb.util;

import java.util.Map;
import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ErrorType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

public class ASBUtils {

    /**
     * Convert Map to BMap.
     *
     * @param map Input Map used to convert to BMap.
     * @return Converted BMap object.
     */
    public static BMap<BString, Object> toBMap(Map<String, Object> map) {
        BMap<BString, Object> returnMap = ValueCreator.createMapValue();
        if (map != null) {
            for (Object aKey : map.keySet().toArray()) {
                returnMap.put(StringUtils.fromString(aKey.toString()),
                        StringUtils.fromString(map.get(aKey).toString()));
            }
        }
        return returnMap;
    }

    /**
     * Get the value as string or as empty based on the object value.
     *
     * @param value Input value.
     * @return value as a string or empty.
     */
    public static String valueToEmptyOrToString(Object value) {
        return (value == null || value.toString() == "") ? null : value.toString();
    }

    /**
     * Returns a Ballerina Error with the given String message.
     *
     * @param errorMessage The error message
     * @return Resulting Ballerina Error
     */
    public static BError createErrorValue(String errorMessage) {
        return ErrorCreator.createError(StringUtils.fromString(errorMessage));
    }

    /**
     * Returns a Ballerina Error with the given String message and exception.
     *
     * @param errorMessage The error message
     * @return Resulting Ballerina Error
     */
    public static BError createErrorValue(String message, Exception error) {
        ErrorType errorType = TypeCreator.createErrorType(error.getClass().getTypeName(), ModuleUtils.getModule());
        String errorFromClass = error.getStackTrace()[0].getClassName();
        String errorMessage = "An error occurred while processing your request. ";
        errorMessage += "Cause: " + error.getCause() + " ";
        errorMessage += "Class: " + error.getClass() + " ";
        BError er = ErrorCreator.createError(StringUtils.fromString(errorMessage));

        BMap<BString, Object> map = ValueCreator.createMapValue();
        map.put(StringUtils.fromString("Type"), StringUtils.fromString(error.getClass().getSimpleName()));
        map.put(StringUtils.fromString("errorCause"), StringUtils.fromString(error.getCause().getClass().getName()));
        map.put(StringUtils.fromString("message"), StringUtils.fromString(error.getMessage()));
        map.put(StringUtils.fromString("stackTrace"), StringUtils.fromString(error.getStackTrace().toString()));
        return ErrorCreator.createError(errorType, StringUtils.fromString(message + " error from " + errorFromClass), er,
        map);
    }
}
