//
//  Character.m
//  Echoes
//
//  Created by Andrew Harrison on 12/2/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Character.h"
#import "CharacterStats.h"


@implementation Character

@dynamic name;
@dynamic level;
@dynamic characterStats;
@dynamic gender;

- (CharacterGender)characterGender {
    if ([self.gender isEqualToNumber:@(0)]) {
        return CharacterGenderMale;
    }
    
    return CharacterGenderFemale;
}

@end
