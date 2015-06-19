// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Style.h instead.

@import CoreData;

extern const struct StyleAttributes {
	__unsafe_unretained NSString *name;
} StyleAttributes;

extern const struct StyleRelationships {
	__unsafe_unretained NSString *beers;
} StyleRelationships;

@class Beer;

@interface StyleID : NSManagedObjectID {}
@end

@interface _Style : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) StyleID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@end

@interface _Style (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Style (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

@end
