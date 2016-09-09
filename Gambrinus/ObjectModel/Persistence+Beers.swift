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
import CoreData
import LaughingAdventure
import SWLogger

extension NSManagedObjectContext {
    func beersWith(rbIds: [String]) -> [Beer] {
        let predicate = NSPredicate(format: "rbIdentifier IN %@", rbIds)
        let existing = fetch(predicate: predicate) as [Beer]
        
        if existing.count == rbIds.count {
            return existing
        }
        
        let existingIds = existing.map({ $0.rbIdentifier! })
        let remaining = rbIds.filter({ !existingIds.contains($0) })
        var created = [Beer]()
        for r in remaining {
            let b = insertEntity() as Beer
            b.rbIdentifier = r
            b.markForSync(needed: true)
            created.append(b)
        }
        
        return existing + created
    }
    
    func update(rateBeer: CloudRateBeer) {
        let saved: Beer = fetchEntity(where: "rbIdentifier", hasValue: rateBeer.rbId! as AnyObject) ?? insertEntity()
        
        saved.rbIdentifier = rateBeer.rbId
        saved.alcohol = rateBeer.alcohol
        saved.name = rateBeer.name
        saved.aliasedValue = rateBeer.aliasFor != nil
        saved.rbScore = rateBeer.score
        
        saved.brewer = brewer(for: rateBeer.brewer)
        saved.style = style(for: rateBeer.style)
        
        saved.markForSync(needed: false)
        
        let posts = saved.posts!
        for p in posts {
            p.isDirtyValue = true
        }
    }
    
    func hasBeersWithMissingData() -> Bool {
        let missingCount = count(instancesOf: Beer.self, predicate: .needsSync)
        Log.debug("Missing info on \(missingCount) beers")
        return missingCount != 0
    }
    
    func rateBeerIDsForBeersNeedingSync() -> [String] {
        if let values = fetchAttribute(named: "rbIdentifier", on: Beer.self, limit: 100, predicate: .needsSync) as? [String] {
            return values
        }
        
        return []
    }
    
    func markSyncFailureOn(rbids: [String]) {
        let predicate = NSPredicate(format: "rbIdentifier IN %@", rbids)
        let beers: [Beer] = fetch(predicate: predicate)
        for b in beers {
            b.syncStatus?.syncFailed = true
        }
    }
}

extension NSPredicate {
    @nonobjc static let needsSync = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "syncStatus.syncNeeded = YES"),
        NSPredicate(format: "syncStatus.syncFailed = NO")
    ])
}
