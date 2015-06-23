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

#import "RateBeerSectionTitleCell.h"
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"

@interface RateBeerSectionTitleCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation RateBeerSectionTitleCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.titleLabel setText:@"ratebeer"];
    [self setBackgroundColor:[UIColor rateBeerBlue]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentContent) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self presentContent];
}

- (void)presentContent {
    NSMutableAttributedString *presented = [[NSMutableAttributedString alloc] initWithString:@"ratebeer"];
    [presented setAttributes:@{NSFontAttributeName: [UIFont rateBeerFont]} range:NSMakeRange(0, presented.length)];
    [presented addAttribute:NSForegroundColorAttributeName value:[UIColor rateBeerYellow] range:NSMakeRange(0, 4)];
    [presented addAttribute:NSForegroundColorAttributeName value:[UIColor rateBeerWhite] range:NSMakeRange(4, 4)];
    [self.titleLabel setAttributedText:presented];
}

@end
