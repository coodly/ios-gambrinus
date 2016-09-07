// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.m instead.

#import "_Beer.h"

@implementation BeerID
@end

@implementation _Beer

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

@dynamic shadowName;

@dynamic brewer;

@dynamic posts;

- (NSMutableSet<Post*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<Post*> *result = (NSMutableSet<Post*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@dynamic style;

@end

@implementation BeerAttributes 
+ (NSString *)alcohol {
	return @"alcohol";
}
+ (NSString *)aliased {
	return @"aliased";
}
+ (NSString *)bindingKey {
	return @"bindingKey";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)normalizedName {
	return @"normalizedName";
}
+ (NSString *)rbIdentifier {
	return @"rbIdentifier";
}
+ (NSString *)rbScore {
	return @"rbScore";
}
+ (NSString *)shadowName {
	return @"shadowName";
}
@end

@implementation BeerRelationships 
+ (NSString *)brewer {
	return @"brewer";
}
+ (NSString *)posts {
	return @"posts";
}
+ (NSString *)style {
	return @"style";
}
@end

