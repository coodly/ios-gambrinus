// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BeerStyle.m instead.

#import "_BeerStyle.h"

@implementation BeerStyleID
@end

@implementation _BeerStyle

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

@dynamic identifier;

@dynamic name;

@dynamic normalizedName;

@dynamic shadowName;

@dynamic beers;

- (NSMutableSet<Beer*>*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet<Beer*> *result = (NSMutableSet<Beer*>*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@end

@implementation BeerStyleAttributes 
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)normalizedName {
	return @"normalizedName";
}
+ (NSString *)shadowName {
	return @"shadowName";
}
@end

@implementation BeerStyleRelationships 
+ (NSString *)beers {
	return @"beers";
}
@end

