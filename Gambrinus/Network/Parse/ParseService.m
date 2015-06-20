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

#import "ParseService.h"
#import "ParseBeer.h"
#import "ParsePost.h"
#import "PFQuery.h"
#import "ObjectModel.h"
#import "Constants.h"

NSUInteger ParsePageSize = 100;

@interface ParseService ()

@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation ParseService

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel {
    self = [super init];
    if (self) {
        _objectModel = objectModel;
    }
    return self;
}

+ (void)registerCustomClasses {
    [ParseBeer registerSubclass];
    [ParsePost registerSubclass];
}

- (void)fetchBeersSinceDate:(NSDate *)sinceDate offset:(NSUInteger)offset completion:(ContentUpdateBlock)completion {
    NSPredicate *afterDate = [NSPredicate predicateWithFormat:@"updatedAt >= %@", sinceDate];
    PFQuery *query = [ParseBeer queryWithPredicate:afterDate];
    [query setLimit:ParsePageSize];
    [query setSkip:offset];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        CDYLog(@"Fetched %d beers", objects.count);
        if (error) {
            completion(NO, error);
            return;
        }

        if (objects.count == ParsePageSize) {
            [self fetchBeersSinceDate:sinceDate offset:offset + ParsePageSize completion:completion];
        } else {
            CDYLog(@"Beers fetch complete");
            completion(YES, nil);
        }
    }];
}

- (void)fetchPostsSinceDate:(NSDate *)sinceDate offset:(NSUInteger)offset completion:(ContentUpdateBlock)completion {
    NSPredicate *afterDate = [NSPredicate predicateWithFormat:@"updatedAt >= %@", sinceDate];
    PFQuery *query = [ParsePost queryWithPredicate:afterDate];
    [query setLimit:ParsePageSize];
    [query setSkip:offset];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        CDYLog(@"Fetched %d posts", objects.count);
        if (error) {
            completion(NO, error);
            return;
        }

        if (objects.count == ParsePageSize) {
            [self fetchPostsSinceDate:sinceDate offset:offset + ParsePageSize completion:completion];
        } else {
            CDYLog(@"Posts fetch complete");
            completion(YES, nil);
        }
    }];
}

- (void)retrieveUpdatesSinceDate:(NSDate *)date completion:(ContentUpdateBlock)completion {
    [self refreshBeersSinceDate:date completion:^(BOOL complete, NSError *error) {
        [self retrievePostsSinceDate:date completion:completion];
    }];
}

- (void)refreshBeersSinceDate:(NSDate *)date completion:(ContentUpdateBlock)completion {
    [self fetchBeersSinceDate:date offset:0 completion:completion];
}

- (void)retrievePostsSinceDate:(NSDate *)date completion:(ContentUpdateBlock)completion {
    [self fetchPostsSinceDate:date offset:0 completion:completion];
}

@end
