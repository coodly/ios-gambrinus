//
//  MigrationViewController.m
//  Gambrinus
//
//  Created by Jaanus Siim on 25/08/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "MigrationViewController.h"
#import "Gambrinus-Swift.h"

@interface MigrationViewController ()

@end

@implementation MigrationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //trigger DB access
    [self.objectModel countInstancesOfEntity:[Post entityName]];
    self.completion();
}

@end
