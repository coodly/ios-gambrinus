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

class PullPostMappingsOperation: CloudKitRequest<CloudPost>, GambrinusContainerConsumer, ObjectModelConsumer {
    var gambrinusContainer: CKContainer! {
        didSet {
            container = gambrinusContainer
        }
    }
    var objectModel: Gambrinus.ObjectModel!
    
    override func performRequest() {
        Log.debug("Pull maapings")
        objectModel.perform() {
            let lastKnownDate = self.objectModel.managedObjectContext.lastKnownMappingTime()
            Log.debug("Pull mappings after: \(lastKnownDate)")
            let sort = NSSortDescriptor(key: "modificationDate", ascending: true)
            let timePredicate = NSPredicate(format: "modificationDate >= %@", lastKnownDate as NSDate)
            self.fetch(predicate: timePredicate, sort: [sort], inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudPost>, completion: @escaping () -> ()) {
        let saveClosure: CDYModelInjectionBlock = {
            model in
            
            switch result {
            case .failure:
                Log.debug("Failure")
            case .success(let posts, _):
                Log.debug("Have \(posts.count) mappings")
                
                if let last = posts.last {
                    model!.managedObjectContext.markLastKnownMapping(last.modificationDate!)
                }
            }
        }
        
        let saveCompletion: CDYModelActionBlock = {
            completion()
        }
        objectModel.save(in: saveClosure, completion: saveCompletion)
    }
}
