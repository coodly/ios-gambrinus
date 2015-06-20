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

#import "MainViewController.h"
#import "ObjectModel.h"
#import "BlogImagesRetrieve.h"
#import "MarkedPostsViewController.h"
#import "BlogPostsViewController.h"
#import "UIColor+Theme.h"
#import "ObjectModel+Posts.h"
#import "ContentUpdate.h"
#import "KioskPostsViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UITabBarController *contentTabController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [self setContentTabController:tabController];
    [tabController.view setFrame:self.view.bounds];
    [tabController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addChildViewController:tabController];
    [self.view addSubview:tabController.view];

    MarkedPostsViewController *markedViewController = [[MarkedPostsViewController alloc] init];
    UINavigationController *markedNavigationController = [[UINavigationController alloc] initWithRootViewController:markedViewController];
    [markedViewController setObjectModel:self.objectModel];
    [markedViewController setContentUpdate:self.contentUpdate];
    [markedViewController setImagesRetrieve:self.imagesRetrieve];

    BlogPostsViewController *postsViewController = [[BlogPostsViewController alloc] init];
    UINavigationController *postsNavigationController = [[UINavigationController alloc] initWithRootViewController:postsViewController];
    [postsViewController setObjectModel:self.objectModel];
    [postsViewController setContentUpdate:self.contentUpdate];
    [postsViewController setImagesRetrieve:self.imagesRetrieve];

    [self.contentTabController setViewControllers:@[markedNavigationController, postsNavigationController]];

    [self.contentTabController.tabBar setTintColor:[UIColor myOrange]];

    if (![self.objectModel hasStarredPosts]) {
        [self.contentTabController setSelectedViewController:postsNavigationController];
    }

#if DEBUG
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentKioskController)];
    [recognizer setNumberOfTapsRequired:3];
    [recognizer setNumberOfTouchesRequired:1];
    [self.contentTabController.tabBar addGestureRecognizer:recognizer];
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guidedAccessStatusChanged) name:UIAccessibilityGuidedAccessStatusDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)guidedAccessStatusChanged  {
    if (UIAccessibilityIsGuidedAccessEnabled()) {
        [self presentKioskController];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)presentKioskController {
    KioskPostsViewController *controller = [[KioskPostsViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setContentUpdate:self.contentUpdate];
    [controller setImagesRetrieve:self.imagesRetrieve];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
