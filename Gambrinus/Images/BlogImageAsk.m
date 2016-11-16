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

#import "BlogImageAsk.h"
#import "Gambrinus-Swift.h"

@interface BlogImageAsk ()

@property (nonatomic, copy) NSManagedObjectID *postID;

@end

@implementation BlogImageAsk

- (id)initWithPostID:(NSManagedObjectID *)postID size:(CGSize)size imageURLString:(NSString *)imageURLString attemptRemovePull:(BOOL)pullRemote {
    self = [super init]; {
        _postID = postID;
        [self setResultSize:size];
        [self setImageURL:[NSURL URLWithString:imageURLString]];
        _shouldAttemptRemotePull = pullRemote;
    }
    return self;
}

@end
