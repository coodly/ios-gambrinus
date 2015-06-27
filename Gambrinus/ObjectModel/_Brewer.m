// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewer.m instead.

#import "_Brewer.h"

const struct BrewerAttributes BrewerAttributes = {
	.name = @"name",
	.normalizedName = @"normalizedName",
};

const struct BrewerRelationships BrewerRelationships = {
	.beers = @"beers",
};

@implementation BrewerID
@end

@implementation _Brewer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Brewer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Brewer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Brewer" inManagedObjectContext:moc_];
}

- (BrewerID*)objectID {
	return (BrewerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic normalizedName;

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@end

