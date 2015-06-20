// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.h instead.

@import CoreData;

extern const struct BeerAttributes {
	__unsafe_unretained NSString *alcohol;
	__unsafe_unretained NSString *aliased;
	__unsafe_unretained NSString *bindingKey;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *rbIdentifier;
	__unsafe_unretained NSString *rbScore;
} BeerAttributes;

extern const struct BeerRelationships {
	__unsafe_unretained NSString *brewer;
	__unsafe_unretained NSString *posts;
	__unsafe_unretained NSString *style;
} BeerRelationships;

@class Brewer;
@class Post;
@class BeerStyle;

@interface BeerID : NSManagedObjectID {}
@end

@interface _Beer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerID* objectID;

@property (nonatomic, strong) NSString* alcohol;

//- (BOOL)validateAlcohol:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* aliased;

@property (atomic) BOOL aliasedValue;
- (BOOL)aliasedValue;
- (void)setAliasedValue:(BOOL)value_;

//- (BOOL)validateAliased:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* bindingKey;

//- (BOOL)validateBindingKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rbIdentifier;

//- (BOOL)validateRbIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rbScore;

//- (BOOL)validateRbScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Brewer *brewer;

//- (BOOL)validateBrewer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;

@property (nonatomic, strong) BeerStyle *style;

//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;

@end

@interface _Beer (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
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

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveRbIdentifier;
- (void)setPrimitiveRbIdentifier:(NSString*)value;

- (NSString*)primitiveRbScore;
- (void)setPrimitiveRbScore:(NSString*)value;

- (Brewer*)primitiveBrewer;
- (void)setPrimitiveBrewer:(Brewer*)value;

- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;

- (BeerStyle*)primitiveStyle;
- (void)setPrimitiveStyle:(BeerStyle*)value;

@end
