// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

@import CoreData;

extern const struct PostAttributes {
	__unsafe_unretained NSString *combinedBeers;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *normalizedTitle;
	__unsafe_unretained NSString *postId;
	__unsafe_unretained NSString *publishDate;
	__unsafe_unretained NSString *slug;
	__unsafe_unretained NSString *starred;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *topScore;
	__unsafe_unretained NSString *touchedAt;
} PostAttributes;

extern const struct PostRelationships {
	__unsafe_unretained NSString *beers;
	__unsafe_unretained NSString *blog;
	__unsafe_unretained NSString *image;
} PostRelationships;

@class Beer;
@class Blog;
@class Image;

@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostID* objectID;

@property (nonatomic, strong) NSString* combinedBeers;

//- (BOOL)validateCombinedBeers:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* normalizedTitle;

//- (BOOL)validateNormalizedTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* postId;

//- (BOOL)validatePostId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* publishDate;

//- (BOOL)validatePublishDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* slug;

//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* starred;

@property (atomic) BOOL starredValue;
- (BOOL)starredValue;
- (void)setStarredValue:(BOOL)value_;

//- (BOOL)validateStarred:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* topScore;

@property (atomic) int16_t topScoreValue;
- (int16_t)topScoreValue;
- (void)setTopScoreValue:(int16_t)value_;

//- (BOOL)validateTopScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* touchedAt;

//- (BOOL)validateTouchedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@property (nonatomic, strong) Blog *blog;

//- (BOOL)validateBlog:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Image *image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@end

@interface _Post (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCombinedBeers;
- (void)setPrimitiveCombinedBeers:(NSString*)value;

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSString*)primitiveNormalizedTitle;
- (void)setPrimitiveNormalizedTitle:(NSString*)value;

- (NSString*)primitivePostId;
- (void)setPrimitivePostId:(NSString*)value;

- (NSDate*)primitivePublishDate;
- (void)setPrimitivePublishDate:(NSDate*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSNumber*)primitiveStarred;
- (void)setPrimitiveStarred:(NSNumber*)value;

- (BOOL)primitiveStarredValue;
- (void)setPrimitiveStarredValue:(BOOL)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveTopScore;
- (void)setPrimitiveTopScore:(NSNumber*)value;

- (int16_t)primitiveTopScoreValue;
- (void)setPrimitiveTopScoreValue:(int16_t)value_;

- (NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(NSDate*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

- (Blog*)primitiveBlog;
- (void)setPrimitiveBlog:(Blog*)value;

- (Image*)primitiveImage;
- (void)setPrimitiveImage:(Image*)value;

@end
