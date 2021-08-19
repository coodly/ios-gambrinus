//
//  ModalPresenter.swift
//  KDMUI
//
//  Created by Jaanus Siim on 07/12/2018.
//  Copyright © 2018 Coodly OU. All rights reserved.
//

import UIKit

internal protocol ModalPresenter {
    func present(modal: UIViewController)
}

extension ModalPresenter where Self: UIViewController {
    func present(modal controller: UIViewController) {
        let modal: ModalPresentationViewController = Storyboards.loadFromStoryboard()
        modal.modalPresentationStyle = .custom
        modal.controller = controller
        present(modal, animated: false)
    }
}
