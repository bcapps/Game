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
#import "LCKItemCell.h"
#import "LCKItemViewController.h"
#import "LCKAllPeersViewController.h"
#import "LCKMultipeerManager.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKInventoryTableViewController () <LCKItemViewControllerDelegate>

@end

@implementation LCKInventoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundColor = [UIColor backgroundColor];
    
    [self.tableView registerClass:[LCKItemCell class] forCellReuseIdentifier:NSStringFromClass([LCKItemCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.character.items objectsPassingTest:^BOOL(LCKItem *item, BOOL *stop) {
        return !item.isEquipped;
    }].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKItemCell class]) forIndexPath:indexPath];
    
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKItem *item = [self.character.items safeObjectAtIndex:indexPath.row];
    
    LCKItemViewController *itemViewController = [[LCKItemViewController alloc] initWithItem:item displayStyle:LCKItemViewControllerDisplayStyleInventory];
    itemViewController.character = self.character;
    itemViewController.delegate = self;
    
    [self.navigationController pushViewController:itemViewController animated:YES];
}

#pragma mark - LCKItemViewControllerDelegate

- (void)giftItemButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    LCKAllPeersViewController *allPeersViewController = [[LCKAllPeersViewController alloc] initWithMultipeerManager:self.multipeerManager];
    allPeersViewController.item = itemViewController.item;
    
    allPeersViewController.dismissBlock = ^(BOOL success) {
        if (success) {
            [self.delegate itemWasGiftedFromInventory:itemViewController.item];
        }
        else {
            //TODO: Handle Error Case
        }
    };
    
    [self.navigationController pushViewController:allPeersViewController animated:YES];
}

@end
