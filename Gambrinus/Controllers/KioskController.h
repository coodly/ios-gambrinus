//
//  KioskController.h
//  Gambrinus
//
//  Created by Jaanus Siim on 03/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

@import UIKit;

@class BlogImagesRetrieve;
@class ObjectModel;
@class ContentUpdate;

@protocol KioskController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) ContentUpdate *contentUpdate;
@property (nonatomic, strong) BlogImagesRetrieve *imagesRetrieve;

@end
