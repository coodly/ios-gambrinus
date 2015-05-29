/*
 * Copyright 2014 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDYObjectModel;

#define CDYObjectModelLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

typedef void (^CDYModelActionBlock)();
typedef void (^CDYModelInjectionBlock)(CDYObjectModel *objectModel);

@interface CDYObjectModel : NSObject

@property (nonatomic, assign) BOOL wipeDatabaseOnSchemaConflict;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) CDYModelActionBlock databaseWipeCallback;
@property (nonatomic, strong, readonly) NSURL *storeURL;

- (id)initWithDataModelName:(NSString *)modelName storeType:(NSString *)storeType;
- (id)initWithDataModelName:(NSString *)modelName storeURL:(NSURL *)storeURL storeType:(NSString *)storeType;

- (id)spawnBackgroundInstance;

- (void)saveContext;
- (void)saveContext:(CDYModelActionBlock)completion;

- (BOOL)databaseFileExists;

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName;
- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)sectionNameKeyPath;

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (id)fetchEntityNamed:(NSString *)entityName atOffset:(NSUInteger)offset;
- (id)fetchFirstEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withSortDescriptors:(NSArray *)descriptors;
- (NSArray *)fetchEntitiesNamed:(NSString *)entityName usingPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;
- (NSArray *)fetchEntitiesNamed:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors limit:(NSUInteger)limit;

- (NSArray *)fetchAttributeNamed:(NSString *)attributeName forEntity:(NSString *)entityName;
- (NSArray *)fetchAttributeNamed:(NSString *)attributeName forEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (NSDictionary *)fetchPropertiesWithDescriptions:(NSArray *)descriptions onEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

- (NSUInteger)countInstancesOfEntity:(NSString *)entityName;
- (NSUInteger)countInstancesOfEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (BOOL)hasExistingEntity:(NSString *)entityName checkAttributeNamed:(NSString *)attributeName attributeValue:(NSString *)attributeValue;

- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObject:(NSManagedObject *)object saveAfter:(BOOL)saveAfter;
- (void)deleteObjects:(NSArray *)objects saveAfter:(BOOL)saveAfter;

- (void)performBlock:(CDYModelActionBlock)actionBlock;

- (void)saveInBlock:(CDYModelInjectionBlock)handler;
- (void)saveInBlock:(CDYModelInjectionBlock)handler completion:(CDYModelActionBlock)completion;

- (NSExpressionDescription *)descriptionWithPath:(NSString *)keyPath function:(NSString *)function resultName:(NSString *)name type:(NSAttributeType)type;

+ (NSURL *)fileUrlInDocumentsFolder:(NSString *)fileName;

@end
