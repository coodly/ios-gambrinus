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
