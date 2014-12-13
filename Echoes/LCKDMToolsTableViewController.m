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
#import "LCKMultipeerManager.h"

typedef NS_ENUM(NSUInteger, LCKDMToolsRow) {
    LCKDMToolsRowAllItems,
    LCKDMToolsRowSoulGifting,
    LCKDMToolsRowCount
};

@interface LCKDMToolsTableViewController ()

@property (nonatomic) LCKMultipeerManager *multipeerManager;

@end

@implementation LCKDMToolsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.multipeerManager = [[LCKMultipeerManager alloc] initWithCharacterName:@"DM"];
    [self.multipeerManager startMonitoring];
}

#pragma mark - LCKDMToolsTableViewController

+ (NSString *)titleForRowType:(LCKDMToolsRow)rowType {
    switch (rowType) {
        case LCKDMToolsRowAllItems:
            return @"All Items";
        case LCKDMToolsRowSoulGifting:
            return @"Soul Gifting";
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
        viewController.multipeerManager = self.multipeerManager;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == LCKDMToolsRowSoulGifting) {
        LCKSoulGiftingViewController *viewController = [[LCKSoulGiftingViewController alloc] init];
        viewController.multipeerManager = self.multipeerManager;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

@end
