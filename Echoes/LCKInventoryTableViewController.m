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

@interface LCKInventoryTableViewController () <LCKAllItemsDelegate, LCKInventoryItemCellDelegate>

@end

@implementation LCKInventoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.tableView registerClass:[LCKInventoryItemCell class] forCellReuseIdentifier:NSStringFromClass([LCKInventoryItemCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIMenuItem *equipItem = [[UIMenuItem alloc] initWithTitle:@"Equip" action:NSSelectorFromString(@"equipItem")];
    [[UIMenuController sharedMenuController] setMenuItems: @[equipItem]];
    [[UIMenuController sharedMenuController] update];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAllItemsViewController"]) {
        UINavigationController *navController = segue.destinationViewController;
        LCKAllItemsTableViewController *allItemsViewController = [navController.viewControllers firstObject];
        allItemsViewController.itemDelegate = self;
    }
}

#pragma mark - LCKAllItemsDelegate

- (void)didSelectItem:(LCKItem *)item {
    if (!self.character.items) {
        self.character.items = @[item.name];
    }
    else {
        self.character.items = [self.character.items arrayByAddingObject:item.name];
    }
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self.tableView reloadData];
}

#pragma mark - LCKInventoryItemCellDelegate

- (void)itemCellWasEquipped:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *itemName = [self.character.items safeObjectAtIndex:indexPath.row];
    
    if (itemName) {
        if (!self.character.equippedItems) {
            self.character.equippedItems = @[itemName];
        }
        else {
            self.character.equippedItems = [self.character.equippedItems arrayByAddingObject:itemName];
        }
    }
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.character.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKInventoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKInventoryItemCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    
    NSString *itemName = [self.character.items safeObjectAtIndex:indexPath.row];
    
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = itemName;
    cell.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    
    if ([self.character.equippedItems containsObject:itemName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // required
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *itemNames = [self.character.items mutableCopy];
        [itemNames removeObjectAtIndex:indexPath.row];
        self.character.items = [itemNames copy];
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
