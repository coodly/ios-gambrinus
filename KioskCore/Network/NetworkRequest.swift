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

internal typealias NetworkResultClosure = (Data?, URLResponse?, Error?) -> ()

internal class NetworkRequest: ConcurrentOperation {
    private let request: URLRequest?
    var resultHandler: NetworkResultClosure!
    
    init(request: URLRequest) {
        self.request = request
    }
    
    override func main() {
        execute(request!)
    }
    
    private func execute(_ request: URLRequest) {
        Log.debug("Execute request")
        
        let resultClosure: ((Data?, URLResponse?, Error?) -> Void) = {
            data, response, error in
            
            Log.debug("Request to \(request.url!.absoluteString) complete")
            Log.debug("Response headers:")
            (response as? HTTPURLResponse)?.allHeaderFields.forEach() {
                name, value in
                
                Log.debug("\t\(name): \(value)")
            }
            
            self.resultHandler(data, response, error)
            self.finish()
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: resultClosure)
        task.resume()
    }
}

