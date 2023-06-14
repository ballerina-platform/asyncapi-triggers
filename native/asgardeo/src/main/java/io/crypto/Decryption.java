/*
 * Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
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

package io.crypto;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import static io.crypto.Utils.getPrivateKey;
import static io.crypto.Utils.valueToEmptyOrToString;

/**
 * Class supports Asymmetric decryption and Symmetric decryption using RSA & AES respectively.
 */
public class Decryption {

    /**
     * Asymmetric decryption using RSA decryption key to obtain symmetric key
     *
     * @param encString Encrypted string
     * @param decKey Decryption key
     * @return Decrypted Object
     */
    public static Object decryptSymmetricKey(Object encString, Object decKey) {
        Cipher cipher = null;
        try {
            String decryptionKey = valueToEmptyOrToString(decKey);
            String encryptedString = valueToEmptyOrToString(encString);

            cipher = Cipher.getInstance("RSA");
            cipher.init(Cipher.DECRYPT_MODE, getPrivateKey(decryptionKey));
            byte[] decryptedMessageBytes = cipher.doFinal(Base64.getDecoder()
                    .decode(encryptedString.getBytes()));
            return StringUtils.fromString(Base64.getEncoder().encodeToString(decryptedMessageBytes));
        } catch (Exception e) {
            return ErrorCreator.createError(StringUtils.fromString(e.toString()));
        }
    }

    /**
     * Symmetric decryption using AES decryption key to obtain the payload
     *
     * @param encString Encrypted string
     * @param decKey Symmetric key
     * @param iv IV parameter
     * @return Decrypted Object
     */
    public static Object decryptPayload(Object encString, Object decKey, Object iv) {
        try {
            String symmetricKey = valueToEmptyOrToString(decKey);
            String encryptedString = valueToEmptyOrToString(encString);
            String ivParameter = valueToEmptyOrToString(iv);

            byte[] symKeyBytes = Base64.getDecoder().decode(symmetricKey);
            byte[] ivBytes = Base64.getDecoder().decode(ivParameter);
            byte[] dataInBytes = Base64.getDecoder().decode(encryptedString);

            SecretKey originalSymKey = new SecretKeySpec(symKeyBytes, 0, symKeyBytes.length, "AES");

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec spec = new GCMParameterSpec(128, ivBytes);

            cipher.init(Cipher.DECRYPT_MODE, originalSymKey, spec);

            byte[] plainText = cipher.doFinal(dataInBytes);
            return StringUtils.fromString(new String(plainText));

        } catch (Exception e) {
            return ErrorCreator.createError(StringUtils.fromString(e.toString()));
        }
    }
}
