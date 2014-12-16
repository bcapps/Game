//
//  LCKMonsterManualTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/13/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterManualTableViewController.h"
#import "LCKMonsterProvider.h"
#import "LCKMonster.h"

#import "LCKBaseCell.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKMonsterManualTableViewController ()

@end

@implementation LCKMonsterManualTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LCKMonsterProvider allMonsters].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKMonster *monster = [[LCKMonsterProvider allMonsters] safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = monster.name;
    
    return cell;
}


@end
