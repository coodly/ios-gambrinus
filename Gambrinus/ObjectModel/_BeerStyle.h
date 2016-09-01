// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BeerStyle.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Beer;

@interface BeerStyleID : NSManagedObjectID {}
@end

@interface _BeerStyle : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerStyleID*objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* normalizedName;

@property (nonatomic, strong, nullable) NSString* shadowName;

@property (nonatomic, strong, nullable) NSSet<Beer*> *beers;
- (nullable NSMutableSet<Beer*>*)beersSet;

@end

@interface _BeerStyle (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet<Beer*>*)value_;
- (void)removeBeers:(NSSet<Beer*>*)value_;
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

- (NSMutableSet<Beer*>*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet<Beer*>*)value;

@end

@interface BeerStyleAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)normalizedName;
+ (NSString *)shadowName;
@end

@interface BeerStyleRelationships: NSObject
+ (NSString *)beers;
@end

NS_ASSUME_NONNULL_END
