//
//  UIFont+Theme.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)rateBeerFont {
    UIFont *system = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    return [UIFont fontWithName:@"Triplex-Bold" size:system.pointSize * 1.5f];
}

@end
