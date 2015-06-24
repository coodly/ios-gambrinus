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

#import <JCSFoundation/NSDate+ISO8601.h>
#import "ObjectModel+Settings.h"
#import "Setting.h"
#import "Constants.h"

typedef NS_ENUM(short, SettingKey) {
    SettingLastVerifiedPullDate,
    SettingSortOrder
};

@implementation ObjectModel (Settings)

- (void)setLastVerifiedPullDate:(NSDate *)date {
    [self setSettingValue:[date iso8601String] forKey:SettingLastVerifiedPullDate];
}

- (NSDate *)lastVerifiedPullDate:(NSDate *)defaultDate {
    return [self dateSettingWithKey:SettingLastVerifiedPullDate defaultValue:defaultDate];
}

- (PostsSortOrder)postsSortOrder {
    return (PostsSortOrder) [self shortValueForKey:SettingSortOrder defaultValue:OrderByDateDesc];
}

- (void)setPostsSortOrder:(PostsSortOrder)order {
    [self setShortValue:order forKey:SettingSortOrder];
    [self saveContext:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GambrinusSortOrderChangedNotification object:nil];
    }];
}

- (short)shortValueForKey:(SettingKey)key defaultValue:(short)defaultValue {
    Setting *setting = [self loadSettingWithKey:key];
    if (!setting) {
        return defaultValue;
    }
    return (short) [setting.value intValue];
}

- (void)setShortValue:(short)value forKey:(SettingKey)key {
    Setting *setting = [self loadSettingWithKey:key];
    if (!setting) {
        setting = [Setting insertInManagedObjectContext:self.managedObjectContext];
        [setting setKeyValue:key];
    }

    [setting setValue:[NSString stringWithFormat:@"%d", value]];
}

- (NSDate *)dateSettingWithKey:(SettingKey)key defaultValue:(NSDate *)defaultValue {
    Setting *setting = [self loadSettingWithKey:key];
    if (!setting) {
        return defaultValue;
    }

    NSDate *result = setting.dateValue;
    if (!result) {
        result = defaultValue;
    }

    return result;
}

- (void)setSettingValue:(NSString *)value forKey:(SettingKey)key {
    Setting *setting = [self loadSettingWithKey:key];
    if (!setting) {
        setting = [Setting insertInManagedObjectContext:self.managedObjectContext];
        [setting setKeyValue:key];
    }

    [setting setValue:value];
}

- (Setting *)loadSettingWithKey:(SettingKey)key {
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"key = %d", key];
    return [self fetchEntityNamed:[Setting entityName] withPredicate:keyPredicate];
}

@end
