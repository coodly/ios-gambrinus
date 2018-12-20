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

class ListPostsRequest: NetworkRequest, BlogIdConsumer, DateFormatterConsumer {
    var blogId: String!
    var dateFormatter: DateFormatter!
    
    private let since: Date
    
    init(since: Date) {
        self.since = since
    }
    
    override func execute() {
        let path = "/blogs/\(blogId!)/posts"
        var params = [String: AnyObject]()
        params["startDate"] = string(from: since)
        params["endDate"] = string(from: Date())
        params["status"] = "live" as AnyObject
        params["fetchImages"] = "true" as AnyObject
        params["fetchBodies"] = "false" as AnyObject
        params["fields"] = "nextPageToken,items(id,published,title,images)" as AnyObject
        params["maxResults"] = "100" as AnyObject
        GET(path, parameters: params)
    }
    
    private func string(from: Date) -> AnyObject {
        let result = dateFormatter.string(from: from)
        return result.appending("-00:00") as AnyObject
    }
}
