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
