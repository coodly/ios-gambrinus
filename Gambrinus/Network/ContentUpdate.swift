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
import SWLogger
import LaughingAdventure

class ContentUpdate: NSObject, InjectionHandler, PersistenceConsumer {
    var persisrtence: CorePersistence!
    
    private lazy var operationsQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Content pdate queue"
        return queue
    }()
    
    func updatePosts(completion: @escaping (() -> ())) {
        var operations = [Operation]()
        
        let postsRefresh = RefreshPostsOperation()
        inject(into: postsRefresh)
        operations.add(operation: postsRefresh)
        
        let pullMappings = PullPostMappingsOperation()
        inject(into: pullMappings)
        operations.add(operation: pullMappings)
        
        let pullScores = PullRateBeerChangesOperation()
        inject(into: pullScores)
        operations.add(operation: pullScores)
        
        let updateDirty = UpdateDirtyPostsOperation()
        inject(into: updateDirty)
        operations.add(operation: updateDirty)
        
        let notifyCompletion = BlockOperation(block: completion)
        operations.add(operation: notifyCompletion)
        
        let checkMissing = BlockOperation() {
            self.checkMissingData()
        }
        operations.add(operation: checkMissing)
        
        operationsQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func refresh(post: Post, completion: (() -> ())) {
        fatalError()
    }
    
    private func checkMissingData() {
        Log.debug("Check missing")
        persisrtence.perform() {
            context in

            var operation: ConcurrentOperation?
            if context.hasBeersWithMissingData() {
                Log.debug("Pull beers meta")
                operation = PullBeersInfoOperation()
            } else if context.hasBrewersWithMissingData() {
                Log.debug("Pull brewers meta")
                operation = PullBrewersInfoOperation()
            } else if context.hasStylesWithMissingData() {
                Log.debug("Pull styles meta")
                operation = PullStylesInfoOperation()
            }
            
            guard let executed = operation else {
                Log.debug("Nothing more to sync")
                return
            }
            
            var operations = [Operation]()
            
            self.inject(into: executed)
            operations.add(operation: executed)
            
            let updateDirty = UpdateDirtyPostsOperation()
            self.inject(into: updateDirty)
            operations.add(operation: updateDirty)
            
            let performNextCheck = BlockOperation() {
                self.checkMissingData()
            }
            operations.add(operation: performNextCheck)
            
            self.operationsQueue.addOperations(operations, waitUntilFinished: false)
        }
    }
}
