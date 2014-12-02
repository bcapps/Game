//
//  NSManagedObjectContext+LCKAdditions.h
//  Velocity
//
//  Created by Twig on 6/7/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (LCKAdditions)

- (NSManagedObject *)objectForURIRepresentation:(NSURL *)objectURI;

@end
