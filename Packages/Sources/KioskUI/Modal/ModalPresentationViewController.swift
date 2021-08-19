//
//  ModalPresentationViewController.swift
//  KDMUI
//
//  Created by Jaanus Siim on 07/12/2018.
//  Copyright © 2018 Coodly OU. All rights reserved.
//

import UIKit

private extension Selector {
    static let dismissModal = #selector(ModalPresentationViewController.dismissModal)
}

internal extension Notification.Name {
    static let modalShowPresented = Notification.Name(rawValue: "modalShowPresented")
    static let modalShowDismissed = Notification.Name(rawValue: "modalShowDismissed")
}

internal class ModalPresentationViewController: UIViewController, StoryboardLoaded, UIInjector {
    static var storyboardName: String {
        return "ModalPresentation"
    }
    
    @IBOutlet private var dimView: UIView!
    @IBOutlet private var container: UIView!
    @IBOutlet private var containerVerticalCenterConstraint: NSLayoutConstraint!
    
    internal var controller: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modalPresented: UIViewController = controller
        
        addChild(modalPresented)
        container.addSubview(modalPresented.view)
        modalPresented.view.pinToSuperviewEdges()

        
        dimView.backgroundColor = UIColor.black
        dimView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: .dismissModal)
        dimView.addGestureRecognizer(tap)
        
        container.layer.cornerRadius = 10
                
        guard let navigation = controller as? UINavigationController else {
            return
        }
        
        navigation.topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        containerVerticalCenterConstraint.constant = view.frame.height
        
        NotificationCenter.default.post(name: .modalShowPresented, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerVerticalCenterConstraint.constant = 0
        let animation = {
            self.dimView.alpha = 0.4
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3, animations: animation)
    }
    
    @objc fileprivate func dismissModal() {
        containerVerticalCenterConstraint.constant = view.frame.height
        let animation = {
            self.dimView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3, animations: animation) {
            _ in
            
            self.dismiss(animated: false)
            
            NotificationCenter.default.post(name: .modalShowDismissed, object: nil)
        }
    }
}
