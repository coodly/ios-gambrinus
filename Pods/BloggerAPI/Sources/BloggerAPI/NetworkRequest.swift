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

private let APIServer = "https://www.googleapis.com/blogger/v3"

private enum Method: String {
    case post
    case get
}

class NetworkRequest: FetchConsumer, KeyConsumer {
    var fetch: NetworkFetch!
    var apiKey: String!
    
    var resulthandler: ((Any?, Error?) -> ())!
    
    func execute() {
        fatalError("Override \(#function)")
    }
    
    func GET(_ path: String, parameters: [String: AnyObject]? = nil) {
        execute(.get, path: path, parameters: parameters)
    }
    
    func POST(_ path: String, parameters: [String: AnyObject]? = nil) {
        execute(.post, path: path, parameters: parameters)
    }
    
    private func execute(_ method: Method, path: String, parameters: [String: AnyObject]?) {
        var components = URLComponents(url: URL(string: APIServer)!, resolvingAgainstBaseURL: true)!
        components.path = components.path + path

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))

        if let parameters = parameters {
            for (name, value) in parameters {
                var encode: String?
                if let integer = value as? Int {
                    encode = String(integer)
                } else if let string = value as? String {
                    encode = string
                }
                
                guard let toEncode = encode else {
                    continue
                }
                
                queryItems.append(URLQueryItem(name: name, value: toEncode))
            }
        }
        components.queryItems = queryItems
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        fetch.fetch(request: request as URLRequest) {
            data, response, error in
            
            if let error = error {
                Logging.log("Fetch error \(error)")
                self.handle(error: error)
            }
            
            if let data = data {
                
                Logging.log("Response \(String(data: data, encoding: String.Encoding.utf8))")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.handle(success: json as! [String: AnyObject])
                } catch let error as NSError {
                    self.handle(error: error)
                }
            } else {
                self.handle(error: error)
            }
        }
    }
    
    func handle(success data: [String: AnyObject]) {
        Logging.log("handleSuccessResponse")
    }
    
    func handle(error: Error?) {
        Logging.log("handleErrorResponse: \(error)")
        resulthandler(nil, error)
    }
}
