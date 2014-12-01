//
//  LCKCoreDataController.h
//  Velocity
//
//  Created by Andrew Harrison on 1/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;
@import CoreData;

extern NSString * const LCKCoreDataControllerSaveNotificationDeletedObjectsKey;
extern NSString * const LCKCoreDataControllerSaveNotificationInsertedObjectsKey;
extern NSString * const LCKCoreDataControllerSaveNotificationUpdatedObjectsKey;

extern NSString * const LCKCoreDataControllerStoresDidChangeNotification;

extern NSString * const LCKCoreDataControllerMainQueueContextDidUpdateWithUbiquitousContentChangesNotification;
extern NSString * const LCKCoreDataControllerUbiquitousContentWillBeRemovedNotification;

typedef void (^LCKCoreDataControllerWorkerContextBlock)(NSManagedObjectContext *context);
typedef void (^LCKCoreDataControllerSaveFinishedBlock)();

@interface LCKCoreDataController : NSObject

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, readonly) NSManagedObjectContext *mainQueueContext;

/** The app specific portion of the model URL resource path. You must set this property in order for Core Data to function appropriately. */
@property (nonatomic) NSString *modelURLResourceString;

/** Warning: Setting this property enables iCloud. By setting this property and returning a ubiquitous content name key, you are registering your application to be enabled with iCloud.
 */
@property (nonatomic) NSString *ubiquitousContentNameKey;

+ (instancetype)sharedController;
- (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

- (NSManagedObject *)existingEntity:(NSString *)entityName withValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context;

/** This method creates a new worker context with a background queue concurrency type, and the runs the block inside of a performBlock: call to that context. After the block has finished executing, it then saves that worker context if there have been any changes. 
 */
- (void)performWorkerContextBlock:(LCKCoreDataControllerWorkerContextBlock)contextBlock saveFinished:(LCKCoreDataControllerSaveFinishedBlock)saveFinishedBlock;

/** This method creates a new worker context with a background queue concurrency type, and the runs the block inside of a performBlockAndWait: call to that context. After the block has finished executing, it then saves that worker context if there have been any changes.
 */
- (void)performWorkerContextBlockAndWait:(LCKCoreDataControllerWorkerContextBlock)contextBlock;

/// Returns a new worker context with a background queue concurrency type.
- (NSManagedObjectContext *)newWorkerContext;

/// Register a custom subclass of LCKCoreDataController to be returned from sharedController.
+ (void)registerSubclass:(Class)subclass;

/// Registers the controller to observe iCloud notifications. You must do this to receive iCloud notifications.
- (void)registerForiCloudNotifications;

@end
