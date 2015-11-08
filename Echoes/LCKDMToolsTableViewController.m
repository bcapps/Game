//
//  LCKDMToolsTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/13/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKDMToolsTableViewController.h"
#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import "LCKAllItemsTableViewController.h"
#import "LCKSoulGiftingViewController.h"
#import "LCKMonsterManualTableViewController.h"
#import "LCKLoreTableViewController.h"
#import "LCKMultipeer.h"
#import "LCKMapsTableViewController.h"
#import "LCKEventsTableViewController.h"
#import "LCKDMManager.h"

typedef NS_ENUM(NSUInteger, LCKDMToolsRow) {
    LCKDMToolsRowAllItems,
    LCKDMToolsRowSoulGifting,
    LCKDMToolsRowMonsterManual,
    LCKDMToolsRowLore,
    LCKDMToolsRowMaps,
    LCKDMToolsRowEvents,
    LCKDMToolsRowCount
};

@interface LCKDMToolsTableViewController ()

@property (nonatomic) LCKMultipeer *multipeer;

@end

@implementation LCKDMToolsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.multipeer = [[LCKMultipeer alloc] initWithMultipeerUserType:LCKMultipeerUserTypeHost peerName:@"DM" serviceName:@"echoes"];
    [self.multipeer startMultipeerConnectivity];
}

#pragma mark - LCKDMToolsTableViewController

+ (NSString *)titleForRowType:(LCKDMToolsRow)rowType {
    switch (rowType) {
        case LCKDMToolsRowAllItems:
            return @"All Items";
        case LCKDMToolsRowSoulGifting:
            return @"Soul Modification";
        case LCKDMToolsRowMonsterManual:
            return @"Monster Manual";
        case LCKDMToolsRowLore:
            return @"Lore";
        case LCKDMToolsRowMaps:
            return @"Maps";
        case LCKDMToolsRowEvents:
            return @"Events";
        case LCKDMToolsRowCount:
            return @"";
    }
    
    return @"";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return LCKDMToolsRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [[self class] titleForRowType:indexPath.row];
    cell.textLabel.font = [UIFont titleTextFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    cell.backgroundColor = self.tableView.backgroundColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == LCKDMToolsRowAllItems) {
        LCKAllItemsTableViewController *viewController = [[LCKAllItemsTableViewController alloc] init];
        viewController.multipeer = self.multipeer;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowSoulGifting) {
        LCKSoulGiftingViewController *viewController = [[LCKSoulGiftingViewController alloc] init];
        viewController.multipeer = self.multipeer;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowMonsterManual) {
        LCKMonsterManualTableViewController *viewController = [[LCKMonsterManualTableViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowLore) {
        LCKLoreTableViewController *viewController = [[LCKLoreTableViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowMaps) {
        LCKMapsTableViewController *viewController = [[LCKMapsTableViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowEvents) {
        LCKEventsTableViewController *viewController = [[LCKEventsTableViewController alloc] init];
        viewController.multipeer = self.multipeer;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
