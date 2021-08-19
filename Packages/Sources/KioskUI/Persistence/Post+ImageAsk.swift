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
import ImageProvide
import KioskCore
import UIKit

extension Post {
    internal var thumbnailAsk: ImageAsk? {
        guard let image = self.image else {
            return nil
        }
        
        guard let url = image.imageURL else {
            return nil
        }
        
        return ImageAsk(url: url)
            .scaled(to: CGSize(width: 300, height: 300), mode: .aspectFill)
    }
    
    internal var backdropAsk: ImageAsk? {
        guard let image = self.image else {
            return nil
        }
        
        guard let url = image.imageURL else {
            return nil
        }
        
        return ImageAsk(url: url)
    }
}
