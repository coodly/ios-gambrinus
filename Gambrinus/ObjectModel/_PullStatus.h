// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PullStatus.h instead.

@import CoreData;

extern const struct PullStatusAttributes {
	__unsafe_unretained NSString *lastPullAttempt;
	__unsafe_unretained NSString *pullFailed;
} PullStatusAttributes;

extern const struct PullStatusRelationships {
	__unsafe_unretained NSString *statusForImage;
} PullStatusRelationships;

@class Image;

@interface PullStatusID : NSManagedObjectID {}
@end

@interface _PullStatus : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PullStatusID* objectID;

@property (nonatomic, strong) NSDate* lastPullAttempt;

//- (BOOL)validateLastPullAttempt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* pullFailed;

@property (atomic) BOOL pullFailedValue;
- (BOOL)pullFailedValue;
- (void)setPullFailedValue:(BOOL)value_;

//- (BOOL)validatePullFailed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Image *statusForImage;

//- (BOOL)validateStatusForImage:(id*)value_ error:(NSError**)error_;

@end

@interface _PullStatus (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveLastPullAttempt;
- (void)setPrimitiveLastPullAttempt:(NSDate*)value;

- (NSNumber*)primitivePullFailed;
- (void)setPrimitivePullFailed:(NSNumber*)value;

- (BOOL)primitivePullFailedValue;
- (void)setPrimitivePullFailedValue:(BOOL)value_;

- (Image*)primitiveStatusForImage;
- (void)setPrimitiveStatusForImage:(Image*)value;

@end
