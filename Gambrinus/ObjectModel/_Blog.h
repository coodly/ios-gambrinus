// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Blog.h instead.

@import CoreData;

extern const struct BlogAttributes {
	__unsafe_unretained NSString *baseURLString;
	__unsafe_unretained NSString *blogId;
	__unsafe_unretained NSString *postsURLString;
	__unsafe_unretained NSString *published;
} BlogAttributes;

extern const struct BlogRelationships {
	__unsafe_unretained NSString *posts;
} BlogRelationships;

@class Post;

@interface BlogID : NSManagedObjectID {}
@end

@interface _Blog : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BlogID* objectID;

@property (nonatomic, strong) NSString* baseURLString;

//- (BOOL)validateBaseURLString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* blogId;

//- (BOOL)validateBlogId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* postsURLString;

//- (BOOL)validatePostsURLString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* published;

//- (BOOL)validatePublished:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;

@end

@interface _Blog (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Blog (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBaseURLString;
- (void)setPrimitiveBaseURLString:(NSString*)value;

- (NSString*)primitiveBlogId;
- (void)setPrimitiveBlogId:(NSString*)value;

- (NSString*)primitivePostsURLString;
- (void)setPrimitivePostsURLString:(NSString*)value;

- (NSDate*)primitivePublished;
- (void)setPrimitivePublished:(NSDate*)value;

- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;

@end
