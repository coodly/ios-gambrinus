// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Blog.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Post;

@interface BlogID : NSManagedObjectID {}
@end

@interface _Blog : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BlogID *objectID;

@property (nonatomic, strong, nullable) NSString* baseURLString;

@property (nonatomic, strong, nullable) NSString* blogId;

@property (nonatomic, strong, nullable) NSString* postsURLString;

@property (nonatomic, strong, nullable) NSDate* published;

@property (nonatomic, strong, nullable) NSSet<Post*> *posts;
- (nullable NSMutableSet<Post*>*)postsSet;

@end

@interface _Blog (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet<Post*>*)value_;
- (void)removePosts:(NSSet<Post*>*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Blog (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveBaseURLString;
- (void)setPrimitiveBaseURLString:(nullable NSString*)value;

- (nullable NSString*)primitiveBlogId;
- (void)setPrimitiveBlogId:(nullable NSString*)value;

- (nullable NSString*)primitivePostsURLString;
- (void)setPrimitivePostsURLString:(nullable NSString*)value;

- (nullable NSDate*)primitivePublished;
- (void)setPrimitivePublished:(nullable NSDate*)value;

- (NSMutableSet<Post*>*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet<Post*>*)value;

@end

@interface BlogAttributes: NSObject 
+ (NSString *)baseURLString;
+ (NSString *)blogId;
+ (NSString *)postsURLString;
+ (NSString *)published;
@end

@interface BlogRelationships: NSObject
+ (NSString *)posts;
@end

NS_ASSUME_NONNULL_END
