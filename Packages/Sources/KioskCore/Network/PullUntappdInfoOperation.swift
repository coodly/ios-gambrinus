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
import CoreDataPersistence
import Foundation
import Puff
import PuffSerialization

internal struct CloudUntappd: RemoteRecord {
    var parent: CKRecord.ID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "Untappd"
    }
    
    var bid: NSNumber?
    var brewery: String?
    var name: String?
    var score: String?
    var scoreCheckedAt: Date?
    var scoreUpdatedAt: Date?
    var style: String?
    
    
    mutating func loadFields(from record: CKRecord) -> Bool {
        guard let name = record["name"] as? String else {
            return false
        }
        
        bid = record["bid"] as? NSNumber
        brewery = record["brewery"] as? String
        self.name = name
        score = record["score"] as? String
        scoreCheckedAt = record["scoreCheckedAt"] as? Date
        scoreUpdatedAt = record["scoreUpdatedAt"] as? Date
        style = record["style"] as? String
        
        return true
    }
}

internal class PullUntappdInfoOperation: CloudKitRequest<CloudUntappd>, BeersContainerConsumer, PersistenceConsumer {
    var persistence: Persistence!
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    private var checked: [NSNumber]?
    
    override func performRequest() {
        Log.debug("Pull Untappd info")
        persistence.performInBackground() {
            context in
            
            let beers = context.itemsNeedingSync(for: Untappd.self)
            guard beers.count > 0 else {
                Log.debug("No Untappd needing details")
                self.finish()
                return
            }
            
            let ids = beers.compactMap({ $0.bid })
            guard ids.count > 0 else {
                self.finish()
                return
            }
            
            self.checked = ids
            let predicate = NSPredicate(format: "bid IN %@", ids)
            self.fetch(predicate: predicate, inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudUntappd>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            var missing = Set(self.checked ?? [])
            context.updateUntappd(with: result.records)
            
            let received = Set(result.records.compactMap({ $0.bid }))
            missing.subtract(received)
            
            guard missing.count > 0 else {
                return
            }
            
            Log.debug("Did not get data on \(missing.count) untappd: \(missing)")
            let predicate = NSPredicate(format: "bid IN %@", missing)
            let marked: [Untappd] = context.fetch(predicate: predicate)
            marked.forEach({ $0.syncStatus?.syncFailed = true })
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
