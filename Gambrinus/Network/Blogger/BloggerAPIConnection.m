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
#import "BloggerAPIConnection.h"
#import "AFHTTPRequestOperationManager.h"
#import "Constants.h"
#import "ObjectModel.h"
#import "ObjectModel+Blogs.h"
#import "Blog.h"
#import "NSDate+BloggerDate.h"
#import "ObjectModel+Posts.h"
#import "Post.h"
#import "NSDate+ISO8601.h"

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

- (void)retrieveUpdatesSinceDate:(NSDate *)date completion:(ContentUpdateBlock)completion {
    [self.objectModel performBlock:^{
        Blog *blog = [self.objectModel blogWithBaseURL:self.blogURLString];
        if (!blog) {
            [self retrieveBlogDetailsWithCompletionHandler:^(BOOL complete, NSError *error) {
                if (error) {
                    completion(complete, error);
                    return;
                }

                [self checkForUpdatesSinceDate:date withRefreshHandler:completion];
            }];
        } else {
            [self checkForUpdatesSinceDate:date withRefreshHandler:completion];
        }
    }];
}

- (void)refreshPost:(Post *)post withCompletionHandler:(ContentUpdateBlock)completion {
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
                [model updatePostWithData:response];
            } completion:^{
                completion(YES, nil);
            }];
        }];
    }];
}

- (void)retrieveBlogDetailsWithCompletionHandler:(ContentUpdateBlock)refreshHandler {
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
            refreshHandler(YES, nil);
        }];
    }];
}

- (void)checkForUpdatesSinceDate:(NSDate *)sinceDate withRefreshHandler:(ContentUpdateBlock)refreshHandler {
    CDYLog(@"checkForUpdatesWithRefreshHandler");
    [self.objectModel performBlock:^{
        Blog *blog = [self.objectModel blogWithBaseURL:self.blogURLString];
        [self retrievePostsWithStartDate:sinceDate toDate:[NSDate date] blogId:blog.blogId refreshHandler:refreshHandler];
    }];
}

- (void)retrievePostsWithStartDate:(NSDate *)rangeStartDate toDate:(NSDate *)rangeEndDate blogId:(NSString *)blogId refreshHandler:(ContentUpdateBlock)refreshHandler {
    [self retrievePostsWithStartDate:rangeStartDate toDate:rangeEndDate blogId:blogId nextPageToken:nil refreshHandler:refreshHandler];
}

- (void)retrievePostsWithStartDate:(NSDate *)rangeStartDate toDate:(NSDate *)rangeEndDate blogId:(NSString *)blogId nextPageToken:(NSString *)nextPageToken refreshHandler:(ContentUpdateBlock)refreshHandler {
    CDYLog(@"retrievePostsInRange:%@ to %@", rangeStartDate.iso8601String, rangeEndDate.iso8601String);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"startDate"] = [rangeStartDate bloggerDateString];
    params[@"endDate"] = [rangeEndDate bloggerDateString];
    params[@"status"] = @"live";
    params[@"fetchImages"] = @"true";
    params[@"maxResults"] = @(100);
    params[@"fields"] = @"nextPageToken,items(id,published,title,content,images)";
    if (nextPageToken.hasValue) {
        params[@"pageToken"] = nextPageToken;
    }

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
            NSArray *knownPostIds = [model knownPostIds];
            for (NSDictionary *postData in items) {
                CDYLog(@"%@", postData[@"title"]);
                NSString *postId = postData[@"id"];
                if ([knownPostIds containsObject:postId]) {
                    [model updatePostWithData:postData];
                } else {
                    Post *post = [model insertPostWithData:postData];
                    [post setBlog:postForBlog];
                }
            }
        } completion:^{
            NSString *token = response[@"nextPageToken"];
            if (token.hasValue) {
                [self retrievePostsWithStartDate:rangeStartDate toDate:rangeEndDate blogId:blogId nextPageToken:token refreshHandler:refreshHandler];
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

    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *build = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *userAgent = [NSString stringWithFormat:@"%@/v%@(%@) (gzip)", appName, version, build];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];

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
