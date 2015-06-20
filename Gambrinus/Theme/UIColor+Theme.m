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

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)myOrange {
    return [UIColor colorWithRed:0.984 green:0.178 blue:0.018 alpha:1.000];
}

+ (UIColor *)controllerBackgroundColor {
    return [UIColor colorWithWhite:0.914 alpha:1.000];
}

+ (UIColor *)rateBeerYellow {
    return [UIColor colorWithRed:0.980 green:0.773 blue:0.027 alpha:1.000];
}

+ (UIColor *)rateBeerWhite {
    return [UIColor colorWithWhite:0.996 alpha:1.000];
}

+ (UIColor *)rateBeerBlue {
    return [UIColor colorWithRed:0.000 green:0.176 blue:0.427 alpha:1.000];
}

@end
