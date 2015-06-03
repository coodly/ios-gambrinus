/*
* Copyright 2015 Coodly LLC
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

class KioskSlideMenuViewController: SlideMenuController {
    private var containedNavigation: UINavigationController!
    private var menuController: SideMenuViewController!
    private var shown = false

    var objectModel: ObjectModel!
    var imagesRetrieve: BlogImagesRetrieve!
    var bloggerAPIConnection: BloggerAPIConnection!

    override func viewWillAppear(animated: Bool) {
        if shown {
            return
        }

        shown = true

        containedNavigation = mainViewController as! UINavigationController
        menuController = leftViewController as! SideMenuViewController

        let blogPostsController = BlogPostsViewController()
        blogPostsController.objectModel = objectModel
        blogPostsController.imagesRetrieve = imagesRetrieve
        blogPostsController.bloggerAPIConnection = bloggerAPIConnection
        presentRootController(blogPostsController)
    }

    private func presentRootController(controller: UIViewController) {
        removeLeftGestures()
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "1099-list-1-toolbar-selected"), style: .Plain, target: self, action: "openMenu")
        containedNavigation.pushViewController(controller, animated: containedNavigation.viewControllers.count > 0)
    }

    func openMenu() {
        addLeftGestures()
        openLeft()
    }
    
    override func track(trackAction: TrackAction) {
        if trackAction == .TapClose || trackAction == .FlickClose {
            removeLeftGestures()
        }
    }
}
