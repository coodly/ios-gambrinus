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

public enum BloggerError: Error {
    case noData
    case networkError(Error)
    case invalidJSON(Error)
}

internal struct NetworkResult<T: Codable> {
    let success: T?
    let error: Error?
}

private enum Method: String {
    case post
    case get
}

internal protocol Executed: AnyObject {
    func execute()
}

internal struct VariableValue {
    let key: String
    let value: String
}

internal enum Variable {
    case blogId(String)
    case postId(String)
    
    var value: VariableValue {
        switch self {
        case .blogId(let id):
            return VariableValue(key: ":blogId:", value: id)
        case .postId(let id):
            return VariableValue(key: ":postId:", value: id)
        }
    }
}

internal class NetworkRequest<T: Codable, Result>: FetchConsumer, KeyConsumer, Executed {
    var fetch: NetworkFetch!
    var apiKey: String!
    
    internal var result: Result! {
        didSet {
            resultCallback?(result)
        }
    }
    internal var resultCallback: ((Result) -> Void)?
    
    func execute() {
        fatalError("Override \(#function)")
    }
    
    func GET(_ path: String, parameters: [String: AnyObject]? = nil) {
        execute(.get, path: path, parameters: parameters)
    }
    
    func POST(_ path: String, parameters: [String: AnyObject]? = nil) {
        execute(.post, path: path, parameters: parameters)
    }
    
    func get(_ path: String, variables: [Variable], parameters: [String: AnyObject]? = nil) {
        var vars = variables
        if let blogId = Injector.sharedInstance.blogId {
            vars.append(.blogId(blogId))
        }
        
        let replaced = path.replace(variables: vars)
        execute(.get, path: replaced, parameters: parameters)
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
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        fetch.fetch(request: request, completion: handle(data:response:error:))
    }
    
    internal func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let data = data, let string = String(data: data, encoding: .utf8) {
            Logging.log("Response")
            Logging.log(string)
        }
        
        var result: T?
        var handleError: BloggerError?
        defer {
            self.handle(result: NetworkResult(success: result, error: handleError))
        }
        
        if let error = error {
            handleError = .networkError(error)
            return
        }
        
        guard let data = data else {
            handleError = .noData
            return
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            result = try decoder.decode(T.self, from: data)
        } catch {
            handleError = .invalidJSON(error)
        }
    }
    
    internal func handle(result: NetworkResult<T>) {
        Logging.log("Handle: \(result)")
    }
}
