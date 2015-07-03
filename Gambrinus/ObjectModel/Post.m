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
#import "Post.h"
#import "BlogImageAsk.h"
#import "Image.h"
#import "Constants.h"
#import "Beer.h"
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

    if ([self.shadowTitle isEqualToString:self.title]) {
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

- (BlogImageAsk *)thumbnailImageAsk {
    if (!self.image) {
        return nil;
    }

    CGSize askSize = IS_PAD ? CGSizeMake(240, 240) : CGSizeMake(150, 150);
    return [[BlogImageAsk alloc] initWithPostID:self.objectID size:askSize imageURLString:self.image.imageURLString attemptRemovePull:[self.image shouldTryRemote]];
}

- (BlogImageAsk *)postImageAsk {
    if (!self.image) {
        return nil;
    }

    CGSize askSize = IS_PAD ? CGSizeMake(600, 600) : CGSizeMake(300, 150);
    BlogImageAsk *ask = [[BlogImageAsk alloc] initWithPostID:self.objectID size:askSize imageURLString:self.image.imageURLString attemptRemovePull:[self.image shouldTryRemote]];
    if (IS_PAD) {
        [ask setImageMode:UIViewContentModeScaleAspectFit];
    } else {
        [ask setImageMode:UIViewContentModeScaleAspectFill];
    }
    return ask;
}

- (BlogImageAsk *)originalImageAsk {
    if (!self.image) {
        return nil;
    }

    return [[BlogImageAsk alloc] initWithPostID:self.objectID size:CGSizeZero imageURLString:self.image.imageURLString attemptRemovePull:[self.image shouldTryRemote]];;
}

- (NSString *)publishDateString {
    return [[Post publishDateFormatter] stringFromDate:self.publishDate];
}

- (void)markTouched {
    [self setTouchedAt:[NSDate date]];
}

- (NSString *)rateBeerScore {
    NSArray *unaliased = self.unaliasedBeers;
    if (unaliased.count == 0) {
        return @"";
    } else if (unaliased.count == 1) {
        Beer *beer = unaliased.firstObject;
        return beer.rbScore;
    } else {
        return @"*";
    }
}

- (NSArray *)unaliasedBeers {
    return [self.beers filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Beer *beer = evaluatedObject;
        return !beer.aliasedValue;
    }]].allObjects;
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
