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
import WebKit

internal class PostDetailsPresentationView: UIView, ScrollPresented {
    @IBOutlet var presentationWidth: NSLayoutConstraint!
    
    @IBOutlet private(set) var image: UIImageView!
    @IBOutlet private(set) var content: UITextView!
    @IBOutlet private(set) var loadingContainer: UIView!
    @IBOutlet private(set) var score: RateBeerScoreLabel!
    @IBOutlet private var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spinner.color = .myOrange
        image.backgroundColor = .controllerBackground
        
        content.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear]
    }
}
