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

class ResolveBlogByURLRequest: NetworkRequest {
    private let url: String
    var completionHandler: ((String?) -> ())!
    
    init(url: String) {
        self.url = url
    }
    
    override func execute() {
        GET("/blogs/byurl", parameters: ["url": url as AnyObject])
    }
    
    override func handle(success data: [String : AnyObject]) {
        let blogId = data["id"] as? String
        completionHandler(blogId)
    }
}
