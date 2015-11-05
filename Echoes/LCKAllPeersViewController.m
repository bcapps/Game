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
#import "LCKDMManager.h"
#import "LCKDMToolsTableViewController.h"
#import "LCKEvent.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKAllPeersViewController ()

@property (nonatomic) LCKMultipeerManager *multipeerManager;
@property (nonatomic) NSArray *selectedPeerIDs;
@property (nonatomic) NSArray *peers;

@end

@implementation LCKAllPeersViewController

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.selectedPeerIDs = @[];
    
    if (self.peerType == LCKAllPeersTypeDM) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerStateChanged) name:LCKMultipeerPeerStateChangedNotification object:nil];
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

- (NSArray *)peers {
    NSMutableArray *peers = [NSMutableArray array];
    
    for (MCPeerID *peerID in self.multipeerManager.connectedPeers) {
        if (![peerID.displayName isEqualToString:LCKDMDisplayName]) {
            [peers addObject:peerID];
        }
    }
    
    return [peers copy];
}

- (void)send {
    for (MCPeerID *peerID in self.selectedPeerIDs) {
        if (self.item) {
            [self.multipeerManager sendItemName:self.item.name toPeerID:peerID];
        }
        else if (self.soulsToGive) {
            [self.multipeerManager sendSoulAmount:self.soulsToGive toPeerID:peerID];
        }
        else if (self.event) {
            [self.multipeerManager sendEventName:self.event.name toPeerID:peerID];
        }
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[LCKDMToolsTableViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
}

- (void)peerStateChanged {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCPeerID *peerID = [self.peers safeObjectAtIndex:indexPath.row];
    
    if (peerID) {
        if (self.peerType == LCKAllPeersTypeDM) {
            if ([self.selectedPeerIDs containsObject:peerID]) {
                NSMutableArray *peerIDsArray = [self.selectedPeerIDs mutableCopy];
                [peerIDsArray removeObject:peerID];
                self.selectedPeerIDs = [peerIDsArray copy];
            }
            else {
                self.selectedPeerIDs = [self.selectedPeerIDs arrayByAddingObject:peerID];
            }
        }
        else if (peerID) {
            BOOL success = [self.multipeerManager sendItemName:self.item.name toPeerID:peerID];
            
            if (self.dismissBlock) {
                self.dismissBlock(success);
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
    if (indexPath) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor backgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    MCPeerID *peerID = [self.peers safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = peerID.displayName;
    cell.textLabel.font = [UIFont titleTextFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    
    if ([self.selectedPeerIDs containsObject:peerID]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

@end
