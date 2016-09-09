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

extension Post {
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
    
    func updateSearchMeta() {
        updateTopScore()
        guard let beers = self.beers else {
            return
        }
        updateSearchNames(with: Array(beers))
        updateSearchBrewers(with: Array(beers))
        updateSearchStyles(with: Array(beers))
        isDirtyValue = false
    }

    private func updateSearchStyles(with: [Beer]) {
        let styles = Set(with.flatMap({ $0.style }))
        let styleNames = styles.flatMap({ $0.normalizedName }).sorted()
        combinedStyles = styleNames.joined(separator: "|")
    }

    private func updateSearchBrewers(with: [Beer]) {
        let brewers = Set(with.flatMap({ $0.brewer }))
        let brewerNames = brewers.flatMap({ $0.normalizedName }).sorted()
        combinedBrewers = brewerNames.joined(separator: "|")
    }
    
    private func updateSearchNames(with beers: [Beer]) {
        let names = beers.flatMap({ $0.normalizedName }).sorted()
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
