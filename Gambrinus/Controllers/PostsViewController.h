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

#import <UIKit/UIKit.h>
#import "JCSFetchedCollectionViewController.h"
#import "KioskController.h"

@class ObjectModel;
@class BlogImagesRetrieve;
@class ContentUpdate;

@interface PostsViewController : JCSFetchedCollectionViewController <KioskController>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) ContentUpdate *contentUpdate;
@property (nonatomic, strong) BlogImagesRetrieve *imagesRetrieve;
@property (nonatomic, assign) BOOL showingInKioskMode;

- (void)checkImagesNeeded;
- (void)removeRefreshControl;
- (BOOL)showDates;
- (BOOL)showHiddenPosts;
- (BOOL)showOnlyStarred;

@end
