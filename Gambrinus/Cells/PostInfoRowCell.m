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

#import "PostInfoRowCell.h"

@interface PostInfoRowCell ()

@property (nonatomic, strong) IBOutlet UILabel *rowLabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *labelVerticalSpacing;

@end

@implementation PostInfoRowCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentContent) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)presentContent {
    NSString *presented = [NSString stringWithFormat:@"%@: %@", self.title, self.value];
    NSMutableAttributedString *displayed = [[NSMutableAttributedString alloc] initWithString:presented];
    [displayed setAttributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]} range:NSMakeRange(0, self.title.length + 1)];
    [displayed setAttributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} range:[presented rangeOfString:self.value]];
    [self.rowLabel setAttributedText:displayed];
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    [self setTitle:title];
    [self setValue:value];
    [self presentContent];
}

- (void)setVerticalSpacing:(CGFloat)spacing {
    for (NSLayoutConstraint *constraint in self.labelVerticalSpacing) {
        [constraint setConstant:spacing];
    }

    [self layoutIfNeeded];
}

@end
