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
import Fabric
import Crashlytics
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PersistenceConsumer, MissingDetailsConsumer {
    var persistence: Persistence!
    var missingMonitor: MissingDetailsMonitor!
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        CoreLog.enableLogs()
        
        CoreInjection.sharedInstance.inject(into: self)
        
        let presentaion = window!.rootViewController as! AppPresentationViewController
        
        Theme.apply()
        
        if let path = Bundle.main.url(forResource: "Kiosk", withExtension: "sqlite") {
            persistence.maybeCopyDatabase(from: path)
        } else {
            CoreLog.debug("No seed DB included")
        }
        
        func presentMain() {
            persistence.write() {
                context in
                
                context.resetFailedStatuses()
            }

            missingMonitor.load()
            
            let menu: MenuViewController = Storyboards.loadFromStoryboard()
            CoreInjection.sharedInstance.inject(into: menu)

            let navigation: MenuNavigationViewController = Storyboards.loadFromStoryboard()
            navigation.menuController = menu
            
            let posts: PostsViewController = Storyboards.loadFromStoryboard()
            CoreInjection.sharedInstance.inject(into: posts)
            navigation.present(root: posts, animated: false)
            
            presentaion.replace(with: navigation)
        }
        
        presentaion.afterLoad = {
            initialization in
            
            CoreInjection.sharedInstance.inject(into: initialization)
            initialization.afterLoad = presentMain
            
            if false, #available(iOS 10.0, *) {
                let subscription = CloudSubscription()
                subscription.subscribe()
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.isIdleTimerDisabled = true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let cloudNotification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        CoreLog.debug("didReceiveRemoteNotification: \(cloudNotification)")
        
        guard application.applicationState == .active else {
            return
        }
        
        NotificationCenter.default.post(name: .postsModification, object: nil)
    }
}

