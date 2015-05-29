// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Setting.m instead.

#import "_Setting.h"

const struct SettingAttributes SettingAttributes = {
	.key = @"key",
	.value = @"value",
};

@implementation SettingID
@end

@implementation _Setting

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Setting";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:moc_];
}

- (SettingID*)objectID {
	return (SettingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"keyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"key"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic key;

- (int16_t)keyValue {
	NSNumber *result = [self key];
	return [result shortValue];
}

- (void)setKeyValue:(int16_t)value_ {
	[self setKey:@(value_)];
}

- (int16_t)primitiveKeyValue {
	NSNumber *result = [self primitiveKey];
	return [result shortValue];
}

- (void)setPrimitiveKeyValue:(int16_t)value_ {
	[self setPrimitiveKey:@(value_)];
}

@dynamic value;

@end

