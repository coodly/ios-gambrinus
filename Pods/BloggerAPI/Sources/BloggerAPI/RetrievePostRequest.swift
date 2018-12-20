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

private let PostPathBase = "/blogs/:blogId:/posts/:postId:"

public struct SinglePostResult {
    public let post: Post?
    public let error: Error?
}

internal class RetrievePostRequest: NetworkRequest<Post, SinglePostResult> {
    private let postId: String
    internal init(postId: String) {
        self.postId = postId
    }
    
    override func execute() {
        get(PostPathBase, variables: [.postId(postId)], parameters: ["fetchImages": "true" as AnyObject])
    }
    
    override func handle(result: NetworkResult<Post>) {
        self.result = SinglePostResult(post: result.success, error: result.error)
    }
}
