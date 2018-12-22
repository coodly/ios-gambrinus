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

class PullBeersInfoOperation: CloudKitRequest<CloudRateBeer>, BeersContainerConsumer, PersistenceConsumer {
    var persistence: Persistence!
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    private var checked: [String]?
    
    override func performRequest() {
        persistence.performInBackground() {
            context in
            
            let beers = context.itemsNeedingSync(for: Beer.self)
            guard beers.count > 0 else {
                Log.debug("No Beers needing details")
                self.finish()
                return
            }
            
            let ids = beers.compactMap({ $0.rbIdentifier })
            guard ids.count > 0 else {
                self.finish()
                return
            }
            
            self.checked = ids
            let predicate = NSPredicate(format: "rbId IN %@", ids)
            self.fetch(predicate: predicate, inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudRateBeer>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            var missing = Set(self.checked ?? [])
            context.updateBeers(with: result.records)
            
            let received = Set(result.records.compactMap({ $0.rbId }))
            missing.subtract(received)
            
            guard missing.count > 0 else {
                return
            }
            
            Log.debug("Did not get data on \(missing.count) beers: \(missing)")
            let predicate = NSPredicate(format: "rbIdentifier IN %@", missing)
            let marked: [Beer] = context.fetch(predicate: predicate)
            marked.forEach({ $0.syncStatus?.syncFailed = true })
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
}
