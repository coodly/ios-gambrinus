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

import Assets
import KioskCore
import UIKit

internal extension Notification.Name {
    static let closeMenu = Notification.Name(rawValue: "com.coodly.kiosk.close.menu")
}

private extension Selector {
    static let toggleMenu = #selector(MenuNavigationViewController.toggleMenu)
}

public class MenuNavigationViewController: UINavigationController, StoryboardLoaded {
    public static var storyboardName: String {
        return "MenuNavigation"
    }

    @IBOutlet private var menuPresentationView: MenuPresentationView!

    private lazy var menuButton = UIBarButtonItem(image: Asset.menu.image, style: .plain, target: self, action: .toggleMenu)
    public var menuController: UIViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        menuPresentationView.reset()
        menuPresentationView.menuContainer.addSubview(menuController.view)
        menuController.view.pinToSuperviewEdges()
        
        let tapped = UITapGestureRecognizer(target: self, action: .toggleMenu)
        menuPresentationView.dimView.addGestureRecognizer(tapped)
        
        NotificationCenter.default.addObserver(self, selector: .toggleMenu, name: .closeMenu, object: nil)
    }
    
    public func present(root controller: UIViewController, animated: Bool = true) {
        let toggleMenu = viewControllers.count != 0

        defer {
            if toggleMenu {
                self.toggleMenu()
            }
        }
        
        if let top = viewControllers.first, type(of: top) == type(of: controller) {
            return
        }
        
        CoreInjection.sharedInstance.inject(into: controller)
        controller.navigationItem.leftBarButtonItem = menuButton
        setViewControllers([controller], animated: animated)
    }
    
    public func present(modal controller: UINavigationController) {
        toggleMenu()
        /*let presented = Storyboards.loadFromStoryboard() as ModalPresenterViewController
        presented.controller = controller
        presented.modalPresentationStyle = .custom
        present(presented, animated: false)*/
    }
    
    @objc fileprivate func toggleMenu() {
        if menuPresentationView.superview == nil {
            view.addSubview(menuPresentationView)
            menuPresentationView.pinToSuperviewEdges(insets: UIEdgeInsets(top: navigationBar.frame.maxY, left: 0, bottom: 0, right: 0))
            menuPresentationView.layoutIfNeeded()

            menuController.viewWillAppear(false)
            menuPresentationView.animateIn()
        } else {
            menuPresentationView.animateOut() {
                self.menuPresentationView.removeFromSuperview()
            }
        }
    }
    
    internal func closeMenu() {
        guard menuPresentationView.superview != nil else {
            return
        }
        
        toggleMenu()
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return [.portrait]
        }
    }
}
