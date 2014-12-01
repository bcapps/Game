//
//  LCKCoreDataTableViewController.m
//  Velocity
//
//  Created by Twig on 6/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKCoreDataTableViewController.h"
#import "LCKCoreDataController.h"

@implementation LCKCoreDataTableViewController

#pragma mark - NSObject

- (void)dealloc {
    self.fetchedResultsController.delegate = nil;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (self.activeTableView.isEditing && self.ignoresChangesDuringEditing) {
        return;
    }
    
    [self.activeTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (self.activeTableView.isEditing && self.ignoresChangesDuringEditing) {
        return;
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.activeTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.activeTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    if (self.activeTableView.isEditing && self.ignoresChangesDuringEditing) {
        return;
    }
    
    UITableView *tableView = self.activeTableView;
    UITableViewRowAnimation animation = [self tableViewRowAnimationForChangeType:type];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animation];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animation];
            break;
    }
}

- (UITableViewRowAnimation)tableViewRowAnimationForChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeMove:
            return UITableViewRowAnimationFade;
            break;
        default:
            return UITableViewRowAnimationAutomatic;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.activeTableView.isEditing && self.ignoresChangesDuringEditing) {
        return;
    }
    
    [self.activeTableView endUpdates];
}

#pragma mark - LCKCoreDataTableViewController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = [[LCKCoreDataController sharedController] mainQueueContext];
    
    Class fetchedResultsControllerClass = [self fetchedResultsControllerClass];
    NSFetchedResultsController *aFetchedResultsController = [[fetchedResultsControllerClass alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:managedObjectContext sectionNameKeyPath:[self sectionNameKeyPath] cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error;
    BOOL fetched = [_fetchedResultsController performFetch:&error];
    if (!fetched && error) {
        NSLog(@"%@", error);
        
        // Fix for an error that occurs with Chinese character sections. http://stackoverflow.com/a/18240372
        if ([error code] == NSCoreDataError) {
            NSFetchedResultsController *removedKeyPathFetchedResultsController = [[fetchedResultsControllerClass alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            removedKeyPathFetchedResultsController.delegate = self;
            
            _fetchedResultsController = removedKeyPathFetchedResultsController;
            fetched = [_fetchedResultsController performFetch:&error];
            
            if (!fetched && error) {
                NSLog(@"Error creating fallback FRC: %@", error);
            }
        }
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest {
    NSAssert(NO, @"Subclasses must implement this method and return a proper NSFetchRequest to be used by the NSFetchedResultsController");
    
    return nil;
}

- (NSString *)sectionNameKeyPath {
    return nil;
}

- (Class)fetchedResultsControllerClass {
    return [NSFetchedResultsController class];
}

- (UITableView *)activeTableView {
    if ([self.searchDisplayController isActive]) {
        return self.searchDisplayController.searchResultsTableView;
    }
    
    return self.tableView;
}

@end
