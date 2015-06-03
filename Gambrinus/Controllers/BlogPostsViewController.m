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

#import "BlogPostsViewController.h"
#import "ObjectModel+Blogs.h"
#import "ObjectModel+Posts.h"

@interface BlogPostsViewController ()

@property (nonatomic, strong) UIBarButtonItem *editButton;

@end

@implementation BlogPostsViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"posts.controller.title", nil) image:[UIImage imageNamed:@"957-beer-mug"] selectedImage:[UIImage imageNamed:@"957-beer-mug-selected"]]];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"posts.controller.title", nil)];
}

- (void)editPressed {
    [self setEditingPosts:!self.isEditingPosts];
    [self.editButton setTitle:self.isEditingPosts ? NSLocalizedString(@"posts.controller.edit.done.button", nil) : NSLocalizedString(@"posts.controller.edit.button", nil)];
}

- (NSFetchedResultsController *)createFetchedController {
    return [self.objectModel fetchedControllerForVisiblePostsOrderedByDate];
}

- (BOOL)showHiddenPosts {
    return self.isEditingPosts;
}

@end
