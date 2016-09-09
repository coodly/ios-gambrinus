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
    func createMapping(for post: CloudPost) {
        let updated = postWith(identifier: post.identifier!)
        let beers = beersWith(rbIds: post.rateBeers!)
        updated.beers = Set(beers)
    }
    
    func postWith(identifier: String) -> Post {
        if let post: Post = fetchEntity(where: "postId", hasValue: identifier as AnyObject) {
            return post
        }
        
        let insert: Post = insertEntity()
        insert.postId = identifier
        return  insert
    }
}
