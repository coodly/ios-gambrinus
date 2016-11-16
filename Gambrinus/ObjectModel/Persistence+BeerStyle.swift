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
import CloudKit
import CoreData
import LaughingAdventure
import SWLogger

extension NSManagedObjectContext {
    func style(for reference: CKReference?) -> BeerStyle? {
        guard let ref = reference else {
            return nil
        }
        
        guard let id = ref.recordID.recordName.components(separatedBy: "-").last else {
            return nil
        }
        
        if let existing: BeerStyle = fetchEntity(where: "identifier", hasValue: id as AnyObject) {
            return existing
        }
        
        let saved: BeerStyle = insertEntity()
        saved.identifier = id
        saved.markForSync()
        return saved
    }
    
    func hasStylesWithMissingData() -> Bool {
        let missingCount = count(instancesOf: BeerStyle.self, predicate: .needsSync)
        Log.debug("Missing info on \(missingCount) style")
        return missingCount != 0
    }

    func rateBeerIDsForStylesNeedingSync() -> [String] {
        return fetchAttribute(named: "identifier", on: BeerStyle.self, limit: 100, predicate: .needsSync)
    }
    
    func markSyncFailureOn(styles rbids: [String]) {
        let predicate = NSPredicate(format: "identifier IN %@", rbids)
        let beers: [BeerStyle] = fetch(predicate: predicate)
        for b in beers {
            b.syncStatus?.syncFailed = true
        }
    }
    
    func update(style: CloudStyle) {
        let saved: BeerStyle = fetchEntity(where: "identifier", hasValue: style.rbId! as AnyObject) ?? insertEntity()
        
        saved.identifier = style.rbId
        saved.name = style.name
        
        saved.markForSync(needed: false)
        
        guard let beers = saved.beers else {
            return
        }
        
        for beer in beers {
            guard let posts = beer.posts else {
                continue
            }
            
            for post in posts {
                post.isDirty = true
            }
        }

    }
}
