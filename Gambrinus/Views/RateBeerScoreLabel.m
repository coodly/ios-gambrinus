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

#import "RateBeerScoreLabel.h"
#import "UIColor+Theme.h"
#import "NSString+JCSValidations.h"
#import "UIFont+Theme.h"

@implementation RateBeerScoreLabel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setTransform:CGAffineTransformMakeRotation((CGFloat) (M_PI / 4))];
    [self setBackgroundColor:[UIColor clearColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFont) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self updateFont];
}

- (void)updateFont {
    [self setFont:[UIFont rateBeerFont]];
}

- (void)setScore:(NSString *)score {
    if ([score isEqualToString:@"-1"]) {
        score = @"-";
    }

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

        [self setAttributedText:attributedPresented];
    } else {
        [self setText:@""];
    }
}

@end
