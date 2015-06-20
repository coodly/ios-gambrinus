//
//  RemoteService.h
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

typedef void (^ContentUpdateBlock)(BOOL complete, NSError *error);

@protocol RemoteService

- (void)retrieveUpdatesSinceDate:(NSDate *)date completion:(ContentUpdateBlock)completion;

@end