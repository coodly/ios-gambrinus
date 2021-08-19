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

import UIKit

private extension Selector {
    static let adjustFont = #selector(RateBeerScoreLabel.adjustFont)
}

internal class RateBeerScoreLabel: UILabel {
    private var usedFont: UIFont = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            updatePresentation()
        }
    }
    internal var value: String = "" {
        didSet {
            updatePresentation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        transform = CGAffineTransform.identity.rotated(by: .pi / 4)
        backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: .adjustFont, name: UIContentSizeCategory.didChangeNotification, object: nil)
        adjustFont()
    }
    
    @objc fileprivate func adjustFont() {
        usedFont = UIFont.ratebeerFont()
    }
    
    private func updatePresentation() {
        let score = value == "-1" ? "-" : value
        
        guard score.hasValue() else {
            text = ""
            return
        }
        
        let presented = "rb:\(score)"
        let atteributed = NSMutableAttributedString(string: presented)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.rateBeerBlue
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 2
        
        atteributed.mark(presented, with:
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: usedFont,
                NSAttributedString.Key.shadow: shadow
            ])
        self.attributedText = atteributed
    }
}
