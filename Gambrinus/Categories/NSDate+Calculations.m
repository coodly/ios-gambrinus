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

#import "NSDate+Calculations.h"

@implementation NSDate (Calculations)

+ (NSDate *)dateOnYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [[NSDate gregorian] dateFromComponents:components];
}

- (NSDate *)beginningOfWeek {
    return [NSDate dateForUnit:NSWeekCalendarUnit beforeDate:self];
}

+ (NSDate *)dateForUnit:(NSCalendarUnit)unit beforeDate:(NSDate *)date {
    NSDate *result;
    [[NSDate gregorian] rangeOfUnit:unit
                          startDate:&result
                           interval:0
                            forDate:date];
    return result;
}

- (NSDate *)startOfNextWeek {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.week = 1;
    return [[NSDate gregorian] dateByAddingComponents:components toDate:self options:0];
}

NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

@end
