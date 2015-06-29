//
//  ContentUpdate.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ContentUpdate.h"
#import "ObjectModel.h"
#import "Post.h"
#import "BloggerAPIConnection.h"
#import "ParseService.h"
#import "ObjectModel+Settings.h"
#import "Constants.h"
#import "NSDate+Calculations.h"

@interface ContentUpdate ()

@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation ContentUpdate

- (instancetype)initWithObjectModel:(ObjectModel *)model {
    self = [super init];
    if (self) {
        _objectModel = model;
    }
    return self;
}

- (void)updateWithCompletionHandler:(ContentUpdateBlock)completion {
    [self.objectModel performBlock:^{
        TICK;

        NSDate *lastPullDate = [self.objectModel lastVerifiedPullDate:[NSDate dateOnYear:2010 month:1 day:1]];
        CDYLog(@"Last pull date:%@", lastPullDate);
        NSDate *refreshStartTime = [NSDate date];
        [self refreshBlogger:lastPullDate completion:^(BOOL complete, NSError *error) {
            if (error) {
                CDYLog(@"Blogger refresh error:%@", error);
                completion(complete, error);
                return;
            }

            [self refreshParse:lastPullDate completion:^(BOOL pComplete, NSError *pError) {
                if (error) {
                    CDYLog(@"Parse refresh error:%@", error);
                    completion(pComplete, pError);
                    return;
                }

                [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
                    ObjectModel *model = (ObjectModel *) objectModel;
                    [model setLastVerifiedPullDate:refreshStartTime];
                } completion:^{
                    TOCK(@"Content refreshed");
                    completion(YES, nil);
                }];
            }];
        }];
    }];
}

- (void)refreshPost:(Post *)post withCompletionHandler:(ContentUpdateBlock)completion {
    [self.bloggerAPIConnection refreshPost:post withCompletionHandler:completion];
}

- (void)refreshBlogger:(NSDate *)sinceDate completion:(ContentUpdateBlock)completion {
    CDYLog(@"refreshBlogger");
    [self.bloggerAPIConnection retrieveUpdatesSinceDate:sinceDate completion:completion];
}

- (void)refreshParse:(NSDate *)sinceDate completion:(ContentUpdateBlock)completion {
    CDYLog(@"refreshParse");
    [self.parseService retrieveUpdatesSinceDate:sinceDate completion:completion];
}

@end
