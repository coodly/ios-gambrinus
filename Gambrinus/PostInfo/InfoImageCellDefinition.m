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

#import "InfoImageCellDefinition.h"
#import "BlogImageAsk.h"
#import "Constants.h"
#import "PostImageCell.h"
#import "BlogImagesRetrieve.h"

@implementation InfoImageCellDefinition

- (void)configureCell:(UICollectionViewCell *)cell {
    PostImageCell *imageCell = (PostImageCell *) cell;
    [self retrievePostImage:imageCell];
}

- (void)retrievePostImage:(PostImageCell *)cell {
    void (^imageLoadBlock)(CDYImageAsk *, UIImage *) = ^(CDYImageAsk *forAsk, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
            [cell.imageView.layer addAnimation:[CATransition animation] forKey:kCATransition];
        });
    };

    if ([self.imagesRetrieve hasImageForAsk:self.imageAsk]) {
        CDYLog(@"Load image");
        imageLoadBlock(self.imageAsk, [self.imagesRetrieve imageForAsk:self.imageAsk]);
    } else {
        CDYLog(@"Retrieve image");
        [self.imagesRetrieve retrieveImageForAsk:self.imageAsk completion:imageLoadBlock];
    }
}

- (CGFloat)heightOfContentForWidth:(CGFloat)presentationWidth {
    return IS_PAD ? 200 : 150;
}

@end
