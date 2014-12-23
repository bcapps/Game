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

#import "UIColor+ColorStyle.h"
#import <LCKCategories/NSArray+LCKAdditions.h>

@implementation LCKLoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LCKLoreProvider allLore].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKLore *lore = [[LCKLoreProvider allLore] safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = lore.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKLore *lore = [[LCKLoreProvider allLore] safeObjectAtIndex:indexPath.row];
    
    LCKLoreViewController *loreViewController = [[LCKLoreViewController alloc] initWithLore:lore];
    
    [self.navigationController pushViewController:loreViewController animated:YES];
}

@end
