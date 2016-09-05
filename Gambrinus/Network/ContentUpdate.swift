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

class ContentUpdate: NSObject, InjectionHandler, ObjectModelConsumer {
    var objectModel: ObjectModel!
    
    private lazy var operationsQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Content pdate queue"
        return queue
    }()
    
    func updatePosts(completion: (() -> ())) {
        var operations = [Operation]()
        
        let postsRefresh = RefreshPostsOperation()
        inject(into: postsRefresh)
        operations.add(operation: postsRefresh)
        
        let notifyCompletion = BlockOperation(block: completion)
        operations.add(operation: notifyCompletion)
        
        operationsQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func refresh(post: Post, completion: (() -> ())) {
        fatalError()
    }
}
