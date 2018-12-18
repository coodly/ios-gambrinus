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
    static let adjustFont = #selector(PostCell.adjustFont)
}

internal class PostCell: UICollectionViewCell {
    @IBOutlet private var postDate: UILabel!
    @IBOutlet private var dateFill: UIView!
    @IBOutlet private var postTitle: UILabel!
    @IBOutlet private var titleFill: UIView!
    
    internal var viewModel: PostCellViewModel? {
        didSet {
            viewModel?.callback = {
                [weak self]
                
                status in
                
                self?.update(with: status)
            }
        }
    }
    
    private func update(with status: PostCellViewModel.Status) {
        postDate.text = status.formattedPostDate
        postTitle.text = status.postTile
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFill.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        titleFill.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        NotificationCenter.default.addObserver(self, selector: .adjustFont, name: UIContentSizeCategory.didChangeNotification, object: nil)
        adjustFont()
    }
    
    @objc fileprivate func adjustFont() {
        postDate.font = UIFont.preferredFont(forTextStyle: .subheadline)
        postTitle.font = UIFont.preferredFont(forTextStyle: .headline)
    }
}
