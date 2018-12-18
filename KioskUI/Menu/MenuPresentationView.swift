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

internal class MenuPresentationView: UIView {
    @IBOutlet private(set) var dimView: UIView!
    @IBOutlet private(set) var menuContainer: UIView!
    @IBOutlet private var menuWidth: NSLayoutConstraint!
    @IBOutlet private var menuLeading: NSLayoutConstraint!
    
    func reset() {
        menuLeading.constant = -menuWidth.constant
        dimView.alpha = 0
    }
    
    func animateIn() {
        dimView.alpha = 0.5
        menuLeading.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func animateOut(completion: @escaping (() -> Void)) {
        menuLeading.constant = -menuWidth.constant
        let animation = {
            self.dimView.alpha = 0
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.3, animations: animation) {
            _ in
            
            completion()
        }
    }
}
