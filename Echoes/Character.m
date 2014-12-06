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

@end
