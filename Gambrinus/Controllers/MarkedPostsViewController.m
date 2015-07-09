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

#import "MarkedPostsViewController.h"
#import "ObjectModel+Blogs.h"
#import "ObjectModel+Posts.h"
#import "PostCell.h"
#import "JCSLocalization.h"

@interface MarkedPostsViewController ()

@end

@implementation MarkedPostsViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"marked.controller.title", nil) image:[UIImage imageNamed:@"726-star"] selectedImage:[UIImage imageNamed:@"726-star-selected"]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self removeRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:JCSLocalizedString(@"marked.controller.title", nil)];
}

- (NSFetchedResultsController *)createFetchedController {
    return [self.objectModel fetchedControllerForStarredPostsSortedByName];
}

- (BOOL)showDates {
    return NO;
}

- (BOOL)showOnlyStarred {
    return YES;
}

@end
