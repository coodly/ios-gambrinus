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

#import "RateBeerDetailsCollectionViewCell.h"
#import "Beer.h"
#import "UIColor+Theme.h"
#import "BeerStyle.h"
#import "Brewer.h"
#import "RateBeerScoreLabel.h"
#import "JCSLocalization.h"

@interface RateBeerDetailsCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel;
@property (nonatomic, strong) IBOutlet UILabel *brewerLabel;
@property (nonatomic, strong) IBOutlet RateBeerScoreLabel *scoreLabel;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *brewer;

@end

@implementation RateBeerDetailsCollectionViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor rateBeerWhite]];
    [self.nameLabel setTextColor:[UIColor rateBeerBlue]];
    [self.styleLabel setTextColor:[UIColor rateBeerBlue]];
    [self.brewerLabel setTextColor:[UIColor rateBeerBlue]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePresentation) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)updatePresentation {
    [self.nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self setTitle:JCSLocalizedString(@"post.extended.details.style.label", nil) value:self.style intoLabel:self.styleLabel];
    [self setTitle:JCSLocalizedString(@"post.extended.details.brewer.label", nil) value:self.brewer intoLabel:self.brewerLabel];
}

- (void)setTitle:(NSString *)title value:(NSString *)value intoLabel:(UILabel *)label {
    if (!value) {
        value = @"-";
    }

    NSString *present = [NSString stringWithFormat:@"%@: %@", title, value];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:present];
    [attributed setAttributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSForegroundColorAttributeName : [UIColor rateBeerBlue]} range:NSMakeRange(0, present.length)];
    [attributed setAttributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} range:[present rangeOfString:value]];
    [label setAttributedText:attributed];
}

- (void)loadDataFromBeer:(Beer *)beer {
    [self.nameLabel setText:beer.name];
    [self.scoreLabel setScore:beer.rbScore];
    [self setStyle:beer.style.name];
    [self setBrewer:beer.brewer.name];

    [self updatePresentation];
}

@end
