// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Syncable.m instead.

#import "_Syncable.h"

@implementation SyncableID
@end

@implementation _Syncable

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Syncable" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Syncable";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Syncable" inManagedObjectContext:moc_];
}

- (SyncableID*)objectID {
	return (SyncableID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic syncStatus;

@end

@implementation SyncableRelationships 
+ (NSString *)syncStatus {
	return @"syncStatus";
}
@end

