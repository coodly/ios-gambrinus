//
//  ObjectModel+Brewers.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ObjectModel+Brewers.h"
#import "Brewer.h"

@implementation ObjectModel (Brewers)

- (Brewer *)fetchBrewerWithName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    return [self fetchEntityNamed:[Brewer entityName] withPredicate:predicate];
}

- (Brewer *)findOrCreateBrewerWithName:(NSString *)name {
    Brewer *brewer = [self fetchBrewerWithName:name];
    if (!brewer) {
        brewer = [Brewer insertInManagedObjectContext:self.managedObjectContext];
        [brewer setName:name];
    }
    return brewer;
}

@end
