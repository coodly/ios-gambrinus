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

class FullOptionsMenuController: MenuViewController, ObjectModelConsumer, InjectionHandler {
    var objectModel: Gambrinus.ObjectModel!
    
    private var allPostsCell: MenuCell?
    private var favoritesCell: MenuCell?
    
    private var postDateCell: MenuCell?
    private var postNameCell: MenuCell?
    private var rbScoreCell: MenuCell?
    
    private var feedbackCell: MenuCell!
    
    override var preferredStyle: UITableViewStyle {
        return .grouped
    }
    private lazy var upImage: UIImage = {
        return UIImage(named: "763-arrow-up-toolbar-selected")!
    }()
    private lazy var downImage: UIImage = {
        return UIImage(named: "764-arrow-down-toolbar-selected")!
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let order = objectModel.managedObjectContext.sortOrder()
        guard let cell = cellFor(sortOrder: order) else {
            return
        }
        
        markOrder(order, in: cell)
    }
    
    func loadContent() {
        appendNavigationOptions()
        appendSortOptions()
        
        feedbackCell = tableView.dequeueReusableCell() as MenuCell
        feedbackCell.textLabel!.text = NSLocalizedString("menu.controller.option.feedback", comment: "")
        
        addSection(InputCellsSection(cells: [feedbackCell]))
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
        } else if let dateCell = postDateCell, dateCell == cell {
            tappedOnSort(cell: dateCell)
        } else if let nameCell = postNameCell, nameCell == cell {
            tappedOnSort(cell: nameCell)
        } else if let rbCell = rbScoreCell, rbCell == cell {
            tappedOnSort(cell: rbCell)
        } else if cell == feedbackCell {
            let controller = Feedback.mainController()
            let navigation = UINavigationController(rootViewController: controller)
            container.presentModalController(navigation)
        }
        
        return false
    }
    
    private func tappedOnSort(cell: MenuCell) {
        let currentOrder = objectModel.managedObjectContext.sortOrder()
        var next: PostsSortOrder?
        switch cell {
        case postNameCell!:
            if currentOrder != .byPostName {
                next = .byPostName
            }
        case rbScoreCell!:
            if currentOrder != .byRBScore {
                next = .byRBScore
            }
        case postDateCell!:
            if currentOrder != .byDateAsc && currentOrder != .byDateDesc {
                next = .byDateDesc
            } else {
                next = currentOrder.reversed()
            }
        default:
            Log.debug("Unhandled cell: \(cell)")
        }
        
        guard let nextOrder = next else {
            return
        }
        
        Log.debug("Change order to \(next)")
        let saveClosure: CDYModelInjectionBlock = {
            model in
            
            model!.managedObjectContext.setSortOrder(nextOrder)
        }
        objectModel.save(in: saveClosure) {
            NotificationCenter.default.post(name: Notification.Name("GambrinusSortOrderChangedNotification"), object: nil)
        }
        container.closeLeft()
    }
    
    private func markOrder(_ order: PostsSortOrder, in cell: MenuCell) {
        switch order {
        case .byDateAsc:
            cell.accessoryView = UIImageView(image: upImage)
        case .byDateDesc:
            cell.accessoryView = UIImageView(image: downImage)
        case .byRBScore, .byPostName:
            cell.accessoryType = .checkmark
        default:
            Log.debug("Unhandled order \(order)")
        }
        
        var sortCells = [postDateCell!, postNameCell!, rbScoreCell!]
        if let index = sortCells.index(of: cell) {
            sortCells.remove(at: index)
        }
        for c in sortCells {
            c.accessoryType = .none
            c.accessoryView = nil
        }
    }
    
    private func cellFor(sortOrder: PostsSortOrder) -> MenuCell? {
        switch sortOrder {
        case .byDateAsc, .byDateDesc:
            return postDateCell
        case .byPostName:
            return postNameCell
        case .byRBScore:
            return rbScoreCell
        default:
            return nil
        }
    }
}
