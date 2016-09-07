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
import LaughingAdventure
import CloudKit

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
    
    lazy var objectModel: Gambrinus.ObjectModel = {
        return ObjectModel(context: self.persistence.mainContext)
    }()
    private lazy var imagesRetrieve: BlogImagesRetrieve = {
        return BlogImagesRetrieve()
    }()
    private lazy var contentUpdate: ContentUpdate = {
        let update = ContentUpdate()
        update.persisrtence = self.persistence
        return update
    }()
    private lazy var bloggerAPI: BloggerAPIConnection = {
        return BloggerAPIConnection(blogURLString:"http://tartugambrinus.blogspot.com/", bloggerKey:BloggerAPIKey, objectModel:self.objectModel)
    }()
    private lazy var gambrinusContainer: CKContainer = {
        return CKContainer(identifier: "iCloud.com.coodly.gambrinus")
    }()
    private lazy var beersContainer: CKContainer = {
        return CKContainer(identifier: "iCloud.com.coodly.beers")
    }()
    private lazy var persistence: CorePersistence = {
        return CorePersistence(modelName: "Gambrinus", wipeOnConflict: true)
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
        
        if var consumer = into as? BloggerAPIConsumer {
            consumer.bloggerAPI = bloggerAPI
        }
        
        if var consumer = into as? GambrinusContainerConsumer {
            consumer.gambrinusContainer = gambrinusContainer
        }
        
        if var consumer = into as? BeersContainerConsumer {
            consumer.beersContainer = beersContainer
        }
        
        if var consumer = into as? PersistenceConsumer {
            consumer.persisrtence = persistence
        }
    }
}
