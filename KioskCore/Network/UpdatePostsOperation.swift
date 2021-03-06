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
import BloggerAPI
import CoreDataPersistence

private typealias Dependencies = PersistenceConsumer & BloggerConsumer

internal class UpdatePostsOperation: ConcurrentOperation, Dependencies {
    var persistence: Persistence!
    var blogger: Blogger!
    
    private let executedAt = Date()
    
    override func main() {
        persistence.performInBackground() {
            context in
            
            let checkUpdatesSince = context.lastKnownPullDate
            guard let checkMinusWeek = checkUpdatesSince.oneWeekBefore, let nowMinusWeek = Date().oneWeekBefore else {
                Log.debug("Something odd with dates")
                self.finish()
                return
            }
            
            let used = min(checkMinusWeek, nowMinusWeek)
            Log.debug("Pull updates after \(used)")
            self.blogger.fetchUpdates(after: used, completion: self.handle(result:))
        }
    }
    
    private func pullNextPage(using cursor: NextPageCursor) {
        Log.debug("Pull next page")
        blogger.fetchUpdates(with: cursor, completion: handle(result:))
    }
    
    private func handle(result: PostsListResult) {
        if let error = result.error {
            Log.error("Pull posts error: \(error)")
            self.finish()
            return
        }
        
        let posts = result.posts ?? []
        Log.debug("Pulled \(posts.count) posts")
        let save: ContextClosure = {
            context in
            
            context.update(posts: posts)
            
            if result.nextPageCursor == nil {
                context.lastKnownPullDate = self.executedAt
            }
        }
        
        persistence.performInBackground(task: save) {
            if let cursor = result.nextPageCursor {
                self.pullNextPage(using: cursor)
            } else {
                self.finish()
            }
        }
    }
}
