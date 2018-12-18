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

internal extension UICollectionView {
    internal func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }
    
    internal func registerCell<T: UICollectionViewCell>(forType type: T.Type) {
        register(T.viewNib(Bundle(for: T.self)), forCellWithReuseIdentifier: T.identifier())
    }
    
    internal func registerHeader<T: UICollectionReusableView>(forType type: T.Type) {
        register(T.viewNib(Bundle(for: T.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier())
    }
    
    internal func registerFooter<T: UICollectionReusableView>(forType type: T.Type) {
        register(T.viewNib(Bundle(for: T.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier())
    }
    
    internal func dequeueHeader<T: UICollectionReusableView>(at indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }
    
    internal func dequeueFooter<T: UICollectionReusableView>(at indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }
}
