//
//  LCKInventoryTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKInventoryTableViewController.h"
#import "LCKItem.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKInventoryTableViewController ()

@end

@implementation LCKInventoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundColor = [UIColor backgroundColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.itemNames safeObjectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    
    return cell;
}

@end
