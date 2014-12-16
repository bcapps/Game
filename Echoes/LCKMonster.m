//
//  LCKMonster.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonster.h"
#import "LCKMonsterAttack.h"

NSString * const LCKMonsterACNumberKey = @"AC";
NSString * const LCKMonsterHealthNumberKey = @"Health";
NSString * const LCKMonsterHitNumberKey = @"To Hit";
NSString * const LCKMonsterAttacksKey = @"Attacks";
NSString * const LCKMonsterSignaledAttacksKey = @"Signaled Attacks";
NSString * const LCKMonsterAttributesKey = @"Attributes";

@implementation LCKMonster

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _AC = [dictionary objectForKey:LCKMonsterACNumberKey];
        _health = [dictionary objectForKey:LCKMonsterHealthNumberKey];
        _hitNumber = [dictionary objectForKey:LCKMonsterHitNumberKey];
        _attributes = [dictionary objectForKey:LCKMonsterAttributesKey];

        NSMutableArray *attacks = [NSMutableArray array];
        
        for (NSString *attackString in [dictionary objectForKey:LCKMonsterAttacksKey]) {
            LCKMonsterAttack *attack = [[LCKMonsterAttack alloc] initWithAttackString:attackString];
            
            [attacks addObject:attack];
        }
        
        for (NSString *attackString in [dictionary objectForKey:LCKMonsterSignaledAttacksKey]) {
            LCKMonsterAttack *attack = [[LCKMonsterAttack alloc] initWithAttackString:attackString];
            attack.signalAttack = YES;
            
            [attacks addObject:attack];
        }
        
        _attacks = [attacks copy];
    }
    
    return self;
}

@end
