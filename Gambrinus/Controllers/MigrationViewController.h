//
//  MigrationViewController.h
//  Gambrinus
//
//  Created by Jaanus Siim on 25/08/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDYObjectModel.h"
#import "ObjectModel.h"

@interface MigrationViewController : UIViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) CDYModelActionBlock completion;

@end
