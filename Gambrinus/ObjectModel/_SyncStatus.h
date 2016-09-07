// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncStatus.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Syncable;

@interface SyncStatusID : NSManagedObjectID {}
@end

@interface _SyncStatus : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SyncStatusID*objectID;

@property (nonatomic, strong) NSNumber* syncFailed;

@property (atomic) BOOL syncFailedValue;
- (BOOL)syncFailedValue;
- (void)setSyncFailedValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* syncNeeded;

@property (atomic) BOOL syncNeededValue;
- (BOOL)syncNeededValue;
- (void)setSyncNeededValue:(BOOL)value_;

@property (nonatomic, strong, nullable) Syncable *syncable;

@end

@interface _SyncStatus (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveSyncFailed;
- (void)setPrimitiveSyncFailed:(NSNumber*)value;

- (BOOL)primitiveSyncFailedValue;
- (void)setPrimitiveSyncFailedValue:(BOOL)value_;

- (NSNumber*)primitiveSyncNeeded;
- (void)setPrimitiveSyncNeeded:(NSNumber*)value;

- (BOOL)primitiveSyncNeededValue;
- (void)setPrimitiveSyncNeededValue:(BOOL)value_;

- (Syncable*)primitiveSyncable;
- (void)setPrimitiveSyncable:(Syncable*)value;

@end

@interface SyncStatusAttributes: NSObject 
+ (NSString *)syncFailed;
+ (NSString *)syncNeeded;
@end

@interface SyncStatusRelationships: NSObject
+ (NSString *)syncable;
@end

NS_ASSUME_NONNULL_END
