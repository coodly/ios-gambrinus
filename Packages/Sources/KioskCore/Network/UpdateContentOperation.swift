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

public class UpdateContentOperation: ConcurrentOperation, AppQueueConsumer, CoreInjector, PersistenceConsumer {
    public var persistence: Persistence!
    public var appQueue: OperationQueue!
    
    public override func main() {
        var operations = [Operation]()
        
        let resetSyncs = BlockOperation() {
            self.persistence.write() {
                context in
                
                context.resetFailedStatuses()
            }
        }
        operations.add(operation: resetSyncs)
        operations.add(operation: UpdatePostsOperation())
        operations.add(operation: PullPostMappingsOperation())
        operations.add(operation: PullRateBeerChangesOperation())
        operations.add(operation: PullUntappdChangesOperation())
        operations.add(operation: UpdateDirtyPostsOperation())
        let finisMe = BlockOperation() {
            self.finish()
        }
        operations.add(operation: finisMe)
        
        operations.forEach({ inject(into: $0) })
        
        appQueue.addOperations(operations, waitUntilFinished: false)
    }
}
