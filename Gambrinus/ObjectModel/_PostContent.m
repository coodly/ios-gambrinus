// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PostContent.m instead.

#import "_PostContent.h"

const struct PostContentAttributes PostContentAttributes = {
	.content = @"content",
};

const struct PostContentRelationships PostContentRelationships = {
	.post = @"post",
};

@implementation PostContentID
@end

@implementation _PostContent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PostContent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PostContent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PostContent" inManagedObjectContext:moc_];
}

- (PostContentID*)objectID {
	return (PostContentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic content;

@dynamic post;

@end

