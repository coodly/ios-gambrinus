/*
 * Copyright 2016 Coodly LLC
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
import LaughingAdventure
import SWLogger
import CloudKit

class PullBrewersInfoOperation: CloudKitRequest<CloudBrewer>, BeersContainerConsumer, PersistenceConsumer {
    var persisrtence: CorePersistence!
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    private var checked: [String]?
    
    override func performRequest() {
        persisrtence.perform() {
            context in
            
            let rbids = context.rateBeerIDsForBrewersNeedingSync()
            Log.debug("Pull data on \(rbids.count) brewers")
            self.checked = rbids
            
            let predicate = NSPredicate(format: "rbId IN %@", rbids)
            self.fetch(predicate: predicate, inDatabase: .public)
            
        }
    }
    
    override func handle(result: CloudResult<CloudBrewer>, completion: @escaping () -> ()) {
        let saveClosure: TaskClosure = {
            context in
            
            switch result {
            case .failure:
                context.markSyncFailureOn(rbids: self.checked!)
            case .success(let beers, _):
                var missing = self.checked!
                for b in beers {
                    if b.name == nil {
                        continue
                    }
                    
                    if let index = missing.index(of: b.rbId!) {
                        missing.remove(at: index)
                    }
                    
                    context.update(brewer: b)
                }
                
                context.markSyncFailureOn(rbids: missing)
            }
        }
        
        persisrtence.save(inClosure: saveClosure, completion: completion)
    }
}
