// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

# Listener related configurations.
#
# + realmIds - An array of company Ids to get the events
public type ListenerConfigs record {
    string[] realmIds;
};

# Record for QuickBook dataChange.
#
public type QuickBookEvent record {
    # The latest timestamp in UTC.
    string lastUpdated?;
    # The name of the entity that changed (customer, Invoice, etc.).
    string name;
    # The type of the change.
    string operation;
    # The ID of the deleted or merged entity (this only applies to merge events)
    string deletedID?;
    # The ID of the changed entity.
    string id?;
};

# Record for event notification for a company.
#
# + realmId - Company Id  
# + dataChangeEvent - The event changes information
public type EventNotification record {
    string realmId;
    DataChangeEvent dataChangeEvent;
};

# Record for set of changes
#
# + entities - Field Description
public type DataChangeEvent record {
    QuickBookEvent[] entities;
};

# Record for set of event notification for all companies.
#
# + eventNotifications - Field Description
public type EventNotifications record {|
    EventNotification[] eventNotifications;
|};

public type CommonResponseType EventNotifications;

public type GenericDataType QuickBookEvent;
