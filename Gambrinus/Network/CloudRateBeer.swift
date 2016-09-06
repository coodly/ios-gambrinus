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

struct CloudRateBeer: RemoteRecord {
    var parent: CKRecordID?
    var recordData: Data?
    var recordName: String?
    static var recordType: String {
        return "RateBeer"
    }
    
    var alcohol: String?
    var aliasFor: CKReference?
    var brewer: CKReference?
    var name: String?
    var rbId: String?
    var score: String?
    var style: CKReference?
    var scoreUpdatedAt: Date?
    
    mutating func loadFields(from record: CKRecord) -> Bool {
        alcohol = record["alcohol"] as? String
        aliasFor = record["aliasFor"] as? CKReference
        brewer = record["brewer"] as? CKReference
        name = record["name"] as? String
        rbId = record["rbId"] as? String
        score = record["score"] as? String
        style = record["style"] as? CKReference
        scoreUpdatedAt = record["scoreUpdatedAt"] as? Date
        return true
    }
}
