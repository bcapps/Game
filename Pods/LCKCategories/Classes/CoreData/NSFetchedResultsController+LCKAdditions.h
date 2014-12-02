//
//  NSFetchedResultsController+LCKAdditions.h
//  Pods
//
//  Created by Andrew Harrison on 7/25/14.
//
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (LCKAdditions)

- (id)safeObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
