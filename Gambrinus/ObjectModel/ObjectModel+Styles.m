//
//  ObjectModel+Styles.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ObjectModel+Styles.h"
#import "BeerStyle.h"

@implementation ObjectModel (Styles)

- (BeerStyle *)fetchStyleWithName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    return [self fetchEntityNamed:[BeerStyle entityName] withPredicate:predicate];
}

- (BeerStyle *)findOrCreateStyleWithName:(NSString *)name {
    BeerStyle *style = [self fetchStyleWithName:name];
    if (!style) {
        style = [BeerStyle insertInManagedObjectContext:self.managedObjectContext];
        [style setName:name];
    }
    return style;
}

@end
