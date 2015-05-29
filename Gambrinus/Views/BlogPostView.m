/*
* Copyright 2015 Coodly LLC
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

#import "BlogPostView.h"
#import "Constants.h"

CGFloat kImagePadding = 10;

@interface BlogPostView () <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextView *content;

@end

@implementation BlogPostView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setExclusionAroundImage];
    [self.content setDelegate:self];

    [self.layer setCornerRadius:5];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [self.imageView addGestureRecognizer:recognizer];
}

- (void)setExclusionAroundImage {
    if (IS_PAD) {
        CGRect exclusionFrame = self.imageView.frame;
        exclusionFrame.size.width += kImagePadding;
        exclusionFrame.size.height += kImagePadding;
        [self.content.textContainer setExclusionPaths:@[[UIBezierPath bezierPathWithRect:exclusionFrame]]];
    } else {
        [self.content setTextContainerInset:UIEdgeInsetsMake(CGRectGetHeight(self.imageView.frame), 0, 0, 0)];
    }
}

- (void)setPostContent:(NSString *)postContent {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:postContent];
    [content setAttributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} range:NSMakeRange(0, content.length)];
    [self.content setAttributedText:content];
}

- (void)setPostImage:(UIImage *)image {
    [self.imageView setImage:image];

    if (IS_PAD) {
        [self.imageView sizeToFit];
    } else {
        CGRect frame = self.imageView.frame;
        frame.size.width = CGRectGetWidth(self.frame);
        frame.size.height = CGRectGetWidth(frame) / 2;
        [self.imageView setFrame:frame];
    }

    [self setExclusionAroundImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.imageView setFrame:CGRectOffset(self.imageView.bounds, 0, -scrollView.contentOffset.y)];
}

- (void)imageTapped {
    self.imageTapHandler();
}

@end
