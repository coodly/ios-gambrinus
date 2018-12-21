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

import UIKit
import ImageProvide

internal class ImageThumbnailAction: AfterAction {
    var key: String {
        return "\(Int(targetSize.width))x\(Int(targetSize.height))"
    }
    
    private let targetSize: CGSize
    internal init(size: CGSize) {
        targetSize = size
    }
    
    func process(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else {
            return data
        }
        
        guard let cropped = image.cropped(at: targetSize) else {
            return data
        }
        
        if let croppedData = cropped.jpegData(compressionQuality: 0.8) {
            return croppedData
        }
        
        return data
    }
}
