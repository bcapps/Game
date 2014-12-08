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

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import "LCKItemCell.h"

#import "LCKMultipeerManager.h"
#import "LCKAllPeersViewController.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

typedef NS_ENUM(NSUInteger, LCKAllItemsSection) {
    LCKAllItemsSectionOneHanded,
    LCKAllItemsSectionTwoHanded,
    LCKAllItemsSectionAccessory,
    LCKAllItemsSectionChest,
    LCKAllItemsSectionHelmet,
    LCKAllItemsSectionBoots
};

NSString * const LCKAllItemsTypeNameOneHanded = @"One-Handed";
NSString * const LCKAllItemsTypeNameTwoHanded = @"Two-Handed";
NSString * const LCKAllItemsTypeNameAccessory = @"Accessory";
NSString * const LCKAllItemsTypeNameHelmet = @"Helmet";
NSString * const LCKAllItemsTypeNameChest = @"Chest";
NSString * const LCKAllItemsTypeNameBoots = @"Boots";

@interface LCKAllItemsTableViewController ()

@property (nonatomic, readonly) NSDictionary *allItems;
@property (nonatomic, readonly) NSArray *itemTypeNames;

@property (nonatomic) LCKMultipeerManager *multipeerManager;

@end

@implementation LCKAllItemsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[LCKItemCell class] forCellReuseIdentifier:NSStringFromClass([LCKItemCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.multipeerManager = [[LCKMultipeerManager alloc] initWithCharacterName:@"DM"];
    [self.multipeerManager startMonitoring];
}

#pragma mark - LCKAllItemsTableViewController

- (NSDictionary *)allItems {
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    for (NSString *typeName in self.itemTypeNames) {
        [itemDictionary setObject:[NSMutableArray array] forKey:typeName];
    }
    
    for (LCKItem *item in [LCKItemProvider allItems]) {
        if ([item isAppropriateForItemSlot:LCKItemSlotOneHand]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameOneHanded] addObject:item];
        }
        if ([item isAppropriateForItemSlot:LCKItemSlotTwoHand]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameTwoHanded] addObject:item];
        }
        if ([item isAppropriateForItemSlot:LCKItemSlotAccessory]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameAccessory] addObject:item];
        }
        if ([item isAppropriateForItemSlot:LCKItemSlotChest]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameChest] addObject:item];
        }
        if ([item isAppropriateForItemSlot:LCKItemSlotHelmet]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameHelmet] addObject:item];
        }
        if ([item isAppropriateForItemSlot:LCKItemSlotBoots]) {
            [[itemDictionary objectForKey:LCKAllItemsTypeNameBoots] addObject:item];
        }
    }
    
    return itemDictionary;
}

- (NSArray *)itemTypeNames {
    return @[LCKAllItemsTypeNameOneHanded, LCKAllItemsTypeNameTwoHanded, LCKAllItemsTypeNameAccessory,LCKAllItemsTypeNameChest, LCKAllItemsTypeNameHelmet, LCKAllItemsTypeNameBoots];
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
    LCKItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKItemCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor backgroundColor];
    
    LCKItem *item = [self itemForIndexPath:indexPath];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCKItem *item = [self itemForIndexPath:indexPath];
    
    LCKAllPeersViewController *peersViewController = [[LCKAllPeersViewController alloc] initWithSession:self.multipeerManager.session];
    peersViewController.item = item;
    
    [self.navigationController pushViewController:peersViewController animated:YES];
}

@end
