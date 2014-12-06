//
//  LCKAllPeersViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKAllPeersViewController.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import "LCKItem.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKAllPeersViewController ()

@property (nonatomic) MCSession *session;

@end

@implementation LCKAllPeersViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewController

#pragma mark - LCKAllPeersViewController

- (instancetype)initWithSession:(MCSession *)session {
    self = [super init];
    
    if (self) {
        _session = session;
    }
    
    return self;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCPeerID *peerID = [self.session.connectedPeers safeObjectAtIndex:indexPath.row];

    NSData *itemData = [self.item.name dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.session sendData:itemData toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.session.connectedPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor backgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    MCPeerID *peerID = [self.session.connectedPeers safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = peerID.displayName;
    cell.textLabel.font = [UIFont titleTextFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    
    return cell;
}

@end
