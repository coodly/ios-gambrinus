// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.m instead.

#import "_Beer.h"

const struct BeerAttributes BeerAttributes = {
	.alcohol = @"alcohol",
	.aliased = @"aliased",
	.bindingKey = @"bindingKey",
	.identifier = @"identifier",
	.name = @"name",
	.normalizedName = @"normalizedName",
	.rbIdentifier = @"rbIdentifier",
	.rbScore = @"rbScore",
};

const struct BeerRelationships BeerRelationships = {
	.brewer = @"brewer",
	.posts = @"posts",
	.style = @"style",
};

@implementation BeerID
@end

@implementation _Beer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Beer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Beer" inManagedObjectContext:moc_];
}

- (BeerID*)objectID {
	return (BeerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"aliasedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"aliased"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic alcohol;

@dynamic aliased;

- (BOOL)aliasedValue {
	NSNumber *result = [self aliased];
	return [result boolValue];
}

- (void)setAliasedValue:(BOOL)value_ {
	[self setAliased:@(value_)];
}

- (BOOL)primitiveAliasedValue {
	NSNumber *result = [self primitiveAliased];
	return [result boolValue];
}

- (void)setPrimitiveAliasedValue:(BOOL)value_ {
	[self setPrimitiveAliased:@(value_)];
}

@dynamic bindingKey;

@dynamic identifier;

- (int32_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result intValue];
}

- (void)setIdentifierValue:(int32_t)value_ {
	[self setIdentifier:@(value_)];
}

- (int32_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result intValue];
}

- (void)setPrimitiveIdentifierValue:(int32_t)value_ {
	[self setPrimitiveIdentifier:@(value_)];
}

@dynamic name;

@dynamic normalizedName;

@dynamic rbIdentifier;

@dynamic rbScore;

@dynamic brewer;

@dynamic posts;

- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@dynamic style;

@end

