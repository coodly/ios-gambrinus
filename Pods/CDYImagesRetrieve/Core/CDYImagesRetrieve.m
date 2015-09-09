/*
 * Copyright 2014 Coodly OÜ
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

#import <CDYImagesRetrieve/CDYImageAsk.h>
#import <CommonCrypto/CommonDigest.h>
#import "CDYImagesRetrieve.h"
#import "CDYImagesRetrieveConstants.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImage+CDYImageScale.h"

@interface CDYImagesRetrieve ()

@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, strong) NSMutableArray *asksQueue;
@property (nonatomic, strong) CDYImageAsk *processedAsk;

@end

@implementation CDYImagesRetrieve {
    dispatch_queue_t __retrieveQueue;
}

- (id)initWithName:(NSString *)name {
    self = [super init];

    if (self) {
        _asksQueue = [NSMutableArray array];
        NSURL *cachesFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *cachesPath = [cachesFolder path];
        cachesPath = [cachesPath stringByAppendingPathComponent:name];
        cachesPath = [cachesPath stringByAppendingPathComponent:@"images"];
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
        _cachePath = cachesPath;
        _timeoutInterval = 20;
    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(initWithName:))]
                                 userInfo:nil];
    return nil;
}

- (BOOL)hasImageForAsk:(CDYImageAsk *)ask {
    NSString *cachedFilePath = [self cachePathForAsk:ask];
    return [[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath];
}

- (UIImage *)imageForAsk:(CDYImageAsk *)ask {
    NSString *cachedFilePath = [self cachePathForAsk:ask];
    NSData *data = [NSData dataWithContentsOfFile:cachedFilePath];
    return [[UIImage alloc] initWithData:data scale:[UIScreen mainScreen].scale];
}

- (void)retrieveImageForAsk:(CDYImageAsk *)ask completion:(CDYImageRetrieveBlock)completion {
    dispatch_async([self retrieveQueue], ^{
        if (!ask) {
            return;
        }

        if ([self.processedAsk isEqual:ask]) {
            CDYIRLog(@"Ask already processed");
            return;
        }

        [self.asksQueue removeObject:ask];
        [self.asksQueue insertObject:ask atIndex:0];
        [ask setCompletion:completion];
        [self processNextAsk];
    });
}

- (void)processNextAsk {
    dispatch_async([self retrieveQueue], ^{
        if (self.processedAsk) {
            CDYIRLog(@"Ask already in progress");
            return;
        }

        CDYImageAsk *ask = [self.asksQueue firstObject];
        if (!ask) {
            CDYIRLog(@"Asks queue empty");
            return;
        }

        [self setProcessedAsk:ask];
        [self.asksQueue removeObject:ask];

        if ([self haveOriginalDataForAsk:ask]) {
            [self localProcessForAsk:ask];
        } else {
            [self retrieveDataForAsk:ask];
        }
    });
}

- (void)localProcessForAsk:(CDYImageAsk *)ask {
    CDYIRLog(@"localProcessForAsk");
    NSString *originalDataPath = [self cachePathForAsk:ask withSize:NO];
    NSData *data = [NSData dataWithContentsOfFile:originalDataPath];
    UIImage *original = [[UIImage alloc] initWithData:data];

    if (CGSizeEqualToSize(CGSizeZero, ask.resultSize)) {
        ask.completion(ask, original);
        [self setProcessedAsk:nil];
        [self processNextAsk];
        return;
    }

    UIImage *atAskSize = [original scaleTo:ask.resultSize mode:ask.imageMode];

    NSString *askDataPath = [self cachePathForAsk:ask];
    NSData *askData = UIImageJPEGRepresentation(atAskSize, 0.8);
    NSError *writeError = nil;
    [askData writeToFile:askDataPath options:NSDataWritingAtomic error:&writeError];
    if (writeError) {
        CDYIRLog(@"Write error:%@", writeError);
        CDYIRLog(@"File name length:%d - %d", askDataPath.length, ((NSString *)[askDataPath.pathComponents lastObject]).length);
    }
    ask.completion(ask, atAskSize);
    [self setProcessedAsk:nil];
    [self processNextAsk];
}

- (BOOL)haveOriginalDataForAsk:(CDYImageAsk *)ask {
    NSString *originalCachePath = [self cachePathForAsk:ask withSize:NO];
    return [[NSFileManager defaultManager] fileExistsAtPath:originalCachePath];
}

- (void)retrieveDataForAsk:(CDYImageAsk *)ask {
    CDYIRLog(@"retrieveDataForAsk");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue setMaxConcurrentOperationCount:1];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.requestSerializer setTimeoutInterval:self.timeoutInterval];
    CDYIRLog(@"Pull image from %@", ask.imageURL);
    [manager GET:ask.imageURL.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async([self retrieveQueue], ^{
            CDYIRLog(@"Success");
            [self cacheData:responseObject forAsk:ask];
            [self localProcessForAsk:ask];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async([self retrieveQueue], ^{
            CDYIRLog(@"Error:%@", error);
            ask.completion(ask, nil);
            [self setProcessedAsk:nil];
            [self processNextAsk];
        });
    }];
}

- (void)cacheData:(NSData *)imageData forAsk:(CDYImageAsk *)ask {
    NSString *cachePath = [self cachePathForAsk:ask withSize:NO];
    NSError *writeError = nil;
    [imageData writeToFile:cachePath options:NSDataWritingAtomic error:&writeError];
    if (writeError) {
        CDYIRLog(@"Write error:%@", writeError);
    }
}

- (NSString *)cachePathForAsk:(CDYImageAsk *)ask {
    return [self cachePathForAsk:ask withSize:YES];
}

- (NSString *)cachePathForAsk:(CDYImageAsk *)ask withSize:(BOOL)pathWithSize {
    NSString *cacheKey = [self cacheKeyForAsk:ask withSize:pathWithSize];
    return  [self.cachePath stringByAppendingPathComponent:cacheKey];
}

- (NSString *)cacheKeyForAsk:(CDYImageAsk *)ask {
    return [self cacheKeyForAsk:ask withSize:YES];
}

- (NSString *)cacheKeyForAsk:(CDYImageAsk *)ask withSize:(BOOL)keyWithSize {
    NSString *key = ask.imageURL.absoluteString;
    if (keyWithSize && !CGSizeEqualToSize(CGSizeZero, ask.resultSize)) {
        NSString *extension = [key pathExtension];
        key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - extension.length, extension.length) withString:@""];
        key = [key stringByAppendingFormat:@"%dx%d", (int) ask.resultSize.width, (int) ask.resultSize.height];
        key = [key stringByAppendingPathExtension:extension];
    }

    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"=" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"*" withString:@"_"];

    if (key.length > NAME_MAX) {
        NSUInteger hashedLength = key.length - NAME_MAX + CC_MD5_DIGEST_LENGTH * 2;
        NSUInteger chopOff = key.length - hashedLength;
        NSString *hashed = [key substringFromIndex:chopOff];
        key = [key substringToIndex:chopOff];
        key = [key stringByAppendingString:[CDYImagesRetrieve cdyMd5HexDigest:hashed]];
    }

    return key;
}

- (dispatch_queue_t)retrieveQueue {
    if (__retrieveQueue == NULL) {
        __retrieveQueue = dispatch_queue_create("com.coodly.dyimagesretrieve.queue", NULL);
    }

    return __retrieveQueue;
}

+ (NSString*)cdyMd5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

@end
