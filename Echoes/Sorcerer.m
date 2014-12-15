//
//  Sorcerer.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Sorcerer.h"

@implementation Sorcerer

- (NSString *)className {
    return @"Sorcerer";
}

- (NSString *)classDescription {
    return @"Uses magic as his primary offensive tool. Limited to small weapons due to low starting strength.";
}

- (NSUInteger)startingHealthModification {
    return 1;
}

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    Sorcerer *sorcerer = [[self alloc] initWithContext:context];
    
    sorcerer.vitality = @(-1);
    sorcerer.strength = @(0);
    sorcerer.dexterity = @(1);
    sorcerer.intelligence = @(4);
    sorcerer.faith = @(-1);

    return sorcerer;
}

@end
