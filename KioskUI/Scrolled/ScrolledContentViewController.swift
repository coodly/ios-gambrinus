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

internal typealias ScrollPresentedView = UIView & ScrollPresented

internal class ScrolledContentViewController: UIViewController {
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        scroll.delegate = self
        return scroll
    }()
    private var presented: ScrollPresentedView?
    internal var maxWidth: CGFloat? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let leading: NSLayoutConstraint
        let trailing: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            leading = scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            trailing = scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        } else {
            leading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            trailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if let maxWidth = self.maxWidth {
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            scrollView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
            leading.priority = .defaultHigh
            trailing.priority = .defaultHigh
        } else {
            leading.priority = .required
            trailing.priority = .required
        }
        leading.isActive = true
        trailing.isActive = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        positionContent()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        positionContent()
    }
    
    private func positionContent() {
        guard let presentation = presented else {
            return
        }
        
        presentation.presentationWidth.constant = scrollView.bounds.width
    }
    
    internal func present(view: ScrollPresentedView) {
        presented = view
        presented?.presentationWidth.constant = scrollView.bounds.width
        presented?.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        presented?.pinToSuperviewEdges()
    }
}

extension ScrolledContentViewController: UIScrollViewDelegate {
    
}

