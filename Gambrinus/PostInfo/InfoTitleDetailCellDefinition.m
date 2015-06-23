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

#import "InfoTitleDetailCellDefinition.h"
#import "PostInfoRowCell.h"
#import "Constants.h"

@implementation InfoTitleDetailCellDefinition

- (instancetype)initWithCellIdentifier:(NSString *)identifier {
    self = [super initWithCellIdentifier:identifier];
    if (self) {
        _backgroundColor = [UIColor whiteColor];
        _foregroundColor = [UIColor blackColor];
        _verticalSpacing = GambrinusSpacing;
    }

    return self;
}

- (void)configureCell:(UICollectionViewCell *)cell {
    PostInfoRowCell *infoRowCell = (PostInfoRowCell *) cell;
    [infoRowCell setBackgroundColor:self.backgroundColor];
    [infoRowCell.rowLabel setTextColor:self.foregroundColor];
    [infoRowCell setTitle:self.title value:self.value];
    [infoRowCell setVerticalSpacing:self.verticalSpacing];
}

- (CGFloat)heightOfContentForWidth:(CGFloat)presentationWidth {
    return [self calculateHeightForString:self.title
                                usingFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                        presentationWidth:presentationWidth - 2 * GambrinusSpacing] + 2 * self.verticalSpacing;
}

@end
