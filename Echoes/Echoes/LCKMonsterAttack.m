//
//  LCKMonsterAttack.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterAttack.h"
#import <LCKCategories/NSArray+LCKAdditions.h>

NSString * const LCKMonsterAttackName = @"name";
NSString * const LCKMonsterAttackDescription = @"description";
NSString * const LCKMonsterAttackDiceRoll = @"diceRoll";

@implementation LCKMonsterAttack

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _diceRoll = [dictionary objectForKey:LCKMonsterAttackDiceRoll];
        _attackName = [dictionary objectForKey:LCKMonsterAttackName];
        _attackDescription = [dictionary objectForKey:LCKMonsterAttackDescription];
    }
    
    return self;
}

@end
