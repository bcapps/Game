//
//  LCKInventoryItemCell.h
//  Echoes
//
//  Created by Andrew Harrison on 12/4/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

#import "LCKItemCell.h"

@protocol LCKInventoryItemCellDelegate <NSObject>

- (void)itemCellWasEquipped:(UITableViewCell *)cell;

@end

@interface LCKInventoryItemCell : LCKItemCell;

@property (nonatomic, weak) id <LCKInventoryItemCellDelegate> delegate;

@end
