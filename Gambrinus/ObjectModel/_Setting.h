// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Setting.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SettingID : NSManagedObjectID {}
@end

@interface _Setting : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SettingID *objectID;

@property (nonatomic, strong) NSNumber* key;

@property (atomic) int16_t keyValue;
- (int16_t)keyValue;
- (void)setKeyValue:(int16_t)value_;

@property (nonatomic, strong) NSString* value;

@end

@interface _Setting (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveKey;
- (void)setPrimitiveKey:(NSNumber*)value;

- (int16_t)primitiveKeyValue;
- (void)setPrimitiveKeyValue:(int16_t)value_;

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

@end

@interface SettingAttributes: NSObject 
+ (NSString *)key;
+ (NSString *)value;
@end

NS_ASSUME_NONNULL_END
