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
        
        if (updatedItem) {
            [updatedItems addObject:[updatedItem copy]];
        }
        else {
            [updatedItems addObject:[item copy]];
        }
    }
    
    self.items = [updatedItems copy];
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

@end
