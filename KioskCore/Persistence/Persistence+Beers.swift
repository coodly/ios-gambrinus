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

extension NSManagedObjectContext {
    internal func beersWith(rbIds: [String]) -> [Beer] {
        let predicate = NSPredicate(format: "rbIdentifier IN %@", rbIds)
        let existing = fetch(predicate: predicate) as [Beer]
        
        if existing.count == rbIds.count {
            return existing
        }
        
        let existingIds = existing.compactMap({ $0.rbIdentifier })
        let remaining = rbIds.filter({ !existingIds.contains($0) })
        var created = [Beer]()
        for r in remaining {
            let b: Beer = insertEntity()
            b.rbIdentifier = r
            b.markForSync(needed: true)
            created.append(b)
        }
        
        return existing + created
    }
}
