//
//  Knight.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Knight.h"

@implementation Knight

- (UIImage *)classImage {
    return [UIImage imageNamed:@"KnightIcon"];
}

- (NSString *)className {
    return @"Knight";
}

- (NSString *)classDescription {
    return @"A tank class, starting with the highest vitality value of all classes, as well as the most robust equipment.";
}

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context {
    Knight *knight = [[self alloc] initWithContext:context];
    
    knight.vitality = @(3);
    knight.strength = @(1);
    knight.dexterity = @(0);
    knight.intelligence = @(0);
    knight.faith = @(1);
    
    return knight;
}

@end
