// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PostContent.h instead.

@import CoreData;

extern const struct PostContentAttributes {
	__unsafe_unretained NSString *content;
} PostContentAttributes;

extern const struct PostContentRelationships {
	__unsafe_unretained NSString *post;
} PostContentRelationships;

@class Post;

@interface PostContentID : NSManagedObjectID {}
@end

@interface _PostContent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostContentID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Post *post;

//- (BOOL)validatePost:(id*)value_ error:(NSError**)error_;

@end

@interface _PostContent (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (Post*)primitivePost;
- (void)setPrimitivePost:(Post*)value;

@end
