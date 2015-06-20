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

#import <Ono/ONOXMLDocument.h>
#import "ObjectModel+Posts.h"
#import "Post.h"
#import "NSDate+BloggerDate.h"
#import "Blog.h"
#import "NSString+Cleanup.h"
#import "ObjectModel+Images.h"
#import "NSString+JCSValidations.h"
#import "ObjectModel+Beers.h"

@implementation ObjectModel (Posts)

- (void)createPostWithId:(NSString *)postId title:(NSString *)title content:(NSString *)content image:(NSString *)imageURL publisDate:(NSDate *)publishDate {
    Post *post = [self existingPostWithId:postId];
    if (!post) {
        post = [Post insertInManagedObjectContext:self.managedObjectContext];
        [post setPostId:postId];
    }

    [post setTitle:title];
    [post setContent:content];
    [post setImage:imageURL];
    [post setPublishDate:publishDate];
}

- (Post *)existingPostWithId:(NSString *)postId {
    NSPredicate *postIdPredicate = [NSPredicate predicateWithFormat:@"postId = %@", postId];
    return [self fetchEntityNamed:[Post entityName] withPredicate:postIdPredicate];
}

- (NSFetchedResultsController *)fetchedControllerForAllPosts {
    NSSortDescriptor *titleDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    return [self fetchedControllerForEntity:[Post entityName] sortDescriptors:@[titleDescriptor]];
}

- (Post *)createOrUpdatePostWithData:(NSDictionary *)dictionary {
    NSString *postId = dictionary[@"id"];
    Post *post = [self existingPostWithId:postId];
    if (!post) {
        post = [Post insertInManagedObjectContext:self.managedObjectContext];
        [post setPostId:postId];
    }

    [post setTitle:[dictionary[@"title"] trimWhitespace]];
    [post setPublishDate:[NSDate bloggerDateFromString:dictionary[@"published"]]];
    NSError *error = error;
    ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithString:dictionary[@"content"] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"HTML error:%@", error);
    }
    [post setContent:document.rootElement.stringValue];
    NSString *imageURLString = [dictionary[@"images"] firstObject][@"url"];
    if ([imageURLString rangeOfString:@"blogspot.com"].location != NSNotFound) {
        imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"/s200/" withString:@"/s1600/"];
    }
    [post setImage:[self findOrCreteImageWithURLString:imageURLString]];

    return post;
}

- (NSDate *)lastKnownPostDateForBlog:(Blog *)blog {
    NSPredicate *blogPredciate = [NSPredicate predicateWithFormat:@"blog = %@", blog];
    NSSortDescriptor *publishDateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:NO];
    Post *latestKnown = [self fetchFirstEntityNamed:[Post entityName] withPredicate:blogPredciate sortDescriptors:@[publishDateDescriptor]];
    NSLog(@"latest:%@", latestKnown.publishDate);
    if (!latestKnown) {
        return blog.published;
    }

    return latestKnown.publishDate;
}

- (BOOL)postsNotLoaded {
    return [self countInstancesOfEntity:[Post entityName]] == 0;
}

- (NSFetchedResultsController *)fetchedControllerForVisiblePostsOrderedByDate {
    NSPredicate *notHiddenPredicate = [self postsPredicateForOptions:KioskNoOptions];
    NSSortDescriptor *hiddenDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hidden" ascending:YES];
    NSSortDescriptor *publishDateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:YES];
    return [self fetchedControllerForEntity:[Post entityName] predicate:notHiddenPredicate sortDescriptors:@[hiddenDescriptor, publishDateDescriptor]];
}

- (NSFetchedResultsController *)fetchedControllerForStarredPostsSortedByName {
    NSPredicate *starredPredicate = [NSPredicate predicateWithFormat:@"starred = YES"];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    return [self fetchedControllerForEntity:[Post entityName] predicate:starredPredicate sortDescriptors:@[nameDescriptor]];
}

- (NSPredicate *)postsPredicateForOptions:(KioskPostShowOptions)options searchTerm:(NSString *)searchTerm {
    NSMutableArray *predicates = [NSMutableArray array];
    if ((options & KioskShowHiddenPosts) != KioskShowHiddenPosts) {
        NSPredicate *hideHiddenPredicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
        [predicates addObject:hideHiddenPredicate];
    }

    if ((options & KioskShowOnlyStarredPosts) == KioskShowOnlyStarredPosts) {
        NSPredicate *starredPredicate = [NSPredicate predicateWithFormat:@"starred = YES"];
        [predicates addObject:starredPredicate];
    }

    if ([searchTerm hasValue]) {
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchTerm];
        [predicates addObject:titlePredicate];
    }

    if ([predicates count] == 0) {
        return nil;
    }

    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

- (NSPredicate *)postsPredicateForOptions:(KioskPostShowOptions)options {
    return [self postsPredicateForOptions:options searchTerm:@""];
}

- (BOOL)hasStarredPosts {
    NSPredicate *starredPredicate = [NSPredicate predicateWithFormat:@"starred = YES"];
    return [self countInstancesOfEntity:[Post entityName] withPredicate:starredPredicate] > 0;
}

- (NSPredicate *)postsPredicateWithSearchTerm:(NSString *)searchTerm showHidden:(BOOL)showHidden showOnlyStarred:(BOOL)showOnlyStarred {
    KioskPostShowOptions options = KioskNoOptions;
    if (showHidden) {
        options = options | KioskShowHiddenPosts;
    }
    if (showOnlyStarred) {
        options = options | KioskShowOnlyStarredPosts;
    }

    return [self postsPredicateForOptions:options searchTerm:searchTerm];
}

- (void)bindPostBeersWithData:(NSDictionary *)data {
    Post *post = [self existingPostWithId:data[PostDataKeyIdentifier]];
    if (!post) {
        return;
    }

    NSArray *beers = [self beersWithBindingKeys:data[PostDataKeyBeerBindingIds]];
    if (beers.count == 0) {
        return;
    }

    [post setBeers:[NSSet setWithArray:beers]];
}

@end
