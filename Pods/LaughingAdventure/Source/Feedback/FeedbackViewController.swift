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
import CloudKit
import CoreData

#if os(iOS)
private extension Selector {
    static let donePressed = #selector(FeedbackViewController.donePressed)
    static let addPressed = #selector(FeedbackViewController.addPressed)
    static let refreshConversations = #selector(FeedbackViewController.refresh)
}

public class FeedbackViewController: FetchedTableViewController<Conversation, ConversationCell>, InjectionHandler, PersistenceConsumer, FeedbackContainerConsumer {
    var persistence: CorePersistence!
    var feedbackContainer: CKContainer!

    private var refreshControl: UIRefreshControl!
    private var accountStatus: CKAccountStatus = .couldNotDetermine
    private var refreshed = false
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        inject(into: self)
        
        navigationItem.title = NSLocalizedString("coodly.feedback.controller.title", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .donePressed)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addPressed)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: .refreshConversations, for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier())
    }
    
    public override func createFetchedController() -> NSFetchedResultsController<Conversation> {
        return persistence.mainContext.fetchedControllerForConversations()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if refreshed {
            return
        }
        
        refreshControl.beginRefreshingManually()
        refreshed = true
    }
    
    public override func configure(cell: ConversationCell, at indexPath: IndexPath, with converation: Conversation, forMeasuring: Bool) {
        if let time = converation.lastMessageTime {
            cell.timeLabel.text = "\(dateFormatter.string(from: time)) >"
        } else {
            cell.timeLabel.text = ""
        }
        
        cell.snippetLabel.text = converation.snippet
    }
    
    public override func tappedCell(at indexPath: IndexPath, object: Conversation) -> Bool {
        pushConversationControllerWith(object)
        return true
    }
    
    @objc fileprivate func donePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func addPressed() {
        pushConversationControllerWith(nil)
    }
    
    private func pushConversationControllerWith(_ conversation: Conversation?) {
        let conversationController = ConversationViewController()
        conversationController.conversation = conversation
        inject(into: conversationController)
        navigationController?.pushViewController(conversationController, animated: true)
    }
    
    @objc fileprivate func refresh() {
        Logging.log("Refresh conversations")
        let refreshClosure: ((Bool) -> ()) = {
            available in
            
            Logging.log("Refresh")
            guard available else {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            let op = PullConversationsOperation()
            self.inject(into: op)
            op.completionHandler = {
                success in
                
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
            op.start()
        }
        
        if accountStatus == .couldNotDetermine {
            checkAccountStatus(completion: refreshClosure)
        } else {
            refreshClosure(true)
        }
    }
    
    private func checkAccountStatus(completion: @escaping ((Bool) -> ())) {
        Logging.log("Check account")
        feedbackContainer.accountStatus() {
            status, error in
            
            Logging.log("Account status: \(status.rawValue) - \(error)")
            completion(status == .available)
        }
    }
}
#endif
