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

import Foundation
import CoreData

public class MissingDetailsMonitor: NSObject, PersistenceConsumer, CoreInjector {
    public var persistence: Persistence!
    private lazy var pullQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .utility
        return queue
    }()
    
    private var fetchedController: NSFetchedResultsController<SyncStatus>!
    
    public func load() {
        Log.debug("Load missing details monitor")
        fetchedController = persistence.mainContext.fetchedControllerForStatusesNeedingSync()
        fetchedController.delegate = self
        queueCheckOperation()
    }
    
    private func queueCheckOperation() {
        pullQueue.addOperation() {
            self.checkPullNeeded()
        }
    }
    
    private func checkPullNeeded() {
        Log.debug("Check pull needed")
        persistence.performInBackground() {
            context in
            
            let operation: Operation?
            if context.isMissingDetails(for: Beer.self) {
                Log.debug("Missing details on Beer")
                operation = PullBeersInfoOperation()
            } else if context.isMissingDetails(for: Brewer.self) {
                Log.debug("Missing details on Brewer")
                operation = nil
            } else if context.isMissingDetails(for: BeerStyle.self) {
                Log.debug("Missing details on BeerStyle")
                operation = nil
            } else {
                operation = nil
            }
            
            guard let run = operation else {
                Log.debug("Nothign to pull")
                return
            }
            
            self.inject(into: run)
            self.pullQueue.addOperation(run)
        }
    }
}

extension MissingDetailsMonitor: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        queueCheckOperation()
    }
}
