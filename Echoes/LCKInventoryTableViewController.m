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
#import "LCKBaseCell.h"
#import "LCKItemViewController.h"
#import "LCKAllPeersViewController.h"
#import "LCKMultipeerManager.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKInventoryTableViewController () <LCKItemViewControllerDelegate>

@property (nonatomic) NSArray *unequippedItems;

@end

@implementation LCKInventoryTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundColor = [UIColor backgroundColor];
    
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - LCKInventoryTableViewController

- (NSArray *)unequippedItems {
    if (!_unequippedItems) {
        NSMutableArray *unequippedItems = [NSMutableArray array];
        
        for (LCKItem *item in self.character.items) {
            if (!item.isEquipped) {
                NSLog(@"Unequipped: %@", item.name);
                [unequippedItems addObject:item];
            }
            else {
                NSLog(@"Equipped: %@", item.name);
            }
        }
        
        _unequippedItems = [unequippedItems copy];
    }
    
    return _unequippedItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.unequippedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKItem *item = [self.unequippedItems safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LCKItem *item = [self.unequippedItems safeObjectAtIndex:indexPath.row];
        
        [self.character removeItemFromInventory:item];
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKItem *item = [self.unequippedItems safeObjectAtIndex:indexPath.row];
    
    LCKItemViewController *itemViewController = [[LCKItemViewController alloc] initWithItem:item displayStyle:LCKItemViewControllerDisplayStyleInventory];
    itemViewController.character = self.character;
    itemViewController.delegate = self;
    
    [self.navigationController pushViewController:itemViewController animated:YES];
}

#pragma mark - LCKItemViewControllerDelegate

- (void)giftItemButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    LCKAllPeersViewController *allPeersViewController = [[LCKAllPeersViewController alloc] initWithMultipeerManager:self.multipeerManager];
    allPeersViewController.peerType = LCKAllPeersTypePlayer;
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
