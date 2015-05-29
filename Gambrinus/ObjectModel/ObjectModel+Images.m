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

#import "ObjectModel+Images.h"
#import "Image.h"

@implementation ObjectModel (Images)

- (Image *)findOrCreteImageWithURLString:(NSString *)imageURLString {
    Image *image = [self imageWithURLString:imageURLString];
    if (!image) {
        image = [Image insertInManagedObjectContext:self.managedObjectContext];
        [image setImageURLString:imageURLString];
    }
    return image;
}

- (Image *)imageWithURLString:(NSString *)imageURLString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageURLString = %@", imageURLString];
    return [self fetchEntityNamed:[Image entityName] withPredicate:predicate];
}

@end
