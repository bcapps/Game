//
//  LCKEventsTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/27/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEventsTableViewController.h"
#import "LCKBaseCell.h"
#import "UIColor+ColorStyle.h"

#import "LCKEventProvider.h"
#import "LCKEvent.h"

#import "LCKAllPeersViewController.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKEventsTableViewController ()

@end

@implementation LCKEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LCKEventProvider allEvents].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKEvent *event = [[LCKEventProvider allEvents] safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKAllPeersViewController *peersViewController = [[LCKAllPeersViewController alloc] initWithMultipeerManager:self.multipeerManager];
    peersViewController.peerType = LCKAllPeersTypeDM;
    
    LCKEvent *event = [[LCKEventProvider allEvents] safeObjectAtIndex:indexPath.row];
    peersViewController.event = event;
    
    [self.navigationController pushViewController:peersViewController animated:YES];
}

@end
