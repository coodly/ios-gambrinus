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
import BloggerAPI

private typealias Dependencies = ImagesConsumer & BloggerConsumer & PersistenceConsumer

internal class PostDetailsViewModel: Dependencies, UIInjector {
    var imagesSource: ImageSource! {
        didSet {
            DispatchQueue.main.async {
                self.performImageAsk()
            }
        }
    }
    var blogger: Blogger! {
        didSet {
            guard status.refreshNeeded, let id = status.postId else {
                return
            }
            
            refreshPost(id: id)
        }
    }
    var persistence: Persistence!
    
    internal struct Status {
        var image: UIImage? = nil
        var content: String? = ""
        var score = ""
        var showLoading = false
        var showContent: Bool {
            return content?.hasValue() ?? false
        }
        fileprivate var refreshNeeded = false
        fileprivate var postId: String?
        var untappdScore = ""
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
    internal var image: UIImage? {
        return status.image
    }
    
    private var imageAsk: ImageAsk?
    internal init(post: KioskCore.Post) {
        imageAsk = post.backdropAsk

        refreshStatus(from: post)
    }
    
    private func refreshStatus(from post: KioskCore.Post) {
        status.postId = post.postId
        status.refreshNeeded = post.contentRefreshNeeded
        status.content = post.body?.htmlBody
        status.score = post.rateBeerScore
        status.untappdScore = post.untappdScore
    }
    
    private func refreshPost(id: String, completion: (() -> Void)? = nil) {
        status.showLoading = status.content == nil
        blogger.fetchPost(id) {
            result in
            
            guard let post = result.post else {
                return
            }
            
            self.persistence.write() {
                context in
                
                let updated = context.update(remote: post)
                self.refreshStatus(from: updated)
                self.status.showLoading = false
                completion?()
            }
        }
    }
    
    internal func refreshWithoutLoader(completion: @escaping (() -> Void)) {
        guard let id = status.postId else {
            completion()
            return
        }
        
        refreshPost(id: id, completion: completion)
    }
    
    private func performImageAsk() {
        guard let ask = imageAsk else {
            return
        }
        
        imagesSource.retrieveImage(for: ask) {
            image in
            
            self.status.image = image
        }
    }
}
