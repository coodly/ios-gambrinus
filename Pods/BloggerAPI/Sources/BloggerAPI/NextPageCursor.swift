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

public struct NextPageCursor {
    var pageToken: String?
    let startDate: String
    let endDate: String
    let status = "live"
    let fetchImages = "true"
    let fetchBodies = "false"
    let fields = "nextPageToken,items(id,published,title,images)"
    let maxResults = "100"
}

extension NextPageCursor {
    internal var params: [String: AnyObject] {
        var result = [String: AnyObject]()
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let name = child.label, let value = child.value as? String else {
                continue
            }
            
            result[name] = value as AnyObject
        }
        return result
    }
}

extension NextPageCursor {
    internal init(since: Date) {
        pageToken = nil
        startDate = NextPageCursor.string(from: since)
        endDate = NextPageCursor.string(from: Date())
    }
    
    private static func string(from: Date) -> String {
        let result = Injector.sharedInstance.bloggerDateFormatter.string(from: from)
        return result.appending("-00:00")
    }
}
