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

public struct PostsListResult {
    public let posts: [Post]?
    public let nextPageCursor: NextPageCursor?
    public let error: Error?
}

private let ListPostsPathBase = "/blogs/:blogId:/posts"

internal class ListPostsRequest: NetworkRequest<PostsPage, PostsListResult>, BlogIdConsumer, DateFormatterConsumer {
    var blogId: String!
    var dateFormatter: DateFormatter!
    
    private let cursor: NextPageCursor
    
    init(since: Date) {
        self.cursor = NextPageCursor(since: since)
    }
    
    init(cursor: NextPageCursor) {
        self.cursor = cursor
    }
    
    override func execute() {
        get(ListPostsPathBase, variables: [.blogId(blogId)], parameters: cursor.params)
    }
    
    override func handle(result: NetworkResult<PostsPage>) {
        let nextCursor: NextPageCursor?
        if let token = result.success?.nextPageToken {
            var modified = cursor
            modified.pageToken = token
            nextCursor = modified
        } else {
            nextCursor = nil
        }
        self.result = PostsListResult(posts: result.success?.items, nextPageCursor: nextCursor, error: result.error)
    }
}
