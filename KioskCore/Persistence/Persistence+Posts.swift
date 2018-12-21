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
import CoreDataPersistence
import BloggerAPI

extension NSManagedObjectContext {
    public func fetchedControllerForAllPosts() -> NSFetchedResultsController<Post> {
        return fetchedController(sort: activeSort())
    }
    
    public func update(remote post: BloggerAPI.Post) -> Post {
        guard let local: Post = fetchEntity(where: "postId", hasValue: post.id) else {
            fatalError()
        }
        
        local.title = post.title
        local.publishDate = post.published
        
        let content: PostContent = local.body ?? insertEntity()
        content.htmlBody = post.content
        content.post = local
        
        if let string = post.images?.first?.largeImageURL.absoluteString {
            local.image = findOrCreteImageWithURLString(string)
        }
        
        return local
    }
    
    public func activeSort() -> [NSSortDescriptor] {
        switch sortOrder {
        case .byDateDesc:
            return [NSSortDescriptor(key: "publishDate", ascending: false)]
        case .byDateAsc:
            return [NSSortDescriptor(key: "publishDate", ascending: true)]
        case .byPostName:
            return [NSSortDescriptor(key: "normalizedTitle", ascending: true)]
        case .byRBScore:
            return [NSSortDescriptor(key: "topScore", ascending: false), NSSortDescriptor(key: "normalizedTitle", ascending: true)]
        case .byStyle: fallthrough
        case .byRBBeerName: fallthrough
        case .byBrewer:
            return [NSSortDescriptor(key: "publishDate", ascending: false)]
        }
    }
    
    public func postsPredicat(with search: String) -> NSPredicate {
        let normalized = search.normalize()
        guard normalized.hasValue() else {
            return .truePredicate
        }
        
        let title = NSPredicate(format: "normalizedTitle CONTAINS %@", normalized)
        let beers = NSPredicate(format: "combinedBeers CONTAINS %@", normalized)
        let styles = NSPredicate(format: "combinedStyles CONTAINS %@", normalized)
        let brewers = NSPredicate(format: "combinedBrewers CONTAINS %@", normalized)
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: [title, beers, styles, brewers])
    }
}
