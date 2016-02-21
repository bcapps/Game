//
//  LCKCoreDataController.m
//  Velocity
//
//  Created by Andrew Harrison on 1/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKCoreDataController.h"

NSString * const LCKCoreDataControllerSaveNotificationDeletedObjectsKey = @"deleted";
NSString * const LCKCoreDataControllerSaveNotificationInsertedObjectsKey = @"inserted";
NSString * const LCKCoreDataControllerSaveNotificationUpdatedObjectsKey = @"updated";

NSString * const LCKCoreDataControllerStoresDidChangeNotification = @"LCKCoreDataControllerStoresDidChangeNotification";

NSString * const LCKCoreDataControllerMainQueueContextDidUpdateWithUbiquitousContentChangesNotification = @"LCKCoreDataControllerMainQueueContextUpdatedWithUbiquitousContentChangesNotification";
NSString * const LCKCoreDataControllerUbiquitousContentWillBeRemovedNotification = @"LCKCoreDataControllerUbiquitousContentWillBeRemovedNotification";

static Class LCKCoreDataControllerSubclass;

@interface LCKCoreDataController ()

@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic) NSManagedObjectContext *mainQueueContext;
@property (nonatomic) NSManagedObjectContext *masterContext;

@end

@implementation LCKCoreDataController

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LCKCoreDataController

+ (instancetype)sharedController {
    NSAssert(LCKCoreDataControllerSubclass, @"You must use a subclass by calling registerSubclass: and passing in an appropriate subclass of this object");
    
	static LCKCoreDataController *sharedController;
	
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[LCKCoreDataControllerSubclass alloc] init];
    });
    
    return sharedController;
}

+ (void)registerSubclass:(Class)subclass {
    LCKCoreDataControllerSubclass = subclass;
}

- (void)performWorkerContextBlock:(LCKCoreDataControllerWorkerContextBlock)contextBlock saveFinished:(LCKCoreDataControllerSaveFinishedBlock)saveFinishedBlock {
    [self performWorkerContextCompletionBlock:contextBlock andWait:NO saveFinished:saveFinishedBlock];
}

- (void)performWorkerContextBlockAndWait:(LCKCoreDataControllerWorkerContextBlock)contextBlock {
    [self performWorkerContextCompletionBlock:contextBlock andWait:YES saveFinished:nil];
}

- (void)performWorkerContextCompletionBlock:(LCKCoreDataControllerWorkerContextBlock)block andWait:(BOOL)shouldWait saveFinished:(LCKCoreDataControllerSaveFinishedBlock)saveCompletion {
    if (!block) {
        return;
    }
    
    NSManagedObjectContext *workerContext = [self newWorkerContext];
    
    if (shouldWait) {
        [workerContext performBlockAndWait:^{
            block(workerContext);
            
            [self saveContext:workerContext];
        }];
    }
    else {
        [workerContext performBlock:^{
            block(workerContext);
            
            [self saveContext:workerContext];
            
            if (saveCompletion) {
                saveCompletion();
            }
        }];
    }
}

#pragma mark - Contexts

- (NSManagedObjectContext *)mainQueueContext {
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext.parentContext = self.masterContext;
    }
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)masterContext {
    if (!_masterContext) {
        _masterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [_masterContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    
    return _masterContext;
}

- (NSManagedObjectContext *)newWorkerContext {
    NSManagedObjectContext *workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    workerContext.parentContext = self.mainQueueContext;
    
    return workerContext;
}

#pragma mark - NSPersistentStoreCoordinator

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSAssert([self.modelURLResourceString length], @"You must set the modelURLResourceString when you initialize this object.");
        
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.modelURLResourceString]];
        
        NSError *error;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSMutableDictionary *storeOptions = [@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} mutableCopy];
        
        [storeOptions setValue:self.ubiquitousContentNameKey forKey:NSPersistentStoreUbiquitousContentNameKey];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
            NSAssert(!error, @"Error loading the PSC");
        }
        
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelURLResourceString withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

#pragma mark - Saving

- (void)saveContext:(NSManagedObjectContext *)managedObjectContext {
    if ([managedObjectContext hasChanges] && [[managedObjectContext.persistentStoreCoordinator persistentStores] count]) {
        [managedObjectContext performBlockAndWait:^{
            NSError *error;

            BOOL saved = [managedObjectContext save:&error];
            if (!saved && error) {
                NSLog(@"Error saving context: %@", error);
            }
        }];
        
        [self saveContext:managedObjectContext.parentContext];
    }
}

#pragma mark - Existence Checking

- (NSManagedObject *)existingEntity:(NSString *)entityName
                          withValue:(id)value forKey:(NSString *)key
                          inContext:(NSManagedObjectContext *)context {
    __block NSArray *fetchedObjects;
    
	[context performBlockAndWait:^{
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
        [fetchRequest setFetchLimit:1];
        
        if (key && value) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
            [fetchRequest setPredicate:predicate];
        }
		
		fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
	}];
    
    NSManagedObject *existingObject = [fetchedObjects firstObject];
    
    return existingObject;
}

#pragma mark - iCloud Core Data Observers

- (void)registerForiCloudNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storesWillChange:)
                                                 name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                               object:self.persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:self.persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storesDidChange:)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:self.persistentStoreCoordinator];
}

- (void)removeObserversForiCloudNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                  object:self.persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:self.persistentStoreCoordinator];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                                  object:self.persistentStoreCoordinator];
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {
    typeof(self) __weak weakSelf = self;

    [self.mainQueueContext performBlock:^{
        [weakSelf.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LCKCoreDataControllerMainQueueContextDidUpdateWithUbiquitousContentChangesNotification object:nil userInfo:[notification userInfo]];
    }];
}

- (void)storesWillChange:(NSNotification *)notification {
    NSManagedObjectContext *context = self.masterContext;
    
    [self saveContext:context];
    
    // We reset the context here to ensure no pollution between stores.
    [context performBlockAndWait:^{
        [context reset];
    }];
    
    NSNumber *transitionTypeNumber = [[notification userInfo] objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    
    if ([transitionTypeNumber integerValue] == NSPersistentStoreUbiquitousTransitionTypeContentRemoved) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LCKCoreDataControllerUbiquitousContentWillBeRemovedNotification object:[notification userInfo]];
        }];
    }
}

- (void)storesDidChange:(NSNotification *)note {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LCKCoreDataControllerStoresDidChangeNotification object:nil userInfo:note.userInfo];
    }];
}

@end
