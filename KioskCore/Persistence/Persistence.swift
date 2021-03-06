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
import CoreDataPersistence

public class Persistence: CorePersistence {
    internal init() {
        super.init(modelName: "Kiosk", bundle: Bundle(identifier: "com.coodly.kiosk.core")!, wipeOnConflict: true)
    }
    
    public func maybeCopyDatabase(from source: URL) {
        Log.debug("Maybe copy database")
        guard let destination = sqliteFilePath else {
            Log.debug("No SQLite path")
            return
        }
        
        Log.debug("Copy to \(destination)")
        
        if FileManager.default.fileExists(atPath: destination.path) {
            Log.debug("File exists, no copy")
            return
        }
        
        do {
            try FileManager.default.copyItem(at: source, to: destination)
            Log.debug("Copied")
        } catch {
            Log.error("Copy error: \(error)")
        }
    }
}
