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
#import "NSDate+Calculations.h"
#import "ObjectModel+Beers.h"
#import "Beer.h"
#import "Post.h"
#import "ObjectModel+Posts.h"

typedef void (^ParseObjectsHandler)(id objects, ObjectModel *objectModel);

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
    ParseObjectsHandler beersHandler = ^(ParseBeer *beer, ObjectModel *objectModel) {
        NSMutableDictionary *save = [NSMutableDictionary dictionary];
        save[BeerDataKeyBindingKey] = beer.objectId;
        save[BeerDataKeyIdentifier] = beer.identifier;
        save[BeerDataKeyName] = beer.name;
        save[BeerDataKeyRbScore] = beer.rbscore;
        save[BeerDataKeyRbIdentifier] = beer.rbidentifier;
        if (beer.brewer) {
            save[BeerDataKeyBrewer] = beer.brewer;
        }
        if (beer.style) {
            save[BeerDataKeyStyle] = beer.style;
        }
        save[BeerDataKeyAlcohol] = beer.alcohol;
        save[BeerDataKeyAliased] = @(beer.aliased);
        [objectModel createOrUpdateBeerWithData:save];
    };
    [self fetchUpdateForObject:[ParseBeer parseClassName] since:sinceDate offset:offset objectsHandler:beersHandler completion:completion];
}

- (void)fetchPostsSinceDate:(NSDate *)sinceDate offset:(NSUInteger)offset completion:(ContentUpdateBlock)completion {
    ParseObjectsHandler postsHandler = ^(ParsePost *post, ObjectModel *objectModel) {
        if ([post.beers count] == 0) {
            return;
        }

        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[PostDataKeyIdentifier] = post.identifier;
        data[PostDataKeyBeerBindingIds] = post.beers;
        [objectModel bindPostBeersWithData:data];
    };
    [self fetchUpdateForObject:[ParsePost parseClassName] since:sinceDate offset:offset objectsHandler:postsHandler completion:completion];
}

- (void)fetchUpdateForObject:(NSString *)className
                       since:(NSDate *)sinceDate
                      offset:(NSUInteger)offset
              objectsHandler:(ParseObjectsHandler)objectsHandler
                  completion:(ContentUpdateBlock)completion {
    NSPredicate *afterDate = [NSPredicate predicateWithFormat:@"updatedAt >= %@", sinceDate];
    PFQuery *query = [PFQuery queryWithClassName:className predicate:afterDate];
    [query setLimit:ParsePageSize];
    [query setSkip:offset];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        CDYLog(@"Fetched %tu of type %@", objects.count, className);
        if (error) {
            completion(NO, error);
            return;
        }

        [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
            for (id object in objects) {
                objectsHandler(object, (ObjectModel *) objectModel);
            }
        } completion:^{
            if (objects.count == ParsePageSize) {
                [self fetchUpdateForObject:className since:sinceDate offset:offset + ParsePageSize objectsHandler:objectsHandler completion:completion];
            } else {
                CDYLog(@"%@ fetch complete", className);
                completion(YES, nil);
            }
        }];
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
