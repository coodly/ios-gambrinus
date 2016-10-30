// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Post;
@class PullStatus;

@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ImageID *objectID;

@property (nonatomic, strong, nullable) NSString* imageURLString;

@property (nonatomic, strong, nullable) NSSet<Post*> *posts;
- (nullable NSMutableSet<Post*>*)postsSet;

@property (nonatomic, strong, nullable) PullStatus *pullStatus;

@end

@interface _Image (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet<Post*>*)value_;
- (void)removePosts:(NSSet<Post*>*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveImageURLString;
- (void)setPrimitiveImageURLString:(NSString*)value;

- (NSMutableSet<Post*>*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet<Post*>*)value;

- (PullStatus*)primitivePullStatus;
- (void)setPrimitivePullStatus:(PullStatus*)value;

@end

@interface ImageAttributes: NSObject 
+ (NSString *)imageURLString;
@end

@interface ImageRelationships: NSObject
+ (NSString *)posts;
+ (NSString *)pullStatus;
@end

NS_ASSUME_NONNULL_END
