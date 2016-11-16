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

#import "NSString+JCSValidations.h"
#import "BlogImageAsk.h"
#import "Image.h"
#import "Constants.h"
#import "NSString+Normalize.h"

NSString *const PostDataKeyIdentifier = @"PostDataKeyIdentifier";
NSString *const PostDataKeyBeerBindingIds = @"PostDataKeyBeerBindingIds";

@interface Post ()

@end

@implementation Post

- (void)willSave {
    [super willSave];

    if (!self.title.hasValue) {
        return;
    }

    if ([self.shadowTitle isEqualToString:self.title] && [self.normalizedTitle hasValue]) {
        return;
    }

    [self setShadowTitle:self.title];

    NSString *normalizedTitle = [self.title normalize];
    [self setNormalizedTitle:normalizedTitle];
}

- (void)awakeFromFetch {
    [super awakeFromFetch];

    [self setShadowTitle:self.title];
}

static NSDateFormatter *__publishDateFormatter;
+ (NSDateFormatter *)publishDateFormatter {
    if (!__publishDateFormatter) {
        __publishDateFormatter = [[NSDateFormatter alloc] init];
        [__publishDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [__publishDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }

    return __publishDateFormatter;
}

@end
