// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PullStatus.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Image;

@interface PullStatusID : NSManagedObjectID {}
@end

@interface _PullStatus : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PullStatusID *objectID;

@property (nonatomic, strong, nullable) NSDate* lastPullAttempt;

@property (nonatomic, strong) NSNumber* pullFailed;

@property (atomic) BOOL pullFailedValue;
- (BOOL)pullFailedValue;
- (void)setPullFailedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) Image *statusForImage;

@end

@interface _PullStatus (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDate*)primitiveLastPullAttempt;
- (void)setPrimitiveLastPullAttempt:(nullable NSDate*)value;

- (NSNumber*)primitivePullFailed;
- (void)setPrimitivePullFailed:(NSNumber*)value;

- (BOOL)primitivePullFailedValue;
- (void)setPrimitivePullFailedValue:(BOOL)value_;

- (Image*)primitiveStatusForImage;
- (void)setPrimitiveStatusForImage:(Image*)value;

@end

@interface PullStatusAttributes: NSObject 
+ (NSString *)lastPullAttempt;
+ (NSString *)pullFailed;
@end

@interface PullStatusRelationships: NSObject
+ (NSString *)statusForImage;
@end

NS_ASSUME_NONNULL_END
