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
#import "InfoImageCellDefinition.h"
#import "InfoPostContentCellDefinition.h"
#import "InfoTitleDetailCellDefinition.h"
#import "InfoRateBeerSectionTitleDefinition.h"
#import "RateBeerSectionTitleCell.h"
#import "Beer.h"
#import "RateBeerDetailsCellDefinition.h"
#import "RateBeerDetailsCollectionViewCell.h"
#import "InfoSpacingCellDefinition.h"
#import "JCSLocalization.h"

@interface PostExtendedDetailsViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *infoRows;

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

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];

    [self.collectionView registerNib:[PostImageCell viewNib] forCellWithReuseIdentifier:[PostImageCell identifier]];
    [self.collectionView registerNib:[PostContentCell viewNib] forCellWithReuseIdentifier:[PostContentCell identifier]];
    [self.collectionView registerNib:[PostInfoRowCell viewNib] forCellWithReuseIdentifier:[PostInfoRowCell identifier]];
    [self.collectionView registerNib:[RateBeerSectionTitleCell viewNib] forCellWithReuseIdentifier:[RateBeerSectionTitleCell identifier]];
    [self.collectionView registerNib:[RateBeerDetailsCollectionViewCell viewNib] forCellWithReuseIdentifier:[RateBeerDetailsCollectionViewCell identifier]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell identifier]];

    if (IS_PAD) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post.extended.details.back.button.title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close)]];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged) name:UIContentSizeCategoryDidChangeNotification object:nil];

    NSMutableArray *presented = [NSMutableArray array];

    InfoImageCellDefinition *imageDefinition = [[InfoImageCellDefinition alloc] initWithCellIdentifier:[PostImageCell identifier]];
    [imageDefinition setImageAsk:self.post.postImageAsk];
    [imageDefinition setImagesRetrieve:self.imagesRetrieve];
    [presented addObject:imageDefinition];

    InfoPostContentCellDefinition *contentDefinition = [[InfoPostContentCellDefinition alloc] initWithCellIdentifier:[PostContentCell identifier]];
    [contentDefinition setText:self.post.content];
    [presented addObject:contentDefinition];

    InfoTitleDetailCellDefinition *postDateDefinition = [[InfoTitleDetailCellDefinition alloc] initWithCellIdentifier:[PostInfoRowCell identifier]];
    [postDateDefinition setTitle:JCSLocalizedString(@"post.extended.details.posted.on.label", nil)];
    [postDateDefinition setValue:self.post.publishDateString];
    [presented addObject:postDateDefinition];

    if (self.post.beers.count > 0)  {
        InfoRateBeerSectionTitleDefinition *rateBeerTitle = [[InfoRateBeerSectionTitleDefinition alloc] initWithCellIdentifier:[RateBeerSectionTitleCell identifier]];
        [presented addObject:rateBeerTitle];

        NSArray *beers = [self.post.beers.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for (Beer *beer in beers) {
            RateBeerDetailsCellDefinition *beerCell = [[RateBeerDetailsCellDefinition alloc] initWithCellIdentifier:[RateBeerDetailsCollectionViewCell identifier]];
            [beerCell setBeer:beer];
            [presented addObject:beerCell];
        }
    }

    InfoSpacingCellDefinition *bottomSpacing = [[InfoSpacingCellDefinition alloc] initWithCellIdentifier:[UICollectionViewCell identifier]];
    [bottomSpacing setSpacingHeight:20];
    [presented addObject:bottomSpacing];

    [self setInfoRows:@[
            presented
    ]];
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
    return self.infoRows.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionRows = self.infoRows[section];
    return sectionRows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoCellDefinition *cellDefinition = self.infoRows[indexPath.section][indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellDefinition.cellIdentifier forIndexPath:indexPath];
    [cellDefinition configureCell:cell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    InfoCellDefinition *cellDefinition = self.infoRows[indexPath.section][indexPath.row];

    if ([cellDefinition isKindOfClass:[InfoImageCellDefinition class]]) {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoCellDefinition *cellDefinition = self.infoRows[indexPath.section][indexPath.row];
    return CGSizeMake(CGRectGetWidth(self.view.frame), [cellDefinition heightOfContentForWidth:CGRectGetWidth(self.view.frame)]);
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
