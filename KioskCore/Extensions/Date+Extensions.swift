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

extension Date {
    internal func iso8601String() -> String {
        return DateFormatter.iso8601Formatter.string(from: self)
    }
    internal static func dateFromISO8601String(_ string: String) -> Date? {
        return DateFormatter.iso8601Formatter.date(from: string)
    }
}
