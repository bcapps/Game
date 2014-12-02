//
//  NSManagedObject+LCKAdditions.m
//  Quotebook
//
//  Created by Andrew Harrison on 1/4/14.
//
//

#import "NSManagedObject+LCKAdditions.h"

@implementation NSManagedObject (LCKAdditions)

- (id <NSCopying>)cacheKey {
    return self.objectID;
}

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
}

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    if (!context) {
        NSParameterAssert(context);
        
        return nil;
    }
    
    NSEntityDescription *entity = [[self class] entityDescriptionInContext:context];
    
    self = [self initWithEntity:entity insertIntoManagedObjectContext:context];
    return self;
}

- (NSManagedObject *)existingObjectInContext:(NSManagedObjectContext *)context {
    if (self.managedObjectContext == context) {
        return self;
    }
    
    if ([self.objectID isTemporaryID]) {
        [self.managedObjectContext performBlockAndWait:^{
            [self.managedObjectContext obtainPermanentIDsForObjects:@[self] error:nil];
        }];
    }
    
    // Get the object ID again now that it may be permanant.
    NSManagedObjectID *objectID = self.objectID;
    
    __block NSManagedObject *existingObject;

    if (objectID && ![objectID isTemporaryID]) {
        [context performBlockAndWait:^{
            existingObject = [context existingObjectWithID:objectID error:nil];
        }];
    }
    
    return existingObject;
}

- (NSString *)objectURIString {
    return [self.objectID.URIRepresentation absoluteString];
}

@end
