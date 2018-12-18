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
import KioskUI
import KioskCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PersistenceConsumer {
    var persistence: Persistence!
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreLog.enableLogs()
        
        CoreInjection.sharedInstance.inject(into: self)
        
        let initialization = window!.rootViewController as! InitializeViewController
        CoreInjection.sharedInstance.inject(into: initialization)
        
        if let path = Bundle.main.url(forResource: "Kiosk", withExtension: "sqlite") {
            persistence.maybeCopyDatabase(from: path)
        } else {
            CoreLog.debug("No seed DB included")
        }
        
        initialization.afterLoad = {
            
            let menu: MenuViewController = Storyboards.loadFromStoryboard()

            let navigation: MenuNavigationViewController = Storyboards.loadFromStoryboard()
            navigation.menuController = menu
            
            let posts: PostsViewController = Storyboards.loadFromStoryboard()
            CoreInjection.sharedInstance.inject(into: posts)
            navigation.present(root: posts, animated: false)
            
            let animation: (() -> ()) = {
                self.window?.rootViewController = navigation
            }
            UIView.transition(with: self.window!, duration: 0.3, options: [], animations: animation) {
                _ in
                
            }
        }
        
        return true
    }
}

