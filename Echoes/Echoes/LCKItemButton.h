//
//  LCKItemButton.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

#import "LCKItem.h"

@interface LCKItemButton : UIButton

@property (nonatomic) LCKItem *item;
@property (nonatomic) LCKItemSlot itemSlot;

@end
