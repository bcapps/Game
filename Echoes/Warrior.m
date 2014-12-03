//
//  Warrior.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior

- (UIImage *)classImage {
    return [UIImage imageNamed:@"WarriorIcon"];
}

- (NSString *)className {
    return @"Warrior";
}

- (NSString *)classDescription {
    return @"High initial strength and dexterity, as well as respectable intelligence and faith stats.";
}

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context {
    Warrior *warrior = [[self alloc] initWithContext:context];
    
    warrior.vitality = @(1);
    warrior.strength = @(3);
    warrior.dexterity = @(1);
    warrior.intelligence = @(0);
    warrior.faith = @(0);
    
    return warrior;
}

@end
