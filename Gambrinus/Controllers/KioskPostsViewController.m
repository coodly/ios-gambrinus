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

#import "KioskPostsViewController.h"
#import "ObjectModel.h"
#import "ObjectModel+Posts.h"
#import "PostCell.h"
#import "UIView+JCSLoadView.h"
#import "PoweredByViewController.h"
#import "JCSLocalization.h"

@interface KioskPostsViewController ()

@end

@implementation KioskPostsViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setFetchedEntityCellNib:[PostCell viewNib]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:JCSLocalizedString(@"kiosk.posts.controller.title", nil)];

    UIImageView *poweredByImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PoweredBy"]];

    UIView *poweredByContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, poweredByImage.bounds.size.width + 10, poweredByImage.bounds.size.height + 5)];
    [poweredByContainer setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [poweredByContainer.layer setCornerRadius:5];
    [poweredByContainer setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    [poweredByContainer setFrame:CGRectOffset(poweredByContainer.bounds, CGRectGetWidth(self.view.bounds) - CGRectGetWidth(poweredByContainer.bounds) + 5, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(poweredByContainer.bounds) + 5)];
    [poweredByImage setFrame:CGRectOffset(poweredByImage.bounds, 5, 0)];
    [poweredByContainer addSubview:poweredByImage];
    [self.view addSubview:poweredByContainer];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPoweredBy)];
    [poweredByContainer addGestureRecognizer:recognizer];

    [self setShowingInKioskMode:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)createFetchedController {
    return [self.objectModel fetchedControllerForAllPosts];
}

- (BOOL)showDates {
    return NO;
}

- (void)showPoweredBy {
    PoweredByViewController *controller = [[PoweredByViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
