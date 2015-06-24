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

#import <JCSFoundation/JCSFoundationConstants.h>
#import "SideMenuViewController.h"
#import "MenuCell.h"
#import "BlogPostsViewController.h"
#import "MarkedPostsViewController.h"
#import "Gambrinus-Swift.h"
#import "ObjectModel.h"
#import "ObjectModel+Settings.h"

NSInteger const GambrinusSortSectionIndex = 1;

@interface SideMenuViewController ()

@property (nonatomic, strong) NSIndexPath *allPost;
@property (nonatomic, strong) NSIndexPath *favorites;

@property (nonatomic, strong) NSIndexPath *sortByPostDate;
@property (nonatomic, strong) NSIndexPath *sortByPostName;
@property (nonatomic, strong) NSIndexPath *sortByBeerName;
@property (nonatomic, strong) NSIndexPath *sortByScore;
@property (nonatomic, strong) NSIndexPath *sortByStyle;
@property (nonatomic, strong) NSIndexPath *sortByBrewer;

@property (nonatomic, strong) NSArray *sortOptions;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allPost = [self addCellWithTitle:NSLocalizedString(@"menu.controller.option.all.posts", nil)];
    self.favorites = [self addCellWithTitle:NSLocalizedString(@"menu.controller.option.favorites", nil)];

    [self closeSection];

    self.sortByPostDate = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.date", nil)];
    self.sortByPostName = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.posts", nil)];
    self.sortByBeerName = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.beer", nil)];
    self.sortByScore = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.score", nil)];
    self.sortByStyle = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.style", nil)];
    self.sortByStyle = [self addCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.brewer", nil)];

    self.sortOptions = @[
        @[@(OrderByDateDesc), @(OrderByDateAsc)],
        @[@(OrderByPostName)],
        @[@(OrderByRBBeerName)],
        @[@(OrderByRBScore)],
        @[@(OrderByStyle)],
        @[@(OrderByBrewer)]
    ];
}

- (NSIndexPath *)addCellWithTitle:(NSString *)title {
    MenuCell *sortByPostName = [self.tableView dequeueReusableCellWithIdentifier:KioskMenuCellIdentifier];
    [sortByPostName.textLabel setText:title];
    return [self addCellForPresentation:sortByPostName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PostsSortOrder sortOrder = [self.objectModel postsSortOrder];
    NSIndexPath *activeIndexPath = [self indexPathForOrder:sortOrder];
    MenuCell *cell = (MenuCell *) [self.tableView cellForRowAtIndexPath:activeIndexPath];
    [self setSortMarkerOnCell:cell order:sortOrder];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.allPost isEqual:indexPath]) {
        [self.container presentRootController:[[BlogPostsViewController alloc] init]];
        return;
    } else if ([self.favorites isEqual:indexPath]) {
        [self.container presentRootController:[[MarkedPostsViewController alloc] init]];
        return;
    } else if (indexPath.section != GambrinusSortSectionIndex) {
        return;
    }

    PostsSortOrder currentOrder = [self.objectModel postsSortOrder];
    PostsSortOrder nextOrder = [self nextOrderUsingRow:indexPath.row currentOrder:currentOrder];

    [self.container closeMenu];

    if (currentOrder == nextOrder) {
        return;
    }

    NSIndexPath *indexPathForCurrentOrder = [self indexPathForOrder:currentOrder];
    NSIndexPath *indexPathForNextOrder = [self indexPathForOrder:nextOrder];

    MenuCell *oldCell = (MenuCell *) [self.tableView cellForRowAtIndexPath:indexPathForCurrentOrder];
    [oldCell setAccessoryType:UITableViewCellAccessoryNone];
    [oldCell setAccessoryView:nil];

    MenuCell *selectedCell = (MenuCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [self setSortMarkerOnCell:selectedCell order:nextOrder];
    [self.objectModel setPostsSortOrder:nextOrder];
}

- (void)setSortMarkerOnCell:(MenuCell *)cell order:(PostsSortOrder)order {
    if (order == OrderByDateDesc) {
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"764-arrow-down-toolbar-selected"]]];
    } else if (order == OrderByDateAsc) {
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"763-arrow-up-toolbar-selected"]]];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

- (NSIndexPath *)indexPathForOrder:(PostsSortOrder)order {
    NSNumber *orderNumber = @(order);
    for (NSInteger row = 0; row < self.sortOptions.count; row++) {
        NSArray *rowOptions = self.sortOptions[row];
        if ([rowOptions containsObject:orderNumber]) {
            return [NSIndexPath indexPathForRow:row inSection:GambrinusSortSectionIndex];
        }
    }

    JCSAssert(NO);
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == GambrinusSortSectionIndex) {
        return NSLocalizedString(@"menu.controller.sort.section.title", nil);
    }

    return nil;
}

- (PostsSortOrder)nextOrderUsingRow:(NSInteger)row currentOrder:(PostsSortOrder)currentOrder {
    PostsSortOrder nextOrder;
    NSArray *nextOptions = self.sortOptions[row];
    if (nextOptions.count == 1) {
        nextOrder = (PostsSortOrder) [nextOptions.firstObject integerValue];
    } else {
        NSNumber *previous = @(currentOrder);
        NSUInteger index = [nextOptions indexOfObject:previous];
        if (index == NSNotFound) {
            index = 0;
        } else {
            index = index + 1;
            if (index == nextOptions.count) {
                index = 0;
            }
        }

        nextOrder = (PostsSortOrder) [nextOptions[index] integerValue];
    }

    return nextOrder;
}

@end
