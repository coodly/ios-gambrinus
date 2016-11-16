// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "Syncable.h"

NS_ASSUME_NONNULL_BEGIN

@class Brewer;
@class Post;
@class BeerStyle;

@interface BeerID : SyncableID {}
@end

@interface _Beer : Syncable
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerID *objectID;

@property (nonatomic, strong, nullable) NSString* alcohol;

@property (nonatomic, strong) NSNumber* aliased;

@property (atomic) BOOL aliasedValue;
- (BOOL)aliasedValue;
- (void)setAliasedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* identifier;

@property (atomic) int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* normalizedName;

@property (nonatomic, strong, nullable) NSString* rbIdentifier;

@property (nonatomic, strong, nullable) NSString* rbScore;

@property (nonatomic, strong, nullable) NSString* shadowName;

@property (nonatomic, strong, nullable) Brewer *brewer;

@property (nonatomic, strong, nullable) NSSet<Post*> *posts;
- (nullable NSMutableSet<Post*>*)postsSet;

@property (nonatomic, strong, nullable) BeerStyle *style;

@end

@interface _Beer (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet<Post*>*)value_;
- (void)removePosts:(NSSet<Post*>*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Beer (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAlcohol;
- (void)setPrimitiveAlcohol:(nullable NSString*)value;

- (NSNumber*)primitiveAliased;
- (void)setPrimitiveAliased:(NSNumber*)value;

- (BOOL)primitiveAliasedValue;
- (void)setPrimitiveAliasedValue:(BOOL)value_;

- (nullable NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(nullable NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(nullable NSString*)value;

- (nullable NSString*)primitiveRbIdentifier;
- (void)setPrimitiveRbIdentifier:(nullable NSString*)value;

- (nullable NSString*)primitiveRbScore;
- (void)setPrimitiveRbScore:(nullable NSString*)value;

- (nullable NSString*)primitiveShadowName;
- (void)setPrimitiveShadowName:(nullable NSString*)value;

- (Brewer*)primitiveBrewer;
- (void)setPrimitiveBrewer:(Brewer*)value;

- (NSMutableSet<Post*>*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet<Post*>*)value;

- (BeerStyle*)primitiveStyle;
- (void)setPrimitiveStyle:(BeerStyle*)value;

@end

@interface BeerAttributes: NSObject 
+ (NSString *)alcohol;
+ (NSString *)aliased;
+ (NSString *)identifier;
+ (NSString *)name;
+ (NSString *)normalizedName;
+ (NSString *)rbIdentifier;
+ (NSString *)rbScore;
+ (NSString *)shadowName;
@end

@interface BeerRelationships: NSObject
+ (NSString *)brewer;
+ (NSString *)posts;
+ (NSString *)style;
@end

NS_ASSUME_NONNULL_END
