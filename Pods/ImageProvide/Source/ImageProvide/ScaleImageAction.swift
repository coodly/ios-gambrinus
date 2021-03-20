/*
* Copyright 2020 Coodly LLC
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

#if os(iOS) || os(tvOS)
import Foundation
import CoreGraphics
import UIKit

public class ScaleImageAction: AfterAction {
    public lazy var key: String = "\(Int(self.size.width))x\(Int(self.size.height))x\(self.mode.rawValue)"
    
    private let size: CGSize
    private let mode: Mode
    public init(size: CGSize, mode: Mode) {
        self.size = size
        self.mode = mode
    }
    
    public func process(_ image: PlatformImage) -> PlatformImage? {
        guard image.size.width > size.width || image.size.height > size.height else {
            return image
        }
        
        let renderRect = mode.apply(rect: CGRect(origin: .zero, size: image.size), target: CGRect(origin: .zero, size: size))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        image.draw(in: renderRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public enum Mode: String {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }

}

extension ImageAsk {
    public func scaled(to size: CGSize, mode: ScaleImageAction.Mode) -> ImageAsk {
        if size != .zero {
            append(action: ScaleImageAction(size: size, mode: mode))
        }
        return self
    }
}
#endif
