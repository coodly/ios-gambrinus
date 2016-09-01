// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Blog.m instead.

#import "_Blog.h"

@implementation BlogID
@end

@implementation _Blog

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

- (NSMutableSet<Post*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<Post*> *result = (NSMutableSet<Post*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

@implementation BlogAttributes 
+ (NSString *)baseURLString {
	return @"baseURLString";
}
+ (NSString *)blogId {
	return @"blogId";
}
+ (NSString *)postsURLString {
	return @"postsURLString";
}
+ (NSString *)published {
	return @"published";
}
@end

@implementation BlogRelationships 
+ (NSString *)posts {
	return @"posts";
}
@end

