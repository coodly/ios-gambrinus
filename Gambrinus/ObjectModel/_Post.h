// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

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
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostID *objectID;

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

- (nullable NSString*)primitiveCombinedBeers;
- (void)setPrimitiveCombinedBeers:(nullable NSString*)value;

- (nullable NSString*)primitiveCombinedBrewers;
- (void)setPrimitiveCombinedBrewers:(nullable NSString*)value;

- (nullable NSString*)primitiveCombinedStyles;
- (void)setPrimitiveCombinedStyles:(nullable NSString*)value;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSNumber*)primitiveIsDirty;
- (void)setPrimitiveIsDirty:(NSNumber*)value;

- (BOOL)primitiveIsDirtyValue;
- (void)setPrimitiveIsDirtyValue:(BOOL)value_;

- (nullable NSString*)primitiveNormalizedTitle;
- (void)setPrimitiveNormalizedTitle:(nullable NSString*)value;

- (nullable NSString*)primitivePostId;
- (void)setPrimitivePostId:(nullable NSString*)value;

- (nullable NSDate*)primitivePublishDate;
- (void)setPrimitivePublishDate:(nullable NSDate*)value;

- (nullable NSString*)primitiveShadowTitle;
- (void)setPrimitiveShadowTitle:(nullable NSString*)value;

- (nullable NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(nullable NSString*)value;

- (NSNumber*)primitiveStarred;
- (void)setPrimitiveStarred:(NSNumber*)value;

- (BOOL)primitiveStarredValue;
- (void)setPrimitiveStarredValue:(BOOL)value_;

- (NSString*)primitiveStyleSort;
- (void)setPrimitiveStyleSort:(NSString*)value;

- (nullable NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(nullable NSString*)value;

- (nullable NSNumber*)primitiveTopScore;
- (void)setPrimitiveTopScore:(nullable NSNumber*)value;

- (int16_t)primitiveTopScoreValue;
- (void)setPrimitiveTopScoreValue:(int16_t)value_;

- (nullable NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(nullable NSDate*)value;

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
