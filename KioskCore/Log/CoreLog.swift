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
import Puff

public class CoreLog {
    public static func enableLogs() {
        guard AppConfig.current.logs else {
            return
        }
        
        SWLogger.Log.logLevel = .debug
        
        SWLogger.Log.add(output: ConsoleOutput())
        #if os(iOS)
        SWLogger.Log.add(output: FileOutput())
        #endif
        
        CoreDataPersistence.Logging.set(logger: CoreLogger())
        ImageProvide.Logging.set(logger: ImageLogger())
        BloggerAPI.Logging.set(logger: BloggerLogger())
        Puff.Logging.set(logger: PuffLogger())
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
}

private class BloggerLogger: BloggerAPI.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}

private class PuffLogger: Puff.Logger {
    func log<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        CoreLog.debug(object, file: file, function: function, line: line)
    }
}
