// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Brewer;
@class Post;
@class BeerStyle;

@interface BeerID : NSManagedObjectID {}
@end

@interface _Beer : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerID*objectID;

@property (nonatomic, strong, nullable) NSString* alcohol;

@property (nonatomic, strong) NSNumber* aliased;

@property (atomic) BOOL aliasedValue;
- (BOOL)aliasedValue;
- (void)setAliasedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* bindingKey;

@property (nonatomic, strong) NSNumber* dataNeeded;

@property (atomic) BOOL dataNeededValue;
- (BOOL)dataNeededValue;
- (void)setDataNeededValue:(BOOL)value_;

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

- (NSString*)primitiveAlcohol;
- (void)setPrimitiveAlcohol:(NSString*)value;

- (NSNumber*)primitiveAliased;
- (void)setPrimitiveAliased:(NSNumber*)value;

- (BOOL)primitiveAliasedValue;
- (void)setPrimitiveAliasedValue:(BOOL)value_;

- (NSString*)primitiveBindingKey;
- (void)setPrimitiveBindingKey:(NSString*)value;

- (NSNumber*)primitiveDataNeeded;
- (void)setPrimitiveDataNeeded:(NSNumber*)value;

- (BOOL)primitiveDataNeededValue;
- (void)setPrimitiveDataNeededValue:(BOOL)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(NSString*)value;

- (NSString*)primitiveRbIdentifier;
- (void)setPrimitiveRbIdentifier:(NSString*)value;

- (NSString*)primitiveRbScore;
- (void)setPrimitiveRbScore:(NSString*)value;

- (NSString*)primitiveShadowName;
- (void)setPrimitiveShadowName:(NSString*)value;

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
+ (NSString *)bindingKey;
+ (NSString *)dataNeeded;
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
