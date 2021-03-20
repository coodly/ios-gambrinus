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
import CommonCrypto

internal typealias AskCompletionClosure = (PlatformImage?) -> ()
internal typealias CacheKey = String

public class ImageAsk {
    private var actions = [AfterAction]()
    internal var actionsCount: Int {
        actions.count
    }
    internal var preceding: ImageAsk?
    internal var lastAction: AfterAction? {
        actions.last
    }

    public let url: URL
    internal let placeholder: ImageAsk?
    public init(url: URL, placeholder: ImageAsk? = nil) {
        self.url = url
        self.placeholder = placeholder
    }
    
    private init(url: URL, placeholder: ImageAsk?, actions: [AfterAction]) {
        self.url = url
        self.placeholder = placeholder
        self.actions = actions
    }
    
    internal var cacheKey: CacheKey {
        let path = url.absoluteString
        var key = path
        actions.forEach() {
            key = key.appendingFormat("#%@", $0.key)
        }
        return key.normalized()
    }
    
    public func append(action: AfterAction) {
        actions.append(action)
    }
    
    internal var actionChain: ActionsChain {
        var steps = [ImageAsk]()
        for index in 0...actions.count {
            let actions = Array(self.actions.prefix(index))
            let current = ImageAsk(url: url, placeholder: placeholder, actions: actions)
            current.preceding = steps.last
            steps.append(current)
        }
        
        return ActionsChain(steps: steps)
    }
}

private let MaxLength = 255

private extension String {
    static let replaced = [" ", ":", "/", "?", "=", "*"]
    
    func normalized() -> String {
        var normalized = self
        
        for replace in String.replaced {
            normalized = normalized.replacingOccurrences(of: replace, with: "_")
        }
        
        guard normalized.count > MaxLength else {
            return normalized
        }
        
        let hashedLength = normalized.count - MaxLength + Int(CC_MD5_DIGEST_LENGTH) * 2
        let chopOff = normalized.count - hashedLength
        let chopIndex = normalized.index(normalized.startIndex, offsetBy: chopOff)
        let hashed = String(normalized[chopIndex..<normalized.endIndex]).md5!
        
        let start = String(normalized[..<chopIndex])
        
        return start + hashed
    }
    
    private var md5: String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

