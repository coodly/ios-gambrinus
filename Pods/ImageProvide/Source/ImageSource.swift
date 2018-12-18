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

internal typealias ImageClosure = ((UIImage?) -> ())

public class ImageSource: LocalImageResolver {
    private let remoteFetch: RemoteFetch
    private var asks = [ImageAsk]()
    private let retrieveQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Image fetch operations queue"
        queue.qualityOfService = .utility
        return queue
    }()
    private let processQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Image process queue"
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    public init(fetch: RemoteFetch) {
        remoteFetch = fetch
    }
    
    @discardableResult
    public func retrieveImage(for ask: ImageAsk, completion: @escaping (UIImage?) -> ()) -> Bool {
        var haveLocalImage = false

        let placeholderOperation: FetchOperation?
        if hasImage(for: ask) {
            placeholderOperation = nil
            haveLocalImage = true
        } else if let placeholder = ask.placeholderAsk {
            placeholderOperation = FetchOperation(fetch: remoteFetch, ask: placeholder, completion: completion)
        } else {
            placeholderOperation = nil
        }
        let imageOperation = FetchOperation(fetch: remoteFetch, ask: ask, completion: completion)
        
        if let placeholder = placeholderOperation {
            imageOperation.addDependency(placeholder)
        }
        
        let operations: [FetchOperation] = [placeholderOperation, imageOperation].compactMap({ $0 })
        let runOnProcess = operations.filter({ hasImage(for: $0.ask) })
        let runOnRetrieve = operations.filter({ !hasImage(for: $0.ask )})
        
        processQueue.addOperations(runOnProcess, waitUntilFinished: false)
        retrieveQueue.addOperations(runOnRetrieve, waitUntilFinished: false)
        
        return haveLocalImage
    }
}
