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
#import <JCSFoundation/JCSFoundationConstants.h>
#import "ObjectModel+Posts.h"
#import "Post.h"
#import "NSDate+BloggerDate.h"
#import "Blog.h"
#import "NSString+Cleanup.h"
#import "ObjectModel+Images.h"
#import "NSString+JCSValidations.h"
#import "ObjectModel+Beers.h"
#import "ObjectModel+Settings.h"
#import "Beer.h"
#import "BeerStyle.h"
#import "Brewer.h"
#import "Constants.h"
#import "PostContent.h"

@implementation ObjectModel (Posts)

- (Post *)existingPostWithId:(NSString *)postId {
    NSPredicate *postIdPredicate = [NSPredicate predicateWithFormat:@"postId = %@", postId];
    return [self fetchEntityNamed:[Post entityName] withPredicate:postIdPredicate];
}

- (NSFetchedResultsController *)fetchedControllerForAllPosts {
    return [self fetchedControllerForEntity:[Post entityName] sortDescriptors:[self postSortDescriptorsForCurrentSortOrder]];
}

- (void)updatePostWithData:(NSDictionary *)dictionary {
    NSString *postId = dictionary[@"id"];
    Post *post = [self existingPostWithId:postId];
    JCSAssert(post);
    [self loadDataFromDictionary:dictionary intoPost:post];
}

- (Post *)insertPostWithData:(NSDictionary *)dictionary {
    Post *post = [Post insertInManagedObjectContext:self.managedObjectContext];
    [post setPostId:dictionary[@"id"]];
    [self loadDataFromDictionary:dictionary intoPost:post];
    return post;
}

- (void)loadDataFromDictionary:(NSDictionary *)dictionary intoPost:(Post *)post {
    [post setTitle:[dictionary[@"title"] trimWhitespace]];
    [post setPublishDate:[NSDate bloggerDateFromString:dictionary[@"published"]]];
    NSError *error = error;
    ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithString:dictionary[@"content"] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"HTML error:%@", error);
    }

    NSString *content = document.rootElement.stringValue;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    content = [content stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    PostContent *postContent = post.content;
    if (!postContent) {
        postContent = [PostContent insertInManagedObjectContext:post.managedObjectContext];
    }
    [postContent setContent:content];
    [post setContent:postContent];

    NSString *imageURLString = [dictionary[@"images"] firstObject][@"url"];
    if ([imageURLString rangeOfString:@"blogspot.com"].location != NSNotFound) {
        imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"/s200/" withString:@"/s1600/"];
    }
    [post setImage:[self findOrCreteImageWithURLString:imageURLString]];
}

- (NSArray *)knownPostIds {
    return [self fetchAttributeNamed:@"postId" forEntity:[Post entityName]];
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
    return [self fetchedControllerForEntity:[Post entityName] predicate:notHiddenPredicate sortDescriptors:[self postSortDescriptorsForCurrentSortOrder]];
}

- (NSFetchedResultsController *)fetchedControllerForStarredPostsSortedByName {
    NSPredicate *starredPredicate = [NSPredicate predicateWithFormat:@"starred = YES"];
    NSArray *sortDescriptors = [self postSortDescriptorsForCurrentSortOrder];
    return [self fetchedControllerForEntity:[Post entityName] predicate:starredPredicate sortDescriptors:sortDescriptors];
}

- (NSPredicate *)postsPredicateForOptions:(KioskPostShowOptions)options searchTerm:(NSString *)searchTerm {
    CDYLog(@"searchTerm:%@", searchTerm);
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
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"normalizedTitle CONTAINS %@", searchTerm];
        NSPredicate *beersPredicate = [NSPredicate predicateWithFormat:@"combinedBeers CONTAINS %@", searchTerm];
        NSPredicate *stylesPredicate = [NSPredicate predicateWithFormat:@"combinedStyles CONTAINS %@", searchTerm];
        NSPredicate *brewersPredicate = [NSPredicate predicateWithFormat:@"combinedBrewers CONTAINS %@", searchTerm];
        NSPredicate *searchPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[titlePredicate, beersPredicate, stylesPredicate, brewersPredicate]];
        [predicates addObject:searchPredicate];
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

    [post setCombinedBeers:[self combinedValuesFrom:beers usingKeyPath:@"normalizedName"]];
    [post setCombinedStyles:[self combinedValuesFrom:beers usingKeyPath:@"style.normalizedName"]];
    [post setCombinedBrewers:[self combinedValuesFrom:beers usingKeyPath:@"brewer.normalizedName"]];

    Beer *topBeer = [self topBeer:beers];
    [post setTopScore:@(topBeer.rbScore.integerValue)];
    [post setBrewerSort:topBeer.brewer.normalizedName];
    if (!topBeer.brewer) {
        [post setBrewerSort:@"æææææ"];
    }
    [post setStyleSort:topBeer.style.normalizedName];
    if (!topBeer.style) {
        [post setStyleSort:@"æææææ"];
    }
    [post setBeers:[NSSet setWithArray:beers]];
}

- (NSString *)combinedValuesFrom:(NSArray *)beers usingKeyPath:(NSString *)keyPath {
    NSArray *normalized = [beers valueForKeyPath:keyPath];
    normalized = [normalized filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isKindOfClass:[NSNull class]];
    }]];

    NSSet *set = [NSSet setWithArray:normalized];
    NSArray *unique = [set allObjects];
    NSArray *sorted = [unique sortedArrayUsingSelector:@selector(compare:)];
    return [sorted componentsJoinedByString:@"|"];
}

- (Beer *)topBeer:(NSArray *)beers {
    NSArray *sorted = [beers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Beer *one = obj1;
        Beer *two = obj2;

        NSInteger scoreOne = one.rbScore.integerValue;
        NSInteger scoreTwo = two.rbScore.integerValue;
        return [@(scoreTwo) compare:@(scoreOne)];
    }];
    Beer *top = [sorted firstObject];
    return top;
}

- (NSArray *)postSortDescriptorsForCurrentSortOrder {
    switch ([self postsSortOrder]) {
        case OrderByDateDesc:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:NO]];
        case OrderByDateAsc:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:YES]];
        case OrderByPostName:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"normalizedTitle" ascending:YES]];
        case OrderByRBScore:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"topScore" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"normalizedTitle" ascending:YES]];
        case OrderByStyle:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"styleSort" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"normalizedTitle" ascending:YES]];
        case OrderByBrewer:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"brewerSort" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"normalizedTitle" ascending:YES]];
        case OrderByRBBeerName:
        default:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:NO]];
    }
}

@end
