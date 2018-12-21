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

public class PostsViewController: FetchedCollectionViewController<Post, PostCell>, StoryboardLoaded, Dependencies, UIInjector, MaybeModalPresenter {
    public static var storyboardName: String {
        return "Posts"
    }
    
    public var persistence: Persistence!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Posts.Controller.title
    }
    
    override func createFetchedController() -> NSFetchedResultsController<Post> {
        return persistence.mainContext.fetchedControllerForAllPosts()
    }
    
    override func configure(cell: PostCell, with post: Post, at indexPath: IndexPath) {
        let viewModel = PostCellViewModel(post: post)
        inject(into: viewModel)
        cell.viewModel = viewModel
    }
    
    override func tapped(_ post: Post, at indexPath: IndexPath) {
        let details: PostDetailsViewController = Storyboards.loadFromStoryboard()
        inject(into: details)
        details.post = post
        presentMaybeModal(controller: details)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 240, height: 240)
        } else {
            let availableWidth = collectionView.frame.width - 20
            let cellWidth = availableWidth / 2
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
}
