//
//  LCKMonster.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonster.h"
#import "LCKMonsterAttack.h"
#import "LCKMonsterAttribute.h"

NSString * const LCKMonsterACNumberKey = @"AC";
NSString * const LCKMonsterHealthNumberKey = @"Health";
NSString * const LCKMonsterHitNumberKey = @"To Hit";
NSString * const LCKMonsterAttacksKey = @"Attacks";
NSString * const LCKMonsterSignaledAttacksKey = @"Signaled Attacks";
NSString * const LCKMonsterAttributesKey = @"Attributes";
NSString * const LCKMonsterSoulValueKey = @"Soul Value";

@implementation LCKMonster

- (instancetype)initWithDictionary:(NSDictionary *)dictionary name:(NSString *)name {
    self = [super init];
    
    if (self) {
        _name = name;
        _AC = [dictionary objectForKey:LCKMonsterACNumberKey];
        _health = [dictionary objectForKey:LCKMonsterHealthNumberKey];
        _hitNumber = [dictionary objectForKey:LCKMonsterHitNumberKey];
        _soulValue = [dictionary objectForKey:LCKMonsterSoulValueKey];

        NSMutableArray *attributes = [NSMutableArray array];
        for (NSDictionary *attributeDictionary in [dictionary objectForKey:LCKMonsterAttributesKey]) {
            LCKMonsterAttribute *attribute = [[LCKMonsterAttribute alloc] initWithDictionary:attributeDictionary];
            
            [attributes addObject:attribute];
        }
        
        _attributes = [attributes copy];
        
        NSMutableArray *attacks = [NSMutableArray array];
        for (NSDictionary *attackDictionary in [dictionary objectForKey:LCKMonsterAttacksKey]) {
            LCKMonsterAttack *attack = [[LCKMonsterAttack alloc] initWithDictionary:attackDictionary];
            
            [attacks addObject:attack];
        }
        
        for (NSDictionary *attackDictionary in [dictionary objectForKey:LCKMonsterSignaledAttacksKey]) {
            LCKMonsterAttack *attack = [[LCKMonsterAttack alloc] initWithDictionary:attackDictionary];
            attack.signalAttack = YES;
            
            [attacks addObject:attack];
        }
        
        _attacks = [attacks copy];
    }
    
    return self;
}

- (UIImage *)image {
    return [UIImage imageNamed:self.name];
}

- (BOOL)hasSignalAttacks {
    for (LCKMonsterAttack *attack in self.attacks) {
        if (attack.isSignalAttack) {
            return YES;
        }
    }
    
    return NO;
}

@end
