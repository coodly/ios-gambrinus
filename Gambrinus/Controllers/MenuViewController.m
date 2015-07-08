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
#import "MenuViewController.h"
#import "MenuCell.h"
#import "UIView+JCSLoadView.h"
#import "UIColor+Theme.h"
#import "ObjectModel.h"
#import "ObjectModel+Settings.h"
#import <Gambrinus-Swift.h>

NSString *const KioskMenuCellIdentifier = @"KioskMenuCellIdentifier";

@interface MenuViewController ()

@property (nonatomic, strong) NSIndexPath *sortByPostDate;
@property (nonatomic, strong) NSIndexPath *sortByPostName;
@property (nonatomic, strong) NSIndexPath *sortByBeerName;
@property (nonatomic, strong) NSIndexPath *sortByScore;
@property (nonatomic, strong) NSIndexPath *sortByStyle;
@property (nonatomic, strong) NSIndexPath *sortByBrewer;

@property (nonatomic, strong) NSArray *sortOptions;

@property (nonatomic, assign) NSUInteger sortOptionsSection;

@end

@implementation MenuViewController

- (instancetype)init {
    self = [super initWithNibName:@"MenuViewController" bundle:nil];
    if (self) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[MenuCell viewNib] forCellReuseIdentifier:KioskMenuCellIdentifier];

    [self.view setBackgroundColor:[UIColor controllerBackgroundColor]];
    [self.tableView setSeparatorColor:[UIColor controllerBackgroundColor]];

    UIImageView *poweredBy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PoweredBy"]];
    [poweredBy setContentMode:UIViewContentModeCenter];
    [self.tableView setTableFooterView:poweredBy];

    [self.tableView setScrollsToTop:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PostsSortOrder sortOrder = [self.objectModel postsSortOrder];
    NSIndexPath *activeIndexPath = [self indexPathForOrder:sortOrder];
    MenuCell *cell = (MenuCell *) [self.tableView cellForRowAtIndexPath:activeIndexPath];
    [self setSortMarkerOnCell:cell order:sortOrder];
}

- (void)appendSortOptions {
    self.sortOptionsSection = [self currentOpenSection];

    self.sortByPostDate = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.date", nil)];
    self.sortByPostName = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.posts", nil)];
    //self.sortByBeerName = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.beer", nil)];
    self.sortByScore = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.score", nil)];
    //self.sortByStyle = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.style", nil)];
    //self.sortByStyle = [self addMenuCellWithTitle:NSLocalizedString(@"menu.controller.sort.by.brewer", nil)];

    self.sortOptions = @[
            @[@(OrderByDateDesc), @(OrderByDateAsc)],
            @[@(OrderByPostName)],
            //@[@(OrderByRBBeerName)],
            @[@(OrderByRBScore)],
            //@[@(OrderByStyle)],
            //@[@(OrderByBrewer)]
    ];
}

- (NSIndexPath *)addMenuCellWithTitle:(NSString *)title {
    MenuCell *sortByPostName = [self.tableView dequeueReusableCellWithIdentifier:KioskMenuCellIdentifier];
    [sortByPostName.textLabel setText:title];
    return [self addCellForPresentation:sortByPostName];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.sortOptionsSection) {
        return;
    }

    PostsSortOrder currentOrder = [self.objectModel postsSortOrder];
    PostsSortOrder nextOrder = [self nextOrderUsingRow:indexPath.row currentOrder:currentOrder];

    [self.container closeMenu];

    if (currentOrder == nextOrder) {
        return;
    }

    NSIndexPath *indexPathForCurrentOrder = [self indexPathForOrder:currentOrder];

    MenuCell *oldCell = (MenuCell *) [self.tableView cellForRowAtIndexPath:indexPathForCurrentOrder];
    [oldCell setAccessoryType:UITableViewCellAccessoryNone];
    [oldCell setAccessoryView:nil];

    MenuCell *selectedCell = (MenuCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [self setSortMarkerOnCell:selectedCell order:nextOrder];
    [self.objectModel setPostsSortOrder:nextOrder];
}

- (NSIndexPath *)indexPathForOrder:(PostsSortOrder)order {
    NSNumber *orderNumber = @(order);
    for (NSInteger row = 0; row < self.sortOptions.count; row++) {
        NSArray *rowOptions = self.sortOptions[row];
        if ([rowOptions containsObject:orderNumber]) {
            return [NSIndexPath indexPathForRow:row inSection:self.sortOptionsSection];
        }
    }

    JCSAssert(NO);
    return nil;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == self.sortOptionsSection) {
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
