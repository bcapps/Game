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

typedef NS_ENUM(NSUInteger, LCKLoreSection) {
    LCKLoreSectionWorld,
    LCKLoreSectionClasses,
    LCKLoreSectionCount
};

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
    LCKLore *lore;
    
    if (indexPath.section == LCKLoreSectionWorld) {
        lore = [[LCKLoreProvider worldLore] safeObjectAtIndex:indexPath.row];
    }
    else if (indexPath.section == LCKLoreSectionClasses) {
        lore = [[LCKLoreProvider classLore] safeObjectAtIndex:indexPath.row];
    }
    
    return lore;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return LCKLoreSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == LCKLoreSectionWorld) {
        return [LCKLoreProvider worldLore].count;
    }
    else if (section == LCKLoreSectionClasses) {
        return [LCKLoreProvider classLore].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKLore *lore = [self loreForIndexPath:indexPath];
    
    cell.textLabel.text = lore.title;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == LCKLoreSectionWorld) {
        return @"World Lore";
    }
    else if (section == LCKLoreSectionClasses) {
        return @"Class Lore";
    }
    
    return @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKLore *lore = [self loreForIndexPath:indexPath];
    
    LCKLoreViewController *loreViewController = [[LCKLoreViewController alloc] initWithLore:lore];
    
    [self.navigationController pushViewController:loreViewController animated:YES];
}

@end
