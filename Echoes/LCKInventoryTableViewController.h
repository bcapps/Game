//
//  LCKInventoryTableViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;
@import MultipeerConnectivity;

#import "Character.h"

@class LCKMultipeerManager;

@protocol LCKInventoryTableViewControllerDelegate <NSObject>

- (void)itemWasGiftedFromInventory:(LCKItem *)item;

@end

@interface LCKInventoryTableViewController : UITableViewController

@property (nonatomic) Character *character;
@property (nonatomic, weak) id <LCKInventoryTableViewControllerDelegate> delegate;
@property (nonatomic) LCKMultipeerManager *multipeerManager;

@end
