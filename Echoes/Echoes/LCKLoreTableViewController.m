//
//  LCKLoreTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLoreTableViewController.h"
#import "LCKLoreProvider.h"
#import "LCKLore.h"
#import "LCKBaseCell.h"
#import "LCKLoreViewController.h"
#import "LCKLoreGroup.h"

#import "UIColor+ColorStyle.h"
#import <LCKCategories/NSArray+LCKAdditions.h>

@implementation LCKLoreTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - LCKLoreTableViewController

- (LCKLore *)loreForIndexPath:(NSIndexPath *)indexPath {
    LCKLoreGroup *loreGroup = [[LCKLoreProvider loreGroups] safeObjectAtIndex:indexPath.section];
    
    return [loreGroup.loreArray safeObjectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LCKLoreProvider loreGroups].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LCKLoreGroup *loreGroup = [[LCKLoreProvider loreGroups] safeObjectAtIndex:section];

    return loreGroup.loreArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKLore *lore = [self loreForIndexPath:indexPath];
    
    cell.textLabel.text = lore.title;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LCKLoreGroup *loreGroup = [[LCKLoreProvider loreGroups] safeObjectAtIndex:section];

    return loreGroup.title;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKLore *lore = [self loreForIndexPath:indexPath];
    
    LCKLoreViewController *loreViewController = [[LCKLoreViewController alloc] initWithLore:lore];
    
    [self.navigationController pushViewController:loreViewController animated:YES];
}

@end
