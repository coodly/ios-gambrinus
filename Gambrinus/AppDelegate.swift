/*
 * Copyright 2015 Coodly LLC
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
import LaughingAdventure

extension AppDelegate {
    func enableLogging() {
        Log.add(output: ConsoleOutput())
        Log.add(output: FileOutput())
        Log.logLevel = .debug
        
        LaughingAdventure.Logging.set(logger: LaughingDelegate())
    }

    func copyDatabase() {
        Log.debug("Copy database")
        let persistence = Injector.sharedInstance.persistence
        guard let sqlitePath = persistence.sqliteFilePath else {
            return
        }
        
        Log.debug("SQLite path: \(sqlitePath)")
        
        if FileManager.default.fileExists(atPath: sqlitePath.path) {
            Log.debug("DB file exists")
            return
        }
        
        guard let baseDataPath = Bundle.main.url(forResource: "Gambrinus", withExtension: "sqlite") else {
            Log.debug("No imput file")
            return
        }
        
        Log.debug("Will copy \(baseDataPath) to \(sqlitePath)")
        do {
            try FileManager.default.createDirectory(at: sqlitePath.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.copyItem(at: baseDataPath, to: sqlitePath)
        } catch let error as NSError {
            Log.error("DB copy failed: \(error)")
        }
    }
}

private class LaughingDelegate: Logger {
    func log<T>(_ object: T, file: String, function: String, line: Int) {
        Log.debug(object, file: file, function: function, line: line)
    }
}
