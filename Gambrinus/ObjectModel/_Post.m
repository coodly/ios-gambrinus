// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.m instead.

#import "_Post.h"

@implementation PostID
@end

@implementation _Post

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (PostID*)objectID {
	return (PostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"starredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"starred"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"topScoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"topScore"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic brewerSort;

@dynamic combinedBeers;

@dynamic combinedBrewers;

@dynamic combinedStyles;

@dynamic hidden;

- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:@(value_)];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:@(value_)];
}

@dynamic normalizedTitle;

@dynamic postId;

@dynamic publishDate;

@dynamic shadowTitle;

@dynamic slug;

@dynamic starred;

- (BOOL)starredValue {
	NSNumber *result = [self starred];
	return [result boolValue];
}

- (void)setStarredValue:(BOOL)value_ {
	[self setStarred:@(value_)];
}

- (BOOL)primitiveStarredValue {
	NSNumber *result = [self primitiveStarred];
	return [result boolValue];
}

- (void)setPrimitiveStarredValue:(BOOL)value_ {
	[self setPrimitiveStarred:@(value_)];
}

@dynamic styleSort;

@dynamic title;

@dynamic topScore;

- (int16_t)topScoreValue {
	NSNumber *result = [self topScore];
	return [result shortValue];
}

- (void)setTopScoreValue:(int16_t)value_ {
	[self setTopScore:@(value_)];
}

- (int16_t)primitiveTopScoreValue {
	NSNumber *result = [self primitiveTopScore];
	return [result shortValue];
}

- (void)setPrimitiveTopScoreValue:(int16_t)value_ {
	[self setPrimitiveTopScore:@(value_)];
}

@dynamic touchedAt;

@dynamic beers;

- (NSMutableSet<Beer*>*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet<Beer*> *result = (NSMutableSet<Beer*>*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@dynamic blog;

@dynamic body;

@dynamic image;

@end

@implementation PostAttributes 
+ (NSString *)brewerSort {
	return @"brewerSort";
}
+ (NSString *)combinedBeers {
	return @"combinedBeers";
}
+ (NSString *)combinedBrewers {
	return @"combinedBrewers";
}
+ (NSString *)combinedStyles {
	return @"combinedStyles";
}
+ (NSString *)hidden {
	return @"hidden";
}
+ (NSString *)normalizedTitle {
	return @"normalizedTitle";
}
+ (NSString *)postId {
	return @"postId";
}
+ (NSString *)publishDate {
	return @"publishDate";
}
+ (NSString *)shadowTitle {
	return @"shadowTitle";
}
+ (NSString *)slug {
	return @"slug";
}
+ (NSString *)starred {
	return @"starred";
}
+ (NSString *)styleSort {
	return @"styleSort";
}
+ (NSString *)title {
	return @"title";
}
+ (NSString *)topScore {
	return @"topScore";
}
+ (NSString *)touchedAt {
	return @"touchedAt";
}
@end

@implementation PostRelationships 
+ (NSString *)beers {
	return @"beers";
}
+ (NSString *)blog {
	return @"blog";
}
+ (NSString *)body {
	return @"body";
}
+ (NSString *)image {
	return @"image";
}
@end

