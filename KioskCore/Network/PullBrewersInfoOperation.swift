/*
 * Copyright 2018 Coodly LLC
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

import Foundation
import Puff
import CloudKit
import CoreDataPersistence

internal struct CloudBrewer: RemoteRecord {
    var parent: CKRecord.ID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "RateBeerBrewer"
    }
    
    var name: String?
    var rbId: String?
    
    mutating func loadFields(from record: CKRecord) -> Bool {
        guard let name = record["name"] as? String else {
            return false
        }
        
        self.name = name
        rbId = record["rbId"] as? String
        
        return true
    }
}

internal class PullBrewersInfoOperation: CloudKitRequest<CloudBrewer>, BeersContainerConsumer, PersistenceConsumer {
    var persistence: Persistence!
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    private var checked: [String]?
    
    override func performRequest() {
        Log.debug("Pull Brewers info")
        persistence.performInBackground() {
            context in
            
            let brewers = context.itemsNeedingSync(for: Brewer.self)
            let ids = brewers.compactMap({ $0.identifier })
            guard ids.count > 0 else {
                Log.debug("No brewers needing details")
                self.finish()
                return
            }
            
            Log.debug("Pull data on \(ids.count) brewers")

            self.checked = ids
            let predicate = NSPredicate(format: "rbId IN %@", ids)
            self.fetch(predicate: predicate, inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudBrewer>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            context.update(brewers: result.records)
            
            var missing = Set(self.checked ?? [])
            let received = Set(result.records.compactMap({ $0.rbId }))
            missing.subtract(received)
            
            guard missing.count > 0 else {
                return
            }
            
            Log.debug("Mark failure on \(missing.count) brewers: \(missing)")
            let predicate = NSPredicate(format: "identifier = %@", missing)
            let marked: [Brewer] = context.fetch(predicate: predicate)
            marked.forEach({ $0.syncStatus?.syncFailed = true })
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
