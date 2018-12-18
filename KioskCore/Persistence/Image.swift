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
import CoreData

class Image: NSManagedObject {
    func markPullFailed() {
        let status = myPullStatus()
        status.pullFailed = true
        status.lastPullAttempt = Date()
    }

    func markPullSuccess() {
        let status = myPullStatus()
        status.pullFailed = false
    }

    private func myPullStatus() -> PullStatus {
        return pullStatus ?? managedObjectContext!.insertEntity()
    }
    
    func shouldTryRemote() -> Bool {
        guard let status = pullStatus else {
            return true
        }
        
        if !status.pullFailed {
            return true
        }
        
        let oneHourAgo = Date().addingTimeInterval(-60 * 60)
        return status.lastPullAttempt! > oneHourAgo
    }
}
