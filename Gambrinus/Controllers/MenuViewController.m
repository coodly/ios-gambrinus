//
//  MenuViewController.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "UIView+JCSLoadView.h"
#import "UIColor+Theme.h"

NSString *const KioskMenuCellIdentifier = @"KioskMenuCellIdentifier";

@interface MenuViewController ()

@end

@implementation MenuViewController

- (instancetype)init {
    self = [super initWithNibName:@"MenuViewController" bundle:nil];
    if (self) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[MenuCell viewNib] forCellReuseIdentifier:KioskMenuCellIdentifier];

    [self.view setBackgroundColor:[UIColor controllerBackgroundColor]];
    [self.tableView setSeparatorColor:[UIColor controllerBackgroundColor]];

    UIImageView *poweredBy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PoweredBy"]];
    [poweredBy setContentMode:UIViewContentModeCenter];
    [self.tableView setTableFooterView:poweredBy];

    [self.tableView setScrollsToTop:NO];
}

@end
