//
//  LCKEquipmentViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/7/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

@class Character;

@interface LCKEquipmentViewController : UITableViewController

- (instancetype)initWithCharacter:(Character *)character equipmentTypes:(NSArray *)equipmentTypes;

@end
