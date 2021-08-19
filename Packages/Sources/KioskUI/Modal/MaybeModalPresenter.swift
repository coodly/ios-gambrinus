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

private extension UIViewController {
    var isContainedInModalDetails: Bool {
        var checked = parent
        while checked != nil {
            if checked is ModalPresentationViewController {
                return true
            }
            
            checked = checked?.parent
        }
        return false
    }
}

internal protocol MaybeModalPresenter: ModalPresenter {
    func presentMaybeModal(controller: UIViewController)
}

internal extension MaybeModalPresenter where Self: UIViewController {
    func presentMaybeModal(controller: UIViewController) {
        if isContainedInModalDetails || traitCollection.horizontalSizeClass == .compact {
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let navigation = UINavigationController(rootViewController: controller)
            present(modal: navigation)
        }
    }
}
