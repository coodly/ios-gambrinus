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

enum Key: Int {
    case lastVerifiedPullDate
    case sortOrder
    case lastKnownMappingTime
    case lastKnownScoresTime
    case lastKnownUntsappdScoresTime
}

public enum PostsSortOrder: Int {
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

extension NSManagedObjectContext {
    public var sortOrder: PostsSortOrder {
        get {
            if let setting = setting(for: .sortOrder), let stringValue = setting.value, let code = Int(stringValue), let value = PostsSortOrder(rawValue: code) {
                return value
            }
            
            return .byDateDesc
        }
        set {
            let oldValue = sortOrder
            
            guard oldValue != newValue else {
                return
            }
            
            let saved: Setting = setting(for: .sortOrder) ?? insertEntity()
            saved.key = NSNumber(integerLiteral: Key.sortOrder.rawValue)
            saved.value = "\(newValue.rawValue)"
            
            NotificationCenter.default.post(name: .postsSortChanged, object: nil)
        }
    }
    
    internal var lastKnownPullDate: Date {
        get {
            return date(for: .lastVerifiedPullDate)
        }
        set {
            save(date: newValue, for: .lastVerifiedPullDate)
        }
    }
    internal var lastKnownMappingTime: Date {
        get {
            return date(for: .lastKnownMappingTime)
        }
        set {
            save(date: newValue, for: .lastKnownMappingTime)
        }
    }
    internal var lastKnownScoresTime: Date {
        get {
            return date(for: .lastKnownScoresTime)
        }
        set {
            save(date: newValue, for: .lastKnownScoresTime)
        }
    }
    internal var lastKnownUntsappdScoresTime: Date {
        get {
            return date(for: .lastKnownUntsappdScoresTime)
        }
        set {
            save(date: newValue, for: .lastKnownUntsappdScoresTime)
        }
    }

    private func save(date: Date, for key: Key) {
        let saved = setting(for: key) ?? insertEntity()
        saved.key = NSNumber(integerLiteral: key.rawValue)
        saved.value = date.iso8601String()
    }
    
    private func date(for key: Key, defaultValue: Date = Date.distantPast) -> Date {
        if let existing = setting(for: key), let date = existing.dateValue {
            return date
        }
        
        return defaultValue
    }
    
    private func setting(for key: Key) -> Setting? {
        return fetchEntity(where: "key", hasValue: key.rawValue as AnyObject)
    }
}
