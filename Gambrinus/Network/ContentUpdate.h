//
//  ContentUpdate.h
//  Gambrinus
//
//  Created by Jaanus Siim on 20/06/15.
//  Copyright (c) 2015 Coodly LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteService.h"

@class ObjectModel;
@class Post;
@class BloggerAPIConnection;
@class ParseService;

@interface ContentUpdate : NSObject

@property (nonatomic, strong) BloggerAPIConnection *bloggerAPIConnection;
@property (nonatomic, strong) ParseService *parseService;

- (instancetype)initWithObjectModel:(ObjectModel *)model;
- (void)updateWithCompletionHandler:(ContentUpdateBlock)completion;
- (void)refreshPost:(Post *)post withCompletionHandler:(ContentUpdateBlock)completion;

@end
