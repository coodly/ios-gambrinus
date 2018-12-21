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

private enum Accessory {
    case asc
    case desc
    case check
    case none
}

private struct MenuOption {
    let name: String
    let accessory: Accessory
    let switchesTo: PostsSortOrder
}

public class MenuViewController: UIViewController, StoryboardLoaded, PersistenceConsumer {
    public static var storyboardName: String {
        return "Menu"
    }
    
    public var persistence: Persistence!
    private lazy var accessoryDesc = UIImageView(image: Asset.arrowDown.image)
    private lazy var accessoryAsc = UIImageView(image: Asset.arrowUp.image)
    
    private var options: [[MenuOption]] = [[]] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let powered: MenuFooterView = MenuFooterView.loadInstance()
        tableView.tableFooterView = powered
        
        tableView.registerCell(forType: MenuCell.self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let activeSort = persistence.mainContext.sortOrder
        
        let sortByPost = activeSort == .byPostName
        let sortByScore = activeSort == .byRBScore
        
        var sortOptions = [MenuOption]()

        if activeSort == .byDateAsc {
            sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.date, accessory: .asc, switchesTo: .byDateDesc))
        } else if activeSort == .byDateDesc {
            sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.date, accessory: .desc, switchesTo: .byDateAsc))
        } else {
            sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.date, accessory: .none, switchesTo: .byDateDesc))
        }
        sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.posts, accessory: sortByPost ? .check : .none, switchesTo: .byPostName))
        sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.score, accessory: sortByScore ? .check : .none, switchesTo: .byRBScore))
        
        self.options = [sortOptions]
    }
}

extension MenuViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuCell = tableView.dequeueReusableCell(for: indexPath)
        let option = options[indexPath.section][indexPath.row]
        cell.textLabel?.text = option.name
        if option.accessory == .check {
            cell.accessoryType = .checkmark
            cell.accessoryView = nil
        } else if option.accessory == .desc {
            cell.accessoryType = .none
            cell.accessoryView = accessoryDesc
        } else if option.accessory == .asc {
            cell.accessoryType = .none
            cell.accessoryView = accessoryAsc
        } else {
            cell.accessoryView = nil
            cell.accessoryType = .none
        }
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let option = options[indexPath.section][indexPath.row]
        NotificationCenter.default.post(name: .closeMenu, object: nil)
        persistence.write() {
            context in
            
            context.sortOrder = option.switchesTo
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return L10n.Menu.Controller.Sort.Section.title
        }
        
        return nil
    }
}
