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
import KioskCore
import ImageProvide

internal class PostCellViewModel: ImagesConsumer {
    var imagesSource: ImageSource! {
        didSet {
            guard let ask = thumbnailAsk else {
                return
            }
            
            imagesSource.retrieveImage(for: ask) {
                image in
                
                self.status.thumbnail = image ?? Asset.placholder.image
            }
        }
    }
    
    internal struct Status {
        var formattedPostDate = ""
        var postTile = ""
        var thumbnail: UIImage? = nil
        var rbScore = ""
    }
    
    private var status = Status() {
        didSet {
            callback?(status)
        }
    }
    internal var callback: ((Status) -> Void)? {
        didSet {
            callback?(status)
        }
    }
    
    private let thumbnailAsk: ImageAsk?
    
    internal init(post: Post) {
        status.formattedPostDate = post.publishDateString() ?? ""
        status.postTile = post.title ?? ""
        status.rbScore = post.rateBeerScore
        
        thumbnailAsk = post.thumbnailAsk
    }
}
