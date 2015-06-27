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

#import "BeerStyle.h"
#import "NSString+Normalize.h"
#import "NSString+JCSValidations.h"

@interface BeerStyle ()

@end

@implementation BeerStyle

- (void)willSave {
    [super willSave];

    if (!self.name.hasValue) {
        return;
    }

    NSString *normalizedName = [self.name normalize];
    if ([normalizedName isEqualToString:self.normalizedName]) {
        return;
    }

    [self setNormalizedName:normalizedName];
}

@end
