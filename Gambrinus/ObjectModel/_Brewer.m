// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewer.m instead.

#import "_Brewer.h"

@implementation BrewerID
@end

@implementation _Brewer

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

@implementation BrewerAttributes 
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

@implementation BrewerRelationships 
+ (NSString *)beers {
	return @"beers";
}
@end

