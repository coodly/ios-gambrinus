//
//  ObjectModel+Brewers.h
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ObjectModel.h"

@class Brewer;

@interface ObjectModel (Brewers)

- (Brewer *)findOrCreateBrewerWithName:(NSString *)name;

@end
