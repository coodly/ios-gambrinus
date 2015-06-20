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

#import <JCSFoundation/NSString+JCSValidations.h>
#import "PostCell.h"
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"

@interface PostCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *titleBackground;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIView *dateBackground;
@property (nonatomic, strong) IBOutlet UILabel *rateBeerScoreLabel;

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

    [self.rateBeerScoreLabel setTransform:CGAffineTransformMakeRotation((CGFloat) (M_PI / 4))];
    [self.rateBeerScoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.rateBeerScoreLabel.layer setShadowColor:[UIColor rateBeerBlue].CGColor];
    [self.rateBeerScoreLabel.layer setShadowRadius:10];
    [self.rateBeerScoreLabel.layer setMasksToBounds:NO];

    [self.titleBackground setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];

    [self.dateBackground setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [self.dateLabel setBackgroundColor:[UIColor clearColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContentFont:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self adjustContentFont:nil];
}

- (void)adjustContentFont:(NSNotification *)notification {
    [self.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self.dateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
    [self.rateBeerScoreLabel setFont:[UIFont rateBeerFont]];
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setMinimumScaleFactor:0.5];
}

- (void)setDateString:(NSString *)dateString {
    if (!dateString) {
        [self.dateLabel setHidden:YES];
        [self.dateBackground setHidden:YES];
        return;
    }

    [self.dateLabel setText:dateString];
}

- (void)setRateBeerScore:(NSString *)score {
    if (score.hasValue) {
        NSString *presented = [NSString stringWithFormat:@"rb:%@", score];
        NSMutableAttributedString *attributedPresented = [[NSMutableAttributedString alloc] initWithString:presented];
        [attributedPresented addAttribute:NSForegroundColorAttributeName value:[UIColor rateBeerYellow] range:NSMakeRange(0, 1)];
        [attributedPresented addAttribute:NSForegroundColorAttributeName value:[UIColor rateBeerWhite] range:NSMakeRange(1, presented.length - 1)];

        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor rateBeerBlue];
        shadow.shadowOffset = CGSizeMake(2.0f, 2.0f);
        shadow.shadowBlurRadius = 2;
        [attributedPresented addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, presented.length)];

        [self.rateBeerScoreLabel setAttributedText:attributedPresented];
    } else {
        [self.rateBeerScoreLabel setText:@""];
    }
}

@end
