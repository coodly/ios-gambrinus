//
//  ObjectModel+Beers.h
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (Beers)

- (void)createOrUpdateBeerWithData:(NSDictionary *)data;
- (NSArray *)beersWithBindingKeys:(NSArray *)bindingKeys;

@end