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

#import <JCSFoundation/UIView+JCSLoadView.h>
#import "SideMenuViewController.h"
#import "MenuCell.h"
#import "BlogPostsViewController.h"
#import "MarkedPostsViewController.h"
#import "Gambrinus-Swift.h"

NSString *const KioskMenuCellIdentifier = @"KioskMenuCellIdentifier";

@interface SideMenuViewController ()

@property (nonatomic, strong) NSIndexPath *allPost;
@property (nonatomic, strong) NSIndexPath *favorites;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[MenuCell viewNib] forCellReuseIdentifier:KioskMenuCellIdentifier];

    MenuCell *allPostCell = [self.tableView dequeueReusableCellWithIdentifier:KioskMenuCellIdentifier];
    [allPostCell.textLabel setText:NSLocalizedString(@"menu.controller.option.all.posts", nil)];
    self.allPost = [self addCellForPresentation:allPostCell];

    MenuCell *favoritesCell = [self.tableView dequeueReusableCellWithIdentifier:KioskMenuCellIdentifier];
    [favoritesCell.textLabel setText:NSLocalizedString(@"menu.controller.option.favorites", nil)];
    self.favorites = [self addCellForPresentation:favoritesCell];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.allPost isEqual:indexPath]) {
        [self.container presentRootController:[[BlogPostsViewController alloc] init]];
    } else if ([self.favorites isEqual:indexPath]) {
        [self.container presentRootController:[[MarkedPostsViewController alloc] init]];
    }
}

@end
