//
//  LCKAllItemsTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import MultipeerConnectivity;

#import "LCKAllItemsTableViewController.h"
#import "LCKItemProvider.h"
#import "LCKItem.h"

#import "UIColor+ColorStyle.h"

#import "LCKBaseCell.h"

#import "LCKAllPeersViewController.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKAllItemsTableViewController ()

@property (nonatomic, readonly) NSDictionary *allItems;
@property (nonatomic, readonly) NSArray *itemTypeNames;

@end

@implementation LCKAllItemsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];    
}

#pragma mark - LCKAllItemsTableViewController

- (NSDictionary *)allItems {
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    for (NSString *typeName in self.itemTypeNames) {
        [itemDictionary setObject:[NSMutableArray array] forKey:typeName];
    }
    
    for (LCKItem *item in [LCKItemProvider allItems]) {
        if ([item isAppropriateForItemSlot:LCKItemSlotOneHand]) {
            [[itemDictionary objectForKey:LCKItemTypeNameOneHanded] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotTwoHand]) {
            [[itemDictionary objectForKey:LCKItemTypeNameTwoHanded] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotAccessory]) {
            [[itemDictionary objectForKey:LCKItemTypeNameAccessory] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotChest]) {
            [[itemDictionary objectForKey:LCKItemTypeNameChest] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotHelmet]) {
            [[itemDictionary objectForKey:LCKItemTypeNameHelmet] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotBoots]) {
            [[itemDictionary objectForKey:LCKItemTypeNameBoots] addObject:item];
        }
        else if ([item isAppropriateForItemSlot:LCKItemSlotSpell]) {
            [[itemDictionary objectForKey:LCKItemTypeNameSpell] addObject:item];
        }
        else {
            [[itemDictionary objectForKey:LCKItemTypeNameInventory] addObject:item];
        }
    }
    
    return itemDictionary;
}

- (NSArray *)itemTypeNames {
    return @[LCKItemTypeNameOneHanded, LCKItemTypeNameTwoHanded, LCKItemTypeNameAccessory, LCKItemTypeNameChest, LCKItemTypeNameHelmet, LCKItemTypeNameBoots, LCKItemTypeNameSpell, LCKItemTypeNameInventory];
}

- (LCKItem *)itemForIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = [self.itemTypeNames safeObjectAtIndex:indexPath.section];
    NSArray *items = [self.allItems objectForKey:keyName];
    
    return [items safeObjectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allItems.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *keyName = [self.itemTypeNames safeObjectAtIndex:section];
    NSArray *items = [self.allItems objectForKey:keyName];
    
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.itemTypeNames safeObjectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKItem *item = [self itemForIndexPath:indexPath];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCKItem *item = [self itemForIndexPath:indexPath];
    
    LCKAllPeersViewController *peersViewController = [[LCKAllPeersViewController alloc] initWithMultipeerManager:self.multipeer];
    peersViewController.peerType = LCKAllPeersTypeDM;
    peersViewController.item = item;
    
    [self.navigationController pushViewController:peersViewController animated:YES];
}

@end
