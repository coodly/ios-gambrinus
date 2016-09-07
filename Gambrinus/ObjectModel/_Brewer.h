// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewer.h instead.

@import CoreData;

#import "Syncable.h"

NS_ASSUME_NONNULL_BEGIN

@class Beer;

@interface BrewerID : SyncableID {}
@end

@interface _Brewer : Syncable
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BrewerID*objectID;

@property (nonatomic, strong, nullable) NSString* identifier;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* normalizedName;

@property (nonatomic, strong, nullable) NSString* shadowName;

@property (nonatomic, strong, nullable) NSSet<Beer*> *beers;
- (nullable NSMutableSet<Beer*>*)beersSet;

@end

@interface _Brewer (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet<Beer*>*)value_;
- (void)removeBeers:(NSSet<Beer*>*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Brewer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(NSString*)value;

- (NSString*)primitiveShadowName;
- (void)setPrimitiveShadowName:(NSString*)value;

- (NSMutableSet<Beer*>*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet<Beer*>*)value;

@end

@interface BrewerAttributes: NSObject 
+ (NSString *)identifier;
+ (NSString *)name;
+ (NSString *)normalizedName;
+ (NSString *)shadowName;
@end

@interface BrewerRelationships: NSObject
+ (NSString *)beers;
@end

NS_ASSUME_NONNULL_END
