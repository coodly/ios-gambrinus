/*
 * Copyright 2019 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import CloudKit

private let SubscriptionID: CKSubscription.ID = "com.coodly.kiosk.changes.subscription"

@available(iOS 10.0, *)
public class CloudSubscription {
    private lazy var database = CKContainer(identifier: "iCloud.com.coodly.gambrinus").publicCloudDatabase
    
    public init() {}
    
    public func subscribe() {
        Log.debug("Fetch all subscriptions")
        database.fetchAllSubscriptions() {
            subscriptions, error in
            
            if let error = error {
                Log.error("Fetch subscriptions error: \(error)")
                return
            }
            
            self.have(subscriptions: subscriptions ?? [])
        }
    }
    
    private func have(subscriptions: [CKSubscription]) {
        Log.debug("Have \(subscriptions.count) existing subscriptions")
        Log.debug(subscriptions.map({ $0.subscriptionID }))
        
        if subscriptions.first(where: { $0.subscriptionID == SubscriptionID }) != nil {
            Log.debug("Have active subscription")
            return
        }
        
        let subscription = CKQuerySubscription(recordType: "Modification", predicate: .truePredicate, subscriptionID: SubscriptionID, options: [.firesOnRecordCreation, .firesOnRecordUpdate])
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true
        subscription.notificationInfo = info
        database.save(subscription) {
            _ , error in
            
            if let error = error {
                Log.error("Save subscription error: \(error)")
            } else {
                Log.debug("Subscribed")
            }
        }
    }
}
