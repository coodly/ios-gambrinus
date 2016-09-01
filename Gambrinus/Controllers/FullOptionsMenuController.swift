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
import SWLogger
import LaughingAdventure

class FullOptionsMenuController: MenuViewController, InjectionHandler {
    private var allPostsCell: MenuCell?
    private var favoritesCell: MenuCell?
    
    private var postDateCell: MenuCell?
    private var postNameCell: MenuCell?
    private var rbScoreCell: MenuCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContent()
        
        tableView.bounces = false
        
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.controllerBackground()
        tableView.separatorColor = UIColor.controllerBackground()
        
        
        let powered = UIImageView(image: UIImage(named: "PoweredBy"))
        powered.contentMode = .scaleAspectFit
        tableView.tableFooterView = powered
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    func loadContent() {
        appendNavigationOptions()
        appendSortOptions()
    }
    
    final func appendNavigationOptions() {
        allPostsCell = tableView.dequeueReusableCell() as MenuCell
        allPostsCell!.textLabel!.text = NSLocalizedString("menu.controller.option.all.posts", comment: "")
        
        favoritesCell = tableView.dequeueReusableCell() as MenuCell
        favoritesCell!.textLabel!.text = NSLocalizedString("menu.controller.option.favorites", comment: "")
        
        addSection(InputCellsSection(cells: [allPostsCell!, favoritesCell!]))
    }
    
    func appendSortOptions() {
        postDateCell = tableView.dequeueReusableCell() as MenuCell
        postDateCell!.textLabel!.text = NSLocalizedString("menu.controller.sort.by.date", comment: "")

        postNameCell = tableView.dequeueReusableCell() as MenuCell
        postNameCell!.textLabel!.text = NSLocalizedString("menu.controller.sort.by.posts", comment: "")

        rbScoreCell = tableView.dequeueReusableCell() as MenuCell
        rbScoreCell!.textLabel!.text = NSLocalizedString("menu.controller.sort.by.score", comment: "")

        addSection(InputCellsSection(title: NSLocalizedString("menu.controller.sort.section.title", comment: ""), cells: [postDateCell!, postNameCell!, rbScoreCell!]))
    }
    
    override func tapped(cell: UITableViewCell, at indexPath: IndexPath) -> Bool {
        if let allCell = allPostsCell, allCell == cell {
            let controller = BlogPostsViewController()
            inject(into: controller)
            container.presentRootController(controller)
        } else if let favorites = favoritesCell, favorites == cell {
            let controller = MarkedPostsViewController()
            inject(into: controller)
            container.presentRootController(controller)
        }
        
        return false
    }
}
