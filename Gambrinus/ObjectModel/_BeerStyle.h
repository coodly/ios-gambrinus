// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BeerStyle.h instead.

@import CoreData;

extern const struct BeerStyleAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *normalizedName;
	__unsafe_unretained NSString *shadowName;
} BeerStyleAttributes;

extern const struct BeerStyleRelationships {
	__unsafe_unretained NSString *beers;
} BeerStyleRelationships;

@class Beer;

@interface BeerStyleID : NSManagedObjectID {}
@end

@interface _BeerStyle : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerStyleID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* normalizedName;

//- (BOOL)validateNormalizedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shadowName;

//- (BOOL)validateShadowName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@end

@interface _BeerStyle (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _BeerStyle (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(NSString*)value;

- (NSString*)primitiveShadowName;
- (void)setPrimitiveShadowName:(NSString*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

@end
