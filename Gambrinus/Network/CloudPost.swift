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
import LaughingAdventure
import CloudKit

struct CloudPost: RemoteRecord {
    var parent: CKRecord.ID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "Post"
    }
    
    var identifier: String?
    var rateBeers: [String]?
    var modificationDate: Date?

    mutating func loadFields(from record: CKRecord) -> Bool {
        identifier = record["identifier"] as? String
        rateBeers = record["rateBeers"] as? [String]
        modificationDate = record.modificationDate
        
        return true
    }
}
