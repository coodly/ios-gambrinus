/*
 * Copyright 2019 Coodly LLC
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

internal class AppPresentationViewController: UIViewController {
    @IBOutlet private var container: UIView!
    
    private var initializationController: InitializeViewController {
        return children.compactMap({ $0 as? InitializeViewController }).first!
    }
    
    internal var afterLoad: ((InitializeViewController) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterLoad(initializationController)
    }
    
    internal func replace(with controller: UIViewController) {
        addChild(controller)
        
        container.insertSubview(controller.view, at: 0)
        
        UIView.transition(from: initializationController.view, to: controller.view, duration: 0.3, options: .transitionCrossDissolve) {
            _ in
            
            self.initializationController.removeFromParent()
        }
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return [.portrait]
        }
    }
}
