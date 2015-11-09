//
//  LCKItemButtonController.m
//  Echoes
//
//  Created by Andrew Harrison on 11/8/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKItemButtonController.h"
#import "LCKItemButton.h"
#import "Character.h"

@implementation LCKItemButtonController

#pragma mark - LCKItemButtonController

- (LCKEquipmentSlot)equipmentSlotForItemButton:(LCKItemButton *)itemButton {
    LCKEquipmentSlot equipmentSlot = LCKEquipmentSlotUnequipped;
    
    if (itemButton == self.leftHandButton || itemButton == self.rightHandButton) {
        if (itemButton == self.leftHandButton) {
            equipmentSlot = LCKEquipmentSlotLeftHand;
        }
        else {
            equipmentSlot = LCKEquipmentSlotRightHand;
        }
    }
    else if (itemButton == self.firstAccessoryButton || itemButton == self.secondAccessoryButton) {
        if (itemButton == self.firstAccessoryButton) {
            equipmentSlot = LCKEquipmentSlotFirstAccessory;
        }
        else {
            equipmentSlot = LCKEquipmentSlotSecondAccessory;
        }
    }
    else if (itemButton == self.helmetButton) {
        equipmentSlot = LCKEquipmentSlotHelmet;
    }
    else if (itemButton == self.chestButton) {
        equipmentSlot = LCKEquipmentSlotChest;
    }
    else if (itemButton == self.bootsButton) {
        equipmentSlot = LCKEquipmentSlotBoots;
    }
    else if (itemButton == self.firstSpellButton || itemButton == self.secondSpellButton || itemButton == self.thirdSpellButton || itemButton == self.fourthSpellButton) {
        
        if (itemButton == self.firstSpellButton) {
            equipmentSlot = LCKEquipmentSlotFirstSpell;
        }
        else if (itemButton == self.secondSpellButton) {
            equipmentSlot = LCKEquipmentSlotSecondSpell;
        }
        else if (itemButton == self.thirdSpellButton) {
            equipmentSlot = LCKEquipmentSlotThirdSpell;
        }
        else {
            equipmentSlot = LCKEquipmentSlotFourthSpell;
        }
    }
    
    return equipmentSlot;
}

- (NSArray *)equipmentTypesForItemButton:(LCKItemButton *)button {
    NSArray *equipmentTypes;
    
    if (button == self.leftHandButton || button == self.rightHandButton) {
        equipmentTypes = @[@(LCKItemSlotOneHand), @(LCKItemSlotTwoHand)];
    }
    else if (button == self.firstAccessoryButton || button == self.secondAccessoryButton) {
        equipmentTypes = @[@(LCKItemSlotAccessory)];
    }
    else if (button == self.helmetButton) {
        equipmentTypes = @[@(LCKItemSlotHelmet)];
    }
    else if (button == self.chestButton) {
        equipmentTypes = @[@(LCKItemSlotChest)];
    }
    else if (button == self.bootsButton) {
        equipmentTypes = @[@(LCKItemSlotBoots)];
    }
    else if (button == self.firstSpellButton || button == self.secondSpellButton || button == self.thirdSpellButton || button == self.fourthSpellButton) {
        equipmentTypes = @[@(LCKItemSlotSpell)];
    }
    
    return equipmentTypes;
}

- (void)updateItemButtonsForCharacter:(Character *)character; {
    self.leftHandButton.item = nil;
    self.rightHandButton.item = nil;
    self.firstSpellButton.item = nil;
    self.secondSpellButton.item = nil;
    self.thirdSpellButton.item = nil;
    self.fourthSpellButton.item = nil;
    self.firstAccessoryButton.item = nil;
    self.secondAccessoryButton.item = nil;
    
    for (LCKItem *weapon in character.equippedWeapons) {
        if (weapon.equippedSlot == LCKEquipmentSlotLeftHand) {
            self.leftHandButton.item = weapon;
        }
        else if (weapon.equippedSlot == LCKEquipmentSlotRightHand) {
            self.rightHandButton.item = weapon;
        }
    }
    
    self.helmetButton.item = character.equippedHelm;
    self.chestButton.item = character.equippedChest;
    self.bootsButton.item = character.equippedBoots;
    
    for (LCKItem *spell in character.equippedSpells) {
        if (spell.equippedSlot == LCKEquipmentSlotFirstSpell) {
            self.firstSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotSecondSpell) {
            self.secondSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotThirdSpell) {
            self.thirdSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotFourthSpell) {
            self.fourthSpellButton.item = spell;
        }
    }
    
    for (LCKItem *accessory in character.equippedAccessories) {
        if (accessory.equippedSlot == LCKEquipmentSlotFirstAccessory) {
            self.firstAccessoryButton.item = accessory;
        }
        else if (accessory.equippedSlot == LCKEquipmentSlotSecondAccessory) {
            self.secondAccessoryButton.item = accessory;
        }
    }
}

#pragma mark - Item Buttons

- (void)setHelmetButton:(LCKItemButton *)helmetButton {
    _helmetButton = helmetButton;
    _helmetButton.itemSlot = LCKItemSlotHelmet;
}

- (void)setChestButton:(LCKItemButton *)chestButton {
    _chestButton = chestButton;
    _chestButton.itemSlot = LCKItemSlotChest;
}

- (void)setBootsButton:(LCKItemButton *)bootsButton {
    _bootsButton = bootsButton;
    _bootsButton.itemSlot = LCKItemSlotBoots;
}

- (void)setFirstAccessoryButton:(LCKItemButton *)firstAccessoryButton {
    _firstAccessoryButton = firstAccessoryButton;
    _firstAccessoryButton.itemSlot = LCKItemSlotAccessory;
}

- (void)setSecondAccessoryButton:(LCKItemButton *)secondAccessoryButton {
    _secondAccessoryButton = secondAccessoryButton;
    _secondAccessoryButton.itemSlot = LCKItemSlotAccessory;
}

- (void)setLeftHandButton:(LCKItemButton *)leftHandButton {
    _leftHandButton = leftHandButton;
    _leftHandButton.itemSlot = LCKItemSlotOneHand;
}

- (void)setRightHandButton:(LCKItemButton *)rightHandButton {
    _rightHandButton = rightHandButton;
    _rightHandButton.itemSlot = LCKItemSlotOneHand;
}

- (void)setFirstSpellButton:(LCKItemButton *)firstSpellButton {
    _firstSpellButton = firstSpellButton;
    _firstSpellButton.itemSlot = LCKItemSlotSpell;
}

- (void)setSecondSpellButton:(LCKItemButton *)secondSpellButton {
    _secondSpellButton = secondSpellButton;
    _secondSpellButton.itemSlot = LCKItemSlotSpell;
}

- (void)setThirdSpellButton:(LCKItemButton *)thirdSpellButton {
    _thirdSpellButton = thirdSpellButton;
    _thirdSpellButton.itemSlot = LCKItemSlotSpell;
}

- (void)setFourthSpellButton:(LCKItemButton *)fourthSpellButton {
    _fourthSpellButton = fourthSpellButton;
    _fourthSpellButton.itemSlot = LCKItemSlotSpell;
}

@end
