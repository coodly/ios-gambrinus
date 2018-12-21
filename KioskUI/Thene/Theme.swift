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

public class Theme {
    public static func apply() {
        UINavigationBar.appearance().isTranslucent = false
    }
}

internal extension UIColor {
    static let rateBeerBlue = UIColor(red: 5.0 / 255.0, green: 52.0 / 255.0, blue: 100.0 / 255.0, alpha: 1)
}

internal extension UIFont {
    internal static func ratebeerFont() ->  UIFont {
        let system = UIFont.preferredFont(forTextStyle: .headline)
        return UIFont(name: "Triplex-Bold", size: system.pointSize * 1.5)!
    }
}
