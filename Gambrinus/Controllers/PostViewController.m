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

#import "PostViewController.h"
#import "Post.h"
#import "UIColor+Theme.h"
#import "BloggerAPIConnection.h"
#import "BlogImagesRetrieve.h"
#import "BlogImageAsk.h"
#import "BlogPostView.h"
#import "UIView+JCSLoadView.h"
#import "ObjectModel.h"
#import "ContentUpdate.h"
#import "PostImageController.h"
#import "Constants.h"

CGFloat const kPostContentPadding = 20;

@interface PostViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) BlogPostView *postView;
@property (nonatomic, strong) UIBarButtonItem *starButton;

@end

@implementation PostViewController

- (id)init {
    self = [super initWithNibName:@"PostViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[UIColor controllerBackgroundColor]];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(startPullRefresh) forControlEvents:UIControlEventValueChanged];
    [self.contentScrollView addSubview:refreshControl];

    [self.navigationItem setTitle:self.post.title];

    BlogPostView *postView = [BlogPostView loadInstance];
    [postView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self setPostView:postView];
    [self.contentScrollView addSubview:postView];

    __weak PostViewController *weakSelf = self;
    [postView setImageTapHandler:^{
        [weakSelf presentImage];
    }];

    CGRect postFrame = self.contentScrollView.bounds;
    postFrame.origin = CGPointMake(kPostContentPadding, kPostContentPadding);
    postFrame.size = CGSizeMake(CGRectGetWidth(postFrame) - 2 * kPostContentPadding, CGRectGetHeight(postFrame) - 2 * kPostContentPadding);
    [self.postView setFrame:postFrame];

    [self setStarButton:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"726-star-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(starPressed)]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadPostDetails];

    if (!self.showMarked) {
        return;
    }

    [self.navigationItem setRightBarButtonItem:self.starButton];
    [self updateStarStatus:self.post.starredValue];
}

- (void)contentSizeChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPostDetails];
    });
}

- (void)loadPostDetails {
    void (^imageLoadBlock)(CDYImageAsk *, UIImage *) = ^(CDYImageAsk *forAsk, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.postView setPostImage:image];
        });
    };

    BlogImageAsk *ask = [self.post postImageAsk];
    if ([self.imagesRetrieve hasImageForAsk:ask]) {
        NSLog(@"Load image");
        imageLoadBlock(ask, [self.imagesRetrieve imageForAsk:ask]);
    } else {
        NSLog(@"Retrieve image");
        [self.imagesRetrieve retrieveImageForAsk:ask completion:imageLoadBlock];
    }

    [self.postView setPostContent:self.post.content];
}

- (void)startPullRefresh {
    [self.contentUpdate refreshPost:self.post withCompletionHandler:^(BOOL complete, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.post.managedObjectContext refreshObject:self.post mergeChanges:YES];
            [self loadPostDetails];
            [self.refreshControl endRefreshing];
        });
    }];
}

- (void)starPressed {
    [self.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
        ObjectModel *model = (ObjectModel *) objectModel;
        Post *post = (Post *) [model.managedObjectContext objectWithID:self.post.objectID];
        [post setStarredValue:!post.starredValue];
    } completion:^{
        [self.objectModel.managedObjectContext refreshObject:self.post mergeChanges:YES];
        [self updateStarStatus:self.post.starredValue];
    }];
}

- (void)updateStarStatus:(BOOL)starred {
    [self.starButton setImage:starred ? [UIImage imageNamed:@"726-star-toolbar-selected"] : [UIImage imageNamed:@"726-star-toolbar"]];
}

- (void)presentImage {
    if (IS_PAD) {
        return;
    }

    BlogImageAsk *ask = [self.post originalImageAsk];
    if (![self.imagesRetrieve hasImageForAsk:ask]) {
        return;
    }

    UIImage *image = [self.imagesRetrieve imageForAsk:ask];
    PostImageController *controller = [[PostImageController alloc] init];
    [controller setImage:image];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
