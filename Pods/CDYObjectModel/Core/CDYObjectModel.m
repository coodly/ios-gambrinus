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

#import "CDYObjectModel.h"

@interface CDYObjectModel ()

@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, copy) NSString *storeType;
@property (nonatomic, copy) NSString *dataModelName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *writingContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) CDYObjectModel *backgroundInstance;

@end

@implementation CDYObjectModel

- (id)initWithDataModelName:(NSString *)modelName storeType:(NSString *)storeType {
    NSURL *databaseURL = [CDYObjectModel fileUrlInDocumentsFolder:[NSString stringWithFormat:@"%@.sqlite", modelName]];
    return [self initWithDataModelName:modelName storeURL:databaseURL storeType:storeType];
}

- (id)initWithDataModelName:(NSString *)modelName storeURL:(NSURL *)storeURL storeType:(NSString *)storeType {
    self = [super init];

    if (self) {
        _dataModelName = modelName;
        _storeURL = storeURL;
        _storeType = storeType;
    }

    return self;
}

- (id)initPrivateModelWithCoordinator:(NSPersistentStoreCoordinator *)coordinator writerContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _persistentStoreCoordinator = coordinator;
        _writingContext = context;
    }
    return self;
}

- (id)spawnBackgroundInstance {
    Class modelClass = [self class];
    CDYObjectModel *model = [[modelClass alloc] initPrivateModelWithCoordinator:self.persistentStoreCoordinator writerContext:self.managedObjectContext];
    return model;
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate {
    return [self fetchRequestForEntity:entity predicate:predicate sortDescriptors:nil];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchRequestForEntity:entity predicate:nil sortDescriptors:sortDescriptors];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName {
    return [self fetchedControllerForEntity:entityName sortDescriptors:@[]];
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchedControllerForEntity:entityName predicate:nil sortDescriptors:sortDescriptors];
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchedControllerForEntity:entityName predicate:predicate sortDescriptors:sortDescriptors sectionNameKeyPath:nil];
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate sortDescriptors:sortDescriptors];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:self.managedObjectContext
              sectionNameKeyPath:sectionNameKeyPath cacheName:nil];

    NSError *fetchError = nil;
    [controller performFetch:&fetchError];
    if (fetchError) {
        CDYObjectModelLog(@"Fetch error - %@", fetchError);
    }

    return controller;
}

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    return [self fetchEntityNamed:entityName withPredicate:predicate atOffset:0];
}

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate atOffset:(NSUInteger)offset {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate];
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:1];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Fetch error %@", error);
    }

    return [objects lastObject];
}

- (id)fetchEntityNamed:(NSString *)entityName atOffset:(NSUInteger)offset {
    return [self fetchEntityNamed:entityName withPredicate:nil atOffset:offset];
}

- (id)fetchFirstEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate sortDescriptors:sortDescriptors];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setFetchLimit:1];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Fetch error %@", error);
    }

    return [objects lastObject];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    return [self fetchEntitiesNamed:entityName usingPredicate:predicate withSortDescriptors:nil];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withSortDescriptors:(NSArray *)descriptors {
    return [self fetchEntitiesNamed:entityName usingPredicate:nil withSortDescriptors:descriptors];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName usingPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors {
    return [self fetchEntitiesNamed:entityName usingPredicate:predicate sortDescriptors:descriptors limit:0];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors limit:(NSUInteger)limit {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate sortDescriptors:descriptors];
    [fetchRequest setFetchLimit:limit];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Fetch error %@", error);
    }

    return objects;
}

- (NSArray *)fetchAttributeNamed:(NSString *)attributeName forEntity:(NSString *)entityName {
    return [self fetchAttributeNamed:attributeName forEntity:entityName withPredicate:nil];
}

- (NSArray *)fetchAttributeNamed:(NSString *)attributeName forEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:@[attributeName]];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Fetch error %@", error);
    }

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[objects count]];
    for (NSDictionary *dictionary in objects) {
        [result addObject:dictionary[attributeName]];
    }

    return [NSArray arrayWithArray:result];
}

- (NSDictionary *)fetchPropertiesWithDescriptions:(NSArray *)descriptions onEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self fetchRequestForEntity:entityName predicate:predicate];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:descriptions];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Fetch error %@", error);
    }

    if ([objects count] > 1) {
        CDYObjectModelLog(@"Fetched %d objects: %@", [objects count], objects);
    }

    return [objects lastObject];
}

- (NSUInteger)countInstancesOfEntity:(NSString *)entityName {
    return [self countInstancesOfEntity:entityName withPredicate:nil];
}

- (NSUInteger)countInstancesOfEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self fetchRequestForEntity:entityName predicate:predicate];

    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];

    if (error != nil) {
        CDYObjectModelLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return count;
}

- (BOOL)hasExistingEntity:(NSString *)entityName checkAttributeNamed:(NSString *)attributeName attributeValue:(NSString *)attributeValue {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attributeName, attributeValue];
    id existing = [self fetchEntityNamed:entityName withPredicate:predicate];

    if (!existing) {
        return NO;
    }

    return [[attributeValue lowercaseString] isEqualToString:[[existing valueForKeyPath:attributeName] lowercaseString]];
}

- (void)performBlock:(CDYModelActionBlock)actionBlock {
    [self.managedObjectContext performBlock:actionBlock];
}

- (void)saveInBlock:(CDYModelInjectionBlock)handler {
    [self saveInBlock:handler completion:nil];
}

- (void)saveInBlock:(CDYModelInjectionBlock)handler completion:(CDYModelActionBlock)completion {
    CDYObjectModel *spawned = [self spawnBackgroundInstance];
    [spawned performBlock:^{
        handler(spawned);
        [spawned saveContext:completion];
    }];
}

- (NSExpressionDescription *)descriptionWithPath:(NSString *)keyPath function:(NSString *)function resultName:(NSString *)name type:(NSAttributeType)type {
    NSExpression *pathExpression = [NSExpression expressionForKeyPath:keyPath];
    NSExpression *functionExpression = [NSExpression expressionForFunction:function arguments:[NSArray arrayWithObject:pathExpression]];
    NSExpressionDescription *description = [[NSExpressionDescription alloc] init];
    [description setName:name];
    [description setExpression:functionExpression];
    [description setExpressionResultType:type];
    return description;
}

- (void)saveContext {
    [self saveContext:nil];
}

- (void)saveContext:(CDYModelActionBlock)completion {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;

    if (!managedObjectContext) {
        return;
    }

    if (managedObjectContext.concurrencyType == NSMainQueueConcurrencyType) {
        CDYObjectModelLog(@"=============================");
        CDYObjectModelLog(@"Calling save on main context!");
        CDYObjectModelLog(@"%@", [NSThread callStackSymbols]);
        CDYObjectModelLog(@"=============================");
    }

    [self saveContext:managedObjectContext completion:completion];
}

- (void)saveContext:(NSManagedObjectContext *)context completion:(CDYModelActionBlock)completion {
    [context performBlock:^{
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"saveContext: Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        NSManagedObjectContext *parent = context.parentContext;
        if (parent) {
            [self saveContext:parent completion:nil];
        }

        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    }];
}

- (BOOL)databaseFileExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.storeURL path]];
}

- (void)deleteObject:(NSManagedObject *)object {
    [self deleteObject:object saveAfter:YES];
}

- (void)deleteObject:(NSManagedObject *)object saveAfter:(BOOL)saveAfter {
    [self.managedObjectContext deleteObject:object];

    if (saveAfter) {
        [self saveContext];
    }
}

- (void)deleteObjects:(NSArray *)objects saveAfter:(BOOL)saveAfter {
    for (NSManagedObject *object in objects) {
        [self deleteObject:object saveAfter:NO];
    }

    if (saveAfter) {
        [self saveContext];
    }
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator == nil) {
        return nil;
    }

    BOOL isPrivateInstance = self.writingContext != nil;

    if (!self.writingContext) {
        NSManagedObjectContext *savingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [savingContext setPersistentStoreCoordinator:coordinator];
        [self setWritingContext:savingContext];
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:isPrivateInstance ? NSPrivateQueueConcurrencyType : NSMainQueueConcurrencyType];
    [_managedObjectContext setParentContext:self.writingContext];

    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.dataModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    // Automatic migration
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:self.storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        if (self.wipeDatabaseOnSchemaConflict) {
            NSLog(@"Wipe file at %@", self.storeURL);
            NSError *wipeError = nil;
            [[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&wipeError];
            if (wipeError) {
                NSLog(@"Wipe error:%@", wipeError);
            }

            _persistentStoreCoordinator = nil;

            if (self.databaseWipeCallback) {
                self.databaseWipeCallback();
            }

            return [self persistentStoreCoordinator];
        } else {
            abort();
        }
    }

    return _persistentStoreCoordinator;
}

+ (NSURL *)fileUrlInDocumentsFolder:(NSString *)fileName {
    NSURL *documentsFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsFolder URLByAppendingPathComponent:fileName];
}

@end
