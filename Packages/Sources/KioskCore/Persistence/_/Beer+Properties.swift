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

extension Beer {
    @NSManaged var alcohol: String?
    @NSManaged var aliased: Bool
    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var normalizedName: String?
    @NSManaged var rbIdentifier: String?
    @NSManaged var rbScore: String?
    @NSManaged var shadowName: String?
 
    @NSManaged var brewer: Brewer?
    @NSManaged var posts: Set<Post>?
    @NSManaged var style: BeerStyle?
}
