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
    return [self.character.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    NSString *itemName = [self.character.items safeObjectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor backgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = itemName;
    cell.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    
    if ([self.character.equippedItems containsObject:itemName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *itemName = [self.character.items safeObjectAtIndex:indexPath.row];
        
        NSMutableArray *itemNames = [self.character.items mutableCopy];
        [itemNames removeObject:itemName];
        self.character.items = [itemNames copy];
    }
}

@end
