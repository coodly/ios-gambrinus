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
