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
#import <CDYImagesRetrieve/CDYImageAsk.h>
#import "PostExtendedDetailsViewController.h"
#import "PostImageCell.h"
#import "UIView+Identifier.h"
#import "Constants.h"
#import "_Post.h"
#import "Post.h"
#import "PostContentCell.h"
#import "BlogImagesRetrieve.h"
#import "BlogImageAsk.h"
#import "PostImageController.h"
#import "ObjectModel.h"
#import "PostInfoRowCell.h"

typedef NS_ENUM(short, DetailSection) {
    SectionContent,
    SectionRateBeer
};

typedef NS_ENUM(short, DetailRow) {
    RowImage,
    RowContent,
    RowPostDate
};

@interface PostExtendedDetailsViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *presentedSections;

@end

@implementation PostExtendedDetailsViewController

- (instancetype)init {
    self = [super initWithNibName:@"PostExtendedDetailsViewController" bundle:nil];
    if (self) {

    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPresentedSections:@[
            @[
                    @(RowImage),
                    @(RowContent),
                    @(RowPostDate)
            ]
    ]];

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];

    [self.collectionView registerNib:[PostImageCell viewNib] forCellWithReuseIdentifier:[PostImageCell identifier]];
    [self.collectionView registerNib:[PostContentCell viewNib] forCellWithReuseIdentifier:[PostContentCell identifier]];
    [self.collectionView registerNib:[PostInfoRowCell viewNib] forCellWithReuseIdentifier:[PostInfoRowCell identifier]];

    if (IS_PAD) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post.extended.details.back.button.title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close)]];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:self.post.title];

    [self updateStarButton];
}

- (void)updateStarButton {
    if (self.isInKioskMode) {
        return;
    }

    UIImage *image = self.post.starredValue ? [UIImage imageNamed:@"726-star-toolbar-selected"] : [UIImage imageNamed:@"726-star-toolbar"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(starPost)]];
}

- (void)starPost {
    [self.post setStarredValue:!self.post.starredValue];
    [self updateStarButton];
    [self.objectModel saveContext];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.presentedSections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionRows = self.presentedSections[section];
    return sectionRows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self configuredCellForIndexPath:indexPath];
    return cell;
}

- (UICollectionViewCell *)configuredCellForIndexPath:(NSIndexPath *)indexPath {
    DetailRow type = [self typeForIndexPath:indexPath];
    UICollectionViewCell *cell = nil;
    switch (type) {
        case RowImage: {
            PostImageCell *imageCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[PostImageCell identifier] forIndexPath:indexPath];
            [self retrievePostImage:imageCell];
            cell = imageCell;
            break;
        }
        case RowContent: {
            PostContentCell *contentCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[PostContentCell identifier] forIndexPath:indexPath];
            [contentCell.contentLabel setText:self.post.content];
            cell = contentCell;
            break;
        }
        case RowPostDate: {
            PostInfoRowCell *dateRowCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[PostInfoRowCell identifier] forIndexPath:indexPath];
            [dateRowCell setTitle:NSLocalizedString(@"post.extended.details.posted.on.label", nil) value:self.post.publishDateString];
            cell = dateRowCell;
            break;
        };
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    DetailRow type = [self typeForIndexPath:indexPath];
    if (type == RowImage) {
        [self presentImage];
    }
}

- (void)presentImage {
    BlogImageAsk *ask = [self.post originalImageAsk];
    if (![self.imagesRetrieve hasImageForAsk:ask]) {
        return;
    }

    UIImage *image = [self.imagesRetrieve imageForAsk:ask];
    PostImageController *controller = [[PostImageController alloc] init];
    [controller setImage:image];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController pushViewController:controller animated:YES];
}

- (DetailRow)typeForIndexPath:(NSIndexPath *)indexPath {
    NSNumber *row = self.presentedSections[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
    return (DetailRow) row.integerValue;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailRow type = [self typeForIndexPath:indexPath];
    CGSize size = CGSizeZero;
    switch (type) {
        case RowImage:
            size = CGSizeMake(CGRectGetWidth(self.view.frame), IS_PAD ? 200 : 150);
            break;
        case RowContent:
            size = CGSizeMake(CGRectGetWidth(self.view.frame),
                    [self calculateHeightForString:self.post.content usingFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]] + 8 * 2 + 50);
            break;
        case RowPostDate:
            size = CGSizeMake(CGRectGetWidth(self.view.frame),
                    [self calculateHeightForString:NSLocalizedString(@"post.extended.details.posted.on.label", nil) usingFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]] + 8 * 2);
            break;
    }
    return size;
}

- (CGFloat)calculateHeightForString:(NSString *)string usingFont:(UIFont *)font {
    CGRect bounds = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 8 * 2, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil];
    return CGRectGetHeight(bounds);
}

- (void)retrievePostImage:(PostImageCell *)cell {
    void (^imageLoadBlock)(CDYImageAsk *, UIImage *) = ^(CDYImageAsk *forAsk, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
            [cell.imageView.layer addAnimation:[CATransition animation] forKey:kCATransition];
        });
    };

    BlogImageAsk *ask = [self.post postImageAsk];
    if ([self.imagesRetrieve hasImageForAsk:ask]) {
        CDYLog(@"Load image");
        imageLoadBlock(ask, [self.imagesRetrieve imageForAsk:ask]);
    } else {
        CDYLog(@"Retrieve image");
        [self.imagesRetrieve retrieveImageForAsk:ask completion:imageLoadBlock];
    }
}

- (void)contentSizeChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.collectionViewLayout invalidateLayout];
    });
}

- (CGFloat)calculateHeightForCell:(UICollectionViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];

    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


@end
