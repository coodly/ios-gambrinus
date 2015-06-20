//
//  ObjectModel+Beers.m
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import "ObjectModel+Beers.h"
#import "Beer.h"
#import "ObjectModel+Brewers.h"
#import "ObjectModel+Styles.h"
#import "Post.h"

@implementation ObjectModel (Beers)

- (Beer *)existingBeerWithIdentifier:(NSNumber *)identifier {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    return [self fetchEntityNamed:[Beer entityName] withPredicate:predicate];
}

- (void)createOrUpdateBeerWithData:(NSDictionary *)data {
    NSNumber *identifier = data[BeerDataKeyIdentifier];
    Beer *beer = [self existingBeerWithIdentifier:identifier];
    if (!beer) {
        beer = [Beer insertInManagedObjectContext:self.managedObjectContext];
        [beer setIdentifier:identifier];
    }

    [beer setBindingKey:data[BeerDataKeyBindingKey]];
    [beer setName:data[BeerDataKeyName]];
    [beer setAlcohol:data[BeerDataKeyAlcohol]];
    [beer setRbIdentifier:data[BeerDataKeyRbIdentifier]];
    [beer setRbScore:data[BeerDataKeyRbScore]];
    [beer setAliased:data[BeerDataKeyAliased]];
    if (data[BeerDataKeyBrewer]) {
        [beer setBrewer:[self findOrCreateBrewerWithName:data[BeerDataKeyBrewer]]];
    }
    if (data[BeerDataKeyStyle]) {
        [beer setStyle:[self findOrCreateStyleWithName:data[BeerDataKeyStyle]]];
    }

    for (Post *post in beer.posts) {
        [post markTouched];
    }
}

- (NSArray *)beersWithBindingKeys:(NSArray *)bindingKeys {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bindingKey IN %@", bindingKeys];
    return [self fetchEntitiesNamed:[Beer entityName] withPredicate:predicate];
}

@end
