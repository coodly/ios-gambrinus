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

internal class NetworkQueue {
    private lazy var operationsQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Network queue"
        queue.qualityOfService = .utility
        return queue
    }()
    
    internal func append(_ request: URLRequest, priority: Operation.QueuePriority = .normal, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        Log.debug("Append request to \(String(describing: request.url))")
        
        let networkRequest = NetworkRequest(request: request)
        networkRequest.resultHandler = completion
        networkRequest.queuePriority = priority
        operationsQueue.addOperation(networkRequest)
    }
}
