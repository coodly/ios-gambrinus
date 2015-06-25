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

#import "ObjectModel.h"

@class Post;
@class Blog;

typedef NS_OPTIONS(short, KioskPostShowOptions) {
    KioskNoOptions = 0,
    KioskShowHiddenPosts = 1 << 0,
    KioskShowOnlyStarredPosts = 1 << 1
};

@interface ObjectModel (Posts)

- (void)createPostWithId:(NSString *)postId title:(NSString *)title content:(NSString *)content image:(NSString *)imageURL publisDate:(NSDate *)publishDate;
- (NSFetchedResultsController *)fetchedControllerForAllPosts;
- (Post *)createOrUpdatePostWithData:(NSDictionary *)dictionary;
- (NSDate *)lastKnownPostDateForBlog:(Blog *)blog;
- (BOOL)postsNotLoaded;
- (NSFetchedResultsController *)fetchedControllerForVisiblePostsOrderedByDate;
- (NSFetchedResultsController *)fetchedControllerForStarredPostsSortedByName;
- (NSPredicate *)postsPredicateForOptions:(KioskPostShowOptions)options;
- (BOOL)hasStarredPosts;
- (NSPredicate *)postsPredicateWithSearchTerm:(NSString *)search showHidden:(BOOL)showHidden showOnlyStarred:(BOOL)showOnlyStarred;
- (void)bindPostBeersWithData:(NSDictionary *)data;
- (NSArray *)postSortDescriptorsForCurrentSortOrder;

@end
