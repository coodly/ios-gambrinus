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

import UIKit
import CoreData

#if os(iOS)
private extension Selector {
    static let addMessage = #selector(ConversationViewController.addMessage)
    static let refreshMessages = #selector(ConversationViewController.refreshMessages)
}

internal class ConversationViewController: FetchedTableViewController<Message, MessageCell>, InjectionHandler, PersistenceConsumer {
    var persistence: CorePersistence!
    var conversation: Conversation?
    
    private var refreshControl: UIRefreshControl!
    private var refreshed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: .addMessage)
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier())
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: .refreshMessages, for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if refreshed {
            return
        }
        
        refreshControl.beginRefreshingManually()
        refreshed = true
    }
    
    override func createFetchedController() -> NSFetchedResultsController<Message> {
        if conversation == nil {
            conversation = persistence.mainContext.insertEntity() as Conversation
        }
        return persistence.mainContext.fetchedControllerForMessages(in: conversation!)
    }
    
    override func configure(cell: MessageCell, at indexPath: IndexPath, with message: Message, forMeasuring: Bool) {
        cell.messageLabel.text = message.body
    }
    
    @objc fileprivate func addMessage() {
        let compose = ComposeViewController()
        compose.conversation = conversation!
        inject(into: compose)
        let navigation = UINavigationController(rootViewController: compose)
        navigation.modalPresentationStyle = .formSheet
        present(navigation, animated: true, completion: nil)
    }
    
    @objc fileprivate func refreshMessages() {
        guard let c = conversation, c.recordData != nil else {
            refreshControl.endRefreshing()
            return
        }
        
        let request = PullMessagesOperation(for: c)
        request.completionHandler = {
            success, op in
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        inject(into: request)
        request.start()
    }
}
#endif
