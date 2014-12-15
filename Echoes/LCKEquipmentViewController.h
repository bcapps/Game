//
//  LCKEquipmentViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/7/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

@class Character;
@class LCKItem;

#import "LCKItem.h"
#import "CharacterStats.h"

@protocol LCKEquipmentViewControllerDelegate <NSObject>

- (void)itemWasSelected:(LCKItem *)item equipmentSlot:(LCKEquipmentSlot)equipmentSlot;

@end

@interface LCKEquipmentViewController : UITableViewController

- (instancetype)initWithCharacter:(Character *)character equipmentTypes:(NSArray *)equipmentTypes;

@property (nonatomic, weak) id <LCKEquipmentViewControllerDelegate> delegate;
@property (nonatomic) LCKEquipmentSlot selectedEquipmentSlot;

@end
