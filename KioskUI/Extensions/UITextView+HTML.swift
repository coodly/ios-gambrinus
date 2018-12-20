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

extension UITextView {
    internal func load(html: String) {
        let loaded = html.cleaned
        let imagesHidden =
        
        """
        <html>
        <style>
        img {display: none;}
        </style>
        \(loaded)
        </html>
        """
        
        if let data = imagesHidden.data(using: .utf8), let attributed = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            attributes[NSAttributedString.Key.foregroundColor] = textColor
            
            if textAlignment == .center {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                attributes[NSAttributedString.Key.paragraphStyle] = paragraph
            } else {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .natural
                attributes[NSAttributedString.Key.paragraphStyle] = paragraph
            }
            
            attributed.mark(attributed.string, with: attributes)
            attributedText = attributed
        } else {
            text = html
        }
    }
}

extension String {
    internal var cleaned: String {
        var result = self.replace("\n", with: "<br />")
        result = result.replace("<div>", with: "")
        result = result.replace("</div>", with: "")
        result = result.replace("<br /><br /><br />", with: "<br /><br />")
        return result
    }
    
    private func replace(_ searched: String, with value: String) -> String {
        var result = self
        while result.range(of: searched) != nil {
            result = result.replacingOccurrences(of: searched, with: value)
        }
        return result
    }
}
