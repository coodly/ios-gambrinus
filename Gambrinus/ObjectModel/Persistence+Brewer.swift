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
import LaughingAdventure
import CloudKit

extension NSManagedObjectContext {
    func brewer(for reference: CKReference?) -> Brewer? {
        guard let ref = reference else {
            return nil
        }
        
        guard let id = ref.recordID.recordName.components(separatedBy: "-").last else {
            return nil
        }
        
        if let existing: Brewer = fetchEntity(where: "identifier", hasValue: id as AnyObject) {
            return existing
        }
        
        let saved: Brewer = insertEntity()
        saved.identifier = id
        saved.dataNeededValue = true
        return saved
    }
}
