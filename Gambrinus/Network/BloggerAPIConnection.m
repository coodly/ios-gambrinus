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

#import "BloggerAPIConnection.h"
#import "AFHTTPRequestOperationManager.h"
#import "Constants.h"
#import "ObjectModel.h"
#import "ObjectModel+Blogs.h"
#import "_Blog.h"
#import "Blog.h"
#import "NSDate+Calculations.h"
#import "NSDate+BloggerDate.h"
#import "ObjectModel+Posts.h"
#import "Post.h"

typedef void (^BloggerResponseBlock)(id response, NSError *error);

NSString *const kGoogleBloggerAPIPath = @"https://www.googleapis.com/blogger/v3";

@interface BloggerAPIConnection ()

@property (nonatomic, copy) NSString *blogURLString;
@property (nonatomic, copy) NSString *bloggerKey;
@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation BloggerAPIConnection

- (id)initWithBlogURLString:(NSString *)blogURLString bloggerKey:(NSString *)key objectModel:(ObjectModel *)model {
    self = [super init];
    if (self) {
        _blogURLString = blogURLString;
        _bloggerKey = key;
        _objectModel = model;
    }
    return self;
}

- (void)refreshWithCompletionHandler:(BloggerRefreshBlock)completion {
    [self.objectModel performBlock:^{
        Blog *blog = [self.objectModel blogWithBaseURL:self.blogURLString];
        if (!blog) {
            [self retrieveBlogDetailsWithRefreshHandler:completion];
        } else {
            [self checkForUpdatesWithRefreshHandler:completion];
        }
    }];
}

- (void)refreshPost:(Post *)post withCompletionHandler:(BloggerRefreshBlock)completion {
    [self.objectModel performBlock:^{
        Blog *blog = [self.objectModel blogWithBaseURL:self.blogURLString];
        NSString *path = [NSString stringWithFormat:@"/blogs/%@/posts/%@", blog.blogId, post.postId];
        [self GET:path params:@{@"fetchImages": @"true"} responseHandler:^(id response, NSError *error) {
            if (error) {
                completion(NO, error);
                return;
            }

            [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
                ObjectModel *model = (ObjectModel *) objectModel;
                [model createOrUpdatePostWithData:response];
            } completion:^{
                completion(YES, nil);
            }];
        }];
    }];
}

- (void)retrieveBlogDetailsWithRefreshHandler:(BloggerRefreshBlock)refreshHandler {
    CDYLog(@"retrieveBlogDetailsWithRefreshHandler");
    [self GET:@"/blogs/byurl" params:@{@"url": self.blogURLString} responseHandler:^(id response, NSError *error) {
        if (error) {
            refreshHandler(NO, error);
            return;
        }

        [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
            ObjectModel *model = (ObjectModel *) objectModel;
            [model createOrUpdateBlogWithData:response];
        } completion:^{
            [self checkForUpdatesWithRefreshHandler:refreshHandler];
        }];
    }];
}

- (void)checkForUpdatesWithRefreshHandler:(BloggerRefreshBlock)refreshHandler {
    CDYLog(@"checkForUpdatesWithRefreshHandler");
    [self.objectModel performBlock:^{
        Blog *blog = [self.objectModel blogWithBaseURL:self.blogURLString];
        NSDate *latestKnownDate = [self.objectModel lastKnownPostDateForBlog:blog];

        [self retrievePostsWithStartDate:[latestKnownDate beginningOfWeek] blogId:blog.blogId refreshHandler:refreshHandler];
    }];
}

- (void)retrievePostsWithStartDate:(NSDate *)rangeStartDate blogId:(NSString *)blogId refreshHandler:(BloggerRefreshBlock)refreshHandler {
    CDYLog(@"retrievePostsWithStartDate:%@", rangeStartDate);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"startDate"] = [rangeStartDate bloggerDateString];
    NSDate *endDate = [rangeStartDate startOfNextWeek];
    params[@"endDate"] = [endDate bloggerDateString];
    params[@"status"] = @"live";
    params[@"fetchImages"] = @"true";
    params[@"maxResults"] = @(100);

    NSString *path = [NSString stringWithFormat:@"/blogs/%@/posts", blogId];
    [self GET:path params:params responseHandler:^(id response, NSError *error) {
        if (error) {
            CDYLog(@"Check updates error:%@", error);
            refreshHandler(NO, error);
            return;
        }

        [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
            ObjectModel *model = (ObjectModel *) objectModel;
            Blog *postForBlog = [model blogWithBaseURL:self.blogURLString];
            NSArray *items = response[@"items"];
            for (NSDictionary *postData in items) {
                CDYLog(@"%@", postData[@"title"]);
                Post *post = [model createOrUpdatePostWithData:postData];
                [post setBlog:postForBlog];
            }
        } completion:^{
            NSDate *now = [NSDate date];
            if ([[now laterDate:endDate] isEqualToDate:now]) {
                [self retrievePostsWithStartDate:endDate blogId:blogId refreshHandler:refreshHandler];
            } else {
                refreshHandler(YES, nil);
            }
        }];
    }];

}

- (void)GET:(NSString *)path params:(NSDictionary *)params responseHandler:(BloggerResponseBlock)completion {
    if (!params) {
        params = @{};
    }
    NSMutableDictionary *sentParams = [NSMutableDictionary dictionaryWithDictionary:params];
    sentParams[@"key"] = self.bloggerKey;
    NSString *requestPath = [NSString stringWithFormat:@"%@%@", kGoogleBloggerAPIPath, path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestPath parameters:sentParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CDYLog(@"Path:%@", operation.request.URL);
        CDYLog(@"Success");
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CDYLog(@"Error:%@", error);
        completion(nil, error);
    }];
}

@end
