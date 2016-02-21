//
//  NSFetchedResultsController+LCKAdditions.m
//  Pods
//
//  Created by Andrew Harrison on 7/25/14.
//
//

#import "NSFetchedResultsController+LCKAdditions.h"
#import "NSArray+LCKAdditions.h"

@implementation NSFetchedResultsController (LCKAdditions)

- (id)safeObjectAtIndexPath:(NSIndexPath *)indexPath {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections safeObjectAtIndex:indexPath.section];
    
    if (sectionInfo.objects.count > indexPath.row) {
        return [self objectAtIndexPath:indexPath];
    }
    
    return nil;
}

@end
