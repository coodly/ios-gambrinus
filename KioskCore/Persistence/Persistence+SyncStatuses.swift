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
import CoreData

private extension NSPredicate {
    static let syncable = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "syncNeeded = YES"),
        NSPredicate(format: "syncFailed = NO")
    ])

    static let waitingSync = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "syncStatus.syncNeeded = YES"),
        NSPredicate(format: "syncStatus.syncFailed = NO")
    ])
}

extension NSManagedObjectContext {
    internal func fetchedControllerForStatusesNeedingSync() -> NSFetchedResultsController<SyncStatus> {
        let sort = NSSortDescriptor(key: "syncNeeded", ascending: true)
        return fetchedController(predicate: .syncable, sort: [sort])
    }
    
    internal func isMissingDetails<T: Syncable>(for type: T.Type) -> Bool {
        return count(instancesOf: T.self, predicate: .waitingSync) != 0
    }
    
    internal func itemsNeedingSync<T: Syncable>(for type: T.Type) -> [T] {
        return fetch(predicate: .waitingSync, limit: 100)
    }
    
    public func resetFailedStatuses() {
        let failedPredicate = NSPredicate(format: "syncFailed = YES")
        let failed: [SyncStatus] = fetch(predicate: failedPredicate)
        Log.debug("Have \(failed.count) failed syncs")
        failed.forEach({ $0.syncFailed = false })
    }
}
