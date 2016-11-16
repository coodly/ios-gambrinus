// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BeerStyle.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "Syncable.h"

NS_ASSUME_NONNULL_BEGIN

@class Beer;

@interface BeerStyleID : SyncableID {}
@end

@interface _BeerStyle : Syncable
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BeerStyleID *objectID;

@property (nonatomic, strong, nullable) NSString* identifier;

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

- (nullable NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(nullable NSString*)value;

- (nullable NSString*)primitiveShadowName;
- (void)setPrimitiveShadowName:(nullable NSString*)value;

- (NSMutableSet<Beer*>*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet<Beer*>*)value;

@end

@interface BeerStyleAttributes: NSObject 
+ (NSString *)identifier;
+ (NSString *)name;
+ (NSString *)normalizedName;
+ (NSString *)shadowName;
@end

@interface BeerStyleRelationships: NSObject
+ (NSString *)beers;
@end

NS_ASSUME_NONNULL_END
