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

private extension Selector {
    static let remove = #selector(ImageShowView.remove)
}

internal class ImageShowView: UIView {
    @IBOutlet private var backgroundFill: UIView!
    private lazy var imageView = UIImageView(frame: self.bounds)
    private lazy var imageClipView = UIView(frame: self.bounds)
    private var startConstraints: [NSLayoutConstraint]!
    private var endConstraints: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        backgroundFill.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: .remove)
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        imageClipView.clipsToBounds = true
    }
    
    internal func present(image: UIImage, from reference: UIView) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageClipView)
        imageClipView.translatesAutoresizingMaskIntoConstraints = false
        
        let inMe = convert(reference.frame, from: reference.superview!)
        
        let startLeading = imageClipView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        let startTop = imageClipView.topAnchor.constraint(equalTo: topAnchor, constant: inMe.minY)
        let startTrailing = imageClipView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        let startHeight = imageClipView.heightAnchor.constraint(equalToConstant: inMe.height)
        
        imageClipView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: imageClipView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageClipView.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageClipView.centerYAnchor).isActive = true
        let sizeRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
        
        startConstraints = [startLeading, startTop, startTrailing, startHeight, sizeRatioConstraint]
        NSLayoutConstraint.activate(startConstraints)
        layoutIfNeeded()
        
        endConstraints = [
            imageClipView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageClipView.topAnchor.constraint(equalTo: topAnchor),
            imageClipView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageClipView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageClipView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageClipView.bottomAnchor)
        ]
        NSLayoutConstraint.deactivate(startConstraints)
        NSLayoutConstraint.activate(endConstraints)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundFill.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func remove() {
        NSLayoutConstraint.deactivate(endConstraints)
        NSLayoutConstraint.activate(startConstraints)
        let animation = {
            self.layoutIfNeeded()
            self.backgroundFill.alpha = 0
        }
        UIView.animate(withDuration: 0.4, animations: animation) {
            _ in
            
            self.removeFromSuperview()
        }
    }
}
