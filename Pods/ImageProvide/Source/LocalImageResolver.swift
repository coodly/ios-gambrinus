/*
 * Copyright 2017 Coodly LLC
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

private class CachePath {
    fileprivate static let path: URL = {
        let identifier = Bundle.main.bundleIdentifier!
        let cache = "\(identifier).images"
        let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
        let imageCacheFolder = cachesFolder.appendingPathComponent(cache)
        if !FileManager.default.fileExists(atPath: imageCacheFolder.path) {
            do {
                try FileManager.default.createDirectory(at: imageCacheFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {}
        }
        
        Logging.log("Images cache at \(imageCacheFolder.absoluteString)")
        
        return imageCacheFolder
    }()
}

public protocol LocalImageResolver {
    func hasImage(for ask: ImageAsk) -> Bool
    func image(for ask: ImageAsk) -> UIImage?
}

public extension LocalImageResolver {
    func hasImage(for ask: ImageAsk) -> Bool {
        return hasImage(for: ask.cacheKey(withActions: true))
    }
    
    func image(for ask: ImageAsk) -> UIImage? {
        return image(for: ask.cacheKey(withActions: true))
    }
}

internal extension LocalImageResolver {
    internal func hasImage(for key: CacheKey) -> Bool {
        let path = localPath(for: key)
        return FileManager.default.fileExists(atPath: path.path)
    }
    
    internal func image(for key: CacheKey) -> UIImage? {
        if let data = data(for: key), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    internal func data(for key: CacheKey) -> Data? {
        let path = localPath(for: key)
        return try? Data(contentsOf: path)
    }

    fileprivate func localPath(for key: CacheKey) -> URL {
        return cachePath().appendingPathComponent(key)
    }
    
    private func cachePath() -> URL {
        return CachePath.path
    }
    
    internal func save(_ data: Data, for key: CacheKey) {
        let path = localPath(for: key)
        do {
            try data.write(to: path, options: .atomicWrite)
        } catch let error as NSError {
            Logging.log("Image save error: \(error)")
        }
    }
}
