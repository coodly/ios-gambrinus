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

#import "Image.h"
#import "PullStatus.h"


@interface Image ()

@end


@implementation Image

- (BOOL)shouldTryRemote {
    if (!self.pullStatus) {
        return YES;
    }

    if (!self.pullStatus.pullFailedValue) {
        return YES;
    }

    NSDate *lastPullFail = self.pullStatus.lastPullAttempt;
    NSTimeInterval secondsFromLastAttempt = [[NSDate date] timeIntervalSinceDate:lastPullFail];

    return secondsFromLastAttempt > 60 * 60;
}

- (void)markPullFailed {
    PullStatus *pullStatus = [self myPullStatus];
    [pullStatus setPullFailedValue:YES];
    [pullStatus setLastPullAttempt:[NSDate date]];
}

- (PullStatus *)myPullStatus {
    if (!self.pullStatus) {
        [self setPullStatus:[PullStatus insertInManagedObjectContext:self.managedObjectContext]];
    }

    return self.pullStatus;
}

- (void)markPullSuccess {
    [self.myPullStatus setPullFailedValue:NO];
}

@end
