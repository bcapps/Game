//
//  LCKAllPeersViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;
@import MultipeerConnectivity;

@class LCKItem;

@interface LCKAllPeersViewController : UITableViewController

@property (nonatomic) LCKItem *item;

- (instancetype)initWithSession:(MCSession *)session;

@end
