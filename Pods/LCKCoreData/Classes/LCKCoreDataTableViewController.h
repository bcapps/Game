//
//  LCKCoreDataTableViewController.h
//  Velocity
//
//  Created by Twig on 6/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

@import Foundation;
@import CoreData;
@import UIKit;

@interface LCKCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/// Determines whether the fetched results controller will not update the rows while the table view is editing. Defaults to NO.
@property (nonatomic) BOOL ignoresChangesDuringEditing;

/// self.tableView or self.searchDisplayController.searchResultsTableView while searching.
@property (nonatomic, readonly) UITableView *activeTableView;

/*! Override to change the behavior of reload animation for a type of change.
 @return The animation to use in the event of a change type.
 @param type The type of change to use this animation for.
 */
- (UITableViewRowAnimation)tableViewRowAnimationForChangeType:(NSFetchedResultsChangeType)type;

/// The fetch request whose content is displayed.
- (NSFetchRequest *)fetchRequest;

/// The section name key path for the associated fetched results controller.
- (NSString *)sectionNameKeyPath;

/// The class of the fetched results controller. Specify a class to override the default of [NSFetchedResultsController class].
- (Class)fetchedResultsControllerClass;

@end
