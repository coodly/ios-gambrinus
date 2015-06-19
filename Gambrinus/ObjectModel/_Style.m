// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Style.m instead.

#import "_Style.h"

const struct StyleAttributes StyleAttributes = {
	.name = @"name",
};

const struct StyleRelationships StyleRelationships = {
	.beers = @"beers",
};

@implementation StyleID
@end

@implementation _Style

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Style" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Style";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Style" inManagedObjectContext:moc_];
}

- (StyleID*)objectID {
	return (StyleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@end

