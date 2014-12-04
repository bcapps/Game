//
//  LCKAllItemsTableViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

@class LCKItem;

@protocol LCKAllItemsDelegate <NSObject>

- (void)didSelectItem:(LCKItem *)item;

@end

@interface LCKAllItemsTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet id <LCKAllItemsDelegate> itemDelegate;

@end
