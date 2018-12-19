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
import UIKit
import ImageProvide

internal class PostDetailsViewModel: ImagesConsumer, UIInjector {
    var imagesSource: ImageSource! {
        didSet {
            guard let ask = imageAsk else {
                return
            }
            
            imagesSource.retrieveImage(for: ask) {
                image in
                
                self.status.image = image
            }
        }
    }
    
    internal struct Status {
        var image: UIImage? = nil
        var content: String? = ""
        var showLoading = false
        var showContent: Bool {
            return content?.hasValue() ?? false
        }
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
    
    private var imageAsk: ImageAsk?
    internal init(post: Post) {
        imageAsk = post.backdropAsk

        refreshStatus(from: post)
        
        if post.contentRefreshNeeded {
            refreshContent(on: post)
        }
    }
    
    private func refreshStatus(from post: Post) {
        status.content = post.body?.htmlBody
    }
    
    private func refreshContent(on post: Post) {
        status.showLoading = true
        Log.debug("Refresh content")
        let request = RefreshPostRequest(post: post)
        inject(into: request)
        request.execute()
    }
}