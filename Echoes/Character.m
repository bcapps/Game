//
//  Character.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Character.h"
#import "CharacterStats.h"

@implementation Character

@dynamic gender;
@dynamic level;
@dynamic name;
@dynamic currentHealth;
@dynamic items;
@dynamic equippedItems;
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

@end
