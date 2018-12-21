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

private struct MenuOption {
    let name: String
    let accessory: UIImage?
    let isOn: Bool
}

public class MenuViewController: UIViewController, StoryboardLoaded, PersistenceConsumer {
    public static var storyboardName: String {
        return "Menu"
    }
    
    public var persistence: Persistence!
    
    private var options: [[MenuOption]] = [[]] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let powered = UIImageView(image: Asset.poweredBy.image)
        powered.contentMode = .scaleAspectFit
        tableView.tableFooterView = powered
        
        tableView.registerCell(forType: MenuCell.self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let activeSort = persistence.mainContext.sortOrder
        
        var sortOptions = [MenuOption]()
        sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.date, accessory: sortIcon(up: .byDateAsc, down: .byDateDesc, checked: activeSort), isOn: false))
        sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.posts, accessory: nil, isOn: activeSort == .byPostName))
        sortOptions.append(MenuOption(name: L10n.Menu.Controller.Sort.By.score, accessory: nil, isOn: activeSort == .byRBScore))
        
        self.options = [sortOptions, []]
    }
    
    private func sortIcon(up: PostsSortOrder, down: PostsSortOrder, checked: PostsSortOrder) -> UIImage? {
        if checked == up {
            return Asset.arrowUp.image
        } else if checked == down {
            return Asset.arrowDown.image
        } else {
            return nil
        }
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
        if option.isOn {
            cell.accessoryType = .checkmark
            cell.accessoryView = nil
        } else if let icon = option.accessory {
            let view = UIImageView(image: icon)
            cell.accessoryView = view
            cell.accessoryType = .none
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
    }
}
