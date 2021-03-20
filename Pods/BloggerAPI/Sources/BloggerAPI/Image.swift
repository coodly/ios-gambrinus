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

public struct Image: Codable {
    public let url: URL
    
    public var largeImageURL: URL {
        guard url.absoluteString.range(of: "blogspot.com") != nil else {
            return url
        }

        let imageName = url.lastPathComponent
        let withoutName = url.deletingLastPathComponent()
        let withoutSizeMarker = withoutName.deletingLastPathComponent()
        let withSizeMarker = withoutSizeMarker.appendingPathComponent("s1600", isDirectory: true)
        let withName = withSizeMarker.appendingPathComponent(imageName)
        
        return withName
    }
}
