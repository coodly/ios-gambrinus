//
//  MenuCell.m
//  Gambrinus
//
//  Created by Jaanus Siim on 03/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "MenuCell.h"
#import "UIColor+Theme.h"

@implementation MenuCell

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.textLabel setTextColor:[UIColor myOrange]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
