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

class UpdateDirtyPostsOperation: ConcurrentOperation, PersistenceConsumer {
    var persisrtence: CorePersistence!
    
    override func main() {
        Log.debug("Update dirty posts")
        
        let save: ContextClosure = {
            context in
            
            let predicate = NSPredicate(format: "isDirty = YES")
            let dirties = context.fetch(predicate: predicate) as [Post]
            Log.debug("Have \(dirties.count) dirty posts")
            
            for post in dirties {
                post.updateSearchMeta()
            }
        }
        
        let completion = {
            self.finish()
        }
        
        persisrtence.performInBackground(task: save, completion: completion)
    }
}
