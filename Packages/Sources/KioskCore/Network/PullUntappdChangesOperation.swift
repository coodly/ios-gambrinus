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

import Foundation
import Puff
import CloudKit
import CoreDataPersistence

internal class PullUntappdChangesOperation: CloudKitRequest<CloudUntappd>, BeersContainerConsumer, PersistenceConsumer {
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    var persistence: Persistence!
    
    override func performRequest() {
        Log.debug("Pull Untappd changes")
        persistence.performInBackground() {
            context in
            
            let lastKnownDate = context.lastKnownUntsappdScoresTime
            Log.debug("Pull untappd after: \(lastKnownDate)")
            let sort = NSSortDescriptor(key: "scoreUpdatedAt", ascending: true)
            let timePredicate = NSPredicate(format: "scoreUpdatedAt >= %@", lastKnownDate as NSDate)
            self.fetch(predicate: timePredicate, sort: [sort], inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudUntappd>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            context.updateUntappd(with: result.records)
            
            guard let max = result.records.compactMap({ $0.scoreUpdatedAt }).max() else {
                return
            }
            
            Log.debug("MArk known score update time to \(max)")
            context.lastKnownUntsappdScoresTime = max
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
