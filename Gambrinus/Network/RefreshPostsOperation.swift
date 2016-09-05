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
import LaughingAdventure
import SWLogger

class RefreshPostsOperation: ConcurrentOperation, ObjectModelConsumer, BloggerAPIConsumer {
    var objectModel: Gambrinus.ObjectModel!
    var bloggerAPI: BloggerAPIConnection!
        
    override func main() {
        Log.debug("Refresh posts")
        objectModel.perform() {
            let lastPostsRefresDate = self.objectModel.lastKnownPullDate()
            
            Log.debug("Last know date: \(lastPostsRefresDate)")
            
            let refreshTime = Date()
            
            self.bloggerAPI.retrieveUpdates(since: lastPostsRefresDate) {
                success, error in
                
                if success {
                    self.objectModel.perform() {
                        self.objectModel.setPostsRefreshTime(refreshTime)
                    }
                }
                
                self.finish(!success)
            }
        }
    }
}
