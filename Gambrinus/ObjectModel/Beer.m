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

#import "Beer.h"
#import "NSString+JCSValidations.h"
#import "NSString+Normalize.h"

NSString *const BeerDataKeyBindingKey = @"bindingKey";
NSString *const BeerDataKeyIdentifier = @"identifier";
NSString *const BeerDataKeyName = @"name";
NSString *const BeerDataKeyRbScore = @"rbscore";
NSString *const BeerDataKeyRbIdentifier = @"rbidentifier";
NSString *const BeerDataKeyBrewer = @"brewer";
NSString *const BeerDataKeyStyle = @"style";
NSString *const BeerDataKeyAlcohol = @"alcohol";
NSString *const BeerDataKeyAliased = @"aliased";

@interface Beer ()

@end

@implementation Beer

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
