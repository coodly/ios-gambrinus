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
import CoreData

internal struct ChangeAction {
    let sectionIndex: Int?
    
    let indexPath: IndexPath?
    let newIndexPath: IndexPath?
    
    let changeType: NSFetchedResultsChangeType
}

private typealias ConformsTo = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout & NSFetchedResultsControllerDelegate

public class FetchedCollectionViewController<Model: NSManagedObject, Cell: UICollectionViewCell>: UIViewController, ConformsTo {
    @IBOutlet internal var collectionView: UICollectionView!
    
    private var objects: NSFetchedResultsController<Model>?
    private var changeActions = [ChangeAction]()
    
    internal var resetSelection = true
    
    internal var numberOfItems: Int {
        return objects?.fetchedObjects?.count ?? 0
    }
    internal var ignoreOffScreenUpdates = true
    internal var collectionLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    internal var allElements: [Model] {
        return objects?.fetchedObjects ?? []
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if collectionView == nil {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionLayout)
            collectionView.backgroundColor = UIColor.white
            collectionView.delegate = self
            collectionView.dataSource = self
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            } else {
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            }
            collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            collectionView.collectionViewLayout = collectionLayout
        }
        
        collectionView.registerCell(forType: Cell.self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard objects == nil else {
            return
        }
        
        objects = createFetchedController()
        objects?.delegate = self
        Log.debug("Have \(objects?.fetchedObjects?.count ?? 0) objects")
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    internal func createFetchedController() -> NSFetchedResultsController<Model> {
        fatalError()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return objects?.sections?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let controller = objects else {
            return 0
        }
        
        let sections:[NSFetchedResultsSectionInfo] = controller.sections! as [NSFetchedResultsSectionInfo]
        return sections[section].numberOfObjects
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as Cell
        let element = objects!.object(at: indexPath)
        configure(cell: cell, with: element, at: indexPath)
        return cell
    }
    
    internal func configure(cell: Cell, with object: Model, at indexPath: IndexPath) {
        Log.debug("Confugre cell at \(indexPath)")
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if resetSelection {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        let element = objects!.object(at: indexPath)
        tapped(element, at: indexPath)
    }
    
    internal func tapped(_ object: Model, at indexPath: IndexPath) {
        Log.debug("Tapped at \(indexPath)")
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.debug("controllerWillChangeContent")
        changeActions.removeAll()
        collectionView.setNeedsFocusUpdate()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        changeActions.append(ChangeAction(sectionIndex: sectionIndex, indexPath: nil, newIndexPath: nil, changeType: type))
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        changeActions.append(ChangeAction(sectionIndex: nil, indexPath: indexPath, newIndexPath: newIndexPath, changeType: type))
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.debug("controllerDidChangeContent: \(changeActions.count) changes")
        let updateClosure = {
            // update sections
            let sectionActions = self.changeActions.filter({ $0.sectionIndex != nil })
            Log.debug("\(sectionActions.count) section actions")
            
            let sectionInserts = sectionActions.filter({ $0.changeType == .insert }).map({ $0.sectionIndex! })
            self.collectionView.insertSections(IndexSet(sectionInserts))
            
            let sectionDeletes = sectionActions.filter({ $0.changeType == .delete }).map({ $0.sectionIndex! })
            self.collectionView.deleteSections(IndexSet(sectionDeletes))
            
            assert(sectionActions.filter({ $0.changeType != .insert && $0.changeType != .delete}).count == 0)
            
            let cellActions = self.changeActions.filter({ $0.sectionIndex == nil })
            Log.debug("\(cellActions.count) cell actions")
            
            for action in cellActions {
                switch(action.changeType) {
                case .update where action.indexPath == action.newIndexPath: // iOS11
                    self.collectionView.reloadItems(at: [action.indexPath!])
                case .update where action.newIndexPath != nil: // iOS11
                    self.collectionView.moveItem(at: action.indexPath!, to: action.newIndexPath!)
                case .update:
                    self.collectionView.reloadItems(at: [action.indexPath!])
                case .insert:
                    self.collectionView.insertItems(at: [action.newIndexPath!])
                case .delete:
                    self.collectionView.deleteItems(at: [action.indexPath!])
                case .move:
                    self.collectionView.moveItem(at: action.indexPath!, to: action.newIndexPath!)
                }
            }
        }
        
        let completion: (Bool) -> () = {
            finished in
            
            self.contentChanged()
        }
        
        collectionView.performBatchUpdates(updateClosure, completion: completion)
    }
    
    func contentChanged() {
        Log.debug("\(#function)")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        fatalError()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        
        checkContent()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkContent()
    }
    
    internal func checkContent() {
        Log.debug("Check content")
    }
    
    internal func element(at indexPath: IndexPath) -> Model {
        return objects!.object(at: indexPath)
    }
        
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension NSFetchedResultsChangeType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .insert:
            return "insert"
        case .delete:
            return "delete"
        case .move:
            return "move"
        case .update:
            return "update"
        }
    }
}
