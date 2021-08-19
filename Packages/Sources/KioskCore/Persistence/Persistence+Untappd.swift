/*
 * Copyright 2019 Coodly LLC
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

extension NSManagedObjectContext {
    internal func untappd(with ids: [NSNumber]) -> [Untappd] {
        let predicate = NSPredicate(format: "bid IN %@", ids)
        let existing: [Untappd] = fetch(predicate: predicate)
        
        if existing.count == ids.count {
            return existing
        }
        
        let existingIds = existing.compactMap({ $0.bid })
        let remaining = ids.filter({ !existingIds.contains($0) })
        var created = [Untappd]()
        for r in remaining {
            let b: Untappd = insertEntity()
            b.bid = r
            b.markForSync(needed: true)
            created.append(b)
        }
        
        return existing + created
    }

    internal func updateUntappd(with rateBeers: [CloudUntappd]) {
        let ids = rateBeers.compactMap({ $0.bid })
        let predicate = NSPredicate(format: "bid IN %@", ids)
        let existing: [Untappd] = fetch(predicate: predicate)
        
        for rateBeer in rateBeers {
            let saved: Untappd = existing.first(where: { $0.bid == rateBeer.bid }) ?? insertEntity()
            
            saved.bid = rateBeer.bid ?? NSNumber(value: -10)
            saved.score = rateBeer.score
            
            saved.markForSync(needed: false)
            
            saved.posts?.forEach({ $0.isDirty = true })
        }
    }
}
