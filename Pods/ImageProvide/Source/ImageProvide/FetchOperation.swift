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

internal class FetchOperation: ConcurrentOperation, LocalImageResolver {
    private let fetch: RemoteFetch
    private let repository: LocalRepository
    internal let ask: ImageAsk
    private let completion: ImageClosure
    
    init(fetch: RemoteFetch, ask: ImageAsk, repository: LocalRepository, completion: @escaping ImageClosure) {
        self.fetch = fetch
        self.ask = ask
        self.repository = repository
        self.completion = completion
    }
    
    override func main() {
        let processedKey = ask.cacheKey
        if hasImage(for: processedKey) {
            Logging.verbose("Fetch local processed image")
            DispatchQueue.global(qos: .background).async {
                let image = self.image(for: processedKey)
                self.completeOnMain(with: image)
            }
            return
        }
        
        let chain = ask.actionChain
        chain.repository = repository
        process(chain: chain)
    }
    
    private func process(chain: ActionsChain, withFetch: Bool = true) {
        if chain.canResolveIn(repository: repository) {
            Logging.debug("Can resolve locally")
            chain.process(completion: completeOnMain(with:))
        } else if withFetch, let first = chain.steps.first {
            Logging.verbose("No local data. Pull")
            remoteFetch(of: first, chain: chain)
        } else {
            Logging.error("No data and no pull")
        }
    }
    
    private func remoteFetch(of ask: ImageAsk, chain: ActionsChain) {
        fetch.fetchImage(for: ask) {
            data, response, error in
            
            if let error = error {
                Logging.error("Fetch data error: \(error)")
                self.completeOnMain(with: nil)
                return
            }
            
            guard let data = data else {
                Logging.error("No data fetched")
                self.completeOnMain(with: nil)
                return
            }
            
            self.save(data, for: ask.cacheKey)
            self.process(chain: chain, withFetch: false)
        }
    }
    
    private func completeOnMain(with image: PlatformImage?) {
        DispatchQueue.main.async {
            self.completion(image)
            self.finish()
        }
    }
}
