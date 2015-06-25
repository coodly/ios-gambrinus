// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.m instead.

#import "_Post.h"

const struct PostAttributes PostAttributes = {
	.content = @"content",
	.hidden = @"hidden",
	.normalizedTitle = @"normalizedTitle",
	.postId = @"postId",
	.publishDate = @"publishDate",
	.slug = @"slug",
	.starred = @"starred",
	.title = @"title",
	.touchedAt = @"touchedAt",
};

const struct PostRelationships PostRelationships = {
	.beers = @"beers",
	.blog = @"blog",
	.image = @"image",
};

@implementation PostID
@end

@implementation _Post

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

	return keyPaths;
}

@dynamic content;

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

@dynamic title;

@dynamic touchedAt;

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@dynamic blog;

@dynamic image;

@end

