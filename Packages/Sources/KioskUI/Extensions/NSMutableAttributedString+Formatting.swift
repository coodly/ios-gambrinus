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

extension NSMutableAttributedString {
    func mark(_ substring: String, with attributes: [NSAttributedString.Key: Any]) {
        guard let range = string.range(of: substring) else {
            return
        }
        
        let start = string.distance(from: string.startIndex, to: range.lowerBound)
        let length = string.distance(from: range.lowerBound, to: range.upperBound)
        let markedRange = NSMakeRange(start, length)
        addAttributes(attributes, range: markedRange)
    }
}
