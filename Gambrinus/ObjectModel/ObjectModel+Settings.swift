/*
 * Copyright 2015 Coodly LLC
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

enum Key: Int {
    case lastVerifiedPullDate
    case sortOrder
}

enum PostsSortOrder: Int {
    case byDateDesc
    case byDateAsc
    case byPostName
    case byRBBeerName
    case byRBScore
    case byStyle
    case byBrewer
    
    func reversed() -> PostsSortOrder? {
        switch self {
        case .byDateAsc:
            return .byDateDesc
        case .byDateDesc:
            return .byDateAsc
        default:
            return nil
        }
    }
}

extension ObjectModel {
    func sortOrder() -> PostsSortOrder {
        if let setting = setting(for: .sortOrder), let code = Int(setting.value), let value = PostsSortOrder(rawValue: code) {
            return value
        }
        
        return .byDateDesc
    }
    
    func setSortOrder(_ value: PostsSortOrder) {
        let saved: Setting = setting(for: .sortOrder) ?? managedObjectContext.insertEntity()
        saved.key = NSNumber(integerLiteral: Key.sortOrder.rawValue)
        saved.value = "\(value.rawValue)"

        saveContext() {
            NotificationCenter.default.post(name: Notification.Name("GambrinusSortOrderChangedNotification"), object: nil)
        }
    }
    
    func lastKnownPullDate() -> Date {
        return date(for: .lastVerifiedPullDate)
    }
    
    func setPostsRefreshTime(_ date: Date) {
        save(date: date, for: .lastVerifiedPullDate)
    }
    
    private func save(date: Date, for key: Key) {
        let saved = setting(for: key) ?? managedObjectContext.insertEntity()
        saved.key = NSNumber(integerLiteral: key.rawValue)
        saved.value = (date as NSDate).iso8601String()
    }
    
    private func date(for key: Key, defaultValue: Date = Date.distantPast) -> Date {
        if let existing = setting(for: key) {
            return existing.dateValue()
        }
        
        return defaultValue
    }
    
    private func setting(for key: Key) -> Setting? {
        return managedObjectContext.fetchEntity(where: "key", hasValue: key.rawValue as AnyObject)
    }
}
