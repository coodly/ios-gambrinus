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

import CloudKit
import CoreDataPersistence
import Foundation
import Puff
import PuffSerialization

internal struct CloudRateBeer: RemoteRecord {
    var parent: CKRecord.ID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "RateBeer"
    }
    
    var alcohol: String?
    var aliasFor: CKRecord.Reference?
    var brewer: CKRecord.Reference?
    var name: String?
    var rbId: String?
    var score: String?
    var style: CKRecord.Reference?
    var scoreUpdatedAt: Date?
    
    mutating func loadFields(from record: CKRecord) -> Bool {
        guard let name = record["name"] as? String else {
            return false
        }
        
        alcohol = record["alcohol"] as? String
        aliasFor = record["aliasFor"] as? CKRecord.Reference
        brewer = record["brewer"] as? CKRecord.Reference
        self.name = name
        rbId = record["rbId"] as? String
        score = record["score"] as? String
        style = record["style"] as? CKRecord.Reference
        scoreUpdatedAt = record["scoreUpdatedAt"] as? Date
        return true
    }
}

internal class PullRateBeerChangesOperation: CloudKitRequest<CloudRateBeer>, BeersContainerConsumer, PersistenceConsumer {
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    var persistence: Persistence!
    
    override func performRequest() {
        Log.debug("Pull RB changes")
        persistence.performInBackground() {
            context in
            
            let lastKnownDate = context.lastKnownScoresTime
            Log.debug("Pull scores after: \(lastKnownDate)")
            let sort = NSSortDescriptor(key: "scoreUpdatedAt", ascending: true)
            let timePredicate = NSPredicate(format: "scoreUpdatedAt >= %@", lastKnownDate as NSDate)
            self.fetch(predicate: timePredicate, sort: [sort], inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudRateBeer>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            context.updateBeers(with: result.records)
            
            guard let max = result.records.compactMap({ $0.scoreUpdatedAt }).max() else {
                return
            }
            
            Log.debug("MArk known score update time to \(max)")
            context.lastKnownScoresTime = max
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
