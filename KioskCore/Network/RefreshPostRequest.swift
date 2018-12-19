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

private let PostDetailsPath = "https://www.googleapis.com/blogger/v3/blogs/:blogId:/posts/:postId:"

public class RefreshPostRequest: BloggerRequest, PersistenceConsumer {
    public var persistence: Persistence!
    
    private let post: Post
    public init(post: Post) {
        self.post = post

        super.init()
    }
    
    public override func execute() {
        persistence.performInBackground() {
            context in
            
            let post = context.inCurrentContext(entity: self.post)
            
            guard let blogId = post.blog?.blogId, let postId = post.postId else {
                Log.error("No blog or post id")
                self.finish()
                return
            }
            
            self.get(path: PostDetailsPath, variables: ["blogId": blogId, "postId": postId])
        }
    }
}
