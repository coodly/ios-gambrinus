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
