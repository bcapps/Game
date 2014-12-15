//
//  LCKAllPeersViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;
@import MultipeerConnectivity;

typedef NS_ENUM(NSUInteger, LCKAllPeersType) {
    LCKAllPeersTypePlayer,
    LCKAllPeersTypeDM
};

typedef void(^LCKAllPeersViewControllerDismissedBlock)(BOOL success);

@class LCKMultipeerManager;
@class LCKItem;

@interface LCKAllPeersViewController : UITableViewController

@property (nonatomic) LCKItem *item;
@property (nonatomic) NSNumber *soulsToGive;
@property (nonatomic) LCKAllPeersType peerType;

@property (nonatomic, copy) LCKAllPeersViewControllerDismissedBlock dismissBlock;

- (instancetype)initWithMultipeerManager:(LCKMultipeerManager *)multipeerManager;

@end
