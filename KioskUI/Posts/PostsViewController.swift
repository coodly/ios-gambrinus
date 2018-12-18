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

import UIKit
import KioskCore
import CoreData

private typealias Dependencies = PersistenceConsumer

public class PostsViewController: FetchedCollectionViewController<Post, PostCell>, StoryboardLoaded, Dependencies {
    public static var storyboardName: String {
        return "Posts"
    }
    
    public var persistence: Persistence!
    
    override func createFetchedController() -> NSFetchedResultsController<Post> {
        return persistence.mainContext.fetchedControllerForAllPosts()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
