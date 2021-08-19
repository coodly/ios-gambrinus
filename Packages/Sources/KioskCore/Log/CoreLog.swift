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
import SWLogger
import CoreDataPersistence
import ImageProvide
import BloggerAPI
import PuffLogger

public class CoreLog {
    public static func enableLogs() {
        guard AppConfig.current.logs else {
            return
        }
        
        SWLogger.Log.level = .debug
        
        SWLogger.Log.add(output: ConsoleOutput())
        #if os(iOS)
        SWLogger.Log.add(output: FileOutput())
        #endif
        
        CoreDataPersistence.Logging.set(logger: CoreLogger())
        ImageProvide.Logging.set(logger: ImageLogger())
        BloggerAPI.Logging.set(logger: BloggerLogger())
        PuffLogger.Logging.set(logger: PuffedLogger())
    }
    
    public static func debug<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        SWLogger.Log.debug(object, file: file, function: function, line: line)
    }
    
    public static func error<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        SWLogger.Log.error(object, file: file, function: function, line: line)
    }
}

internal class Log {
    internal static func debug<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
    
    internal static func error<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.error(object, file: file, function: function, line: line)
    }
    
    internal static let image = SWLogger.Logging(name: "Image")
}

internal class Logging {
    internal static func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}

private class CoreLogger: CoreDataPersistence.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}

private class ImageLogger: ImageProvide.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
    
    func debug<T>(_ object: T, file: String, function: String, line: Int) {
        Log.image.debug(object, file: file, function: function, line: line)
    }
    
    func error<T>(_ object: T, file: String, function: String, line: Int) {
        Log.image.error(object, file: file, function: function, line: line)
    }
    
    func verbose<T>(_ object: T, file: String, function: String, line: Int) {
        Log.image.verbose(object, file: file, function: function, line: line)
    }
}

private class BloggerLogger: BloggerAPI.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}

private class PuffedLogger: PuffLogger.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}
