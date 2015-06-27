// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewer.h instead.

@import CoreData;

extern const struct BrewerAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *normalizedName;
} BrewerAttributes;

extern const struct BrewerRelationships {
	__unsafe_unretained NSString *beers;
} BrewerRelationships;

@class Beer;

@interface BrewerID : NSManagedObjectID {}
@end

@interface _Brewer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BrewerID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* normalizedName;

//- (BOOL)validateNormalizedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@end

@interface _Brewer (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Brewer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(NSString*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

@end
