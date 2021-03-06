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

private extension Selector {
    static let postSortChanged = #selector(PostsViewController.postSortChanged)
    static let toggleSearch = #selector(PostsViewController.toggleSearch)
    static let searchChanged = #selector(PostsViewController.searchChanged(_:))
    static let keyboardFramwChanged = #selector(PostsViewController.keyboardFramwChanged(_:))
    static let refreshContent = #selector(PostsViewController.refreshContent)
    static let scheduleNextPostsCheck = #selector(PostsViewController.scheduleNextPostsCheck)
}

private typealias Dependencies = PersistenceConsumer & AppQueueConsumer
private typealias ConformsTo = MaybeModalPresenter & UITextFieldDelegate

public class PostsViewController: FetchedCollectionViewController<Post, PostCell>, StoryboardLoaded, Dependencies, UIInjector, ConformsTo {
    public static var storyboardName: String {
        return "Posts"
    }
    
    @IBOutlet private var collection: UICollectionView! {
        didSet {
            collectionView = collection
        }
    }
    @IBOutlet private var searchContainer: UIView!
    @IBOutlet private var searchField: UITextField!
    @IBOutlet private var keyboardFill: NSLayoutConstraint!
    private lazy var refresh = UIRefreshControl(frame: .zero)
    private var checkTimer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    public var persistence: Persistence!
    public var appQueue: OperationQueue!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Posts.Controller.title
        
        NotificationCenter.default.addObserver(self, selector: .postSortChanged, name: .postsSortChanged, object: nil)
        
        searchContainer.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.search.image, style: .plain, target: self, action: .toggleSearch)
        searchField.addTarget(self, action: .searchChanged, for: .editingChanged)
        searchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: .keyboardFramwChanged, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        collectionView.addSubview(refresh)
        refresh.addTarget(self, action: .refreshContent, for: .valueChanged)
        refresh.tintColor = .myOrange
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        searchContainer.backgroundColor = UIColor.controllerBackground
        collectionView.backgroundColor = UIColor.controllerBackground
        
        NotificationCenter.default.addObserver(self, selector: .refreshContent, name: .postsModification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .scheduleNextPostsCheck, name: UIAccessibility.guidedAccessStatusDidChangeNotification, object: nil)
        
        scheduleNextPostsCheck()
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
        var columns = floor(view.frame.width / posterBaseWidth)
        if UIDevice.current.userInterfaceIdiom == .phone, traitCollection.horizontalSizeClass == .compact {
            columns = min(columns, 2)
        }
        columns = max(1, columns)
        let width = floor(view.frame.width / columns)
        return CGSize(width: width, height: width)
    }
    
    @objc fileprivate func postSortChanged() {
        Log.debug("Posts sort changed")
        let activeSortDescriptors = persistence.mainContext.activeSort()
        updateFetchedController(sort: activeSortDescriptors, animate: true)
    }
    
    @objc fileprivate func toggleSearch() {
        let showHide = {
            self.searchContainer.isHidden = !self.searchContainer.isHidden
        }
        UIView.animate(withDuration: 0.3, animations: showHide) {
            _ in
            
            if self.searchContainer.isHidden {
                self.searchField.resignFirstResponder()
                self.searchField.text = ""
                self.updateSearch(with: "", animate: false)
            } else {
                self.searchField.becomeFirstResponder()
            }
        }
    }
    
    @objc fileprivate func searchChanged(_ field: UITextField) {
        guard let text = field.text else {
            return
        }
        
        updateSearch(with: text)
    }
    
    private func updateSearch(with term: String, animate: Bool = true) {
        persistence.perform() {
            context in
            
            let predicate = context.postsPredicat(with: term)
            DispatchQueue.main.async {
                self.updateFetchedController(predicate: predicate, animate: animate)
                self.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 10, height: 10), animated: false)
            }
        }
    }
    
    @objc fileprivate func keyboardFramwChanged(_ notification: Notification) {
        guard let info = notification.userInfo, let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let converted = view.convert(keyboardSize, from: UIApplication.shared.keyWindow!)
        let covering = view.frame.height - converted.origin.y
        
        guard covering >= 0 else {
            return
        }
        
        keyboardFill.constant = covering
    }
    
    @objc fileprivate func refreshContent() {
        Log.debug("Refresh content")
        let op = UpdateContentOperation()
        inject(into: op)
        op.completionHandler = {
            _, _ in
            
            DispatchQueue.main.async {
                self.refresh.endRefreshing()
            }
        }
        appQueue.addOperation(op)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private var PostCellWidthReference: NSString {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return "WWWWWWWWW"
        } else {
            return "WWWWWWWWWWWWW"
        }
    }
    private var cachedPosterWidth: CategoryDimension?
    var posterBaseWidth: CGFloat {
        let category = UIApplication.shared.preferredContentSizeCategory
        
        if cachedPosterWidth?.category != category {
            let reference: NSString = PostCellWidthReference
            let size = reference.size(withAttributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline)])
            cachedPosterWidth = CategoryDimension(category: category, dimension: ceil(size.width))
        }
        
        return cachedPosterWidth!.dimension
    }
    
    @objc fileprivate func scheduleNextPostsCheck() {
        Log.debug("scheduleNextCheck")
        guard UIAccessibility.isGuidedAccessEnabled else {
            Log.debug("Guided access not enabled. No automatic checks")
            checkTimer = nil
            return
        }
        
        refreshContent()
        let nextCheckAt = Date.tomorrow(at: 14)
        Log.debug("Next check at \(nextCheckAt)")
        let timer = Timer(fireAt: nextCheckAt, interval: 0, target: self, selector: .scheduleNextPostsCheck, userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .default)
        checkTimer = timer
    }
}

internal struct CategoryDimension {
    let category: UIContentSizeCategory
    let dimension: CGFloat
}
