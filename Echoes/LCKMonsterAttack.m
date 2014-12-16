//
//  LCKMonsterAttack.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterAttack.h"
#import <LCKCategories/NSArray+LCKAdditions.h>

@implementation LCKMonsterAttack

- (instancetype)initWithAttackString:(NSString *)attackString {
    self = [super init];
    
    if (self) {
        NSArray *attackComponents = [attackString componentsSeparatedByString:@" "];
        _diceRoll = [attackComponents firstObject];
        _attackName = [attackComponents safeObjectAtIndex:1];
        _attackDescription = [attackComponents safeObjectAtIndex:2];
    }
    
    return self;
}

@end
