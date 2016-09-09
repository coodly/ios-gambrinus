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

class PullRateBeerChangesOperation: CloudKitRequest<CloudRateBeer>, BeersContainerConsumer, ObjectModelConsumer {
    var beersContainer: CKContainer! {
        didSet {
            container = beersContainer
        }
    }
    var objectModel: Gambrinus.ObjectModel!
    
    override func performRequest() {
        Log.debug("Pull maapings")
        objectModel.perform() {
            let lastKnownDate = self.objectModel.managedObjectContext.lastKnownScoresTime()
            Log.debug("Pull mappings after: \(lastKnownDate)")
            let sort = NSSortDescriptor(key: "scoreUpdatedAt", ascending: true)
            let timePredicate = NSPredicate(format: "scoreUpdatedAt >= %@", lastKnownDate as NSDate)
            self.fetch(predicate: timePredicate, sort: [sort], inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<CloudRateBeer>, completion: @escaping () -> ()) {
        let saveClosure: CDYModelInjectionBlock = {
            model in
            
            switch result {
            case .failure:
                Log.debug("Failure")
            case .success(let rbs, _):
                Log.debug("Have \(rbs.count) mappings")
                
                var modifiedPosts = Set<Post>()
                for rb in rbs {
                    let posts = model!.managedObjectContext.update(rateBeer: rb)
                    modifiedPosts = modifiedPosts.union(posts)
                }
                
                Log.debug("\(modifiedPosts.count) posts touched")
                model!.managedObjectContext.updateTopScores(on: modifiedPosts)
                
                if let last = rbs.last {
                    model!.managedObjectContext.markLastKnownScores(last.scoreUpdatedAt!)
                }
            }
        }
        
        let saveCompletion: CDYModelActionBlock = {
            completion()
        }
        objectModel.save(in: saveClosure, completion: saveCompletion)
    }
}
