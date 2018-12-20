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

internal class PostDetailsViewController: ScrolledContentViewController, StoryboardLoaded, UIInjector {
    static var storyboardName: String {
        return "PostDetails"
    }
    
    internal var post: Post!
    private lazy var viewModel = PostDetailsViewModel(post: self.post)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inject(into: viewModel)

        navigationItem.title = post.title ?? ""
        
        let presentation: PostDetailsPresentationView = PostDetailsPresentationView.loadInstance()
        
        viewModel.callback = {
            status in
            
            presentation.image.image = status.image
            presentation.loadingContainer.isHidden = !status.showLoading
            presentation.content.isHidden = !status.showContent
            presentation.content.load(html: status.content ?? "")
        }
        
        present(view: presentation)
    }
}
