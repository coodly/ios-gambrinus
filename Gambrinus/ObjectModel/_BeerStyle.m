// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BeerStyle.m instead.

#import "_BeerStyle.h"

const struct BeerStyleAttributes BeerStyleAttributes = {
	.name = @"name",
	.normalizedName = @"normalizedName",
	.shadowName = @"shadowName",
};

const struct BeerStyleRelationships BeerStyleRelationships = {
	.beers = @"beers",
};

@implementation BeerStyleID
@end

@implementation _BeerStyle

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BeerStyle" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BeerStyle";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BeerStyle" inManagedObjectContext:moc_];
}

- (BeerStyleID*)objectID {
	return (BeerStyleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic normalizedName;

@dynamic shadowName;

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@end

