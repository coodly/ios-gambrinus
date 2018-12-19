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

private enum HTTPMethod: String {
    case get = "GET"
}

public class BloggerRequest: NetworkRequest {
    public override func main() {
        execute()
    }
    
    public func execute() {
        fatalError()
    }
    
    internal func get(path: String, variables: [String: String]) {
        perform(.get, to: path, variables: variables)
    }
    
    private func perform(_ method: HTTPMethod, to parh: String, variables: [String: String]) {
        let fullPath = parh.replace(variables: variables)
        Log.debug("Perform \(method.rawValue) ro \(fullPath)")
    }
}

fileprivate extension String {
    func replace(variables: [String: String]) -> String {
        var result = self
        for (key, value) in variables {
            let replaceKey = ":\(key):"
            result = result.replacingOccurrences(of: replaceKey, with: value)
        }
        return result
    }
}
