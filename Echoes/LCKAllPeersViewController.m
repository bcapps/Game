//
//  LCKAllPeersViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKAllPeersViewController.h"
#import "LCKMultipeerManager.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import "LCKItem.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKAllPeersViewController ()

@property (nonatomic) LCKMultipeerManager *multipeerManager;

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

- (instancetype)initWithMultipeerManager:(LCKMultipeerManager *)multipeerManager {
    self = [super init];
    
    if (self) {
        _multipeerManager = multipeerManager;
    }
    
    return self;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCPeerID *peerID = [self.multipeerManager.session.connectedPeers safeObjectAtIndex:indexPath.row];
    
    if (peerID) {
        BOOL success = [self.multipeerManager sendItemName:self.item.name];
        
        if (self.dismissBlock) {
            self.dismissBlock(success);
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.multipeerManager.session.connectedPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor backgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    MCPeerID *peerID = [self.multipeerManager.session.connectedPeers safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = peerID.displayName;
    cell.textLabel.font = [UIFont titleTextFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    
    return cell;
}

@end
