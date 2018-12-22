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

internal struct CloudPost: RemoteRecord {
    var parent: CKRecord.ID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "Post"
    }
    
    var identifier: String?
    var rateBeers: [String]?
    var modificationDate: Date?
    
    mutating func loadFields(from record: CKRecord) -> Bool {
        identifier = record["identifier"] as? String
        rateBeers = record["rateBeers"] as? [String]
        modificationDate = record.modificationDate
        
        return true
    }
}


internal class PullPostMappingsOperation: CloudKitRequest<CloudPost>, GambrinusContainerConsumer, PersistenceConsumer {
    var gambrinusContainer: CKContainer! {
        didSet {
            container = gambrinusContainer
        }
    }
    var persistence: Persistence!
    
    override func performRequest() {
        Log.debug("Pull mapping updates")
        persistence.performInBackground() {
            context in
            
            let lastKnownTime = context.lastKnownMappingTime
            Log.debug("Pull mappings after \(lastKnownTime)")
            
            let sort = NSSortDescriptor(key: "modificationDate", ascending: true)
            let timePredicate = NSPredicate(format: "modificationDate >= %@", lastKnownTime as NSDate)
            self.fetch(predicate: timePredicate, sort: [sort], inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudPost>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in

            context.createMappings(from: result.records)
            
            guard let maxDate = result.records.compactMap({ $0.modificationDate }).max() else {
                return
            }
            
            Log.debug("Mark mappings max time to \(maxDate)")
            context.lastKnownMappingTime = maxDate
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
