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

#import "PostsSearchInputView.h"
#import "UIColor+Theme.h"
#import "Constants.h"

CGFloat const KioskSearchPaddingOnPhone = 5;

@interface PostsSearchInputView () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *searchField;

@end

@implementation PostsSearchInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor clearColor]];
    UIToolbar *blur = [[UIToolbar alloc] initWithFrame:self.bounds];
    [blur setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [blur setBarTintColor:[UIColor myOrange]];
    [self insertSubview:blur atIndex:0];

    [self.searchField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.searchField addTarget:self action:@selector(searchEntryChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (IS_PAD) {
        return;
    }

    CGRect entryFrame = self.searchField.frame;
    entryFrame.origin.x = KioskSearchPaddingOnPhone;
    entryFrame.size.width = CGRectGetWidth(self.frame) - KioskSearchPaddingOnPhone * 2;
    [self.searchField setFrame:entryFrame];
}

- (void)searchEntryChanged {
    self.searchTermChangeHandler(self.searchField.text);
}

@end
