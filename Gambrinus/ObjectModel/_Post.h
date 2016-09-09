// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Beer;
@class Blog;
@class PostContent;
@class Image;

@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostID*objectID;

@property (nonatomic, strong) NSString* brewerSort;

@property (nonatomic, strong, nullable) NSString* combinedBeers;

@property (nonatomic, strong, nullable) NSString* combinedBrewers;

@property (nonatomic, strong, nullable) NSString* combinedStyles;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* isDirty;

@property (atomic) BOOL isDirtyValue;
- (BOOL)isDirtyValue;
- (void)setIsDirtyValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* normalizedTitle;

@property (nonatomic, strong, nullable) NSString* postId;

@property (nonatomic, strong, nullable) NSDate* publishDate;

@property (nonatomic, strong, nullable) NSString* shadowTitle;

@property (nonatomic, strong, nullable) NSString* slug;

@property (nonatomic, strong) NSNumber* starred;

@property (atomic) BOOL starredValue;
- (BOOL)starredValue;
- (void)setStarredValue:(BOOL)value_;

@property (nonatomic, strong) NSString* styleSort;

@property (nonatomic, strong, nullable) NSString* title;

@property (nonatomic, strong, nullable) NSNumber* topScore;

@property (atomic) int16_t topScoreValue;
- (int16_t)topScoreValue;
- (void)setTopScoreValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSDate* touchedAt;

@property (nonatomic, strong, nullable) NSSet<Beer*> *beers;
- (nullable NSMutableSet<Beer*>*)beersSet;

@property (nonatomic, strong, nullable) Blog *blog;

@property (nonatomic, strong, nullable) PostContent *body;

@property (nonatomic, strong, nullable) Image *image;

@end

@interface _Post (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet<Beer*>*)value_;
- (void)removeBeers:(NSSet<Beer*>*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBrewerSort;
- (void)setPrimitiveBrewerSort:(NSString*)value;

- (NSString*)primitiveCombinedBeers;
- (void)setPrimitiveCombinedBeers:(NSString*)value;

- (NSString*)primitiveCombinedBrewers;
- (void)setPrimitiveCombinedBrewers:(NSString*)value;

- (NSString*)primitiveCombinedStyles;
- (void)setPrimitiveCombinedStyles:(NSString*)value;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSNumber*)primitiveIsDirty;
- (void)setPrimitiveIsDirty:(NSNumber*)value;

- (BOOL)primitiveIsDirtyValue;
- (void)setPrimitiveIsDirtyValue:(BOOL)value_;

- (NSString*)primitiveNormalizedTitle;
- (void)setPrimitiveNormalizedTitle:(NSString*)value;

- (NSString*)primitivePostId;
- (void)setPrimitivePostId:(NSString*)value;

- (NSDate*)primitivePublishDate;
- (void)setPrimitivePublishDate:(NSDate*)value;

- (NSString*)primitiveShadowTitle;
- (void)setPrimitiveShadowTitle:(NSString*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSNumber*)primitiveStarred;
- (void)setPrimitiveStarred:(NSNumber*)value;

- (BOOL)primitiveStarredValue;
- (void)setPrimitiveStarredValue:(BOOL)value_;

- (NSString*)primitiveStyleSort;
- (void)setPrimitiveStyleSort:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveTopScore;
- (void)setPrimitiveTopScore:(NSNumber*)value;

- (int16_t)primitiveTopScoreValue;
- (void)setPrimitiveTopScoreValue:(int16_t)value_;

- (NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(NSDate*)value;

- (NSMutableSet<Beer*>*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet<Beer*>*)value;

- (Blog*)primitiveBlog;
- (void)setPrimitiveBlog:(Blog*)value;

- (PostContent*)primitiveBody;
- (void)setPrimitiveBody:(PostContent*)value;

- (Image*)primitiveImage;
- (void)setPrimitiveImage:(Image*)value;

@end

@interface PostAttributes: NSObject 
+ (NSString *)brewerSort;
+ (NSString *)combinedBeers;
+ (NSString *)combinedBrewers;
+ (NSString *)combinedStyles;
+ (NSString *)hidden;
+ (NSString *)isDirty;
+ (NSString *)normalizedTitle;
+ (NSString *)postId;
+ (NSString *)publishDate;
+ (NSString *)shadowTitle;
+ (NSString *)slug;
+ (NSString *)starred;
+ (NSString *)styleSort;
+ (NSString *)title;
+ (NSString *)topScore;
+ (NSString *)touchedAt;
@end

@interface PostRelationships: NSObject
+ (NSString *)beers;
+ (NSString *)blog;
+ (NSString *)body;
+ (NSString *)image;
@end

NS_ASSUME_NONNULL_END
