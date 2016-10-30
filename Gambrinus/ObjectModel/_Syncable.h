// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Syncable.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SyncStatus;

@interface SyncableID : NSManagedObjectID {}
@end

@interface _Syncable : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SyncableID *objectID;

@property (nonatomic, strong, nullable) SyncStatus *syncStatus;

@end

@interface _Syncable (CoreDataGeneratedPrimitiveAccessors)

- (SyncStatus*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(SyncStatus*)value;

@end

@interface SyncableRelationships: NSObject
+ (NSString *)syncStatus;
@end

NS_ASSUME_NONNULL_END
