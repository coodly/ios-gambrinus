// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"

@implementation ImageID
@end

@implementation _Image

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Image";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (ImageID*)objectID {
	return (ImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageURLString;

@dynamic posts;

- (NSMutableSet<Post*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<Post*> *result = (NSMutableSet<Post*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@dynamic pullStatus;

@end

@implementation ImageAttributes 
+ (NSString *)imageURLString {
	return @"imageURLString";
}
@end

@implementation ImageRelationships 
+ (NSString *)posts {
	return @"posts";
}
+ (NSString *)pullStatus {
	return @"pullStatus";
}
@end

