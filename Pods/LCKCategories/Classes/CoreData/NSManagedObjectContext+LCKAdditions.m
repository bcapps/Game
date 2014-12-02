//
//  NSManagedObjectContext+LCKAdditions.m
//  Velocity
//
//  Created by Twig on 6/7/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "NSManagedObjectContext+LCKAdditions.h"

@implementation NSManagedObjectContext (LCKAdditions)

- (NSManagedObject *)objectForURIRepresentation:(NSURL *)objectURI {
    NSManagedObjectID *objectID = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:objectURI];
    
    if (objectID) {
        return [self existingObjectWithID:objectID error:nil];
    }
    
    return nil;
}

@end
