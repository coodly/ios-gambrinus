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

#import "BlogPostsRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "ObjectModel.h"
#import "ONOXMLDocument.h"
#import "NSString+Cleanup.h"
#import "ObjectModel+Posts.h"
#import "ObjectModel+Settings.h"
#import "NSDate+Calculations.h"

@interface BlogPostsRefresh ()

@property (nonatomic, copy) NSString *rootURL;
@property (nonatomic, strong) NSDate *startDate;

@end

@implementation BlogPostsRefresh

- (id)initWithRootURL:(NSString *)rootURLString startDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        _rootURL = rootURLString;
        _startDate = startDate;
    }
    return self;
}

- (void)execute {
    NSDate *startDate = [self.objectModel lastVerifiedPullDate:self.startDate];
    startDate = [startDate beginningOfWeek];
    [self refreshWithDate:startDate];
}

- (void)refreshWithDate:(NSDate *)rangeStartDate {
    NSDate *rangeEndDate = [rangeStartDate startOfNextWeek];
    NSLog(@"refreshWithDate:%@ - %@", rangeStartDate, rangeEndDate);
    NSString *checkURLString = [self buildCheckURLWithStartDate:rangeStartDate endDate:rangeEndDate];
    NSLog(@"Check URL:%@", checkURLString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:checkURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:&error];

        [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
            ObjectModel *model = (ObjectModel *) objectModel;

            __block NSDate *maxPostDate = nil;

            __block NSUInteger count = 0;
            [document enumerateElementsWithXPath:@"//div[contains(@class,'date-outer')]" block:^(ONOXMLElement *element) {
                NSLog(@"%@ - %@ - %@", element.tag, element.attributes, @"");
                [element enumerateElementsWithXPath:@"//div[contains(@class,'post-outer')]" block:^(ONOXMLElement *element) {
                    NSDate *publishDate = [self parsePostFromElement:element objectModel:model];
                    maxPostDate = [publishDate laterDate:maxPostDate];
                    count++;
                }];
            }];

            NSDate *checkedMax = rangeEndDate;
            if (maxPostDate) {
                checkedMax = maxPostDate;
            }

            [model setLastVerifiedPullDate:checkedMax];

            NSLog(@"Processed %d posts", count);
        } completion:^{
            NSDate *now = [NSDate date];
            if ([[now laterDate:rangeEndDate] isEqualToDate:now]) {
                [self refreshWithDate:rangeEndDate];
            } else {
                self.resultHandler(@YES, nil);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.resultHandler(@NO, error);
    }];
}

- (NSString *)buildCheckURLWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [NSString stringWithFormat:@"%@/search?updated-min=%@&updated-max=%@&max-results=50", self.rootURL, [self serverFormat:[[BlogPostsRefresh publishDateFormatter] stringFromDate:startDate]], [self serverFormat:[[BlogPostsRefresh publishDateFormatter] stringFromDate:endDate]]];
}

- (NSString *)serverFormat:(NSString *)dateString {
    NSMutableString *result = [NSMutableString stringWithString:dateString];
    [result replaceCharactersInRange:NSMakeRange(result.length - 6, 6) withString:@"-08:00"];
    return [NSString stringWithString:result];
}

- (NSDate *)parsePostFromElement:(ONOXMLElement *)element objectModel:(ObjectModel *)model {
    ONOXMLElement *blogIdElement = [self findChildFromElement:element tagName:@"meta" itemprop:@"postId"];
    NSString *postId = [(NSString *)blogIdElement.attributes[@"content"] trimWhitespace];
    ONOXMLElement *titleElement = [self findChildFromElement:element tagName:@"h3" itemprop:@"name"];
    NSString *title = [titleElement.stringValue trimWhitespace];
    ONOXMLElement *contentElement = [self findChildFromElement:element tagName:@"div" itemprop:@"articleBody"];
    NSString *content = [contentElement.stringValue trimWhitespace];
    ONOXMLElement *imageElement = [contentElement firstChildWithTag:@"a"];
    NSString *imageURL = imageElement.attributes[@"href"];
    ONOXMLElement *publishDateElement = [self findChildFromElement:element tagName:@"abbr" itemprop:@"datePublished"];
    NSString *publishDateString = publishDateElement.attributes[@"title"];
    NSRange range = [publishDateString rangeOfString:@":00" options:NSBackwardsSearch];
    publishDateString = [publishDateString stringByReplacingCharactersInRange:range withString:@"00"];
    NSDate *publishDate = [[BlogPostsRefresh publishDateFormatter] dateFromString:publishDateString];
    [model createPostWithId:postId title:title content:content image:imageURL publisDate:publishDate];
    return publishDate;
}

- (ONOXMLElement *)findChildFromElement:(ONOXMLElement *)element tagName:(NSString *)tagName itemprop:(NSString *)itemprop {
    ONOXMLElement *searched = nil;
    for (ONOXMLElement *child in element.children) {
        if ([child.tag isEqualToString:tagName]) {
            NSString *prop = child.attributes[@"itemprop"];
            if (prop && [prop rangeOfString:itemprop].location != NSNotFound) {
                searched = child;
            } else {
                searched = [self findChildFromElement:child tagName:tagName itemprop:itemprop];
            }
        } else {
            searched = [self findChildFromElement:child tagName:tagName itemprop:itemprop];
        }

        if (searched) {
            break;
        }
    }

    return searched;
}

static NSDateFormatter *__publishDateFormatter;
+ (NSDateFormatter *)publishDateFormatter {
    if (!__publishDateFormatter) {
        __publishDateFormatter = [[NSDateFormatter alloc] init];
        [__publishDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    }

    return __publishDateFormatter;
}

@end
