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

internal extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.identifier()) as? T {
            return cell
        }
        
        register(T.viewNib(Bundle(for: T.self)), forCellReuseIdentifier: T.identifier())
        
        return dequeueReusableCell(withIdentifier: T.identifier()) as! T
    }
    
    func registerCell<T: UITableViewCell>(forType type: T.Type) {
        register(T.viewNib(Bundle.module), forCellReuseIdentifier: T.identifier())
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier(), for: indexPath) as! T
    }
}
