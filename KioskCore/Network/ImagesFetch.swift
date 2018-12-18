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

import ImageProvide

internal class ImagesFetch: RemoteFetch {
    private let queue: NetworkQueue
    private let appQueue: OperationQueue
    init(queue: NetworkQueue, appQueue: OperationQueue) {
        self.queue = queue
        self.appQueue = appQueue
    }
    
    func fetchImage(for ask: ImageAsk, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: ask.url)
        request.httpMethod = "GET"
        queue.append(request, priority: .low, completion: completion)
    }    
}
