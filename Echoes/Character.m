//
//  Character.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Character.h"
#import "CharacterStats.h"

#import "LCKItem.h"
#import "LCKItemProvider.h"

@implementation Character

@dynamic gender;
@dynamic level;
@dynamic name;
@dynamic currentHealth;
@dynamic items;
@dynamic characterStats;
@dynamic souls;

- (void)awakeFromInsert {
    self.items = @[];
}

- (void)awakeFromFetch {
    NSMutableArray *updatedItems = [NSMutableArray array];
    
    for (LCKItem *item in self.items) {
        LCKItem *updatedItem = [LCKItemProvider itemForName:item.name];
        updatedItem.equipped = item.isEquipped;
        updatedItem.equippedSlot = item.equippedSlot;
        
        if (updatedItem.itemSlot == LCKItemSlotNone && updatedItem.equipped) {
            updatedItem.equipped = NO;
        }
        
        if (updatedItem) {
            [updatedItems addObject:[updatedItem copy]];
        }
        else {
            [updatedItems addObject:[item copy]];
        }
    }
    
    self.items = [updatedItems copy];
}

- (void)increaseLevel {
    self.souls = @(self.souls.integerValue - [self soulValueForLevelUp].integerValue);
    self.level = @(self.level.integerValue + 1);
}

- (BOOL)canLevelUp {
    return self.souls.integerValue >= [self soulValueForLevelUp].integerValue;
}

- (CharacterGender)characterGender {
    if ([self.gender isEqualToNumber:@(0)]) {
        return CharacterGenderMale;
    }
    
    return CharacterGenderFemale;
}

- (NSNumber *)maximumHealth {
    //TODO: Add gear health.
    return self.characterStats.statHealth;
}

- (void)equipItem:(LCKItem *)item {
    if (item.itemSlot == LCKItemSlotOneHand) {
        for (LCKItem *weapon in self.equippedWeapons) {
            if (weapon.itemSlot == LCKItemSlotTwoHand) {
                [self setItem:weapon equippedStatus:NO];
            }
        }
    }
    else if (item.itemSlot == LCKItemSlotTwoHand) {
        for (LCKItem *weapon in self.equippedWeapons) {
            if (weapon.itemSlot == LCKItemSlotOneHand) {
                [self setItem:weapon equippedStatus:NO];
            }
        }
    }
    
    [self setItem:item equippedStatus:YES];
}

- (void)unequipItem:(LCKItem *)item {
    item.equippedSlot = LCKEquipmentSlotUnequipped;
    [self setItem:item equippedStatus:NO];
}

- (void)setItem:(LCKItem *)item equippedStatus:(BOOL)equippedStatus {
    if ([self.items containsObject:item]) {
        NSMutableArray *items = [self.items mutableCopy];
        [items removeObject:item];
        
        LCKItem *copyItem = [item copy];
        copyItem.equipped = equippedStatus;
        copyItem.equippedSlot = item.equippedSlot;
        [items addObject:copyItem];
        
        self.items = [items copy];
    }
}

- (void)addItemToInventory:(LCKItem *)item {
    if (!item) {
        return;
    }
    
    NSMutableArray *items = [self.items mutableCopy];
    [items addObject:[item copy]];
    self.items = [items copy];
}

- (void)removeItemFromInventory:(LCKItem *)item {
    if (!item) {
        return;
    }
    
    NSMutableArray *items = [self.items mutableCopy];
    [items removeObject:item];
    self.items = [items copy];
}

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ - Level %@ %@", self.name, self.level, self.characterStats.className];
}

#pragma mark - Equipment

- (NSArray *)equippedWeapons {
    NSMutableArray *weapons = [NSMutableArray array];
    
    for (LCKItem *item in self.items) {
        if (item.isEquipped && ([item isAppropriateForItemSlot:LCKItemSlotOneHand] || [item isAppropriateForItemSlot:LCKItemSlotTwoHand])) {
            [weapons addObject:item];
        }
    }
    
    return [weapons copy];
}

- (NSArray *)equippedAccessories {
    NSMutableArray *accessories = [NSMutableArray array];
    
    for (LCKItem *item in self.items) {
        if (item.isEquipped && [item isAppropriateForItemSlot:LCKItemSlotAccessory]) {
            [accessories addObject:item];
        }
    }
    
    return [accessories copy];
}

- (NSArray *)equippedSpells {
    NSMutableArray *spells = [NSMutableArray array];
    
    for (LCKItem *item in self.items) {
        if (item.isEquipped && [item isAppropriateForItemSlot:LCKItemSlotSpell]) {
            [spells addObject:item];
        }
    }
    
    return [spells copy];
}

- (LCKItem *)equippedHelm {
    for (LCKItem *item in self.items) {
        if (item.isEquipped && [item isAppropriateForItemSlot:LCKItemSlotHelmet]) {
            return item;
        }
    }
    
    return nil;
}

- (LCKItem *)equippedChest {
    for (LCKItem *item in self.items) {
        if (item.isEquipped && [item isAppropriateForItemSlot:LCKItemSlotChest]) {
            return item;
        }
    }
    
    return nil;
}

- (LCKItem *)equippedBoots {
    for (LCKItem *item in self.items) {
        if (item.isEquipped && [item isAppropriateForItemSlot:LCKItemSlotBoots]) {
            return item;
        }
    }
    
    return nil;
}

- (BOOL)meetsRequirement:(NSString *)requirement forItem:(LCKItem *)item {
    NSString *statString = [[requirement componentsSeparatedByString:@" "] firstObject];
    NSString *requirementString = [[requirement componentsSeparatedByString:@" "] lastObject];
    
    return [[self.characterStats statValueForStatString:statString] integerValue] >= [requirementString integerValue];
}

- (BOOL)meetsRequirementsForItem:(LCKItem *)item {
    BOOL meetsRequirements = YES;
    
    for (NSString *requirement in item.attributeRequirements) {
        meetsRequirements = [self meetsRequirement:requirement forItem:item];
        
        if (!meetsRequirements) {
            break;
        }
    }
    
    return meetsRequirements;
}

- (NSNumber *)soulValueForLevelUp {
    if (self.level.integerValue == 1) {
        return @(850);
    }
    else if (self.level.integerValue == 2) {
        return @(2600);
    }
    else if (self.level.integerValue == 3) {
        return @(5500);
    }
    else if (self.level.integerValue == 4) {
        return @(9500);
    }
    else if (self.level.integerValue == 5) {
        return @(14500);
    }
    else if (self.level.integerValue == 6) {
        return @(20800);
    }
    else if (self.level.integerValue == 7) {
        return @(28500);
    }
    else if (self.level.integerValue == 8) {
        return @(37000);
    }
    else if (self.level.integerValue == 9) {
        return @(48000);
    }
    else if (self.level.integerValue == 10) {
        return @(60000);
    }
    else if (self.level.integerValue == 11) {
        return @(74000);
    }
    else if (self.level.integerValue == 12) {
        return @(90500);
    }
    else if (self.level.integerValue == 13) {
        return @(109000);
    }
    else if (self.level.integerValue == 14) {
        return @(128000);
    }
    else if (self.level.integerValue == 15) {
        return @(151000);
    }
    else if (self.level.integerValue == 16) {
        return @(176000);
    }
    else if (self.level.integerValue == 17) {
        return @(204000);
    }
    else if (self.level.integerValue == 18) {
        return @(234000);
    }
    else if (self.level.integerValue == 19) {
        return @(266000);
    }
    else if (self.level.integerValue == 20) {
        return @(300000);
    }

    
    return @(999999999);
}

@end
