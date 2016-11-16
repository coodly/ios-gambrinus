// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewer.h instead.

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

@interface BrewerID : SyncableID {}
@end

@interface _Brewer : Syncable
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BrewerID *objectID;

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
