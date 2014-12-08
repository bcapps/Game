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

@implementation Character

@dynamic gender;
@dynamic level;
@dynamic name;
@dynamic currentHealth;
@dynamic items;
@dynamic characterStats;

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
    [self setItem:item equippedStatus:YES];
}

- (void)unequipItem:(LCKItem *)item {
    [self setItem:item equippedStatus:NO];
}

- (void)setItem:(LCKItem *)item equippedStatus:(BOOL)equippedStatus {
    if ([self.items containsObject:item]) {
        NSMutableArray *items = [self.items mutableCopy];
        [items removeObject:item];
        
        LCKItem *copyItem = [item copy];
        copyItem.equipped = equippedStatus;
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

@end
