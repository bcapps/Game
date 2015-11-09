//
//  LCKItemButtonController.h
//  Echoes
//
//  Created by Andrew Harrison on 11/8/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

#import "LCKItem.h"

@class LCKItemButton;
@class Character;

@interface LCKItemButtonController : NSObject

- (NSArray *)equipmentTypesForItemButton:(LCKItemButton *)button;
- (LCKEquipmentSlot)equipmentSlotForItemButton:(LCKItemButton *)itemButton;
- (void)updateItemButtonsForCharacter:(Character *)character;

@property (nonatomic) LCKItemButton *helmetButton;
@property (nonatomic) LCKItemButton *chestButton;
@property (nonatomic) LCKItemButton *rightHandButton;
@property (nonatomic) LCKItemButton *firstAccessoryButton;
@property (nonatomic) LCKItemButton *secondAccessoryButton;
@property (nonatomic) LCKItemButton *bootsButton;
@property (nonatomic) LCKItemButton *leftHandButton;
@property (nonatomic) LCKItemButton *firstSpellButton;
@property (nonatomic) LCKItemButton *secondSpellButton;
@property (nonatomic) LCKItemButton *thirdSpellButton;
@property (nonatomic) LCKItemButton *fourthSpellButton;

@end
