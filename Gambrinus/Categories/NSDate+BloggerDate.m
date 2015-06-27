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

#import "NSDate+BloggerDate.h"
#import "Constants.h"

@implementation NSDate (BloggerDate)

+ (NSDate *)bloggerDateFromString:(NSString *)dateString {
    NSString *parsed = [NSString stringWithString:dateString];
    parsed = [parsed stringByReplacingCharactersInRange:NSMakeRange(dateString.length - 3, 3) withString:@"00"];
    NSDate *result = [[NSDate bloggerDateFormatter] dateFromString:parsed];
    return result;
}

- (id)bloggerDateString {
    NSString *dateString = [[NSDate bloggerDateFormatter] stringFromDate:self];
    return dateString;
}

static NSDateFormatter *__bloggerDateFormatter;
+ (NSDateFormatter *)bloggerDateFormatter {
    if (!__bloggerDateFormatter) {
        __bloggerDateFormatter =  [[NSDateFormatter alloc] init];
        [__bloggerDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    }

    return __bloggerDateFormatter;
}

@end
