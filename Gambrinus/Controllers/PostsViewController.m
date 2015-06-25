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
#import "PostsViewController.h"
#import "PostCell.h"
#import "ObjectModel.h"
#import "BlogImagesRetrieve.h"
#import "BloggerAPIConnection.h"
#import "UIColor+Theme.h"
#import "ProgressOverlayView.h"
#import "ObjectModel+Posts.h"
#import "Constants.h"
#import "BlogImageAsk.h"
#import "Post.h"
#import "Image.h"
#import "ContentUpdate.h"
#import "PostsSearchInputView.h"
#import "PostExtendedDetailsViewController.h"

@interface PostsViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL refreshed;
@property (nonatomic, strong) PostsSearchInputView *searchInputView;
@property (nonatomic, copy) NSString *currentFilter;

@end

@implementation PostsViewController

- (id)init {
    self = [super initWithNibName:@"PostsViewController" bundle:nil];
    if (self) {
        [self setFetchedEntityCellNib:[PostCell viewNib]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCurrentFilter:@""];

    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor controllerBackgroundColor]];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(startPullRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];

    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"708-search-toolbar"] style:UIBarButtonItemStyleDone target:self action:@selector(searchTapped)];
    [self.navigationItem setRightBarButtonItem:search];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortOrderChanged) name:GambrinusSortOrderChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.refreshed && [self.objectModel postsNotLoaded]) {
        [self refreshPosts];

        [self setRefreshed:YES];
    }

    [self checkImagesNeeded];
}

- (void)startPullRefresh {
    [self refreshPosts:NO];
}

- (void)refreshPosts {
    [self refreshPosts:YES];
}

- (void)refreshPosts:(BOOL)showHud {
    ProgressOverlayView *hud;
    if (showHud) {
        hud = [ProgressOverlayView showHUDOnView:self.navigationController.view];
    }
    [self.contentUpdate updateWithCompletionHandler:^(BOOL complete, NSError *error) {
        [self.refreshControl endRefreshing];
        [hud hide];
    }];
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    PostCell *postCell = (PostCell *) cell;
    Post *post = object;
    [postCell setTitle:post.title];
    [postCell setDateString:[self showDates] ? post.publishDateString : nil];
    [postCell setRateBeerScore:post.rateBeerScore];

    if (!post.image) {
        [postCell.imageView setImage:nil];
        return;
    }

    BlogImageAsk *ask = [post thumbnailImageAsk];
    if ([self.imagesRetrieve hasImageForAsk:ask]) {
        UIImage *image = [self.imagesRetrieve imageForAsk:ask];
        [postCell.imageView setImage:image];
    } else {
        [postCell.imageView setImage:nil];
    }
}

- (void)tappedOnObject:(id)tapped {
    PostExtendedDetailsViewController *controller = [[PostExtendedDetailsViewController alloc] init];
    [controller setPost:tapped];
    [controller setContentUpdate:self.contentUpdate];
    [controller setImagesRetrieve:self.imagesRetrieve];
    [controller setInKioskMode:self.showingInKioskMode];
    [controller setObjectModel:self.objectModel];
    if (IS_PAD) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
        [navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)contentChanged {
    [self checkImagesNeeded];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_PAD) {
        return CGSizeMake(240, 240);
    } else {
        CGFloat screenWidth = CGRectGetWidth(self.view.frame);
        screenWidth -= 20;
        return CGSizeMake(screenWidth / 2, screenWidth / 2);
    }
}

- (void)checkImagesNeeded {
    NSLog(@"checkImagesNeeded");
    NSArray *cells = [self.collectionView visibleCells];
    for (PostCell *cell in cells) {
        if (cell.imageView.image) {
            continue;
        }

        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        Post *post = [self.allObjects objectAtIndexPath:indexPath];
        BlogImageAsk *ask = [post thumbnailImageAsk];

        if (!ask.shouldAttemptRemotePull) {
            CDYLog(@"Snould not attempt pull of %@ - %@", post.title, ask.imageURL);
            continue;
        }

        [self.imagesRetrieve retrieveImageForAsk:ask completion:^(CDYImageAsk *forAsk, UIImage *image) {
            [self.objectModel performBlock:^{
                BlogImageAsk *imageAsk = (BlogImageAsk *) forAsk;
                PostID *postID = imageAsk.postID;
                Post *askPost = (Post *) [self.objectModel.managedObjectContext objectWithID:postID];
                if (!image) {
                    CDYLog(@"No image for %@", imageAsk.imageURL);
                    [post.image markPullFailed];
                } else {
                    [post.image markPullSuccess];
                }

                NSIndexPath *postIndexPath = [self.allObjects indexPathForObject:askPost];
                NSArray *visible = [self.collectionView indexPathsForVisibleItems];
                if (![visible containsObject:postIndexPath]) {
                    return;
                }

                PostCell *postCell = (PostCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
                [postCell.imageView setImage:image];
                [postCell.imageView.layer addAnimation:[CATransition animation] forKey:kCATransition];

                [self.objectModel saveContext];
            }];
        }];
    }
}

- (void)removeRefreshControl {
    [self.refreshControl removeFromSuperview];
}

- (BOOL)showDates {
    return YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CDYLog(@"scrollViewDidEndDragging:%d", decelerate);
    if (!decelerate) {
        [self checkImagesNeeded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CDYLog(@"scrollViewDidEndDecelerating");
    [self checkImagesNeeded];
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)searchTapped {
    if (self.searchInputView) {
        [self hideSearchInput];
    } else {
        [self showSearchInput];
    }
}

- (void)showSearchInput {
    PostsSearchInputView *inputView = [PostsSearchInputView loadInstance];
    [self setSearchInputView:inputView];
    [inputView setSearchTermChangeHandler:^(NSString *searchTerm) {
        [self searchTermChanged:searchTerm];
    }];
    [self.view addSubview:self.searchInputView];
    [inputView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    CGRect searchFrame = self.searchInputView.frame;
    searchFrame.origin.y = CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20;
    searchFrame.size.width = CGRectGetWidth(self.view.bounds);
    [self.searchInputView setFrame:CGRectOffset(searchFrame, 0, -CGRectGetHeight(searchFrame))];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchInputView setFrame:searchFrame];
    }];
    [self.searchInputView.searchField becomeFirstResponder];
}

- (void)hideSearchInput {
    [self.searchInputView.searchField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect searchFrame = self.searchInputView.frame;
        [self.searchInputView setFrame:CGRectOffset(searchFrame, 0, -CGRectGetHeight(searchFrame))];
    } completion:^(BOOL finished) {
        [self.searchInputView removeFromSuperview];
        [self setSearchInputView:nil];
        [self searchTermChanged:@"" forceUpdate:YES];
    }];
}

- (void)searchTermChanged:(NSString *)searchTerm {
    [self searchTermChanged:searchTerm forceUpdate:NO];
}

- (void)searchTermChanged:(NSString *)searchTerm forceUpdate:(BOOL)force {
    if (!force && [searchTerm isEqualToString:self.currentFilter]) {
        return;
    }

    [self setCurrentFilter:searchTerm];

    NSPredicate *predicate = [self.objectModel postsPredicateWithSearchTerm:searchTerm showHidden:[self showHiddenPosts] showOnlyStarred:[self showOnlyStarred]];
    [self refreshFetchedControllerUsingPredicate:predicate sortDescriptors:nil];
}

- (void)refreshFetchedControllerUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    if (predicate) {
        [self.allObjects.fetchRequest setPredicate:predicate];
    }

    if (sortDescriptors) {
        [self.allObjects.fetchRequest setSortDescriptors:sortDescriptors];
    }

    NSError *fetchError = nil;
    [self.allObjects performFetch:&fetchError];
    if (fetchError) {
        NSLog(@"Fetch error:%@", fetchError);
    }

    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {
        [self checkImagesNeeded];
    }];
}

- (void)sortOrderChanged {
    NSArray *sortDescriptors = [self.objectModel postSortDescriptorsForCurrentSortOrder];
    [self refreshFetchedControllerUsingPredicate:nil sortDescriptors:sortDescriptors];
}

- (BOOL)showHiddenPosts {
    return NO;
}

- (BOOL)showOnlyStarred {
    return NO;
}

@end
