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
        let sort = NSSortDescriptor(key: "publishDate", ascending: false)
        return fetchedController(sort: [sort])
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
        
        if let string = post.images.first?.largeImageURL.absoluteString {
            local.image = findOrCreteImageWithURLString(string)
        }
        
        return local
    }
}
