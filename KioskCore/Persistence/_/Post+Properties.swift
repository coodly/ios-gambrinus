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

extension Post {
    @NSManaged var brewerSort: String?
    @NSManaged var combinedBeers: String?
    @NSManaged var combinedBrewers: String?
    @NSManaged var combinedStyles: String?
    @NSManaged var hidden: Bool
    @NSManaged var isDirty: Bool
    @NSManaged var normalizedTitle: String?
    @NSManaged public var postId: String?
    @NSManaged var publishDate: Date?
    @NSManaged var shadowTitle: String?
    @NSManaged var slug: String?
    @NSManaged var starred: Bool
    @NSManaged var styleSort: String?
    @NSManaged public var title: String?
    @NSManaged var topScore: NSNumber?
    @NSManaged var touchedAt: Date?
    @NSManaged var topUntappd: String?
    
    @NSManaged var beers: Set<Beer>?
    @NSManaged var blog: Blog?
    @NSManaged public var body: PostContent?
    @NSManaged public var image: Image?
    @NSManaged var untappd: Set<Untappd>?
}
