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

protocol InjectionHandler {
    func inject(into: AnyObject)
}

extension InjectionHandler {
    func inject(into: AnyObject) {
        Injector.sharedInstance.inject(into: into)
    }
}

class Injector: NSObject {
    static let sharedInstance = Injector()
    
    lazy var objectModel: ObjectModel = {
        return ObjectModel()
    }()
    private lazy var imagesRetrieve: BlogImagesRetrieve = {
        return BlogImagesRetrieve()
    }()
    private lazy var contentUpdate: ContentUpdate = {
        let update = ContentUpdate(objectModel: self.objectModel)!
        update.bloggerAPIConnection = self.bloggerAPI
        return update
    }()
    private lazy var bloggerAPI: BloggerAPIConnection = {
        return BloggerAPIConnection(blogURLString:"http://tartugambrinus.blogspot.com/", bloggerKey:BloggerAPIKey, objectModel:self.objectModel)
    }()
    
    func inject(into: AnyObject) {
        if var consumer = into as? ObjectModelConsumer {
            consumer.objectModel = objectModel
        }
        
        if var consumer = into as? ImagesRetrieveConsumer {
            consumer.imagesRetrieve = imagesRetrieve
        }
        
        if var consumer = into as? ContentUpdateConsumer {
            consumer.contentUpdate = contentUpdate
        }
    }
}
