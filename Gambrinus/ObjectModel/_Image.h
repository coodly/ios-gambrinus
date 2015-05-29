// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

@import CoreData;

extern const struct ImageAttributes {
	__unsafe_unretained NSString *imageURLString;
} ImageAttributes;

extern const struct ImageRelationships {
	__unsafe_unretained NSString *posts;
	__unsafe_unretained NSString *pullStatus;
} ImageRelationships;

@class Post;
@class PullStatus;

@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ImageID* objectID;

@property (nonatomic, strong) NSString* imageURLString;

//- (BOOL)validateImageURLString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;

@property (nonatomic, strong) PullStatus *pullStatus;

//- (BOOL)validatePullStatus:(id*)value_ error:(NSError**)error_;

@end

@interface _Image (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveImageURLString;
- (void)setPrimitiveImageURLString:(NSString*)value;

- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;

- (PullStatus*)primitivePullStatus;
- (void)setPrimitivePullStatus:(PullStatus*)value;

@end
