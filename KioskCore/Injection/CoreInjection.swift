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

import ImageProvide
import BloggerAPI
import CloudKit

internal protocol CoreInjector {
    func inject(into object: AnyObject)
}

internal extension CoreInjector {
    func inject(into object: AnyObject) {
        CoreInjection.sharedInstance.inject(into: object)
    }
}

public class CoreInjection {
    public static let sharedInstance = CoreInjection()
    
    private lazy var persistence = Persistence()
    private lazy var networkQueue = NetworkQueue()
    private lazy var appQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    private lazy var images = ImageSource(fetch: ImagesFetch(queue: self.networkQueue, appQueue: self.appQueue))
    private lazy var blogger = Blogger(blogURL: "http://tartugambrinus.blogspot.com", key: BloggerAPIKey, fetch: BloggerFetch(queue: self.networkQueue, appQueue: self.appQueue))
    private lazy var gambrinusContainer = CKContainer(identifier: "iCloud.com.coodly.gambrinus")
    private lazy var beersContainer = CKContainer(identifier: "iCloud.com.coodly.beers")

    public func inject(into object: AnyObject) {
        if var consumer = object as? PersistenceConsumer {
            consumer.persistence = persistence
        }
        
        if var consumer = object as? ImagesConsumer {
            consumer.imagesSource = images
        }
        
        if var consumer = object as? BloggerConsumer {
            consumer.blogger = blogger
        }
        
        if var consumer = object as? AppQueueConsumer {
            consumer.appQueue = appQueue
        }
        
        if var consumer = object as? GambrinusContainerConsumer {
            consumer.gambrinusContainer = gambrinusContainer
        }
        
        if var consumer = object as? BeersContainerConsumer {
            consumer.beersContainer = beersContainer
        }
    }
}
