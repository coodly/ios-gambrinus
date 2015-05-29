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

#import "PostCell.h"
#import "UIColor+Theme.h"

@interface PostCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *titleBackground;
@property (nonatomic, strong) IBOutlet UIButton *addRemoveButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateBackground;

@end

@implementation PostCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setTextColor:[UIColor myOrange]];
    [self.dateLabel setTextColor:[UIColor myOrange]];
    [self.layer setCornerRadius:5];
    UIView *titleBackground = [[UIView alloc] initWithFrame:self.bounds];
    [self setTitleBackground:titleBackground];
    [titleBackground setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [self.contentView insertSubview:titleBackground belowSubview:self.titleLabel];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];

    UIView *dateBackground = [[UIView alloc] initWithFrame:self.bounds];
    [self setDateBackground:dateBackground];
    [dateBackground setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [self.contentView insertSubview:dateBackground belowSubview:self.dateLabel];
    [self.dateLabel setBackgroundColor:[UIColor clearColor]];

    [self.addRemoveButton.layer setCornerRadius:5];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContentFont:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self adjustContentFont:nil];
}

- (void)adjustContentFont:(NSNotification *)notification {
    [self.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self.dateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setMinimumScaleFactor:0.5];
    CGFloat fitHeight = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.titleLabel.frame), CGFLOAT_MAX)].height;

    CGRect labelFrame = self.titleLabel.bounds;
    labelFrame.size.height = fitHeight;
    [self.titleLabel setFrame:CGRectOffset(labelFrame, 5, CGRectGetHeight(self.bounds) - CGRectGetHeight(labelFrame))];

    CGRect backgroundFrame = self.titleBackground.frame;
    backgroundFrame.origin.y = self.titleLabel.frame.origin.y;
    backgroundFrame.size.height = labelFrame.size.height;
    [self.titleBackground setFrame:backgroundFrame];
}

- (void)setDateString:(NSString *)dateString {
    if (!dateString) {
        [self.dateLabel setHidden:YES];
        [self.dateBackground setHidden:YES];
        return;
    }

    [self.dateLabel setText:dateString];
    [self.dateLabel sizeToFit];

    CGRect backgroundFrame = self.dateBackground.frame;
    backgroundFrame.origin.x = 0;
    backgroundFrame.origin.y = 0;
    backgroundFrame.size.width = CGRectGetWidth(self.contentView.frame);
    backgroundFrame.size.height = CGRectGetHeight(self.dateLabel.frame);
    [self.dateBackground setFrame:backgroundFrame];
}

- (IBAction)addRemoveTapped {
    self.addRemoveHandler();
}

@end
