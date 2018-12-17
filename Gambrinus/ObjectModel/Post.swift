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
import CoreData

class Post: NSManagedObject {
    struct Satic {
        static let postDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
        
        shadowTitle = title
    }
    
    override func willSave() {
        super.willSave()
        
        guard let title = self.title, title.hasValue() else {
            return
        }
        
        if let shadow = shadowTitle, shadow == title {
            return
        }
        
        shadowTitle = title
        
        let normalized = title.normalize()
        normalizedTitle = normalized
    }
    
    func rateBeerScore() -> String {
        let unaliased = unaliasedBeers()
        if unaliased.count == 0 {
           return ""
        }
        
        if unaliased.count > 1 {
            return "*"
        }
        
        if let beer = unaliased.first, let score = beer.rbScore {
            return score
        }
        
        return ""
    }

    private func unaliasedBeers() -> [Beer] {
        guard let beers = self.beers else {
            return []
        }
        
        return beers.filter({ !$0.aliased })
    }
    
    func markTouched() {
        touchedAt = Date()
    }
    
    func topScoredBeer() -> Beer? {
        guard let beers = self.beers else {
            return nil
        }
        
        if beers.count == 0 {
            return nil
        }
        
        if beers.count == 1 {
            return beers.first
        }
        
        return beers.sorted(by: {
            first, second in
            
            if first.rbScore == nil && second.rbScore == nil {
                return true
            }
            
            if first.rbScore != nil && second.rbScore == nil {
                return true
            }
            
            if first.rbScore == nil && second.rbScore != nil {
                return false
            }
            
            return first.rbScore! > second.rbScore!
        }).first
    }
    
    func publishDateString() -> String? {
        guard let date = publishDate else {
            return nil
        }
        
        return Post.Satic.postDateFormatter.string(from: date)
    }
    
    func thumbnailImageAsk() -> BlogImageAsk? {
        guard let image = self.image, let imageURLString = image.imageURLString else {
            return nil
        }
        
        let askSize = RunningOnPad ? CGSize(width: 240, height: 240) : CGSize(width: 150, height: 150)
        return BlogImageAsk(post: self.objectID, size: askSize, imageURLString: imageURLString, attemptRemovePull: image.shouldTryRemote())
    }

    func postImageAsk() -> BlogImageAsk? {
        guard let image = self.image, let imageURLString = image.imageURLString else {
            return nil
        }
        
        let askSize = RunningOnPad ? CGSize(width: 600, height: 600) : CGSize(width: 300, height: 150)
        let ask = BlogImageAsk(post: objectID, size: askSize, imageURLString: imageURLString, attemptRemovePull: image.shouldTryRemote())!
        if RunningOnPad {
            ask.imageMode = .scaleAspectFit
        } else {
            ask.imageMode = .scaleAspectFill
        }
        return ask
    }

    func originalImageAsk() -> BlogImageAsk? {
        guard let image = self.image, let imageURLString = image.imageURLString else {
            return nil
        }
        
        return BlogImageAsk(post: objectID, size: .zero, imageURLString: imageURLString, attemptRemovePull: image.shouldTryRemote())
    }
    
    func updateSearchMeta() {
        updateTopScore()
        guard let beers = self.beers else {
            return
        }
        updateSearchNames(with: Array(beers))
        updateSearchBrewers(with: Array(beers))
        updateSearchStyles(with: Array(beers))
        isDirty = false
    }

    private func updateSearchStyles(with: [Beer]) {
        let styles = Set(with.compactMap({ $0.style }))
        let styleNames = styles.compactMap({ $0.normalizedName }).sorted()
        combinedStyles = styleNames.joined(separator: "|")
    }

    private func updateSearchBrewers(with: [Beer]) {
        let brewers = Set(with.compactMap({ $0.brewer }))
        let brewerNames = brewers.compactMap({ $0.normalizedName }).sorted()
        combinedBrewers = brewerNames.joined(separator: "|")
    }
    
    private func updateSearchNames(with beers: [Beer]) {
        let names = beers.compactMap({ $0.normalizedName }).sorted()
        combinedBeers = names.joined(separator: "|")
    }
    
    private func updateTopScore() {
        guard let top = topScoredBeer() else {
            return
        }
        
        guard let score = top.rbScore else {
            return
        }
        
        topScore = Int(score) as NSNumber?
    }
}
