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
    
    knight.vitality = @(14);
    knight.strength = @(11);
    knight.dexterity = @(11);
    knight.intelligence = @(9);
    knight.faith = @(11);
    
    return knight;
}

@end
