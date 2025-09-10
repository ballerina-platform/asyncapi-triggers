// Copyright (c) 2025 WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Triggers when a new event related to user operations is received.
# Available actions: onCreateUser, onUpdateUser, onDeleteUser, onEnableUser, onDisableUser, onUserAccountLock, onUserAccountUnlock
public type UserOperationService service object {
    remote function onCreateUser(GenericUserOperationEvent event) returns error?;
    remote function onUpdateUser(UserProfileUpdateOperationEvent event) returns error?;
    remote function onDeleteUser(GenericUserOperationEvent event) returns error?;
    remote function onEnableUser(GenericUserOperationEvent event) returns error?;
    remote function onDisableUser(GenericUserOperationEvent event) returns error?;
    remote function onUserAccountLock(GenericUserOperationEvent event) returns error?;
    remote function onUserAccountUnlock(GenericUserOperationEvent event) returns error?;
};

public type GenericServiceType UserOperationService;
