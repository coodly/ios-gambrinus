// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PostContent.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Post;

@interface PostContentID : NSManagedObjectID {}
@end

@interface _PostContent : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostContentID *objectID;

@property (nonatomic, strong, nullable) NSString* content;

@property (nonatomic, strong, nullable) Post *post;

@end

@interface _PostContent (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveContent;
- (void)setPrimitiveContent:(nullable NSString*)value;

- (Post*)primitivePost;
- (void)setPrimitivePost:(Post*)value;

@end

@interface PostContentAttributes: NSObject 
+ (NSString *)content;
@end

@interface PostContentRelationships: NSObject
+ (NSString *)post;
@end

NS_ASSUME_NONNULL_END
