// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PullStatus.m instead.

#import "_PullStatus.h"

const struct PullStatusAttributes PullStatusAttributes = {
	.lastPullAttempt = @"lastPullAttempt",
	.pullFailed = @"pullFailed",
};

const struct PullStatusRelationships PullStatusRelationships = {
	.statusForImage = @"statusForImage",
};

@implementation PullStatusID
@end

@implementation _PullStatus

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PullStatus" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PullStatus";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PullStatus" inManagedObjectContext:moc_];
}

- (PullStatusID*)objectID {
	return (PullStatusID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"pullFailedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pullFailed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic lastPullAttempt;

@dynamic pullFailed;

- (BOOL)pullFailedValue {
	NSNumber *result = [self pullFailed];
	return [result boolValue];
}

- (void)setPullFailedValue:(BOOL)value_ {
	[self setPullFailed:@(value_)];
}

- (BOOL)primitivePullFailedValue {
	NSNumber *result = [self primitivePullFailed];
	return [result boolValue];
}

- (void)setPrimitivePullFailedValue:(BOOL)value_ {
	[self setPrimitivePullFailed:@(value_)];
}

@dynamic statusForImage;

@end

