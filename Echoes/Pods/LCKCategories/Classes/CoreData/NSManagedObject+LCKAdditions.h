//
//  NSManagedObject+LCKAdditions.h
//  Quotebook
//
//  Created by Andrew Harrison on 1/4/14.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (LCKAdditions)

/// A key suitable for use in an NSCache or NSDictionary
@property (nonatomic, readonly) id <NSCopying> cacheKey;

/// The object’s class as a string.
+ (NSString *)entityName;

/// An NSEntityDescription based on the object’s entityName in a given context.
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;

/// Initializes the object inserted into a given context by calling entityDescriptionInContext: with the same context.
- (instancetype)initWithContext:(NSManagedObjectContext *)context;

/**
 *  Returns an object in another context, obtaining a permanant ID if necessary.
 *
 *  @param context The context in which to fetch the object by ID.
 *
 *  @return An NSManagedObject in the provided context or nil.
 */
- (NSManagedObject *)existingObjectInContext:(NSManagedObjectContext *)context;

/// The object URI as a string.
- (NSString *)objectURIString;

@end
