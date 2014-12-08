//
//  LCKInventoryTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKInventoryTableViewController.h"
#import "LCKAllItemsTableViewController.h"
#import "LCKEchoCoreDataController.h"
#import "LCKItem.h"
#import "LCKInventoryItemCell.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKInventoryTableViewController () <LCKInventoryItemCellDelegate>

@end

@implementation LCKInventoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.tableView registerClass:[LCKInventoryItemCell class] forCellReuseIdentifier:NSStringFromClass([LCKInventoryItemCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - LCKInventoryItemCellDelegate

- (void)itemCellWasEquipped:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    LCKItem *item = [self.character.items safeObjectAtIndex:indexPath.row];
    [self.character equipItem:item];

    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.character.items objectsPassingTest:^BOOL(LCKItem *item, BOOL *stop) {
        return !item.isEquipped;
    }].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKInventoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKInventoryItemCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    
    LCKItem *item = [self.character.items safeObjectAtIndex:indexPath.row];
    
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.textLabel.text = item.name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LCKItem *item = [self.character.items safeObjectAtIndex:indexPath.row];
        
        [self.character removeItemFromInventory:item];
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
