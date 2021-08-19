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
    internal func update(styles: [CloudStyle]) {
        let ids = styles.compactMap({ $0.rbId })
        let predicate = NSPredicate(format: "identifier IN %@", ids)
        let existing: [BeerStyle] = fetch(predicate: predicate)
        
        for style in styles {
            let saved: BeerStyle = existing.first(where: { $0.identifier == style.rbId }) ?? insertEntity()
            
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
}
