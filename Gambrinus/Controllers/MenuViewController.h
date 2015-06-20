//
//  MenuViewController.h
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JCSFoundation/JCSInputCellsViewController.h>

@class KioskSlideMenuViewController;

extern NSString *const KioskMenuCellIdentifier;

@interface MenuViewController : JCSInputCellsViewController

@property (nonatomic, weak) KioskSlideMenuViewController *container;

@end
