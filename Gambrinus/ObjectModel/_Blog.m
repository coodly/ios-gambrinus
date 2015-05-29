// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Blog.m instead.

#import "_Blog.h"

const struct BlogAttributes BlogAttributes = {
	.baseURLString = @"baseURLString",
	.blogId = @"blogId",
	.postsURLString = @"postsURLString",
	.published = @"published",
};

const struct BlogRelationships BlogRelationships = {
	.posts = @"posts",
};

@implementation BlogID
@end

@implementation _Blog

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Blog";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc_];
}

- (BlogID*)objectID {
	return (BlogID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic baseURLString;

@dynamic blogId;

@dynamic postsURLString;

@dynamic published;

@dynamic posts;

- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

