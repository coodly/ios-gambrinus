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

class Injector {
    static let sharedInstance = Injector()
    
    var fetch: NetworkFetch!
    var apiKey: String!
    var blogId: String?
    private var bloggerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func inject(into: AnyObject) {
        if var consumer = into as? FetchConsumer {
            consumer.fetch = fetch
        }
        
        if var consumer = into as? KeyConsumer {
            consumer.apiKey = apiKey
        }
        
        if var consumer = into as? BlogIdConsumer {
            consumer.blogId = blogId!
        }
        
        if var consumer = into as? DateFormatterConsumer {
            consumer.dateFormatter = bloggerDateFormatter
        }
    }
}
