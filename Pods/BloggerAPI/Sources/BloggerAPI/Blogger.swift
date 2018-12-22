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

public class Blogger: InjectionHandler {
    private let blogURL: String
    
    public init(blogURL: String, key: String, fetch: NetworkFetch) {
        self.blogURL = blogURL
        Injector.sharedInstance.apiKey = key
        Injector.sharedInstance.fetch = fetch
    }
    
    public func fetchUpdates(after date: Date, completion: @escaping ((PostsListResult) -> Void)) {
        Logging.log("Fetch updates after \(date)")
        let request = ListPostsRequest(since: date)
        request.resultCallback = completion
        execute(request: request)
    }

    public func fetchUpdates(with cursor: NextPageCursor, completion: @escaping ((PostsListResult) -> Void)) {
        Logging.log("Fetch updates with \(cursor)")
        let request = ListPostsRequest(cursor: cursor)
        request.resultCallback = completion
        execute(request: request)
    }

    public func fetchPost(_ postId: String, completion: @escaping ((SinglePostResult) -> Void)) {
        Logging.log("Fetch post: \(postId)")
        let request = RetrievePostRequest(postId: postId)
        request.resultCallback = completion
        execute(request: request)
    }
    
    private func execute(request: Executed) {
        guard Injector.sharedInstance.blogId != nil else {
            resolveBlog() {
                self.execute(request: request)
            }
            return
        }
        
        inject(into: request)
        request.execute()
    }
    
    private func resolveBlog(completion: @escaping () -> ()) {
        Logging.log("Resolve blog")
        let request = ResolveBlogByURLRequest(url: blogURL)
        inject(into: request)
        request.resultCallback = {
            result in
            
            guard let blogId = result.id else {
                Logging.log("Blog id not received")
                return
            }
            
            Logging.log("BlogID: \(blogId)")
            Injector.sharedInstance.blogId = blogId
            completion()
        }
        request.execute()
    }
}
